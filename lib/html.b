use util io buffer alloc cstr vio

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
	c = gc()

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
	say(buffer_to_cstr(b))
	buffer_clear(b)

html_join()
	eachline(l)
		for(i, cstr_range(l))
			which *i
			'\r'	*i = '\n'
		print(l)

def tag(name) tagn(name, NULL)
def tag(name, k0, v0) tagn(name, k0, v0, NULL)
def tag(name, k0, v0, k1, v1) tagn(name, k0, v0, k1, v1, NULL)
def tag(name, k0, v0, k1, v1, k2, v2) tagn(name, k0, v0, k1, v1, k2, v2, NULL)
def tag(name, k0, v0, k1, v1, k2, v2, k3, v3) tagn(name, k0, v0, k1, v1, k2, v2, k3, v3, NULL)
def tag(name, k0, v0, k1, v1, k2, v2, k3, v3, k4, v4) tagn(name, k0, v0, k1, v1, k2, v2, k3, v3, k4, v4, NULL)

cstr tag__no_value = (cstr)-1
tagn(cstr name, ...)
	collect_void(vtag, name)
vtag(cstr name, va_list ap)
	pf("<%s", name)
	repeat
		cstr k = va_arg(ap, cstr)
		if !k
			break
		cstr v = va_arg(ap, cstr)
		if !v
			error("tag: missing value for key %s", k)
		if v == tag__no_value
			pf(" %s", k)
		 else
			let(v1, html_encode(v))
		 	pf(" %s=\"%s\"", k, v1)
			Free(v1)
	pf(">")


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

cstr html2text(cstr html)
	decl(b_html, buffer)
	buffer_from_cstr(b_html, html)

	new(b_split, buffer, 1024)
	b_io(b_html, b_split)
		html_split()

	new(b_text, buffer, 1024)

	b_io(b_split, b_text)
		eachline(s)
			if s[0] != '<'
				print(s)
			 eif !strcasecmp(s, "<br>") || !strcasecmp(s, "</p>")
				say()
			 eif !strcasecmp(s, "</td>")
				print("\t")
			 else
				print(" ")

	buffer_free(b_split)

	return buffer_to_cstr(b_text)
