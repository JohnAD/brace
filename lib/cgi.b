cgi_html()
	cgi_content_type("text/html")

cgi_content_type(cstr type)
	Printf("Content-Type: %s", type)
	crnl() ; crnl()
	Fflush()

cgi_text()
	cgi_content_type("text/plain")

cstr cgi__prefix = "cgi__"
def cgi_env() cgi_env(cgi__prefix)
cgi_env(cstr prefix)
	cgi__prefix = prefix
	# this copies cgi parameters to the environment, with an optional prefix
	cgi_env_load(Strdup(env("QUERY_STRING")))
	if cstr_eq(env("REQUEST_METHOD"), "POST")
		let(b, slurp())
		cgi_env_load(buffer_to_cstr(b))

  # this tries to handle POST, but does NOT handle multi-part form data yet

cgi_env_load(cstr data)
	cstr i = data
	repeat
		let(amp, strchr(i, '&'))
		if amp
			*amp = '\0'
		url_decode(i)
		if *cgi__prefix
			i = cstr_cat(cgi__prefix, i)
		Putenv(i)
		if !amp
			break
		i = amp+1

# this only handles "get" method cgi parameters so far

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

# this isn't strictly a CGI thing, more an http thing,
# but it can go here for now.
# This is a bit dodgy yet, because have to encode different bits of the url
# differently I think.  Returns alloc'd

cstr url_encode(cstr q)
	new(b, buffer, 256)
	while *q
		char c = *q
		if c == ' '
			buffer_cat_char(b, '+')
		 eif !isalnum(c) && !strchr(":_-/?", c)
			Sprintf(b, "%%02x", c)
		 else
			buffer_cat_char(b, c)
	return buffer_to_cstr(b)

cstr cgi(cstr k, cstr _default)
	# XXX not efficient, use a buffer?
	k = cstr_cat(cgi__prefix, k)
	let(v, Getenv(k, _default))
	Free(k)
	return v

def cgi(k) cgi(k, "")
def cgi_or_null(k) cgi(k, NULL)
def cgi_required(k) cgi(k, env__required)

use io process env stdc gr time cstr util alloc
export types
