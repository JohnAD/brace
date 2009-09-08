use io process time cstr util alloc env
export types http

cgi_html()
	cgi_content_type("text/html")

int cgi__sent_headers = 0

cgi_content_type(cstr type)
	if !cgi__sent_headers
		Printf("Content-Type: %s", type)
		crlf() ; crlf()
		Fflush()
		cgi__sent_headers = 1

cgi_text()
	cgi_content_type("text/plain")

hashtable _cgi_query_hash, *cgi_query_hash
cgi_init()
	cgi_query_hash = &_cgi_query_hash
	NEW(cgi_query_hash, hashtable, cstr_hash, cstr_eq, 1009)
	cgi_query_load(Strdup(env("QUERY_STRING")))
	if cstr_eq(env("REQUEST_METHOD"), "POST")
		new(b, buffer, block_size)
		buffer_cat_cstr(b, env("REQUEST_BODY_1"))  # to work with tachyon
		slurp(0, b)
		cgi_query_load(buffer_to_cstr(b))

cgi_query_load(cstr data)
	cstr i = data
	repeat
		let(amp, strchr(i, '&'))
		if amp
			*amp = '\0'
		url_decode(i)
		char *val = strchr(i, '=')
		if val
			*val = '\0'
			++val
		 else
		 	val = Strdup("")
		char *key = Strdup(i)
		mput(cgi_query_hash, key, val)
		if !amp
			break
		i = amp+1

def cgi(k) cgi(k, "")
def cgi_or_null(k) cgi(k, NULL)
cstr cgi(cstr key, cstr _default)
	vec *v = mcgi(key)
	if v && veclen(v) > 0
		return vec0(v)
	return _default

def mcgi(key) mget(cgi_query_hash, key)

cstr cgi_required(cstr key)
	cstr v = cgi_or_null(key)
	if !v
		error("cgi_required: key not found: %s", key)
	return v

cgi_errors_to_browser()
	error_handler *h = vec_push(error_handlers)
	h->handler.func = cgi_error_to_browser
	h->handler.obj = NULL
	h->handler.common_arg = NULL
	h->jump = NULL
	h->err = 0

void *cgi_error_to_browser(void *obj, void *common_arg, void *specific_arg)
	use(obj) ; use(common_arg)
	err *e = specific_arg
	cgi_text()
	Say(e->msg)
	Fflush()
	vec_pop(error_handlers)
	Throw()
	return thunk_yes

# old-style code that put cgi query vars into the environment

#cstr cgi__prefix = "cgi__"
#def cgi_env() cgi_env(cgi__prefix)
#cgi_env(cstr prefix)
#	cgi__prefix = prefix
#	# this copies cgi parameters to the environment, with an optional prefix
#	cgi_env_load(Strdup(env("QUERY_STRING")))
#	if cstr_eq(env("REQUEST_METHOD"), "POST")
#		let(b, slurp())
#		cgi_env_load(buffer_to_cstr(b))
#
#  # this tries to handle POST, but does NOT handle multi-part form data yet
#
#cgi_env_load(cstr data)
#	cstr i = data
#	repeat
#		let(amp, strchr(i, '&'))
#		if amp
#			*amp = '\0'
#		url_decode(i)
#		if *cgi__prefix
#			i = cstr_cat(cgi__prefix, i)
#		Putenv(i)
#		if !amp
#			break
#		i = amp+1
#
## this only handles "get" method cgi parameters so far
#
#cstr cgi(cstr k, cstr _default)
#	# XXX not efficient, use a buffer?
#	k = cstr_cat(cgi__prefix, k)
#	let(v, Getenv(k, _default))
#	Free(k)
#	return v
#
#def cgi(k) cgi(k, "")
#def cgi_or_null(k) cgi(k, NULL)
#def cgi_required(k) cgi(k, env__required)
