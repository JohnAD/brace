use alloc
export stdlib.h
use error
export str
use util
export types
use string.h
export stdarg.h
export stdio.h
use io

# this is a general buffer, revised version to be compatible with libb strs
# I haven't decided if this is a good idea or not yet.
# The generic get/let syntax seems okay, now need lang support for namespaces!

# TODO make sure it always has a '\0' after the allocated data

# TODO make this stuff more efficient

# TODO buffer should start with 0 bytes size and no memory allocated,
# so can alloc buffer size on first use in case of a repeatedly reused buffer
# ???

struct buffer
	char *start
	char *end
	char *space_end

#size_t buffer_get_size(buffer *b)
#	return b->end - b->start

size_t buffer_get_space(buffer *b)
	return b->space_end - b->start

buffer_init(buffer *b, size_t space)
	if space == 0
		space = 1
	b->start = (char *)Malloc(space)
	b->end = b->start
	b->space_end = b->start + space
def buffer_init(b) buffer_init(b, 8)

buffer_free(buffer *b)
	Free(b->start)

buffer_set_space(buffer *b, size_t space)
	size_t size = buffer_get_size(b)
	assert(size <= space, "cannot set buffer space less than buffer size")
	if space == 0
		space = 1
	Realloc(b->start, space)
	b->end = b->start + size
	b->space_end = b->start + space

buffer_set_size(buffer *b, size_t size)
	buffer_ensure_space(b, size)
	b->end = b->start + size

buffer_double(buffer *b)
	buffer_set_space(b, 2 * buffer_get_space(b))

buffer_squeeze(buffer *b)
	buffer_set_space(b, buffer_get_size(b))

buffer_cat_char(buffer *b, char c)
	buffer_grow(b, 1)
	*(b->end - 1) = c

buffer_cat_cstr(buffer *b, const char *s)
	int l = strlen(s)
	buffer_grow(b, l)
	memcpy(b->end - l, s, l)

buffer_cat_str(buffer *b, str s)
	int size = str_get_size(s)
	buffer_grow(b, size)
	str_copy(b->end - size, s)

buffer_cat_range(buffer *b, const char *start, const char *end)
	int size = end - start
	buffer_grow(b, size)
	memmove(b->end - size, start, size)

buffer_grow(buffer *b, size_t delta_size)
	buffer_set_size(b, buffer_get_size(b) + delta_size)

buffer_clear(buffer *b)
	b->end = b->start

size_t buffer_get_free(buffer *b)
	return b->space_end - b->end

# this should use a reference or pointer?
char buffer_last_char(buffer *b)
	return b->start[buffer_get_size(b)-1]

boolean buffer_ends_with_char(buffer *b, char c)
	return buffer_get_size(b) && buffer_last_char(b) == c

boolean buffer_ends_with(buffer *b, cstr s)
	size_t len = strlen(s)
	return buffer_get_size(b) >= len && !strncmp(b->end-len, s, len)

char buffer_first_char(buffer *b)
	return b->start[0]

char buffer_get_char(buffer *b, int i)
	return b->start[i]

buffer_zero(buffer *b)
	memset(buffer_get_start(b), 0, buffer_get_size(b))

Def buffer_range(b) buffer_get_start(b), buffer_get_end(b)

def buffer_get_start(b) b->start
def buffer_get_end(b) b->end
def buffer_get_size(b) (size_t)(buffer_get_end(b)-buffer_get_start(b))

# NOTE: you should use buffer_clear() before calling Sprintf,
# otherwise the output will be appended to the buffer.
# (possibly after a terminating \0 !)

int Sprintf(buffer *b, const char *format, ...)
	int len
	va_list ap
	va_start(ap, format)
	len = Vsprintf(b, format, ap)
	va_end(ap)
	return len

# TODO move these?

cstr format(const char *format, ...)
	collect(vformat, format)

cstr vformat(const char *format, va_list ap)
	new(b, buffer, 4096)
	 # vsnprintf() seems to be broken on mingw, can't tell how long unless fits in buffer
	Vsprintf(b, format, ap)
	buffer_add_nul(b)
	buffer_squeeze(b)
	return buffer_get_start(b)

int Vsnprintf(char *buf, size_t size, const char *format, va_list ap)
	let(rv, vsnprintf(buf, size, format, ap))
	if rv < 0
		failed("vsnprintf")
	return rv

int Vsprintf(buffer *b, const char *format, va_list ap)
	va_list ap1
	va_copy(ap1, ap)
	size_t old_size = buffer_get_size(b)
	char *start = b->start + old_size
	size_t space = buffer_get_space(b) - old_size
	if space == 0
		buffer_ensure_space(b, old_size+1)
		start = b->start + old_size
		space = buffer_get_space(b) - old_size
	size_t len = Vsnprintf(start, space, format, ap)
	if len < space
		buffer_grow(b, len)
	 else
		buffer_set_size(b, old_size+len+1)
		start = b->start + old_size
		space = buffer_get_space(b) - old_size
		len = Vsnprintf(start, space, format, ap1)
		assert(old_size+len == buffer_get_size(b)-1, "vsnprintf returned different sizes on same input!!")
		buffer_set_size(b, old_size+len)
	va_end(ap1)
	# we don't include the nul in the buffer size - but it is there!
	# you'd better call buffer_add_nul to make sure
	return len

buffer_add_nul(buffer *b)
	if buffer_get_size(b) == 0 || buffer_last_char(b) != '\0'
		buffer_cat_char(b, '\0')

char *buffer_nul_terminate(buffer *b)
	if buffer_get_size(b) == 0 || buffer_last_char(b) != '\0'
		buffer_cat_char(b, '\0')
		buffer_grow(b, -1)
	return buf0(b)

buffer_strip_nul(buffer *b)
	if buffer_get_size(b) && buffer_last_char(b) == '\0'
		buffer_grow(b, -1)

buffer_dump(FILE *stream, buffer *b)
	Fprintf(stderr, "buffer: %04x %04x %04x (%d):\n", b->start, b->end, b->space_end, b->end - b->start)
	hexdump(stream, b->start, b->end)

def buffer_dump(b)
	buffer_dump(stderr, b)

def buffer_dup(from) buffer_dup_0(from)
buffer *buffer_dup_0(buffer *from)
	return buffer_dup(Talloc(buffer), from)
buffer *buffer_dup(buffer *to, buffer *from)
 # 'to' should be uninitialized (or after free'd)
	buffer_init(to, buffer_get_space(from))
	int size = buffer_get_size(from)
	memcpy(to->start, from->start, size)
	to->end = to->start + size
	return to

cstr buffer_to_cstr(buffer *b)
	buffer_add_nul(b)
	buffer_squeeze(b)
	return buffer_get_start(b)

buffer_from_cstr(buffer *b, cstr s, size_t len)
	b->start = s
	b->end = s + len
	b->space_end = b->end + 1

def buffer_from_cstr(b, s)
	buffer_from_cstr(b, s, strlen(s))

buffer *buffer_from_cstr_1(cstr s)
	size_t len = strlen(s)
	New(b, buffer, len+1)
	buffer_from_cstr(b, s, len)
	return b

def buffer_from_cstr(s)
	buffer_from_cstr_1(s)

def for_buffer(i, b)
	char *i
	char *my(end) = buffer_get_end(b)
	for i=buffer_get_start(b); i!=my(end); ++i

# THIS was not working with brace_include or something :/
#split_buffer(vec *v, buffer *b, char c)
#	vec_clear(v)
#	vec_push(v, buffer_get_start(b))
#	for_buffer(i, b)
#		if *i == c
#			*i = '\0'
			vec_push(v, i+1)

def buffer_is_empty(b) b->start == b->end

buffer_shift(buffer *b, size_t shift)
	char *start = buffer_get_start(b)
	size_t size = buffer_get_size(b)
	memmove(start, start+shift, size-shift)
	buffer_grow(b, -shift)

def buffer_shift(b)
	buffer_shift(b, 1)

# TODO unshift, push, pop ? better names? more efficient impl (circbuf) ?

buffer_ensure_space(buffer *b, size_t space)
	size_t ospace = buffer_get_space(b)
	if space > ospace
		do
			ospace *= 2
		while space > ospace
		buffer_set_space(b, ospace)

buffer_ensure_size(buffer *b, size_t size)
	if buffer_get_size(b) < size
		buffer_set_size(b, size)

buffer_ensure_free(buffer *b, size_t free)
	while buffer_get_free(b) < free
		buffer_double(b)

buffer_nl(buffer *b)
	buffer_cat_char(b, '\n')

def b(buf, i) b->start+i

def buflen(b) buffer_get_size(b)
def buf0(b) buffer_get_start(b)
def bufend(b) buffer_get_end(b)
def bufclr(b) buffer_clear(b)

buf_splice(buffer *b, size_t i, size_t cut, char *in, size_t ins)
	ssize_t in_i = -1
	if in+ins < buf0(b) || in >= bufend(b)
		# in is outside the buffer - good!
	 eif Tween(in, buf0(b), bufend(b))
		# in is fully inside the buffer - ok.
		in_i = in - buf0(b)
	 else
		fault("buf_splice: input overlaps the start or end of the buffer")

	size_t oldlen = buflen(b)

	buffer_grow(b, ins-cut)

	if in_i >= 0
		in = buf0(b) + in_i

	size_t endcut = i+cut
	size_t endins = i+ins

	if in && ins <= cut
		# the buf will shrink - good!
		memmove(b(b,i), in, ins)

	size_t tail = oldlen-endcut
	memmove(b(b,endins), b(b,endcut), tail)

	if in && ins > cut
		# the buf grows - ok.
		size_t hard = 0
		if in_i >= 0
			hard = in+ins - b(b,endcut)
			# the buf grows and 'in' is inside the buffer.
			# the bit in both 'in' and 'tail' is 'hard'.
			if hard > 0
				memcpy(b(b,endins-hard), b(b,endins), hard)
		memmove(b(b,i), in, ins-hard)

def buf_append(b, in, n) buf_insert(b, buflen(b), in, n)

def buf_cut(b, i, n) buf_splice(b, i, n, NULL, 0)

def buf_grow_at(b, i, n) buf_splice(b, i, 0, NULL, n)

def buf_insert(b, i, in, n) buf_splice(b, i, 0, in, n)

def buf_unshift(b, in, n) buf_insert(b, 0, in, n)

def Subbuf(b, i, n) Subbuf(b, i, n, 0)
buffer *Subbuf(buffer *b, size_t i, size_t n, size_t extra)
	buffer *sub = Talloc(buffer)
	subbuf(sub, b, i, n)
	buf_dup_guts(sub, extra)
	return sub

buffer *subbuf(buffer *sub, buffer *b, size_t i, size_t n)
	# warning: subbuf takes an uninitialised buf and sets it to access
	# an area that is actually inside the old buf.
	# The subbuf should not be grown or shrunk! unless you don't mind
	# overwriting the old buf.  Also it should be Free'd not buffer_free'd!
	sub->start = b(b, i)
	sub->space_end = sub->end = b(b, i+n)
	return sub

def buf_dup_guts(b) buf_dup_guts(b, 0)
buf_dup_guts(buffer *b, size_t extra)
	size_t n = buflen(b)
	b->start = memdup(b->start, n, extra)
	b->end = b->start + n
	b->space_end = b->end + extra
