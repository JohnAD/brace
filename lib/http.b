url_decode(cstr q)
	cstr o = q
	while *q
		if *q == '+'
			*o = ' '
		 eif *q == '%' && q[1] && q[2]
			char c[3] = { q[1], q[2], '\0' }
			*o = (char)strtol(c, NULL, 16)
			q+=2
		 else
			*o = *q
		++q
		++o
	*o = '\0'

# This is a bit dodgy yet, because we should encode different bits of the url
# differently I think.  Returns alloc'd

cstr url_encode(cstr q)
	new(b, buffer, 256)
	while *q
		char c = *q++
#		if c == ' '
#			buffer_cat_char(b, '+')
		if !isalnum(c) && !strchr(":_-/?.", c)
			Sprintf(b, "%%%02x", c)
		 else
			buffer_cat_char(b, c)
	return buffer_to_cstr(b)

cstr url_host(cstr url)
	cstr host = Strstr(url, "//") + 2
	cstr host_end = Strchr(host, '/')
	if !host_end
		host_end = host+strlen(host)
	host = Strndup(host, host_end-host)
	return host

int _http_fake_browser = 0
def http_fake_browser() http_fake_browser(1)
http_fake_browser(int f)
	_http_fake_browser = f

cstr http(cstr method, cstr url, buffer *req_headers, buffer *req_data, buffer *rsp_headers, buffer *rsp_data)
	cstr host_port = url_host(url)
	cstr path = Strchr(Strstr(url, "//") + 2, '/')
	if !*path
		path = "/"
	int port = 80
	cstr host = strdup(host_port)
	cstr port_s = strchr(host, ':')
	if port_s
		*port_s++ = '\0'
		port = atoi(port_s)

	int fd = Client(host, port)
	FILE *s = Fdopen(fd, "r+b")
	Fprintf(s, "%s %s HTTP/1.1\r\n", method, path)
	Fprintf(s, "Host: %s\r\n", host_port)
	if _http_fake_browser == 1
		Fprintf(s, "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.6) Gecko/2009020911 Ubuntu/8.10 (intrepid) Firefox/3.0.6\r\n")
		Fprintf(s, "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n")

	if req_headers
		Fwrite_buffer(s, req_headers)
	crnl(s)
	if req_data
		Fwrite_buffer(s, req_data)
	Fflush(s)

	Shutdown(fd)

	decl(rsp_headers_tmp, buffer) 
	buffer *rsp_headers_orig = rsp_headers
	if !rsp_headers_orig
		init(rsp_headers_tmp, buffer, 512)
		rsp_headers = rsp_headers_tmp

	repeat
		if Freadline(rsp_headers, s) == EOF
			break
		if buffer_ends_with_char(rsp_headers, '\r')
			buffer_grow(rsp_headers, -1)
		if buffer_ends_with_char(rsp_headers, '\n')
			break
		buffer_cat_char(rsp_headers, '\n')

	if !rsp_headers_orig
		buffer_free(rsp_headers_tmp)

	if rsp_data
		fslurp(s, rsp_data)

	Fclose(s)

	Free(host_port)
	Free(host)

	if !rsp_data && rsp_headers
		rsp_data = rsp_headers
	if rsp_data
		buffer_nul_terminate(rsp_data)
		return buffer_get_start(rsp_data)
	return NULL

def http_get(url) http_get_1(url)
cstr http_get_1(cstr url)
	New(rsp_data, buffer, 1024)
	return http_get(url, rsp_data)
cstr http_get(cstr url, buffer *rsp_data)
	return http("GET", url, NULL, NULL, NULL, rsp_data)

def http_head(url) http_head_1(url)
cstr http_head_1(cstr url)
	New(rsp_headers, buffer, 1024)
	return http_head(url, rsp_headers)
cstr http_head(cstr url, buffer *rsp_headers)
	return http("HEAD", url, NULL, NULL, rsp_headers, NULL)

def http_post(url, req_data) http_post_1(url, req_data)
cstr http_post_1(cstr url, cstr req_data)
	New(rsp_data, buffer, 1024)
	return http_post(url, req_data, rsp_data)
cstr http_post(cstr url, cstr _req_data, buffer *rsp_data)
	decl(req_data, buffer)
	buffer_from_cstr(req_data, _req_data)
	return http("POST", url, NULL, req_data, NULL, rsp_data)

use cstr alloc util io
