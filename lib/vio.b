# vstream contextual io!

use io buffer circbuf m

# TODO could be simpler, it really only needs read, write and flush?
# TODO integrate with rd, wr of shuttle.b

# Can't use vstreams in a proc yet, would need to:
#  - auto-declare state vars
#  - reset in and out when returning from an io() block - or make them local variables - already have in and out ports in a proc
# Maybe return could be regarded as a type of exception, and try / final could use used?

typedef void (*vs_putc_t)(int c, vstream *vs)
typedef int (*vs_getc_t)(vstream *vs)
typedef int (*vs_printf_t)(vstream *vs, const char *format, va_list ap)
typedef char *(*vs_gets_t)(char *s, int size, vstream *vs)
typedef void (*vs_write_t)(const void *ptr, size_t size, size_t nmemb, vstream *vs)
typedef size_t (*vs_read_t)(void *ptr, size_t size, size_t nmemb, vstream *vs)
typedef void (*vs_flush_t)(vstream *vs)
typedef void (*vs_close_t)(vstream *vs)
typedef void (*vs_shutdown_t)(vstream *vs, int how)

# TODO use class structs instead of duplicating all the function pointers in each vstream

struct vstream
	vs_putc_t putc
	vs_getc_t getc
	vs_printf_t printf
	vs_gets_t gets
	vs_write_t write
	vs_read_t read
	vs_flush_t flush
	vs_close_t close
	vs_shutdown_t shutdown
	void *data

def vstream_init_x(vs, x, d)
	vs->putc = vs_putc_^^x
	vs->getc = vs_getc_^^x
	vs->printf = vs_printf_^^x
	vs->gets = vs_gets_^^x
	vs->write = vs_write_^^x
	vs->read = vs_read_^^x
	vs->flush = vs_flush_^^x
	vs->close = vs_close_^^x
	vs->shutdown = vs_shutdown_^^x
	vs->data = d

vstream_init_stdio(vstream *vs, FILE *s)
	vstream_init_x(vs, stdio, s)

vs_putc_stdio(int c, vstream *vs)
	Fputc(c, vs->data)

int vs_getc_stdio(vstream *vs)
	return Fgetc(vs->data)

int vs_printf_stdio(vstream *vs, const char *format, va_list ap)
	return Vfprintf(vs->data, format, ap)

char *vs_gets_stdio(char *s, int size, vstream *vs)
	return Fgets(s, size, vs->data)

vs_write_stdio(const void *ptr, size_t size, size_t nmemb, vstream *vs)
	Fwrite(ptr, size, nmemb, vs->data)

size_t vs_read_stdio(void *ptr, size_t size, size_t nmemb, vstream *vs)
	return Fread(ptr, size, nmemb, vs->data)

vs_flush_stdio(vstream *vs)
	Fflush(vs->data)

vs_close_stdio(vstream *vs)
	Fclose(vs->data)

vs_shutdown_stdio(vstream *vs, int how)
	Shutdown(fileno((FILE*)vs->data), how)

vstream struct__in, *in
vstream struct__out, *out
vstream struct__er, *er

vstreams_init()
	in = &struct__in ; out = &struct__out ; er = &struct__er
	vstream_init_stdio(in, stdin)
	vstream_init_stdio(out, stdout)
	vstream_init_stdio(er, stderr)

def vstream_init(vs, type, a0)
	vstream_init_^^type(vs, a0)

vstream_init_buffer(vstream *vs, buffer *b)
	vstream_init_x(vs, buffer, b)

vs_putc_buffer(int c, vstream *vs)
	buffer *b = vs->data
	buffer_cat_char(b, c)

# XXX this is inefficient - it wants to be using circbuf!

int vs_getc_buffer(vstream *vs)
	buffer *b = vs->data
	if buffer_get_size(b)
		int c = buffer_first_char(b)
		buffer_shift(b)
		return c
	 else
		return EOF

int vs_printf_buffer(vstream *vs, const char *format, va_list ap)
	buffer *b = vs->data
	return Vsprintf(b, format, ap)

char *vs_gets_buffer(char *s, int size, vstream *vs)
	buffer *b = vs->data
	char *c = buffer_get_start(b)
	char *e = buffer_get_end(b)
	if c == e || *c == 0
		return NULL
	char *o = s
	if e > c+size-1
		e = c+size-1
	while c < e
		if among(*c, '\0', '\n')
			c++
			break
		*o++ = *c++
	*o++ = '\0'
	buffer_shift(b, c-buffer_get_start(b))
	return s

vs_write_buffer(const void *ptr, size_t size, size_t nmemb, vstream *vs)
	buffer *b = vs->data
	size_t l = size * nmemb
	buffer_cat_range(b, ptr, ((const char *)ptr)+l)

# XXX this is inefficient - it wants to be using circbuf!

size_t vs_read_buffer(void *ptr, size_t size, size_t nmemb, vstream *vs)
	buffer *b = vs->data
	ssize_t l = size * nmemb
	if l > buffer_get_size(b)
		l = buffer_get_size(b)
	memmove(ptr, buffer_get_start(b), l)
	buffer_shift(b, l)
	return nmemb

vs_flush_buffer(vstream *vs)
	buffer *b = vs->data
	buffer_nul_terminate(b)

vs_close_buffer(vstream *vs)
	buffer *b = vs->data
	buffer_to_cstr(b)

vs_shutdown_buffer(vstream *vs, int how)
	if among(how, SHUT_WR, SHUT_RDWR)
		vs_close_buffer(vs)

def in(new_in)
	in(new_in, my(old_in))
def in(new_in, old_in)
	vstream *old_in = in
	post(my(x))
		in = old_in
	pre(my(x))
		old_in = in
		in = new_in
		.

def out(new_out)
	out(new_out, my(old_out))
def out(new_out, old_out)
	vstream *old_out = out
	post(my(x))
		out = old_out
	pre(my(x))
		old_out = out
		out = new_out
		.

def er(new_er)
	er(new_er, my(old_er))
def er(new_er, old_er)
	vstream *old_er = er
	post(my(x))
		er = old_er
	pre(my(x))
		old_er = er
		er = new_er
		.

def io(new_in, new_out)
	io(new_in, new_out, my(old_in), my(old_out))
def io(new_in, new_out, old_in, old_out)
	vstream *old_in = in, *old_out = out
	post(my(x))
		in = old_in ; out = old_out
	pre(my(x))
		old_in = in ; old_out = out
		in = new_in ; out = new_out
		.

def oe(new_out, new_er)
	oe(new_out, new_er, my(old_out), my(old_er))
def oe(new_out, new_er, old_out, old_er)
	vstream *old_out = out, *old_er = er
	post(my(x))
		out = old_out ; er = old_er
	pre(my(x))
		old_out = out ; old_er = er
		out = new_out ; er = new_er
		.

def ioe(new_in, new_out, new_er)
	ioe(new_in, new_out, new_er, old_in, old_out, old_er)
def ioe(new_in, new_out, new_er, old_in, old_out, old_er)
	vstream *old_in = in, *old_out = out, *old_er = er
	post(my(x))
		in = old_in ; out = old_out ; er = old_er
	pre(my(x))
		old_in = in ; old_out = out ; old_er = er
		in = new_in ; out = new_out ; er = new_er
		.

vs_putc(int c)
	(*out->putc)(c, out)

int vs_getc(void)
	return (*in->getc)(in)

int vs_printf(const char *format, va_list ap)
	return (*out->printf)(out, format, ap)

char *vs_gets(char *s, int size)
	return (*in->gets)(s, size, in)

def vs_write(ptr, size) vs_write(ptr, 1, size)
vs_write(const void *ptr, size_t size, size_t nmemb)
	(*out->write)(ptr, size, nmemb, out)

def vs_read(ptr, size) vs_read(ptr, 1, size)
size_t vs_read(void *ptr, size_t size, size_t nmemb)
	return (*in->read)(ptr, size, nmemb, in)

vs_flush(void)
	(*out->flush)(out)

vs_close(void)
	(*out->close)(out)
	(*in->close)(in)

vs_shutdown(int how)
	if among(how, SHUT_WR, SHUT_RDWR)
		(*out->shutdown)(out, SHUT_WR)
	if among(how, SHUT_RD, SHUT_RDWR)
		(*in->shutdown)(in, SHUT_RD)

def pc(c) vs_putc(c)

def gc() vs_getc()

int pf(const char *format, ...)
	collect(vs_printf, format)

int vs_sayf(const char *format, va_list ap)
	int rv = (*out->printf)(out, format, ap)
	(*out->putc)('\n', out)
	++rv
	return rv

int sf(const char *format, ...)
	collect(vs_sayf, format)

int print(const char *s)
	return pf("%s", s)

int say(const char *s)
	return sf("%s", s)

def sf() sf("")
def say() sf()

int rl(buffer *b)
	ssize_t len = buffer_get_size(b)
	repeat
		char *rv = vs_gets(b->start+len, buffer_get_space(b)-len)
		if rv == NULL
			return EOF
		len += strlen(b->start+len)
		if b->start[len-1] == '\n'
			# chomp it - XXX should we do this?
			b->start[len-1] = '\0'
			--len
			break
		if len < buffer_get_space(b) - 1
			break
		buffer_double(b)
	buffer_set_size(b, len)
	return 0

def rl() rl_0()
cstr rl_0()
	New(b, buffer, 128)
	if rl(b) == 0
		buffer_squeeze(b)
		return buffer_to_cstr(b)
	 else
		buffer_free(b)
		Free(b)
		return NULL

def fl() vs_flush()

def cl() vs_close()

def shut() shut(SHUT_WR)
def shut(how) vs_shutdown(how)

def b_in(i)
	new(my(vs), vstream, buffer, i)
	in(my(vs))
		.

def b_out(o)
	new(my(vs), vstream, buffer, o)
	out(my(vs))
		.

def b_err(e)
	new(my(vs), vstream, buffer, e)
	err(my(vs))
		.

def b_io(i, o)
	new(my(vsi), vstream, buffer, i)
	new(my(vso), vstream, buffer, o)
	io(my(vsi), my(vso))
		.

def b_oe(i, o)
	new(my(vso), vstream, buffer, o)
	new(my(vse), vstream, buffer, e)
	oe(my(vso), my(vse))
		.

def b_ioe(i, o, e)
	new(my(vsi), vstream, buffer, i)
	new(my(vso), vstream, buffer, o)
	new(my(vse), vstream, buffer, e)
	ioe(my(vsi), my(vso), my(vse))
		.

def f_in(i)
	new(my(vs), vstream, stdio, i)
	in(my(vs))
		.

def f_out(o)
	new(my(vs), vstream, stdio, o)
	out(my(vs))
		.

def f_err(e)
	new(my(vs), vstream, stdio, e)
	err(my(vs))
		.

def f_io(i, o)
	new(my(vsi), vstream, stdio, i)
	new(my(vso), vstream, stdio, o)
	io(my(vsi), my(vso))
		.

def f_oe(i, o)
	new(my(vso), vstream, stdio, o)
	new(my(vse), vstream, stdio, e)
	oe(my(vso), my(vse))
		.

def f_ioe(i, o, e)
	new(my(vsi), vstream, stdio, i)
	new(my(vso), vstream, stdio, o)
	new(my(vse), vstream, stdio, e)
	ioe(my(vsi), my(vso), my(vse))
		.

# this is a bit ugly because can't re-indent a block after a macro yet.
# it should use f_in

def F_in(i)
	state FILE *my(s) = Fopen(i)
	state vstream *my(old_in) = in
	new(my(vs), vstream, stdio, my(s))
	post(my(p))
		Fclose(my(s))
		in = my(old_in)
	pre(my(p))
		in = my(vs)
		.

def F_out(i)
	state FILE *my(s) = Fopenout(i)
	state vstream *my(old_out) = out
	new(my(vs), vstream, stdio, my(s))
	post(my(p))
		Fclose(my(s))
		out = my(old_out)
	pre(my(p))
		out = my(vs)
		.

def F_err(o)
	state FILE *my(s) = Fopenout(o)
	state vstream *my(old_err) = err
	new(my(vs), vstream, stdio, my(s))
	post(my(p))
		Fclose(my(s))
		err = my(old_err)
	pre(my(p))
		err = my(vs)
		.

def F_io(i, o)
	state FILE *my(si) = Fopen(i)
	state FILE *my(so) = Fopenout(o)
	state vstream *my(old_in) = in
	state vstream *my(old_out) = out
	new(my(vsi), vstream, stdio, my(si))
	new(my(vso), vstream, stdio, my(so))
	post(my(p))
		Fclose(my(si))
		Fclose(my(so))
		in = my(old_in)
		out = my(old_out)
	pre(my(p))
		in = my(vsi)
		out = my(vso)
		.

def F_oe(o, e)
	state FILE *my(so) = Fopenout(o)
	state FILE *my(se) = Fopenout(e)
	state vstream *my(old_out) = out
	state vstream *my(old_err) = err
	new(my(vso), vstream, stdio, my(so))
	new(my(vse), vstream, stdio, my(se))
	post(my(p))
		Fclose(my(so))
		Fclose(my(se))
		out = my(old_out)
		err = my(old_err)
	pre(my(p))
		out = my(vso)
		err = my(vse)
		.

def F_ioe(i, o, e)
	state FILE *my(si) = Fopen(i)
	state FILE *my(so) = Fopenout(o)
	state FILE *my(se) = Fopenout(e)
	state vstream *my(old_in) = in
	state vstream *my(old_out) = out
	state vstream *my(old_err) = err
	new(my(vsi), vstream, stdio, my(si))
	new(my(vso), vstream, stdio, my(so))
	new(my(vse), vstream, stdio, my(se))
	post(my(p))
		Fclose(my(si))
		Fclose(my(so))
		Fclose(my(se))
		in = my(old_in)
		out = my(old_out)
		err = my(old_err)
	pre(my(p))
		in = my(vsi)
		out = my(vso)
		err = my(vse)
		.


vec *read_ints(cstr file)
	read_file_to_vec(file, int, l, (int)atoi(l))

vec *read_nums(cstr file)
	read_file_to_vec(file, num, l, (num)atof(l))

vec *read_cstrs(cstr file)
	read_file_to_vec(file, cstr, l, Strdup(l))

def read_file_to_vec(file, type, l, map)
	New(v, vec, type, 200)
	F_in(file)
		eachline(l)
			vec_push(v, map)
	vec_squeeze(v)
	return v


vstream_init_circbuf(vstream *vs, circbuf *b)
	vstream_init_x(vs, circbuf, b)

vs_putc_circbuf(int c, vstream *vs)
	circbuf *b = vs->data
	circbuf_cat_char(b, c)

int vs_getc_circbuf(vstream *vs)
	circbuf *b = vs->data
	if circbuf_get_size(b)
		int c = circbuf_first_char(b)
		circbuf_shift(b)
		return c
	 else
		return EOF

int vs_printf_circbuf(vstream *vs, const char *format, va_list ap)
	circbuf *b = vs->data
	return Vsprintf_cb(b, format, ap)

char *vs_gets_circbuf(char *s, int size, vstream *vs)
	circbuf *b = vs->data
	char *c = circbuf_get_start(b)
	if cbuflen(b) == 0 || *c == 0
		return NULL
	if size > 0
		char *space_end = circbuf_get_space_end(b)
		char *o = s
		char *e
		if cbuflen(b) > size-1
			e = cb(b, size-1)
		 else
			e = circbuf_get_end(b)
		do
			if among(*c, '\0', '\n')
				c++
				break
			*o++ = *c++
			if c == space_end
				c = b->data
		 while c != e
		*o++ = '\0'
		ssize_t l = cbindex_not_0(b, c)
		circbuf_shift(b, l)
	return s

vs_write_circbuf(const void *ptr, size_t size, size_t nmemb, vstream *vs)
	circbuf *b = vs->data
	ssize_t l = size * nmemb
	circbuf_cat_range(b, ptr, ((const char *)ptr)+l)

size_t vs_read_circbuf(void *ptr, size_t size, size_t nmemb, vstream *vs)
	circbuf *b = vs->data
	ssize_t l = size * nmemb
	if l > circbuf_get_size(b)
		l = circbuf_get_size(b)
	char *space_end = circbuf_get_space_end(b)
	char *i = cbuf0(b)
	ssize_t l1 = space_end - i
	boolean onestep = l <= l1
	if onestep
		l1 = l
	memmove(ptr, cbuf0(b), l1)
	if !onestep
		memmove(((char *)ptr)+l1, b->data, l - l1)
	circbuf_shift(b, l)
	return nmemb

vs_flush_circbuf(vstream *vs)
	circbuf *b = vs->data
	circbuf_nul_terminate(b)

vs_close_circbuf(vstream *vs)
	circbuf *b = vs->data
	circbuf_to_cstr(b)

vs_shutdown_circbuf(vstream *vs, int how)
	if among(how, SHUT_WR, SHUT_RDWR)
		vs_close_circbuf(vs)

def cb_in(i)
	new(my(vs), vstream, circbuf, i)
	in(my(vs))
		.

def cb_out(o)
	new(my(vs), vstream, circbuf, o)
	out(my(vs))
		.

def cb_err(e)
	new(my(vs), vstream, circbuf, e)
	err(my(vs))
		.

def cb_io(i, o)
	new(my(vsi), vstream, circbuf, i)
	new(my(vso), vstream, circbuf, o)
	io(my(vsi), my(vso))
		.

def cb_oe(i, o)
	new(my(vso), vstream, circbuf, o)
	new(my(vse), vstream, circbuf, e)
	oe(my(vso), my(vse))
		.

def cb_ioe(i, o, e)
	new(my(vsi), vstream, circbuf, i)
	new(my(vso), vstream, circbuf, o)
	new(my(vse), vstream, circbuf, e)
	ioe(my(vsi), my(vso), my(vse))
		.

discard(size_t n)
	char buf[block_size]
	while n
		size_t to_read = imin(block_size, n)
		if vs_read(buf, to_read) != to_read
			failed0("discard", "file too short")
		n -= to_read

