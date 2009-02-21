use util io buffer alloc cstr

# idea - functions that have access to env of caller "automatically" without
# having to pass in params, create automatically for each macro YYY!

def html_split()
	html_split(0)

html_split(boolean split_entities)
	new(b, buffer, 128)
	int c
	rd_ch()
	cstr end_text = split_entities ? "<&\n" : "<\n"
	while c != EOF
		if c == '<'
			copy_to_inc(">")
		 eif split_entities && c == '&'
		 	copy_to_inc(";")
		 else
		 	copy_to(end_text)
			if c == '\n'
				copy_c()
		nl_to_cr()
		out()
	if buffer_get_size(b)
		out()

ldef nl_to_cr()
	.
		for(i, buffer_range(b))
			which *i
			'\n'	*i = '\r'


# split and join are inverses, unless there is a newline in middle of a tag

ldef rd_ch()
	Getchar(c)

ldef copy_to(end)
	while strchr(end, c) == NULL && c != EOF
		copy_c()

ldef copy_c()
	add_b()
	rd_ch()

ldef copy_to_inc(end)
	copy_to(end)
	copy_c()

ldef add_b()
	buffer_cat_char(b, c)

ldef out()
	Say(buffer_to_cstr(b))
	buffer_clear(b)

html_join()
	eachline(l)
		for(i, cstr_range(l))
			which *i
			'\r'	*i = '\n'
		Print(l)

def tag(name) tagn(stdout, name, NULL)
def tag(name, k0, v0) tagn(stdout, name, k0, v0, NULL)
def tag(name, k0, v0, k1, v1) tagn(stdout, name, k0, v0, k1, v1, NULL)
def tag(name, k0, v0, k1, v1, k2, v2) tagn(stdout, name, k0, v0, k1, v1, k2, v2, NULL)
def tag(name, k0, v0, k1, v1, k2, v2, k3, v3) tagn(stdout, name, k0, v0, k1, v1, k2, v2, k3, v3, NULL)
def tag(name, k0, v0, k1, v1, k2, v2, k3, v3, k4, v4) tagn(stdout, name, k0, v0, k1, v1, k2, v2, k3, v3, k4, v4, NULL)

cstr tag__no_value = (cstr)-1
tagn(FILE *stream, cstr name, ...)
	collect_void(vtag, stream, name)
vtag(FILE *stream, cstr name, va_list ap)
	Fprintf(stream, "<%s", name)
	repeat
		cstr k = va_arg(ap, cstr)
		if !k
			break
		cstr v = va_arg(ap, cstr)
		if !v
			error("tag: missing value for key %s", k)
		if v == tag__no_value
			Fprintf(stream, " %s", k)
		 else
			let(v1, html_encode(v))
		 	Fprintf(stream, " %s=\"%s\"", k, v1)
			Free(v1)
	Fprintf(stream, ">")


_html_encode(buffer *b, cstr v)
	while *v != 0
		if *v == '&'
			buffer_cat_cstr(b, "&amp;")
		 eif *v == '"'
		 	buffer_cat_cstr(b, "&quot;")
		 eif *v == '<'
		 	buffer_cat_cstr(b, "&lt;")
		 eif *v == '>'
		 	buffer_cat_cstr(b, "&gt;")
		 else
		 	buffer_cat_char(b, *v)
		++v
cstr html_encode(cstr v)
	new(b, buffer)
	_html_encode(b, v)
	return buffer_to_cstr(b)
def html_encode(b, v) _html_encode(b, v)
