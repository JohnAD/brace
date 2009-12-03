url_decode(cstr q)
	cstr o = q
	while *q
#		if *q == '+'
#			*o = ' '
		if *q == '%' && q[1] && q[2]
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
		if !Isalnum(c) && !strchr(":_-/?.", c)
			Sprintf(b, "%%%02x", c)
		 else
			buffer_cat_char(b, c)
	return buffer_to_cstr(b)

# malloc'd
cstr get_host_from_url(cstr url)
	cstr host = strstr(url, "://")
	if host
		host += 3
		char *e = strchr(host, '/')
		if e
			host = Strndup(host, e-host)
		 else
			host = NULL
	return host

# not malloc'd
cstr get_path_from_url(cstr url)
	cstr path = url
	cstr host = strstr(url, "://")
	if host
		host += 3
		path = strchr(host, '/')
		if !path
			path = "/"
	return path

boolean _http_fake_browser = 0
def http_fake_browser() http_fake_browser(1)
http_fake_browser(boolean f)
	_http_fake_browser = f

boolean http_debug = 0

cstr http(cstr method, cstr url, buffer *req_headers, buffer *req_data, buffer *rsp_headers, buffer *rsp_data)
	cstr host_port = get_host_from_url(url)
	if !host_port
		error("http: invalid url %s", url)
	cstr path = Strchr(Strstr(url, "//") + 2, '/')
	if !*path
		path = "/"
	int port = 80
	cstr host = Strdup(host_port)
	cstr port_s = strchr(host, ':')
	if port_s
		*port_s++ = '\0'
		port = atoi(port_s)

	if http_debug
		warn("connecting to %s port %d", host, port)
	int fd = Client(host, port)
	FILE *s = Fdopen(fd, "r+b")
	Fprintf(s, "%s %s HTTP/1.0\r\n", method, url)
	if http_debug
		warn("%s %s HTTP/1.0", method, url)
#	Fprintf(s, "%s %s HTTP/1.1\r\n", method, path)
	  # I was using HTTP/1.1 but I don't want to do the code to handle "chunked" encoding right now.
#	Fprintf(s, "Host: %s\r\n", host_port)
	if _http_fake_browser
		Fprintf(s, "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.6) Gecko/2009020911 Ubuntu/8.10 (intrepid) Firefox/3.0.6\r\n")
		Fprintf(s, "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n")
		if http_debug
			warn("User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.6) Gecko/2009020911 Ubuntu/8.10 (intrepid) Firefox/3.0.6")
			warn("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")

	if req_headers
		Fwrite_buffer(s, req_headers)
		if http_debug
			warn("%s", req_headers)
	crlf(s)
	if req_data
		Fwrite_buffer(s, req_data)
		if http_debug
			warn("%s", req_data)
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

	if http_debug
		buffer_nul_terminate(rsp_headers)
		warn("%s", buf0(rsp_headers))

	if !rsp_headers_orig
		buffer_free(rsp_headers_tmp)

	if rsp_data
		fslurp(s, rsp_data)
		if http_debug
			buffer_nul_terminate(rsp_data)
			warn("%s", buf0(rsp_data))

	Fclose(s)

	Free(host_port)
	Free(host)

	if !rsp_data && rsp_headers
		rsp_data = rsp_headers
	if rsp_data
		buffer_nul_terminate(rsp_data)
		return buf0(rsp_data)
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

const char *base64_encode_map = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
char *base64_decode_map = NULL

base64_decode_buffers(buffer *i, buffer *o)
	b_io(i, o)
		base64_decode()

base64_decode()
	if !base64_decode_map
		base64_decode_map = Calloc(128)
		for(i, 0, 64)
			base64_decode_map[(unsigned int)base64_encode_map[i]] = i
	int c
	repeat
		long o = 0
		for_keep(i, 0, 4)
			do
				c = gc()
			 while isspace(c)
			if c == EOF || c == '='
				break
			o |= base64_decode_map[c & 0x7F] << (6*(3-i))
		for(j, 0, i-1)
			pc((char)(o>>((2-j)*8)))
		if i < 4
			break

# TODO base64_encode

typedef enum { HTTP_GET, HTTP_HEAD, HTTP_POST, HTTP_PUT, HTTP_DELETE, HTTP_INVALID } http__method

http__method http_which_method(cstr method)
	http__method rv
	if cstr_eq(method, "GET")
		rv = HTTP_GET
	 eif cstr_eq(method, "HEAD")
		rv = HTTP_HEAD
	 eif cstr_eq(method, "POST")
		rv = HTTP_POST
	 eif cstr_eq(method, "PUT")
		rv = HTTP_PUT
	 eif cstr_eq(method, "DELETE")
		rv = HTTP_DELETE
	 else
		rv = HTTP_INVALID
	return rv

use cstr alloc util io vio
