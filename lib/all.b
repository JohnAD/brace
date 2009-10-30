use png.h
use string.h stdlib.h

# this (together with rope.b) is the way I think strings ought to be done

# NB pass strings by pointer (not by value) _consistently_
# NB use either "length" or "size" everywhere, not both?

# TODO redefine buffer in terms of str?

# the law of str:
# every str must have a mutable byte after it (i.e. alloc an extra byte for
# each str) so it can be temporarily converted to a cstr easily by putting a
# '\0' there and then changing it back  :)  nice idea

struct str
	char *start
	char *end

# NEED an abbrev for this?
str new_str(char *start, char *end)
	str s = {start, end}
	return s

str str_null = { NULL, NULL }
def str_is_null(s) s.end == NULL
def str_is_empty(s) s.start == s.end

def str_get_size(s) s.end - s.start
def str_get_start(s) s.start
def str_get_end(s) s.end

str str_dup(str s)
	size_t size = str_get_size(s)
	# TODO in this context, "size" should be implicitly defined as above
	let(ret, str_of_size(size))
	str_copy(ret.start, s)
	return ret

str str_of_size(size_t size)
	str ret
	ret.start = Malloc(size)
	ret.end = ret.start + size
	return ret

# XXX is the to, from syntax sensible?  it's counter-intuitive.
char *str_copy(char *to, str from)
	size_t size = str_get_size(from)
	memmove(to, from.start, size)
	# XXX is memmove significantly less efficient than memcpy??
	return to+size

str_free(str s)
	Free(s.start)
	# str_null(s)

# this mallocs a new buffer for the cstr
# this should be in cstr.b, but I'm afraid of the mk_cc bug!
cstr cstr_from_str(const str s)
	int size = str_get_size(s)
	let(cs, cstr_of_size(size))
	strlcpy(cs, s.start, size+1)
	return cs

def str_from_buffer(b) *(str *)b
 # buffers are "str-compatible"

str str_cat_2(str s1, str s2)
	size_t s1_size = str_get_size(s1)
	size_t s2_size = str_get_size(s2)
	let(ret, str_of_size(s1_size + s2_size))
	str_copy(ret.start, s1)
	str_copy(ret.start + s1_size, s2)
	return ret

str str_cat_3(str s1, str s2, str s3)
	size_t s1_size = str_get_size(s1)
	size_t s2_size = str_get_size(s2)
	size_t s3_size = str_get_size(s3)
	let(ret, str_of_size(s1_size + s2_size + s3_size))
	str_copy(ret.start, s1)
	str_copy(ret.start + s1_size, s2)
	str_copy(ret.start + s1_size + s2_size, s3)
	return ret

def str_cat(a, b) str_cat_2(a, b)
def str_cat(a, b, c) str_cat_3(a, b, c)

# TODO a coherent function-form / relational-form return value system
#   the CALLER declares the space for the return value, and passes in a pointer
#   to it, or else receives a register value.

str str_from_char(char c)
	let(ret, str_of_size(1))
	*ret.start = c
	return ret

str str_from_cstr(cstr cs)
	return new_str(cstr_range(cs))
def S(cs) str_from_cstr(cs)
def CS(cs) cstr_from_str(cs)  # XXX conflicts with South!
 # this is for use mid-expression, especially with cstr literals

 # TODO need a better syntax for const literal strs
 # TODO need printf etc replacements that support strs / ropes, not just cstrs

## use memmem!
#
#char *find_str(char *haystack0, char *haystack1, char *needle0, char *needle1)
#	let(end, haystack1 - (needle1-needle0) + 1)
#	for(imy(i), haystack0 ; i!=end ; ++i

Def str_range(s) s.start, s.end

str_dump(str s)
	memdump(str_range(s))

char *str_chr(str s, char c)
	return memchr(s.start, c, str_get_size(s))

str str_null = { NULL, NULL }

str str_str(str haystack, str needle)
	str rv
	rv.start = mem_mem(haystack.start, str_get_size(haystack),
	  needle.start, str_get_size(needle))
	if rv.start == NULL
		return str_null
	rv.end = rv.start + str_get_size(needle)
	return rv

cstr *str_str_start(str haystack, str needle)
	return mem_mem(haystack.start, str_get_size(haystack),
	  needle.start, str_get_size(needle))

fprint_str(FILE *stream, str s)
	fprint_range(stream, str_get_start(s), str_get_end(s))
	#Fwrite(str_get_start(s), 1, str_get_size(s), stream)

#prints_and_says(str)

print_str(str s)
	fprint_str(stdout, s)

fsay_str(FILE *stream, str s)
	fprint_str(stream, s)
	nl(stream)

say_str(str s)
	fsay_str(stdout, s)
export sys/types.h
export stdint.h
export limits.h
export float.h

typedef uint8_t byte
typedef double num
typedef unsigned char boolean
  # TODO change all boolean to bool
#typedef int bool
  # TODO hack around C++ with an ^ifndef __c_plus_plus ?
typedef char *cstr
typedef unsigned int count_t
#typedef size_t size

typedef unsigned short ushort;
typedef unsigned char uchar;
typedef unsigned long ulong;
typedef unsigned int uint;
typedef signed char schar;
typedef long vlong;

# TODO if not C++  ?
def true 1
def false 0

typedef struct timeval timeval
typedef struct timespec timespec
typedef struct tm datetime

typedef void free_t(void *)

union any
	void *p
	char *cs
	char c
	short s
	int i
	long l
	long long ll
	float f
	double d
	long double ld
	size_t z
	off_t o

typedef long long long_long
typedef long double long_double

typedef signed int signed_int
typedef signed short signed_short
typedef signed char signed_char
typedef signed long signed_long
typedef signed long long signed_long_long
typedef unsigned int unsigned_int
typedef unsigned short unsigned_short
typedef unsigned char unsigned_char
typedef unsigned long unsigned_long
typedef unsigned long long unsigned_long_long

typedef void *ptr

typedef unsigned int flag
export stdlib.h
use string.h
export stdio.h

# this is a general buffer, revised version to be compatible with libb strs
# I haven't decided if this is a good idea or not yet.
# The generic get/let syntax seems okay, now need lang support for namespaces!

# TODO make sure it always has a '\0' after the allocated data

# TODO make this stuff more efficient

# TODO buffer should start with 0 bytes size and no memory allocated,
# so can alloc buffer size on first use in case of a repeatedly reused buffer
# ???

# TODO have two types of "buffer", "vec", etc, one that is on the heap, and one
# that is on the stack (somehow!). We can't realloc space on the stack, it
# would have to just lose the first space. It would be much faster than
# malloc'd space though. Or maybe if it needs to realloc, it could move the
# storage to the heap.


struct buffer
	char *start
	char *end
	char *space_end

buffer_init(buffer *b, size_t space)
	if space == 0
		space = 1
	b->start = (char *)Malloc(space)
	b->end = b->start
	b->space_end = b->start + space
def buffer_init(b) buffer_init(b, 128)  # was 8

buffer_free(buffer *b)
	Free(b->start)

buffer_set_space(buffer *b, size_t space)
	size_t size = buffer_get_size(b)
	assert(size <= space, "cannot set buffer space less than buffer size")
	if space == 0
		space = 1
#	if buffer_get_space(b) != b->space
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
	int l = str_get_size(s)
	buffer_grow(b, l)
	str_copy(b->end - l, s)

buffer_cat_range(buffer *b, const char *start, const char *end)
	int l = end - start
	buffer_grow(b, l)
	memmove(b->end - l, start, l)

buffer_grow(buffer *b, size_t delta_size)
	buffer_set_size(b, buffer_get_size(b) + delta_size)

buffer_clear(buffer *b)
	b->end = b->start

# this should use a reference or pointer?
char buffer_last_char(buffer *b)
	return b->start[buffer_get_size(b)-1]

boolean buffer_ends_with_char(buffer *b, char c)
	return buffer_get_size(b) && buffer_last_char(b) == c

boolean buffer_ends_with(buffer *b, cstr s)
	ssize_t len = strlen(s)
	return buffer_get_size(b) >= len && !strncmp(b->end-len, s, len)

char buffer_first_char(buffer *b)
	return b->start[0]

char buffer_get_char(buffer *b, size_t i)
	return b->start[i]

buffer_zero(buffer *b)
	memset(buffer_get_start(b), 0, buffer_get_size(b))

Def buffer_range(b) buffer_get_start(b), buffer_get_end(b)

def buffer_get_start(b) b->start
def buffer_get_end(b) b->end
def buffer_get_size(b) (ssize_t)(buffer_get_end(b)-buffer_get_start(b))
def buffer_get_space(b) (ssize_t)(b->space_end - b->start)
def buffer_get_free(b) (ssize_t)(b->space_end - b->end)

# NOTE: you should use buffer_clear() before calling Sprintf,
# otherwise the output will be appended to the buffer.
# (possibly after a terminating \0 !)

int Sprintf(buffer *b, const char *format, ...)
	collect(Vsprintf, b, format)

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

# fformat calls tofree() on the new string:

cstr fformat(const char *format, ...)
	collect(vformat, format)

cstr vfformat(const char *format, va_list ap)
	return tofree(vformat(format, ap))

int Vsnprintf(char *buf, size_t size, const char *format, va_list ap)
	let(rv, vsnprintf(buf, size, format, ap))
	if rv < 0
		failed("vsnprintf")
	return rv

int Vsprintf(buffer *b, const char *format, va_list ap)
	va_list ap1
	va_copy(ap1, ap)
	ssize_t old_size = buffer_get_size(b)
	char *start = b->start + old_size
	ssize_t space = buffer_get_space(b) - old_size
	if space == 0
		buffer_ensure_space(b, old_size+1)
		start = b->start + old_size
		space = buffer_get_space(b) - old_size
	ssize_t len = Vsnprintf(start, space, format, ap)
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

char *buffer_add_nul(buffer *b)
	buffer_cat_char(b, '\0')
	return buf0(b)

char *buffer_nul_terminate(buffer *b)
#	if buffer_get_size(b) == 0 || buffer_last_char(b) != '\0'
	buffer_cat_char(b, '\0')
	buffer_grow(b, -1)
	return buf0(b)

buffer_strip_nul(buffer *b)
	if buffer_get_size(b) && buffer_last_char(b) == '\0'
		buffer_grow(b, -1)

buffer_dump(FILE *stream, buffer *b)
	Fprintf(stream, "buffer: %08x %08x %08x (%d):\n", b->start, b->end, b->space_end, b->end - b->start)
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
	state char *my(i1)
	state char *my(end) = buffer_get_end(b)
	for my(i1)=buffer_get_start(b); my(i1)!=my(end); ++my(i1)
		let(i, my(i1))

# THIS was not working with brace_include or something :/
#split_buffer(vec *v, buffer *b, char c)
#	vec_clear(v)
#	vec_push(v, buffer_get_start(b))
#	for_buffer(i, b)
#		if *i == c
#			*i = '\0'
#			vec_push(v, i+1)

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

buffer_ensure_size(buffer *b, ssize_t size)
	if buffer_get_size(b) < size
		buffer_set_size(b, size)

buffer_ensure_free(buffer *b, ssize_t free)
	while buffer_get_free(b) < free
		buffer_double(b)

buffer_nl(buffer *b)
	buffer_cat_char(b, '\n')

def b(b, i) b->start+i

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

buffer_cat_chars(buffer *b, char c, size_t n)
	buffer_grow(b, n)
	char *p = bufend(b) - n
	memset(p, c, n)

buffer_cat_int(buffer *b, int i)
	# TODO speed this up?
	Sprintf(b, "%d", i)

buffer_cat_long(buffer *b, long i)
	# TODO speed this up?
	Sprintf(b, "%ld", i)
export stdlib.h
use string.h

# this is a circular buffer
# should I integrate this with the general buffer?
# should I make it "inherit" from the general buffer?

# can I integrate this with "string" somehow?

struct circbuf
	ssize_t size
	ssize_t space
	ssize_t start
	char *data

circbuf_init(circbuf *b, ssize_t space)
	b->space = space ? space : 1
	b->data = Malloc(b->space)
	b->size = 0
	b->start = 0

def circbuf_get_start(b) b->data + b->start
def circbuf_get_size(b) b->size
def circbuf_get_end(b) circbuf_get_pos(b, b->size)
def circbuf_get_space_end(b) b->data + b->space
def circbuf_get_space_start(b) b->data
def circbuf_is_wrapped(b) b->size >= b->space - b->start
def circbuf_get_free(b) circbuf_get_space(b) - circbuf_get_size(b)
def circbuf_get_free_1(b) circbuf_is_wrapped(b) ? b->space - b->size : b->space - b->start - b->size
def circbuf_get_free_2(b) circbuf_is_wrapped(b) ? 0 : b->start
def circbuf_get_space(b) b->space
def circbuf_get_size_1(b) circbuf_is_wrapped(b) ? b->space - b->start : b->size
def circbuf_get_size_2(b) circbuf_is_wrapped(b) ? b->start + b->size - b->space : 0

char *circbuf_get_pos(circbuf *b, int index)
	char *pos = b->data + b->start + index
	if b->start + index >= b->space
		pos -= b->space
	return pos

circbuf_free(circbuf *b)
	Free(b->data)

circbuf_set_space(circbuf *b, ssize_t space)
	space = space ? space : 1
	char *new_data = Malloc(space)
	ssize_t max_first_part = b->space - b->start
	ssize_t second_part = b->size - max_first_part
	if second_part <= 0
#		fprintf(stderr, "a %010p %010p %08x\n", new_data, b->data+b->start, b->size)
		memcpy(new_data, b->data+b->start, b->size)
	else
#		fprintf(stderr, "b %010p %010p %08x\n", new_data, b->data+b->start, max_first_part)
		memcpy(new_data, b->data+b->start, max_first_part)
#		fprintf(stderr, "c %010p %010p %08x\n", new_data+max_first_part, b->data, second_part)
		memcpy(new_data+max_first_part, b->data, second_part)
	Free(b->data)
	b->data = new_data
	b->space = space
	b->start = 0

circbuf_ensure_space(circbuf *b, ssize_t space)
	ssize_t ospace = circbuf_get_space(b)
	if space > ospace
		do
			ospace *= 2
		while space > ospace
		circbuf_set_space(b, ospace)

circbuf_ensure_size(circbuf *b, ssize_t size)
	if circbuf_get_size(b) < size
		circbuf_set_size(b, size)

circbuf_ensure_free(circbuf *b, ssize_t free)
	while circbuf_get_free(b) < free
		circbuf_double(b)

circbuf_set_size(circbuf *b, ssize_t size)
	ssize_t space = b->space
	while size > space
		space *= 2
		circbuf_set_space(b, space)
	b->size = size

circbuf_grow(circbuf *b, ssize_t delta_size)
	circbuf_set_size(b, circbuf_get_size(b) + delta_size)

circbuf_shift(circbuf *b, ssize_t delta_size)
	b->start += delta_size
	if b->start >= b->space
		b->start -= b->space
	b->size -= delta_size

def circbuf_shift(b)
	circbuf_shift(b, 1)

circbuf_unshift(circbuf *b, ssize_t delta_size)
	circbuf_ensure_free(b, delta_size)
	b->start -= delta_size
	if b->start < 0
		b->start += b->space
	b->size += delta_size

def circbuf_unshift(b)
	circbuf_unshift(b, 1)

# TODO push == grow, unshift, pop ???
#   XXX push would not be similar to vec:push

circbuf_double(circbuf *b)
	circbuf_set_space(b, b->space * 2)

circbuf_squeeze(circbuf *b)
	circbuf_set_space(b, b->size)

# TODO circbuf_get_wrap,origin

def cb(b, i) circbuf_get_pos(b, i)

def cbuflen(b) circbuf_get_size(b)
def cbuf0(b) circbuf_get_start(b)
def cbufend(b) circbuf_get_end(b)
def cbufclr(b) circbuf_clear(b)

circbuf_clear(circbuf *b)
	b->size = 0
	b->start = 0

buffer_to_circbuf(circbuf *cb, buffer *b)
	cb->space = buffer_get_space(b)
	cb->data = buf0(b)
	cb->size = buflen(b)
	cb->start = 0

circbuf_cat_char(circbuf *b, char c)
	circbuf_grow(b, 1)
	*cb(b, cbuflen(b)-1) = c

circbuf_cat_cstr(circbuf *b, const char *s)
	ssize_t l = strlen(s)
	circbuf_cat_range(b, s, s+l)

circbuf_cat_str(circbuf *b, str s)
	circbuf_cat_range(b, s.start, s.end)

# circbuf_cat_range does not work with a range that is inside the circbuf

circbuf_cat_range(circbuf *b, const char *start, const char *end)
	ssize_t l = end - start
	circbuf_grow(b, l)
	char *space_end = circbuf_get_space_end(b)
	char *i = cb(b, circbuf_get_size(b) - l)
	ssize_t l1 = space_end - i
	boolean onestep = l <= l1
	if onestep
		l1 = l
	memcpy(i, start, l1)
	if !onestep
		memcpy(b->data, start+l1, l - l1)

char circbuf_first_char(circbuf *b)
	return *cb(b, 0)

char circbuf_last_char(circbuf *b)
	return *cb(b, cbuflen(b)-1)

char circbuf_get_char(circbuf *b, ssize_t i)
	return *cb(b, i)

int Vsprintf_cb(circbuf *b, const char *format, va_list ap)
	va_list ap1
	va_copy(ap1, ap)
	ssize_t old_size = circbuf_get_size(b)
	char *start = cbufend(b)
	ssize_t free = circbuf_get_free(b)
	ssize_t free_1 = circbuf_get_free_1(b)
	if free_1 == 0
		circbuf_ensure_space(b, old_size+1)
		start = cbufend(b)
		free = circbuf_get_free(b)
		free_1 = circbuf_get_free_1(b)
	ssize_t len = Vsnprintf(start, free_1, format, ap)
	if len < free_1
		circbuf_grow(b, len)
	 eif len < free
		char tmp[len+1]
		ssize_t len1 = Vsnprintf(tmp, len+1, format, ap1)
		assert(len == len1, "vsnprintf returned different sizes on same input!!")
		circbuf_cat_range(b, tmp, tmp+len+1)  # FIXME just copy the 2nd half of it
		circbuf_grow(b, -1)
	 else
		# FIXME keep the 1st half of it when resizing?
		circbuf_ensure_space(b, old_size+len+1)
		start = cbufend(b)
		free_1 = circbuf_get_free_1(b)
		assert(free_1 >= len+1, "Vsprintf_cb: circbuf_ensure_space did not work properly")
		ssize_t len1 = Vsnprintf(start, free_1, format, ap1)
		assert(len == len1, "vsnprintf returned different sizes on same input!!")
		circbuf_grow(b, len)
	va_end(ap1)
	# we don't include the nul in the circbuf size - but it is there!
	# you'd better call circbuf_add_nul to make sure
	return len

circbuf_add_nul(circbuf *b)
	if circbuf_get_size(b) == 0 || circbuf_last_char(b) != '\0'
		circbuf_cat_char(b, '\0')

circbuf_to_buffer(buffer *b, circbuf *cb)
	circbuf_tidy(cb)
	b->start = cb->data
	b->end = b->start + cb->size
	b->space_end = b->start + cb->space

circbuf_tidy(circbuf *b)
	if b->start == 0
		return
	ssize_t l1 = circbuf_get_size_1(b)
	ssize_t l2 = circbuf_get_size_2(b)
	if l1 <= l2
		char tmp[l1]
		memcpy(tmp, cbuf0(b), l1)
		if l2
			memmove(b->data + l1, b->data, l2)
		memcpy(b->data, tmp, l1)
	 else
		char tmp[l2]
		memcpy(tmp, b->data, l2)
		memmove(b->data, cbuf0(b), l1)
		memcpy(b->data + l1, tmp, l2)
	b->start = 0

cstr circbuf_to_cstr(circbuf *b)
	if !circbuf_get_free(b)
		circbuf_grow(b, 1)
		assert(b->start == 0, "circbuf_grow did not work properly")
	 else
		circbuf_tidy(b)

	circbuf_add_nul(b)
	circbuf_squeeze(b)
	return cbuf0(b)

char *circbuf_nul_terminate(circbuf *b)
	if circbuf_is_wrapped(b) || circbuf_get_size(b) == 0 || circbuf_last_char(b) != '\0'
		circbuf_to_cstr(b)
	circbuf_grow(b, -1)
	return cbuf0(b)

# TODO circbuf_readv, circbuf_writev?

ssize_t cbindex_not_len(circbuf *b, char *p)
	ssize_t i = p - cbuf0(b)
	if i < 0
		i += circbuf_get_space(b)
	return i

ssize_t cbindex_not_0(circbuf *b, char *p)
	ssize_t i = p - cbuf0(b)
	if i <= 0
		i += circbuf_get_space(b)
	return i

circbuf_from_cstr(circbuf *b, cstr s, ssize_t len)
	b->data = s
	b->size = len
	b->space = len + 1
	b->start = 0

def circbuf_from_cstr(b, s)
	circbuf_from_cstr(b, s, strlen(s))

circbuf_dump(FILE *stream, circbuf *b)
	Fprintf(stream, "circbuf: %08x %08x %08x %08x:\n", b->data, b->size, b->space, b->start)
	hexdump(stream, b->data, b->data + b->space)

def circbuf_dump(b)
	circbuf_dump(stderr, b)

circbuf_copy_out(circbuf *b, void *dest, ssize_t i, ssize_t n)
	i += b->start
	if i >= b->space
		i -= b->space
	ssize_t n0 = lmin(n, b->space - i)
	ssize_t n1 = n - n0
	memcpy(dest, b->data + i, n0)
	if n1
		memcpy((char*)dest + n0, b->data, n1)

circbuf_cat_cb_range(circbuf *b, circbuf *from, ssize_t i, ssize_t n)
	ssize_t to = circbuf_get_size(b)
	circbuf_grow(b, n)
	
	ssize_t l1 = circbuf_get_size_1(from)

	if i < l1
		ssize_t n1 = l1 - i
		if n1 > n
			n1 = n
		circbuf_copy_in(b, to, cb(from, i), n1)
		n -= n1
		if n
			to += n1
			circbuf_copy_in(b, to, from->data, n)
	 else
		circbuf_copy_in(b, to, cb(from, i), n)

circbuf_copy_in(circbuf *b, ssize_t i, void *from, ssize_t n)
	char *p = cb(b, i)
	ssize_t l0 = circbuf_get_space_end(b) - p
	ssize_t l1 = n - l0
	if n < l0
		l0 = n
	memcpy(p, from, l0)
	if l1 > 0
		memcpy(b->data, (char *)from+l0, l1)


# TODO implement without circbuf??

struct deq
	circbuf b
	ssize_t element_size
	ssize_t space
	ssize_t size
	ssize_t start

_deq_init(deq *q, ssize_t element_size, ssize_t space)
	q->space = space ? space : 1
	circbuf_init(&q->b, q->space * element_size)
	q->element_size = element_size
	q->size = 0
	q->start = 0

Def deq_init(v, element_type, space) _deq_init(v, sizeof(element_type), (space))
def deq_init(v, element_type) deq_init(v, element_type, 1)

deq_free(deq *q)
	circbuf_free(&q->b)

deq_space(deq *q, ssize_t space)
	q->space = space ? space : 1
	circbuf_set_space(&q->b, q->space * q->element_size)
	if q->b.start == 0
		q->start = 0

deq_size(deq *q, ssize_t size)
	ssize_t cap = q->space
	if size > cap
		do
			cap *= 2
		while size > cap
		deq_space(q, cap)
	q->size = size
	q->b.size = size * q->element_size

deq_clear(deq *q)
	circbuf_clear(&q->b)
	q->start = q->size = 0

deq_double(deq *q)
	deq_space(q, q->space * 2)

deq_squeeze(deq *q)
	deq_space(q, q->size)

void *deq_element(deq *q, ssize_t index)
	#if index < 0
	#	index += v->size
	index += q->start
	if index >= q->space
		index -= q->space
	return q->b.data + index * q->element_size

void *deq_push(deq *q)
	if q->size == q->space
		deq_double(q)
	++q->size
	q->b.size += q->element_size
	return deq_element(q, q->size-1)
def deq_push(q, data)
	*(typeof(data) *)deq_push(q) = data

deq_pop(deq *q)
	--q->size
	q->b.size -= q->element_size
Def deq_pop(q, var)
	let(my(p), castto_ref(deq_top(q), &var))
	data = *my(p)
	deq_pop(q)

void *deq_top(deq *q, ssize_t index)
	return deq_element(q, q->size -1 - index)
def deq_top(q) deq_top(q, 0)
def deq_bot(q) deq_get_start(q)

# perl terminology, ugh! :)
# shift is ok, how about a better word than unshift...  shuft?  ;)

void *deq_unshift(deq *q)
	if q->size == q->space
		deq_double(q)
	++q->size
	q->b.size += q->element_size
	if q->start > 0
		--q->start
		q->b.start -= q->element_size
	else
		q->start = q->space - 1
		q->b.start = q->b.space - q->element_size
	return deq_element(q, 0)
def deq_unshift(q, data)
	*(typeof(&data))deq_unshift(q) = data

deq_shift(deq *q)
	--q->size
	if q->size == 0
		deq_clear(q)
		return
	q->b.size -= q->element_size
	++q->start
	q->b.start += q->element_size
	if q->start >= q->space
		q->start -= q->space
		q->b.start -= q->b.space
Def deq_shift(q, data)
	let(my(p), castto_ref(deq_bot(q), &data))
	data = *my(p)
	deq_shift(q)

def deq_get_start(q) deq_element(q, 0)
def deq_get_end(q) deq_element(q, q->size)
def deq_set_size(q, size) deq_size(q, size)
def deq_get_size(q) q->size

def deq_get_space_end(q) (void *)(q->b.data + q->b.space)
def deq_get_space_start(q) (void *)(q->b.data)

def for_deq(i, q, type)
	state deq *my(q1) = q
	state type *i = deq_get_start(my(q1))
	state type *my(end) = deq_get_end(my(q1))
	state type *my(wrap) = deq_get_space_end(my(q1))
	state type *my(origin) = deq_get_space_start(my(q1))
	if deq_get_size(my(q1))
		my(st)
	for ; i != my(end) ; ++i, i = i == my(wrap) ? my(origin) : i
my(st)		.
 # this is a hack!

def deq_set_space deq_space
def deq_get_space(q) q->space

def q(deq, i) deq_element(deq, i)

def deqlen(q) deq_get_size(q)
def deqclr(q) deq_clear(q)

deq_grow(deq *q, ssize_t delta_size)
	deq_set_size(q, deqlen(q) + delta_size)

deq_cat_range(deq *q, void *start, void *end)
	ssize_t old_space = q->b.space
	circbuf_cat_range(&q->b, start, end)
	if q->b.space != old_space
		deq_recalc_from_cb(q)
	 else
	 	q->size = q->b.size / q->element_size

deq_recalc_from_cb(deq *q)
	q->start = q->b.start / q->element_size
	q->space = q->b.space / q->element_size
	q->size = q->b.size / q->element_size

deq_shifts(deq *q, ssize_t n)
	q->size -= n
	if q->size == 0
		deq_clear(q)
	 else
		circbuf_shift(&q->b, q->element_size * n)
		q->start += n
		if q->start >= q->space
			q->start -= q->space

deq_unshifts(deq *q, ssize_t n)
	q->size += n
	circbuf_unshift(&q->b, q->element_size * n)
	q->start -= n
	if q->start < 0
		q->start += q->space

deq_copy_out(deq *q, void *dest, ssize_t i, ssize_t n)
	ssize_t es = q->element_size
	circbuf_copy_out(&q->b, dest, i*es, n*es)

deq_cat_deq_range(deq *q, deq *from, ssize_t i, ssize_t n)
	ssize_t old_space = q->b.space
	ssize_t es = q->element_size
	circbuf_cat_cb_range(&q->b, &from->b, i*es, n*es)
	if q->b.space != old_space
		deq_recalc_from_cb(q)
	 else
	 	q->size += n

deq_cat_deq(deq *q, deq *from)
	deq_cat_deq_range(q, from, 0, deqlen(from))

deq_copy_in(deq *q, ssize_t i, void *from, ssize_t n)
	ssize_t es = q->element_size
	circbuf_copy_in(&q->b, i*es, from, n*es)

vec_to_deq(deq *q, vec *v)
	q->element_size = v->element_size
	buffer_to_circbuf(&q->b, &v->b)
	deq_recalc_from_cb(q)

deq_to_vec(vec *v, deq *q)
	v->element_size = q->element_size
	circbuf_to_buffer(&v->b, &q->b)
	deq_recalc_from_cb(q)
	vec_recalc_from_buffer(v)

deq_tidy(deq *q)
	circbuf_tidy(&q->b)
	deq_recalc_from_cb(q)

data_to_deq(deq *q, void *data, ssize_t size, ssize_t element_size)
	q->element_size = element_size
	q->size = q->space = size
	q->start = 0
	q->b.size = q->b.space = size * element_size
	q->b.start = 0
	q->b.data = data

deq_to_data(deq *q, void **data, ssize_t *size)
	deq_tidy(q)
	*data = q(q, 0)
	*size = deqlen(q)


# deq tees

ssize_t deqt_pre(deq *t, deq *q, ssize_t offset)
	*t = *q
	deq_shifts(t, offset)
	return deqlen(t)

ssize_t deqt_post(deq *t, ssize_t oldsize)
	ssize_t offset = oldsize - deqlen(t)
	return offset

deqts_shift(deq *q, ssize_t *offsets, ssize_t n)
	ssize_t min_offset = deqts_min_offset(offsets, n)
	deqts_shift_offsets(offsets, n, min_offset)
	deq_shifts(q, min_offset)

ssize_t deqts_min_offset(ssize_t *offsets, ssize_t n)
	ssize_t min_offset = *offsets
	for(i, offsets+1, offsets+n)
		if *i < min_offset
			min_offset = *i
	return min_offset

deqts_shift_offsets(ssize_t *offsets, ssize_t n, ssize_t min_offset)
	for(i, offsets, offsets+n)
		*i -= min_offset

def deqt_do(t, q, offset)
	deqt_do(t, q, offset, my(size0), my(x))
def deqt_do(t, q, offset, size0, x)
	ssize_t size0
	post(x)
		offset = deqt_post(t, size0)
	pre(x)
		size0 = deqt_pre(t, q, offset)
		.


typedef void *thunk_func(void *obj, void *common_arg, void *specific_arg)

struct thunk
	thunk_func *func
	void *obj
	void *common_arg

def thunk() (thunk){ thunk_void, NULL, NULL }
def thunk(f) (thunk){ f, NULL, NULL }
def thunk(f, o) (thunk){ f, o, NULL }
def thunk(f, o, a) (thunk){ f, o, a }

def thunk_init(t, func, obj, common_arg)
	t->func = func
	t->obj = obj
	t->common_arg = common_arg
def thunk_init(t, func, obj)
	thunk_init(t, func, obj, NULL)
def thunk_init(t, func)
	thunk_init(t, func, NULL, NULL)
def thunk_init(t)
	thunk_init(t, thunk_ignore)
def thunk_init_thunks(t, d)
	thunk_init(t, thunk_thunks, d, NULL)

void *thunk_ignore(void *obj, void *common_arg, void *specific_arg)
	use(obj) ; use(common_arg) ; use(specific_arg)
	return thunk_yes

void *thunk_void(void *obj, void *common_arg, void *specific_arg)
	use(obj) ; use(common_arg) ; use(specific_arg)
	return thunk_no

void *thunk_thunks(void *obj, void *common_arg, void *specific_arg)
	use(common_arg)
	return thunks_call((deq*)obj, specific_arg)

def thunk_call(t, specific_arg) (*t->func)(t->obj, t->common_arg, specific_arg)

def thunk_call(t) thunk_call(t, NULL)

thunk _thunk_null = { NULL, NULL, NULL }
thunk *thunk_null = &_thunk_null

def thunk_not_null(thunk) thunk->func != NULL
def thunk_is_null(thunk) thunk->func == NULL

# thunk_call_deq: call a series of thunks until an event is handled.
# a deq is my recommended container for this
# you could also use a list, vec or priq
def thunks_call(q)
	call_thunks(q, NULL)
void *thunks_call(deq *q, void *specific_arg)
	for_deq(i, q, thunk)
		void *handled = thunk_call(i, specific_arg)
		if handled
			return handled
	return thunk_no

# thunk return values:
# thunk_no (0) means not handled - try some other handler
# thunk_yes (1) means it was handled
# thunk_err (-1) means some error happened but don't try other handers

def thunk_no i2p(0)
def thunk_yes i2p(1)
def thunk_err i2p(-1)
def thunk_int(i) i2p(i)
#use stdlib.h

# a singly-linked list
# used by hash.b

# The list itself is a plain "struct list".  This first struct
# in the list is not a node, but a pointer to the first node
# (or NULL).  The nodes are each a "struct list" pointing to
# the next node, followed by an arbitrary payload.  This list
# does not allocate or free memory itself.

struct list
	list *next

def list_next_p(node) &node->next

list_init(list *l)
	l->next = NULL

boolean list_is_empty(list *l)
	return l->next == NULL

# # This inserts new_node after old_node.
# # This only works to insert single nodes!
# # You don't have to call list_init for a node which will be inserted with list_insert
# list_insert(list *old_node, list *new_node)
# 	new_node->next = old_node->next
# 	old_node->next = new_node

# list types????!

def list_insert(link, object)
	let(next, *link)
	*link = object
	*list_next_p(object) = next

 # general insert, at a link, not at a node :)
 # do also list_insert_before list_insert_after --- prepend, append?

 # TODO empty lists...  I think when a list is empty e.g. db = NULL,
 # and the list manip functions/macros should modify that if inserting at the
 # start of the list or whatever...  this means list pointers would have to be
 # passed by reference somehow.., like a pointer to the link (pointer) to the
 # first node..that's ok

list *list_last(list *l)
	# XXX maybe should remember the tail of a list? no
	while l->next != NULL
		l = l->next
	return l

def list_next(l) l->next

# This unlinks the node after this link from the list.
# pre-req : *link is not NULL !
# This does NOT free memory, you need to free the node after (NOT before!) doing this.
def list_delete(link)
	*link = (*link)->next

# perhaps list_delete should be implemented in terms of a list_splice or list_cut ?

list_dump(list *l)
	repeat
		if l == NULL
			Say("NULL")
			break
		else
			Sayf("%010p ", l)
			l = list_next(l)

list *list_reverse(list *l)
	list *prev = NULL
	while l != NULL
		list *next = l->next
		l->next = prev
		prev = l
		l = next
	return prev

list *list_reverse_fast(list *l)
	list *prev = NULL
	repeat
		if l == NULL
			return prev
		list *next = l->next
		l->next = prev
		# now, to avoid those assignments!
		if next == NULL
			return l
		prev = next->next
		next->next = l
		# last one!
		if prev == NULL
			return next
		l = prev->next
		prev->next = next

list_push(list **list_pp, list *new_node)
	list_insert(list_pp, new_node)

list_pop(list **list_pp)
	list_delete(list_pp)

# idea - a general purpose function to create a node and insert it in an existing list in one go.  dodgy code:
#
#_link_list(list *prev, list *next, size_t size)
#	list *l = Malloc(sizeof(list *) + size)
#	if prev
#		prev->next = l
#	l->next = next
#	return &l->data
#
## FIXME change all _foo functions to foo_ ?
#_link_list_ptr(list *prev, list *next)
#	list *l = Malloc(sizeof(list *) + size)
#	if prev
#		prev->next = l
#	l->next = next
#	return &l->data

# 
# # pre-declare "node" so the type can be cast
# # FIXME for_list should use a node ref (ptr to prev node's list *)
# # so can delete or insert before?
# def for_list(node_p, l)
# 	node_p = (typeof(node_p))l
# 	for ; node_p != NULL ; node_p = (typeof(node_p))(((list *)node_p)->next)
# 
# I think the normal c-style list is better, where we just put next in the
# right place and don't include a "list" struct or anything like that.
# This here works but it would be simpler without the casting, right?


def for_list(i, first_link, link0, link1)
	# link0 and link1 are set to pointers to the links, i.e. node **
	let(link1, first_link)
	while *link1
		let(link0, link1)
		let(i, *link0)
		link1 = list_next_p(i)
		.

# we use i_p so can delete and pre-insert nodes in a list
# next_p is needed so can delete a node
# I would HOPE this stuff is optimised away in the cases where it's not used :p

# we refer to a LIST by a POINTER to its FIRST LINK, not the VALUE of its
# first LINK, which would be a pointer to its first NODE.
# When using macros or automatic referencing this could be done implicitly,
# but if want to be using function-calls we need to do it this way.

def for_list(i, first_link)
	for_list(i, first_link, my(link0), my(link1))
	# this should optimise clean if link0 and link1 weren't used in the
	# loop body, I hope!

# Should the list pointer point at the actual struct, and the "next" be stored
# at [-4] bytes or whatever?  maybe just let's try to write the "list" stuff
# with such generality that it would be doable to make this change later
# list_next_p is to help with that, and part of the general "struct accessors"
# idea.  I want to get brace to still output clean C this will be a challenge :)

# Maybe we could make a nice "graph" container with nodes and links,
# using this method of putting the links previous to the object pointer in memory.
# it might be assumed that the number of links from a node is known, or the list
# might be NULL terminated (or pre-terminated!)  hm how insane is this?!
# Anyway this "list" could then be a specific case of the graph type.

# And double-linked lists could use some functions designed to search lists, etc!


# list_free frees a list and all nodes
# it MIGHT in future need to know what type the nodes are for different allocator,
# can do that using sizeof(typeof(*foo)) in a macro I guess!
# can do allocators contextually too like graphics, IO, ...
list_free(list **l)
	for_list(i, l)
		Free(i)

# FIXME we need a "link" type and a "node" type, not a "list" type (which would be same as link type)
# can't use the name "link" though unless we rename the library function.  HOW to do that?


# list of void *:

struct list_x
	list *next
	void *o

list_x_init(list_x *n, void *o)
	n->o = o


# TODO base this on a hashset ?
# maybe I should use (wrap) the glib hashtable for now?
# surely glib has lots of useful stuff

# TODO make hashtable work as a multi-hash by default,
# i.e. "add" always adds a new node...

# TODO use the hashtable itself for storage?  this would probably be more
# efficient overall.  maybe

struct hashtable
	list *buckets
	size_t size
	hash_func *hash
	eq_func *eq

# TODO count, is_empty

# hashtable abbrevs:

def Get(ht, key) hashtable_value(ht, i2p(key))
def get(ht, key) hashtable_value_or_null(ht, i2p(key))
def get(ht, key, value) hashtable_value_or(ht, i2p(key), i2p(value))
def put(ht, key, value) hashtable_add(ht, i2p(key), i2p(value))
def kv(ht, key) hashtable_lookup(ht, i2p(key))
def del(ht, key) hashtable_delete(ht, i2p(key))
def KV(ht, key) hashtable_lookup_or_die(ht, i2p(key))
def kv(ht, key, init) hashtable_lookup_or_add_key(ht, i2p(key), i2p(init))
def already(ht, key) hashtable_already(ht, i2p(key))

def set(ht, key, value)
	set(ht, key, value, void)
def set(ht, key, value, free_or_void)
	hashtable_set(ht, key, value, free_or_void)

def hashtable_set(ht, key, value, free_or_void)
	let(my(kv), kv(ht, key, NULL))
	if my(kv)->v
		free_or_void(my(kv)->v)
	my(kv)->v = i2p(value)

# TODO, simplify hashtable so that it always returns a ref, and use key() and
# val() to get the key and value parts.

typedef unsigned long hash_func(void *key)
typedef boolean eq_func(void *k1, void *k2)

# I miss C++!!

# TODO typedef list *hashtable_node_ref

key_value kv_null = { i2p(-1), i2p(-1) }

def kv_is_null(kv) kv.k == i2p(-1)

# TODO use ^^ to join type to _hash and _eq instead of passing both
# TODO like priq, use macros for hash_func and all hashtable funcs and pass type / hash_func / type_eq in to functions that need them..?


# TODO replace new(ht, hashtable .......) crap with this simpler stuff

def ht(foo)
	new(foo, hashtable)
def Ht(foo)
	New(foo, hashtable)
def HT(foo)
	NEW(foo, hashtable)

def hashtable_default_buckets 101

def hashtable_init(ht)
	hashtable_init(ht, hashtable_default_buckets)
def hashtable_init(ht, size)
	hashtable_init(ht, cstr_hash, cstr_eq, size)
def hashtable_init(ht, hash, eq)
	hashtable_init(ht, hash, eq, hashtable_default_buckets)
hashtable_init(hashtable *ht, hash_func *hash, eq_func *eq, size_t size)
	ht->size = hashtable_sensible_size(size)
	ht->buckets = alloc_buckets(ht->size)
	ht->hash = hash
	ht->eq = eq

# TODO rename to ht_* ?

list *alloc_buckets(size_t size)
	list *buckets = Nalloc(list, size)
	list *end = buckets + size
	list *i
	for i = buckets ; i != end ; ++i
		list_init(i)
	return buckets

#hashtable_set_size(hashtable *ht, size_t new_size)
	#list *new_buckets = alloc_buckets(new_size)
	# XXX TODO rehash, free old buckets, etc.
	#.

# this returns a list *, the actual matching node is rv->next -
#  this is so we can delete nodes, check if exists then add, etc
list *hashtable_lookup_ref(hashtable *ht, void *key)
	list *bucket = which_bucket(ht, key)
	eq_func *eq = ht->eq
	repeat
		node_kv *node = (node_kv *)bucket->next
		if node == NULL || (*eq)(key, node->kv.k)
			return bucket
		bucket = (list *)node

# XXX return a key_value instead of a key_value * ??
key_value *hashtable_lookup(hashtable *ht, void *key)
	list *l = hashtable_lookup_ref(ht, key)
	if l->next == NULL
		return NULL
	 else
		return hashtable_ref_lookup(l)

key_value *hashtable_ref_lookup(list *l)
	node_kv *node = (node_kv *)l->next
	return (key_value *)&node->kv

void *hashtable_value(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup(ht, key)
	if kv == NULL
		error("hashtable_value: key does not exist")
		return NULL # keep GCC happy
	 else
		return kv->v

void *hashtable_value_or_null(hashtable *ht, void *key)
	return hashtable_value_or(ht, key, NULL)
void *hashtable_value_or(hashtable *ht, void *key, void *def)
	key_value *kv = hashtable_lookup(ht, key)
	if kv == NULL
		return def
	 else
		return kv->v

key_value *hashtable_add(hashtable *ht, void *key, void *value)
	list *l = hashtable_lookup_ref(ht, key)
	hashtable_ref_add(l, key, value)
	return hashtable_ref_key_value(l)

hashtable_ref_add(list *l, void *key, void *value)
	if !hashtable_ref_add_maybe(l, key, value)
		error("hashtable_ref_add: key already exists")

key_value *hashtable_add_maybe(hashtable *ht, void *key, void *value)
	list *l = hashtable_lookup_ref(ht, key)
	if hashtable_ref_add_maybe(l, key, value)
		return hashtable_ref_key_value(l)
	 else
		return NULL

boolean hashtable_ref_add_maybe(list *l, void *key, void *value)
	if l->next != NULL
		return 0
	
	node_kv *node = Talloc(node_kv)
	node->kv.k = key ; node->kv.v = value
	list_insert(list_next_p(l), (list *)node)
	return 1

# XXX TODO MAYBE make hashtable_add receive an already alloc'd node_kv,
#   and make hashtable_delete return it again, i.e. hashtable does not do
#   memory alloc itself

# this returns key_value because may need to free the strings?
# XXX better to use a hook?
# see above TODO MAYBE
key_value hashtable_delete(hashtable *ht, void *key)
	list *l = hashtable_lookup_ref(ht, key)
	return hashtable_ref_delete(l)

hashtable_delete_maybe(hashtable *ht, void *key)
	list *l = hashtable_lookup_ref(ht, key)
	if hashtable_ref_exists(l)
		hashtable_ref_delete(l)

key_value hashtable_ref_delete(list *l)
	key_value ret
	if hashtable_ref_exists(l)
		node_kv *node = hashtable_ref_node(l)
		list_delete(list_next_p(l))
		ret = node->kv
		Free(node)
	 else
		ret = kv_null
	return ret

node_kv *hashtable_ref_node(list *l)
	node_kv *node = (node_kv *)l->next
	assert(node != NULL, "hashtable_ref_node: node not found")
	return node

boolean hashtable_ref_exists(list *l)
	return l->next != NULL

# XXX todo a way to customise error messages produced by called subs?

key_value *hashtable_ref_key_value(list *l)
	node_kv *node = hashtable_ref_node(l)
	return &node->kv

list *which_bucket(hashtable *ht, void *key)
	unsigned int hash = (*ht->hash)(key)
	unsigned int i = hash % ht->size
	return ht->buckets + i

size_t hashtable_sensible_size(size_t size)
	if size == 0
		size = 1
	return size
	# TODO use primes?

# TODO keep track of max bucket size, number of elements, etc.

def hash_mult 101 #7123

# TODO is this a good hash function?  I forget!
unsigned long cstr_hash(void *s)
	unsigned long rv = 0
	for(i, cstr_range((char *)s))
		rv *= hash_mult
		rv += *i
	return rv

hashtable_dump(hashtable *ht)
	uint i
	for i=0; i<ht->size; ++i
		list *bucket = &ht->buckets[i]
		list *l = bucket
		repeat
			Printf("%010p ", l)
			l = l->next
			if l == NULL
				break
		nl()
	nl()

key_value *hashtable_lookup_or_add_key(hashtable *ht, void *key, void *value_init)
	list *ref = hashtable_lookup_ref(ht, key)
	if ref->next == NULL
		hashtable_ref_add(ref, key, value_init)
	return hashtable_ref_lookup(ref)

key_value *hashtable_lookup_or_die(hashtable *ht, void *key)
	list *ref = hashtable_lookup_ref(ht, key)
	if ref->next == NULL
		failed0("hashtable_lookup_or_die")
	return hashtable_ref_lookup(ref)

#void *hashtable_ref_value(list *l)
#	node_kv *node = hashtable_ref_node(l)
#	return node->kv.v
#
#void *hashtable_ref_value_ptr(list *l)
#	node_kv *node = hashtable_ref_node(l)
#	return &node->kv.v


# this is hackily designed in a single loop so you can "break" from it
# have to pre-declare "key" and "value" so the types can be cast
def for_hashtable(key, value, ht)
	for_hashtable(key, value, ht, my(kv), my(ref))
def for_hashtable(key, value, ht, kv, ref)
	_for_hashtable(key, value, ht, kv, ref, my(bucket), my(end), my(next))
def _for_hashtable(_key, _value, ht, _kv, ref, bucket, end, _next)
	list *bucket = ht->buckets
	list *end = bucket + ht->size
	list *ref = bucket
	list *_next
	for ; ; ref = _next
		while bucket != end && ref->next == NULL
			++bucket
			ref = bucket
		if bucket == end
			break
		node_kv *n = (node_kv *)ref->next
		key_value *_kv = &n->kv
		_key = (typeof(_key))_kv->k
		_value = (typeof(_value))_kv->v
		_next = ref->next

def hashtable_exists(ht, key) hashtable_lookup(kt, key)

# this is redundant to hashtable_lookup I guess?
# should def hashtable_exists hashtable_lookup  ?
# otherwise it should be just a hashset I guess
#boolean hashtable_exists(hashtable *ht, void *key)
#	list *l = hashtable_lookup_ref(ht, key)
#	return hashtable_ref_exists(l)

# need a "reference" type I guess, so can assign to the "value" easier
# or use "with" ?

# TODO change hashtable_init so the number is the 3rd arg, as we're more likely to want to vary it than the hash type (cstr)  ??

# FIXME rename node->kv to node->k_value ?



# This int_hash converts the int to a cstr first then hashes that.
# disadvantage - a bit slow
# advantages
#  - can look up by string too potentially
#  - works with any size int, long too, up to sizeof(void *)
#  - same method could work for other types (float, struct etc)

unsigned long int_hash(void *i_ptr)
	long i = p2i(i_ptr)
	char s[64]
	size_t size = snprintf(s, sizeof(s), "%ld", i)
	if size >= sizeof(s)
		failed("int_hash")
	return cstr_hash(s)

boolean int_eq(void *a, void *b)
	return p2i(a) == p2i(b)

# here is an alternate I got from http://www.concentric.net/~Ttwang/tech/inthash.htm
# in java code, works for 32 bits only
#public int hash32shift(int key)
#{
#  key = ~key + (key << 15); // key = (key << 15) - key - 1;
#  key = key ^ (key >>> 12);
#  key = key + (key << 2);
#  key = key ^ (key >>> 4);
#  key = key * 2057; // key = (key + (key << 3)) + (key << 11);
#  key = key ^ (key >>> 16);
#  return key;
#}
#

def hashtable_free(ht)
	hashtable_free(ht, NULL, NULL)
hashtable_free(hashtable *ht, free_t *free_key, free_t *free_value)
	hashtable_clear(ht, free_key, free_value)
	Free(ht->buckets)

def hashtable_clear(ht)
	hashtable_clear(ht, NULL, NULL)
hashtable_clear(hashtable *ht, free_t *free_key, free_t *free_value)
	list *bucket = ht->buckets
	list *end = bucket + ht->size
	for ; bucket != end; ++bucket
		list *item = bucket->next
		while item
			list *next = item->next
			node_kv *node = (node_kv *)item
			if free_key
				free_key(node->kv.k)
			if free_value
				free_value(node->kv.v)
			Free(node)
			item = next

# multi-hash functions

# mget returns NULL if empty or a vec of pointers to whatever if not

vec *mget(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->v
	return v

mput(hashtable *ht, void *key, void *value)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->v
	if v == NULL
		NEW(kv->v, vec, void*, 1)
		v = kv->v
	*(void**)vec_push(v) = value

def mdel(ht, key, value, Free_or_void)
	mdel(ht, key, value, Free_or_void, my(kv))
def mdel(ht, key, value, Free_or_void, kv)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->v
	if v == NULL
		warn("mdel: key not found")
	 else
	 	int already = 0
		grep(i, v, void*, *i == value && !already++, Free_or_void)  # not ideal but ok

def mdelmany(ht, key, value, Free_or_void)
	mdelmany(ht, key, value, Free_or_void, my(kv))
def mdelmany(ht, key, value, Free_or_void, kv)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->v
	if v == NULL
		warn("mdel: key not found")
	 else
		grep(i, v, void*, *i == value, Free_or_void)

def mdelall(ht, key, Free_or_void)
	mdelall(ht, key, Free_or_void, my(kv))
def mdelall(ht, key, Free_or_void)
	list *l = hashtable_lookup_ref(ht, key)
	if l->next != NULL
		key_value *kv = hashtable_ref_lookup(l)
		vec *v = kv->v
	 	for_vec(i, v, void *)
			Free_or_void(*i)
		vec_free(v)
		hashtable_ref_delete(l)

void *mget1(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->v
	if v && veclen(v) == 1
		return *(void**)vec0(v)
	 else
	 	return NULL

ssize_t mgetc(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->v
	return v ? veclen(v) : 0

void *mget1st(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->v
	if v && veclen(v)
		return *(void**)vec0(v)
	 else
	 	return NULL

void *mgetlast(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->v
	if v && veclen(v)
		return *(void**)vec_top(v)
	 else
	 	return NULL

# TODO for_mhashtable ...


# TODO ordered hash option - using a double-linked list to keep the keys in insertion order
# TODO sorted hash option - using a tree or something to keep the keys in sort order?
# or actually use a tree for the data structure

kv_cstr_to_hashtable(hashtable *ht, cstr kv[][2])
	table_cstr_to_hashtable(ht, kv, 2, 0, 1)
#	cstr (*i)[2] = kv
#	for ; (*i)[0] ; ++i
#		put(ht, (*i)[0], (*i)[1])

table_cstr_to_hashtable(hashtable *ht, void *table, long width, long ki, long vi)
	cstr *i = table
	for ; *i ; i += width
		put(ht, i[ki], i[vi])

ssize_t hashtable_already(hashtable *ht, void *key)
	Assert(sizeof(ssize_t) <= sizeof(void*), warn, "sizeof(ssize_t) %zu is bigger than sizeof(void *) %zu", sizeof(ssize_t), sizeof(void*))
	ssize_t count, count1
	key_value *x = kv(ht, key, i2p(0))
	count = (ssize_t)p2i(x->v)
	count1 = count + 1
	if !count1
		count1 = 1
	x->v = i2p(count1)
	return count


unsigned long vos_hash(void *s)
	unsigned long rv = 0
	for_vec(i, (vec*)s, cstr)
		cstr l = *i
		rv *= hash_mult
		for(j, cstr_range(l))
			rv *= hash_mult
			rv += *j
	return rv

boolean vos_eq(void *_v1, void *_v2)
	vec *v1 = _v1, *v2 = _v2
	if veclen(v1) != veclen(v2)
		return 0
	cstr *p2 = vec0(v2)
	for_vec(p1, v1, cstr)
		if !cstr_eq(*p1, *p2)
			return 0
		++p2
	return 1

keys(vec *out, hashtable *ht)
	void *k, *v
	for_hashtable(k, v, ht)
		vec_push(out, k)

values(vec *out, hashtable *ht)
	void *k, *v
	for_hashtable(k, v, ht)
		vec_push(out, v)

sort_keys(vec *out, hashtable *ht)
	keys(out, ht)
	sort(out)

# XXX crappy hack to get around ordering bug
struct thunk
	thunk_func *func
	void *obj
	void *common_arg

export errno.h setjmp.h
use stdio.h stdarg.h stdlib.h


def debug warn
#def debug void

def verbose warn

int exit__error = 125
int exit__fault = 124

# warning: because sigsetjmp is a lot slower than setjmp I have changed to using setjmp
# This means that the signal mask might be wrong after an exception, have to be careful about that.
# I could make an option to use sigsetjmp in some cases.
# perf:  sigsetjmp = 0.7ms  setjmp = 0.025ms  28X faster

# Generally, a function that outputs error messages etc should not generate new
# errors (for fear of an infinite loop). That's also the case for warnings,
# because many error printing functions call a warning function to print the
# message.

# Anything that outputs on stderr should flush stdout first and stderr after.
# On mingw, stderr is not automatically flushed. Maybe that can be configured?

# TODO or, use try and fatal to handle errors in error routines?

error(const char *format, ...)
	collect_void(verror, format)

verror(const char *format, va_list ap)
	new(b, buffer)  # FIXME 256
	Vsprintf(b, format, ap)
	buffer_add_nul(b)
	buffer_squeeze(b)
	Throw(buffer_get_start(b), 0, NULL)

serror(const char *format, ...)
	collect_void(vserror, format)

vserror(const char *format, va_list ap)
	int no = errno
	new(b, buffer)
	Vsprintf(b, format, ap)
	Sprintf(b, ": %s", Strerror(no))
	buffer_add_nul(b)
	buffer_squeeze(b)
	Throw(buffer_get_start(b), no, NULL)

warn(const char *format, ...)
	collect_void(vwarn, format)
def warn()
	warn("")

vwarn(const char *format, va_list ap)
	format_add_nl(format1, format)
	fflush(stdout)
	vfprintf(stderr, format1, ap)
	if mingw
		fflush(stderr)

failed(const char *funcname)
	serror("%s failed", funcname)

# I think this 2 arg version isn't used
failed2(const char *funcname, const char *errmsg)
	serror("%s failed: %s", funcname, errmsg)
failed3(const char *funcname, const char *msg1, const char *msg2)
	serror("%s failed: %s, %s", funcname, msg1, msg2)

def failed(funcname, errmsg)
	failed2(funcname, errmsg)

def failed(funcname, msg1, msg2)
	failed3(funcname, msg1, msg2)

def failed0(funcname)
	error("%s failed", funcname)

def failed0(funcname, errmsg)
	error("%s failed: %s", funcname, errmsg)

def failed0(funcname, msg1, msg2)
	error("%s failed: %s, %s", funcname, msg1, msg2)

warn_failed(const char *funcname)
	swarning("%s failed", funcname)

swarning(const char *format, ...)
	collect_void(vswarning, format)

vswarning(const char *format, va_list ap)
	fflush(stdout)
	Vfprintf(stderr, format, ap)
	fprintf(stderr, ": ")
	Perror(NULL)
	if mingw
		fflush(stderr)

# hexdump from util is better, but this is ok for single-line stuff
memdump(const char *from, const char *to)
	Fflush(stdout)
	while from != to
		Fprintf(stderr, "%02x ", (const unsigned char)*from)
		++from
	Fprintf(stderr, "\n")
	if mingw
		Fflush(stderr)

def assert_check 1
def assert_error fault

def assert(should_be_true)
	Assert(should_be_true, assert_error)
def assert(should_be_true, format)
	Assert(should_be_true, assert_error, format)
def assert(should_be_true, format, a1)
	Assert(should_be_true, assert_error, format, a1)
def assert(should_be_true, format, a1, a2)
	Assert(should_be_true, assert_error, format, a1, a2)
def assert(should_be_true, format, a1, a2, a3)
	Assert(should_be_true, assert_error, format, a1, a2, a3)
def assert(should_be_true, format, a1, a2, a3, a4)
	Assert(should_be_true, assert_error, format, a1, a2, a3, a4)

def Assert(should_be_true, my_error)
	if assert_check && !should_be_true
		my_error("assertion failed")
def Assert(should_be_true, my_error, format)
	if assert_check && !should_be_true
		my_error(format)
def Assert(should_be_true, my_error, format, a1)
	if assert_check && !should_be_true
		my_error(format, a1)
def Assert(should_be_true, my_error, format, a1, a2)
	if assert_check && !should_be_true
		my_error(format, a1, a2)
def Assert(should_be_true, my_error, format, a1, a2, a3)
	if assert_check && !should_be_true
		my_error(format, a1, a2, a3)
def Assert(should_be_true, my_error, format, a1, a2, a3, a4)
	if assert_check && !should_be_true
		my_error(format, a1, a2, a3, a4)

def usage(syntax)
	warn_usage(syntax)
	Exit(1)
def usage(s1, s2)
	warn_usage(s1, s2)
	Exit(1)

def fsay_usage(s, syntax)
	Fsayf(s, "usage: %s %s", program, syntax)
def fsay_usage(s, s1, s2)
	Fsayf(s, "usage: %s %s\n       %s %s", program, s1, program, s2)

def warn_usage(syntax)
	fsay_usage(stderr, syntax)
def warn_usage(s1, s2)
	fsay_usage(stderr, s1, s2)

def say_usage(syntax)
	fsay_usage(stdout, syntax)
def say_usage(s1, s2)
	fsay_usage(stdout, s1, s2)

fsay_usage_(FILE *s, cstr *usage)
	let(i, usage)
	let(my(first), 1)
	for ; *i; ++i
		if my(first)
			Fsayf(s, "usage: %s %s", program, *i)
			my(first) = 0
		 else
			Fsayf(s, "       %s %s", program, *i)

def fsay_usage(s)
	fsay_usage_(s, usage)
def warn_usage()
	fsay_usage(stderr)
def say_usage()
	fsay_usage(stdout)
def usage()
	warn_usage()
	Exit(1)

# exception handling stuff - including revised versions of error() etc

struct err
	cstr msg
	int no
	void *data
	# add "where" somehow

vec *error_handlers
vec *errors

# TODO add a way to handle errors in coros here

struct error_handler
#	sigjmp_buf *jump
	jmp_buf *jump
	thunk handler
	int err

# TODO
# vec *cleanup_handlers

# Don't know how to do this with return.
# Maybe use "return" that calls cleanup handlers / finally first.
# Use exceptions instead of "return" out of place or goto?

error_init()
	global(error_handlers, vec, error_handler, 16)
	global(errors, vec, err, 16)
	global(extra_error_messages, hashtable, int_hash, int_eq, 101)

def try(h)
	try(h, thunk_null, 1)
def try(h, thunk)
	try(h, thunk, 0)
def try(h, thunk, need_jump)
	state error_handler *h = vec_push(error_handlers)
	h->handler = *thunk
	if need_jump
#		h->jump = Talloc(sigjmp_buf)
		h->jump = Talloc(jmp_buf)
#		h->err = sigsetjmp(*h->jump, 1)
		h->err = setjmp(*h->jump)
	 else
		h->jump = NULL
		h->err = 0
	state int my(stage)
	for my(stage) = 0 ; h->err == 0 ; ++my(stage)
		if my(stage) == 1
			if need_jump
				Free(h->jump)
			vec_pop(error_handlers)
			break
		.

def final()
	.
		.

def except(h)
	if h->err
		.

err *error_add(cstr msg, int no, void *data)
	err *e = vec_push(errors)
	e->msg = msg
	e->no = no
	e->data = data
	return e

def errors() vec_get_size(errors)

def Throw() throw_(NULL)
def Throw(msg) Throw(msg, 0)
def Throw(msg, no) Throw(msg, no, NULL)

Throw(cstr msg, int no, void *data)
	throw_(error_add(msg, no, data))

throw_(err *e)
	if vec_is_empty(error_handlers)
		die_errors(exit__error)
	error_handler *h = vec_top(error_handlers)
	if thunk_not_null(&h->handler)
		if thunk_call(&h->handler, e)
			h->jump = NULL
	if h->jump
		vec_pop(error_handlers)
#		siglongjmp(*h->jump, 1)
		longjmp(*h->jump, 1)

def die_errors() die_errors(1)

die_errors(int status)
	warn_errors()
	if *env("DEBUG")
		abort()
	Exit(status)

clear_errors()
	for_vec(e, errors, err)
		Free(e->msg)
		Free(e->data)
	vec_set_size(errors, 0)

def warn_errors(format)
	warn(format)
	warn_errors()
def warn_errors(format, a0)
	warn(format, a0)
	warn_errors()
def warn_errors(format, a0, a1)
	warn(format, a0, a1)
	warn_errors()
def warn_errors(format, a0, a1, a2)
	warn(format, a0, a1, a2)
	warn_errors()
def warn_errors(format, a0, a1, a2, a3)
	warn(format, a0, a1, a2, a3)
	warn_errors()

warn_errors()
	warn_errors_keep()
	clear_errors()

warn_errors_keep()
	for_vec(e, errors, err)
		warn("%s", e->msg)

def debug_errors(format)
	debug(format)
	debug_errors()
def debug_errors(format, a0)
	debug(format, a0)
	debug_errors()
def debug_errors(format, a0, a1)
	debug(format, a0, a1)
	debug_errors()
def debug_errors(format, a0, a1, a2)
	debug(format, a0, a1, a2)
	debug_errors()
def debug_errors(format, a0, a1, a2, a3)
	debug(format, a0, a1, a2, a3)
	debug_errors()

debug_errors()
	debug_errors_keep()
	clear_errors()

debug_errors_keep()
	for_vec(e, errors, err)
		use(e)
		debug("%s", e->msg)

def fault(format)
	fault_(__FILE__, __LINE__, format)
def fault(format, a0)
	fault_(__FILE__, __LINE__, format, a0)
def fault(format, a0, a1)
	fault_(__FILE__, __LINE__, format, a0, a1)
def fault(format, a0, a1, a2)
	fault_(__FILE__, __LINE__, format, a0, a1, a2)
def fault(format, a0, a1, a2, a3)
	fault_(__FILE__, __LINE__, format, a0, a1, a2, a3)
def fault(format, a0, a1, a2, a3, a4)
	fault_(__FILE__, __LINE__, format, a0, a1, a2, a3, a4)

int throw_faults = 0

fault_(char *file, int line, const char *format, ...)
	collect_void(vfault_, file, line, format)

vfault_(char *file, int line, const char *format, va_list ap)
	file = best_path_main(Strdup(file))
	new(b, buffer)
	Sprintf(b, "%s:%d: ", file, line)
	Vsprintf(b, format, ap)
	buffer_add_nul(b)
	buffer_squeeze(b)
	if throw_faults
		Throw(buf0(b), 0, NULL)
	 else
		error_add(buf0(b), 0, NULL)
		die_errors(exit__fault)

hashtable *extra_error_messages

add_error_message(int errnum, cstr message)
	hashtable_add(extra_error_messages, i2p(errnum), message)

cstr Strerror(int errnum)
	key_value *kv = hashtable_lookup(extra_error_messages, i2p(errnum))
	if kv == NULL
		return strerror(errnum)
	 else
		return kv->v

Perror(const char *s)
	cstr msg = Strerror(errno)
	if s
		warn("%s: %s", s, msg)
	 else
		warn("%s", msg)

# "bash" runs all the code in the block, ignoring errors
# (any errors are still collected)
# This is not related to the shell "bash"!

def bash(h)
	try(h, thunk_error_ignore, 0)

def bash_warn(h)
	try(h, thunk_error_warn, 0)

def bash_keep(h)
	try(h, thunk_null, 0)

thunk _thunk_error_warn = { error_warn, NULL, NULL }
thunk *thunk_error_warn = &_thunk_error_warn

void *error_warn(void *obj, void *common_arg, void *er)
	use(obj) ; use(common_arg)
	fflush(stdout)
	fprintf(stderr, "%s\n", ((err*)er)->msg)
	if mingw
		fflush(stderr)
	vec_pop(errors)
	return thunk_yes

thunk _thunk_error_ignore = { error_ignore, NULL, NULL }
thunk *thunk_error_ignore = &_thunk_error_ignore

void *error_ignore(void *obj, void *common_arg, void *er)
	use(obj) ; use(common_arg) ; use(er)
	vec_pop(errors)
	return thunk_yes

typedef enum { OE_CONT, OE_ERRCODE, OE_ERROR, OE_WARN=1<<31 } opt_err

any opt_err_do(opt_err opt, any value, any errcode, char *format, ...)
	collect(vopt_err_do, opt, value, errcode, format)

any vopt_err_do(opt_err opt, any value, any errcode, char *format, va_list ap)
	if opt & OE_WARN || opt == OE_ERROR
		opt &= ~OE_WARN
		if opt == OE_ERROR
		 	verror(format, ap)
		 else
			vwarn(format, ap)

	which opt
	OE_CONT	return value
	OE_ERRCODE	return errcode
	else	failed("vopt_err_do", "unknown opt_err option")
	return errcode

boolean is_verbose = 0

def Verbose(a0)
	if is_verbose
		warn(a0)
def Verbose(a0, a1)
	if is_verbose
		warn(a0, a1)
def Verbose(a0, a1, a2)
	if is_verbose
		warn(a0, a1, a2)
def Verbose(a0, a1, a2, a3)
	if is_verbose
		warn(a0, a1, a2, a3)
def Verbose(a0, a1, a2, a3, a4)
	if is_verbose
		warn(a0, a1, a2, a3, a4)
def Verbose(a0, a1, a2, a3, a4, a5)
	if is_verbose
		warn(a0, a1, a2, a3, a4, a5)
def Verbose(a0, a1, a2, a3, a4, a5, a6)
	if is_verbose
		warn(a0, a1, a2, a3, a4, a5, a6)
def Verbose(a0, a1, a2, a3, a4, a5, a6, a7)
	if is_verbose
		warn(a0, a1, a2, a3, a4, a5, a6, a7)
use stdlib.h

# maybe rename process.b -> system.b ?

# magic exit code, semi-consistent with bash
# bash distinguishes not found (127) and if the file was found but not
# executable (126). We return 127 in case of any exec error.

int exit__execfailed = 127
int status__execfailed = 512 + 127

boolean process__forked = 0
boolean process__fork_fflush = 1
boolean process__exit_fflush = 1

boolean exec__warn_fail = 1

Atexit(void (*function)(void))
	if atexit(function) != 0
		failed("atexit")

def exit() exit(0)

void Exit(int status)
	if process__forked
		if process__exit_fflush
			Fflush_all()
		_Exit(status)
	exit(status)

def Exit() Exit(0)

# TODO maybe I could raise() a signal to kill the process with thereby a
# non-normal exit status in case of not being able to exec the child process?
# I would like to be able to return the errno from exec to the parent, too.

Execv(const char *path, char *const argv[])
	execv(path, argv)
	if exec__warn_fail
		warn_failed("execv")
	exit_exec_failed()

Execvp(const char *file, char *const argv[])
	execvp(file, argv)
	if exec__warn_fail
		warn_failed("execvp")
	exit_exec_failed()

Execve(const char *filename, char *const argv[], char *const envp[])
	execve(filename, argv, envp)
	if exec__warn_fail
		warn_failed("execve")
	exit_exec_failed()

# XXX TODO use local, not static?
static vec exec_argv
static int exec_argv_init = 0

# XXX shouldn't have to specify void
static void exec_argv_do_init()
	vec_init(&exec_argv, cstr, 10)
	exec_argv_init = 1

Execl(const char *path, ...)
	collect_void(Vexecl, path)

Vexecl(const char *path, va_list ap)
	if !exec_argv_init
		exec_argv_do_init()
	vec_clear(&exec_argv)
	repeat
		char *arg = va_arg(ap, char *)
		if arg == NULL
			break
		*(char **)vec_push(&exec_argv) = arg
	Execv(path, (char *const *)vec_to_array(&exec_argv))

# TODO macros to simplify common varargs usage?
# TODO macros!

Execlp(const char *file, ...)
	collect_void(Vexeclp, file)

Vexeclp(const char *file, va_list ap)
	if !exec_argv_init
		exec_argv_do_init()
	vec_clear(&exec_argv)
	repeat
		char *arg = va_arg(ap, char *)
		if arg == NULL
			break
		*(char **)vec_push(&exec_argv) = arg
	Execvp(file, (char *const *)vec_to_array(&exec_argv))

Execle(const char *path, ...)
	collect_void(Vexecle, path)

Vexecle(const char *path, va_list ap)
	# and char *const envp[]
	if !exec_argv_init
		exec_argv_do_init()
	vec_clear(&exec_argv)
	repeat
		char *arg = va_arg(ap, char *)
		if arg == NULL
			break
		*(char **)vec_push(&exec_argv) = arg
	char *const *envp = va_arg(ap, char *const *)
	Execve(path, (char *const *)vec_to_array(&exec_argv), envp)

# as usual, you should set to->size to 0 first
sh_quote(const char *from, buffer *to)
	char c
	int i = buffer_get_size(to)
	repeat
		c = *from
		if c == '\0'
			break
		if (c >= 'A' && c <= 'Z') ||
		 (c >= 'a' && c <= 'z') ||
		 (c >= '0' && c <= '9') ||
		 strchr("-_./", c) != NULL
			# doesn't need escaping
			buffer_set_size(to, i+1)
			to->start[i] = c
			++i
		 eif c == '\n'
			buffer_set_size(to, i+3)
			to->start[i] = '"'
			to->start[i+1] = c
			to->start[i+2] = '"'
			i += 3
		 else
			buffer_set_size(to, i+2)
			to->start[i] = '\\'
			to->start[i+1] = c
			i += 2
		++from
	buffer_nul_terminate(to)

# as usual, you should set to->size to 0 first
cmd_quote(const char *from, buffer *to)
	let(quote, strchr(from, ' ') != NULL)
	if quote
		buffer_cat_char(to, '"')
	buffer_cat_cstr(to, (cstr)from)
	if quote
		buffer_cat_char(to, '"')
	buffer_nul_terminate(to)

boolean system_verbose = 0

# System - this only fails with an error if it can't exec the subprocess, not
# if the subprocess itself returns an error code

int System(const char *s)
	if system_verbose
		warn(s)
	int status = system(s)
	if status == -1
		failed("system")
	if WIFEXITED(status)
		return WEXITSTATUS(status)
	return -1

int Systemf(const char *format, ...)
	collect(Vsystemf, format)

# SYSTEM, SYSTEMF - this one fails if the subprocess fails

SYSTEM(const char *s)
	if System(s)
		failed("system", s)

SYSTEMF(const char *format, ...)
	collect_void(VSYSTEMF, format)

VSYSTEMF(const char *format, va_list ap)
	int rv = Vsystemf(format, ap)
	if rv
		failed("system")

# TODO rename buffer to string??
# but would conflict with C++ standard.  buffer is ok

int Vsystemf(const char *format, va_list ap)
	static buffer b
	static int init = 0
	if !init
		buffer_init(&b, 32)
		init = 1
	buffer_clear(&b)
	Vsprintf(&b, format, ap)
	return System(b.start)

sighandler_t Signal(int signum, sighandler_t handler)
	sighandler_t rv = signal(signum, handler)
	if rv == SIG_ERR
		failed("signal")
	return rv

def ignore_ctrl_c()
	Sigign(SIGINT)

def allow_ctrl_c()
	Sigdfl(SIGINT)


int Systema_q(boolean quote, const char *filename, char *const argv[])
	new(b, buffer, 256)
	system_quote_check_uq(quote, filename, b)
	while (*argv) {
		buffer_cat_char(b, ' ')
		system_quote_check_uq(quote, *argv, b)
		++argv
	}
	cstr command = buffer_to_cstr(b)
#	warn("command: %s", command)
	let(rv, System(command))
	buffer_free(b)
	uq_clean()
	return rv

def Systema(filename, argv) Systema_q(1, filename, argv)

def Systemau(filename, argv) Systema_q(0, filename, argv)

system_quote_check_uq(boolean quote, const char *s, buffer *b)
	if quote && !is_uq(s)
		system_quote(s, b)
	 else
	 	buffer_cat_cstr(b, s)

int Systemv_q(boolean quote, const char *filename, char *const argv[])
	# the filename is repeated in argv[0] - so skip it
	return Systema_q(quote, filename, argv+1)

def Systemv(filename, argv) Systemv_q(1, filename, argv)

def Systemvu(filename, argv) Systemv_q(0, filename, argv)

# note: for Systeml, unlike exec, and unlike Systemv, the
# filename is not repeated

int Systeml__q(boolean quote, const char *filename, ...)
	collect(Vsysteml_q, quote, filename)

int Systeml_(const char *filename, ...)
	collect(Vsysteml, filename)

int Systemlu_(const char *filename, ...)
	collect(Vsystemlu, filename)

int Vsysteml_q(boolean quote, const char *filename, va_list ap)
	if !exec_argv_init
		exec_argv_do_init()
	vec_clear(&exec_argv)
	*(const char **)vec_push(&exec_argv) = filename
	repeat
		char *arg = va_arg(ap, char *)
		if arg == NULL
			break
		*(char **)vec_push(&exec_argv) = arg
	return Systemv_q(quote, filename, (char *const *)vec_to_array(&exec_argv))

def Vsysteml(filename, ap) Vsysteml_q(1, filename, ap)

def Vsystemlu(filename, ap) Vsysteml_q(0, filename, ap)

def Systeml(filename) Systeml_(filename, NULL)
def Systeml(filename, a0) Systeml_(filename, a0, NULL)
def Systeml(filename, a0, a1) Systeml_(filename, a0, a1, NULL)
def Systeml(filename, a0, a1, a2) Systeml_(filename, a0, a1, a2, NULL)
def Systeml(filename, a0, a1, a2, a3) Systeml_(filename, a0, a1, a2, a3, NULL)
def Systeml(filename, a0, a1, a2, a3, a4) Systeml_(filename, a0, a1, a2, a3, a4, NULL)
def Systeml(filename, a0, a1, a2, a3, a4, a5) Systeml_(filename, a0, a1, a2, a3, a4, a5, NULL)
def Systeml(filename, a0, a1, a2, a3, a4, a5, a6) Systeml_(filename, a0, a1, a2, a3, a4, a5, a6, NULL)
def Systeml(filename, a0, a1, a2, a3, a4, a5, a6, a7) Systeml_(filename, a0, a1, a2, a3, a4, a5, a6, a7, NULL)

def Systeml_q(quote, filename) Systeml__q(quote, filename, NULL)
def Systeml_q(quote, filename, a0) Systeml__q(quote, filename, a0, NULL)
def Systeml_q(quote, filename, a0, a1) Systeml__q(quote, filename, a0, a1, NULL)
def Systeml_q(quote, filename, a0, a1, a2) Systeml__q(quote, filename, a0, a1, a2, NULL)
def Systeml_q(quote, filename, a0, a1, a2, a3) Systeml__q(quote, filename, a0, a1, a2, a3, NULL)
def Systeml_q(quote, filename, a0, a1, a2, a3, a4) Systeml__q(quote, filename, a0, a1, a2, a3, a4, NULL)
def Systeml_q(quote, filename, a0, a1, a2, a3, a4, a5) Systeml__q(quote, filename, a0, a1, a2, a3, a4, a5, NULL)
def Systeml_q(quote, filename, a0, a1, a2, a3, a4, a5, a6) Systeml__q(quote, filename, a0, a1, a2, a3, a4, a5, a6, NULL)
def Systeml_q(quote, filename, a0, a1, a2, a3, a4, a5, a6, a7) Systeml__q(quote, filename, a0, a1, a2, a3, a4, a5, a6, a7, NULL)

def Systemlu(filename) Systemlu_(filename, NULL)
def Systemlu(filename, a0) Systemlu_(filename, a0, NULL)
def Systemlu(filename, a0, a1) Systemlu_(filename, a0, a1, NULL)
def Systemlu(filename, a0, a1, a2) Systemlu_(filename, a0, a1, a2, NULL)
def Systemlu(filename, a0, a1, a2, a3) Systemlu_(filename, a0, a1, a2, a3, NULL)
def Systemlu(filename, a0, a1, a2, a3, a4) Systemlu_(filename, a0, a1, a2, a3, a4, NULL)
def Systemlu(filename, a0, a1, a2, a3, a4, a5) Systemlu_(filename, a0, a1, a2, a3, a4, a5, NULL)
def Systemlu(filename, a0, a1, a2, a3, a4, a5, a6) Systemlu_(filename, a0, a1, a2, a3, a4, a5, a6, NULL)
def Systemlu(filename, a0, a1, a2, a3, a4, a5, a6, a7) Systemlu_(filename, a0, a1, a2, a3, a4, a5, a6, a7, NULL)


cstr cmd(cstr c)
	FILE *f = Popen(c, "r")
	cstr rv = buffer_to_cstr(fslurp(f))
	Pclose(f)
	return rv

# This sigact / Sigact is equivalent to signal but uses the more stable
# sigaction call. The signal will be blocked during the handler.
# It is also implemented (just using signal) for non-unix systems i.e. mingw.

sighandler_t Sigact(int signum, sighandler_t handler, int sa_flags)
	sighandler_t rv = sigact(signum, handler, sa_flags)
	if rv == SIG_ERR
		failed("sigact")
	return rv

# Sigact with two args sets a signal handler, system calls will be restarted.
# Sigintr sets a signal handler, system calls will be interrupted.
# You probably want to use Sigintr for SIGALRM.

def sigact(signum, handler) sigact(signum, handler, SA_RESTART|nochldwait(signum))
def sigintr(signum, handler) sigact(signum, handler, SA_INTERRUPT|nochldwait(signum))
def Sigact(signum, handler) Sigact(signum, handler, SA_RESTART|nochldwait(signum))
def Sigintr(signum, handler) Sigact(signum, handler, SA_INTERRUPT|nochldwait(signum))
def sigign(signum) sigact(signum, SIG_IGN, 0)
def sigdfl(signum) sigact(signum, SIG_DFL, 0)
def Sigign(signum) Sigact(signum, SIG_IGN, 0)
def Sigdfl(signum) Sigact(signum, SIG_DFL, 0)

def sigget(signum) sigact(signum, NULL, 0)
def Sigget(signum) Sigact(signum, NULL, 0)

Raise(int sig)
	if raise(sig)
		failed("raise")

void catch_signal_null(int sig)
	use(sig)

int wait__status

def Child_wait() Child_wait(-1)

int fix_exit_status(int status)
	if WIFEXITED(status)
		status = WEXITSTATUS(status)
		if !sig_execfailed && status == exit__execfailed
			status = status__execfailed
	 eif WIFSIGNALED(status)
		status = 256 + 128 + WTERMSIG(status)
		if sig_execfailed && status == 256 + 128 + sig_execfailed
			status = status__execfailed
	 else
		fault("unknown exit status %d - perhaps child stop/cont.\nSet your SIGCHLD handler with Sigact or Sigintr to avoid this.", status)
	return status

def status_normal(status) status >= 0 && status < 256 && (sig_execfailed || status != exit__execfailed)
def status_signal(status) status >= 384 && status < 512 ? status - 384 : 0
def status_execfailed(status) status == status__execfailed

def Child_status() wait__status

hold_term_open()
	warn("\ndone, press enter to close the terminal")
	new(b, buffer)
	Freadline(b, stdin)

#sunos doesn't like: typedef struct utsname utsname

Uname(struct utsname *buf)
	if !uname(buf)
		failed("uname")



# unquoting, this seems a bit ugly!
# This is used by Systema, and could also be used for html.
# The same idea could be generalized to arbitrary annotations.

vec struct__uq_vec
vec *uq_vec = NULL

uq_init()
	uq_vec = &struct__uq_vec
	init(uq_vec, vec, cstr, 16)

cstr uq(const char *s)
	if !uq_vec
		uq_init()
	char *s1 = Strdup(s)
	vec_push(uq_vec, s1)
	return s1

boolean is_uq(const char *s)
	if uq_vec
		for_vec(i, uq_vec, cstr)
			if *i == s
				return 1
	return 0

uq_clean()
	if uq_vec
		for_vec(i, uq_vec, cstr)
			Free(*i)
		vec_clear(uq_vec)


# q(), this may be a better way than using uq() !

vec struct__q_vec
vec *q_vec = NULL

q_init()
	q_vec = &struct__q_vec
	init(q_vec, vec, cstr, 16)

cstr q(const char *s)
	if !q_vec
		q_init()
	new(b, buffer, 128)
	system_quote(s, b)
	cstr q = buffer_to_cstr(b)
	vec_push(q_vec, q)
	return q

q_clean()
	if q_vec
		for_vec(i, q_vec, cstr)
			Free(*i)
		vec_clear(q_vec)

cstr qq(cstr s)
	new(b, buffer, PATH_MAX)
	buffer_cat_char(b, '"')
	sh_quote(s, b)
	buffer_cat_char(b, '"')
	return buffer_to_cstr(b)

cstr x(cstr command)
	FILE *s = Popen(command, "r")
	cstr rv = buffer_to_cstr(fslurp(s))
	Pclose(s)
	return rv

 # TODO similar with argument escaping and/or formatting etc.

sh_unquote(cstr s)
	char *o = s
	while *s
		if *s == '\\'
			++s
		*o++ = *s++
	*o = '\0'

char *sh_unquote_full(cstr s)
	char *o = s
	while *s
		if *s == '\''
			while *s != '\''
				*o++ = *s++
			++s
		 eif *s == '\"'
			while *s != '\"'
				if *s == '\\'
					++s
				*o++ = *s++
			++s
		 eif isspace(*s)
			# this will separate args with \0
			*o++ = '\0'
			++s
		 else
			if *s == '\\'
				++s
			*o++ = *s++
	*o = '\0'
	return o
export unistd.h stdarg.h signal.h pwd.h grp.h shadow.h sched.h sys/wait.h sys/utsname.h crypt.h
use string.h


#int sig_execfailed = 64
int sig_execfailed = SIGUSR2
# A process in brace should not otherwise be terminated by SIGUSR2.
# If that is a problem, the program can set sig_execfailed to 64 or something.

typedef void (*sighandler_t)(int)

pid_t Fork()
	if process__fork_fflush
		Fflush_all()
	pid_t pid = fork()
	if pid == -1
		failed("fork")
	 eif pid == 0
		process__forked = 1
	return pid

# TODO cope with interrupted system calls universally, aargh
# This Waitpid restarts in the case of an interrupted system call.

pid_t Waitpid(pid_t pid, int *status, int options)
	pid_t r_pid
	repeat
		r_pid = waitpid(pid, status, options)
		if r_pid == -1
			if errno != EINTR
				failed("waitpid")
		else
			return r_pid

int Child_wait(pid_t pid)
	Waitpid(pid, &wait__status, 0)
	wait__status = fix_exit_status(wait__status)
	return wait__status

pid_t Child_done()
	pid_t pid = Waitpid(-1, &wait__status, WNOHANG)
	if pid
		wait__status = fix_exit_status(wait__status)
	return pid

# This Waitpid can return -1 in case of an interrupted system call

pid_t Waitpid_intr(pid_t pid, int *status, int options)
	pid_t r_pid = waitpid(pid, status, options)
	if r_pid == -1 && errno != EINTR
		failed("waitpid")
	return r_pid

# TODO should block SIGCHLD? etc
# Systemv is an _emulated_ system, doesn't call system(3),
# doesn't use the shell
# not any more! now it does call system() in the interests of portability,
# and is in the common process.b  Here's the old version:

#int Systemv(const char *filename, char *const argv[])
#	pid_t pid
#	pid = Fork()
#	if pid == 0
#		Execvp(filename, argv)
#	int status
#	Waitpid(pid, &status, 0)
#	if WIFEXITED(status)
#		return WEXITSTATUS(status)
#	return -1

typedef struct sched_param sched_param

Sched_setscheduler(pid_t pid, int policy, const sched_param *p)
	if sched_setscheduler(pid, policy, p) == -1
		failed("sched_setscheduler")

set_priority(pid_t pid, int priority)
	decl(param, sched_param)
	bzero(param)
	param->sched_priority = priority
	Sched_setscheduler(pid, SCHED_FIFO, param)

cstr whoami()
	return Strdup(Getpwuid(geteuid())->pw_name)

def ignore_pipe()
	Sigign(SIGPIPE)
def ignore_hup()
	Sigign(SIGHUP)

def system_quote sh_quote

# FIXME should update this stuff when call setuid or something,
# or don't use it at all.
uid_t uid_root = 0
int myuid = -1
int mygid = -1
def Getuid() (uid_t)(myuid != -1 ? myuid : (myuid = getuid()))
def Getgid() (gid_t)(mygid != -1 ? mygid : (mygid = getgid()))

int auth(user *u, cstr pass)
	return auth_pw((passwd *)u, pass)
int auth_pw(passwd *pw, cstr pass)
	char *x = pw->pw_passwd
	char salt[64]
	char *dollar = strrchr(x, '$')
	if !dollar
		return 0
	int l = dollar - x
	assert(l < (int)sizeof(salt), "auth: salt too long")
	strlcpy(salt, x, l+1)
	salt[l] = '\0'
#	Sayf("%s %s %s", x, salt, crypt(pass, salt))
	return cstr_eq(x, crypt(pass, salt)) && !cstr_eq(pw->pw_shell, "/bin/false")

def become(user)
	become_(user, my(pw), my(groups))
def become_(user, pw, groups)
	passwd *pw = Getpwnam(user)
	if !pw
		error("user not found: %s", user)
	new(groups, vec, gid_t, 32)
	Getgrouplist(user, pw->pw_gid, groups)
	become(pw->pw_uid, pw->pw_gid, groups, 1)

def become(pw, groups)
	become(pw->pw_uid, pw->pw_gid, groups)
		.

def become(uid, gid, groups)
	become(uid, gid, groups, 0)
def become(uid, gid, groups, free_groups)
	post(my(x))
		Seteuid(0)
		Setegid(0)
		Cleargroups()
		if free_groups
			vec_free(groups)
	pre(my(x))
		Setgroups(veclen(groups), (gid_t*)vec0(groups))
		Setegid(gid)
		Seteuid(uid)
		.


def Seteuidgid(pw)
	Seteuidgid(pw->pw_uid, pw->pw_gid)
def Seteuidgid(uid, gid)
	Setegid(gid) ; Seteuid(uid)
def Seteuidgid_root()
	Seteuid(0) ; Setegid(0)
def Seteuidgid_via_root(pw)
	Seteuidgid_root()
	Seteuidgid(pw)
def Setuidgid(uid, gid)
	Setgid(gid) ; Setuid(uid)
def Setuidgid(pw)
	Setuidgid(pw->pw_uid, pw->pw_gid)
def Setuidgid_via_root(pw)
	Seteuidgid_root()
	Setuidgid(pw)

def Setgroups(user)
	Setgroups(user->n_groups, user->gids)

Setgroups(size_t size, const gid_t *list)
	if setgroups(size, list)
		failed("setgroups")

def Cleargroups()
	Setgroups(0, NULL)

def Setuser(user)
	Setgroups(user)
	Seteuidgid(user)

def Setuser_root()
	Seteuidgid_root()
	Setgroups(0,NULL)
def Setuser_via_root(user)
	Setuser_root()
	Setuser(user)

typedef struct passwd passwd
typedef struct spwd spwd
typedef struct group group

struct user
	char *pw_name
	char *pw_passwd
	uid_t pw_uid
	gid_t pw_gid
	char *pw_gecos
	char *pw_dir
	char *pw_shell
	long n_groups
	char **groups
	gid_t *gids
	long n_members
	char **members
	uid_t *mids

int passwd_n_buckets = 1009

hashtable *load_users()
	# warning: this caches the password/shadow/group databases
	# if the databases are changed, you would need to call load_users again.
	sym_init()
	New(ht, hashtable, cstr_hash, cstr_eq, passwd_n_buckets)
	passwd *p
	while (p = Getpwent())
		user *u = passwd_to_user(p)
		put(ht, u->pw_name, u)
	spwd *s
	while (s = Getspent())
		user *u = get(ht, s->sp_namp)
		Free(u->pw_passwd)
		u->pw_passwd = Strdup(s->sp_pwdp)
	endspent()
	group *g
	while (g = Getgrent())
		user *u = get(ht, g->gr_name)
		if !u  # XXX FIXME there must be a user for each group
			continue
		char **p = g->gr_mem
		while *p
			++u->n_members
			++p
		u->members = Nalloc(char *, u->n_members)
		u->mids = Nalloc(uid_t, u->n_members)
		char **member = u->members
		gid_t *mid = u->mids
		p = g->gr_mem
		while *p
			user *m = get(ht, *p)
			++m->n_groups
			*member++ = sym(*p)
			*mid++ = m->pw_uid
			++p
	endgrent()
	setpwent()
	while (p = Getpwent())
		user *u = get(ht, p->pw_name)
		u->groups = Nalloc(char *, u->n_groups)
		u->gids = Nalloc(gid_t, u->n_groups)
		u->n_groups = 0
	setpwent()
	while (p = Getpwent())
		user *u = get(ht, p->pw_name)
		int i = 0
		for ; i<u->n_members ; ++i
			user *m = get(ht, u->members[i])
			m->groups[m->n_groups] = u->pw_name
			m->gids[m->n_groups] = u->pw_gid
			++m->n_groups
	endpwent()
	return ht

#passwd *passwd_dup(passwd *_p)
#	passwd *p = Talloc(passwd)
#	*p = *_p
#	p->pw_name = Strdup(p->pw_name)
#	p->pw_passwd = Strdup(p->pw_passwd)
#	p->pw_gecos = Strdup(p->pw_gecos)
#	p->pw_dir = Strdup(p->pw_dir)
#	p->pw_shell = Strdup(p->pw_shell)
#	return p

#passwd_free(passwd *p)
#	Free(p->pw_name)
#	Free(p->pw_passwd)
#	Free(p->pw_gecos)
#	Free(p->pw_dir)
#	Free(p->pw_shell)
#	Free(p)

user *passwd_to_user(passwd *p)
	user *u = Talloc(user)
	*(passwd*)u = *p
	u->pw_name = sym(p->pw_name)
	u->pw_passwd = Strdup(p->pw_passwd)
	u->pw_gecos = Strdup(p->pw_gecos)
	u->pw_dir = Strdup(p->pw_dir)
	u->pw_shell = sym(p->pw_shell)
	u->n_groups = 0
	u->groups = NULL
	u->gids = NULL
	u->n_members = 0
	u->members = NULL
	u->mids = NULL
	return u

user_free(user *u)
#	Free(u->pw_name)
	Free(u->pw_passwd)
	Free(u->pw_gecos)
	Free(u->pw_dir)
#	Free(u->pw_shell)
	Free(u->members)
	Free(u->mids)
	Free(u)

struct passwd *Getpwent()
	struct passwd *rv
	errno = 0
	rv = getpwent()
	if !rv && errno
		failed("getpwent")
	return rv

struct passwd *Getpwnam(const char *name)
	struct passwd *rv
	errno = 0
	rv = getpwnam(name)
	if !rv && errno
		failed("getpwnam")
	return rv

struct passwd *Getpwuid(uid_t uid)
	struct passwd *rv
	errno = 0
	rv = getpwuid(uid)
	if !rv && errno
		failed("getpwuid")
	return rv

struct group *Getgrent()
	struct group *rv
	errno = 0
	rv = getgrent()
	if !rv && errno
		failed("getgrent")
	return rv

struct spwd *Getspent()
	struct spwd *rv
	errno = 0
	rv = getspent()
	if !rv && errno
		failed("getspent")
	return rv

struct spwd *Getspnam(const char *name)
	struct spwd *rv
	errno = 0
	rv = getspnam(name)
	if !rv && errno
		failed("getspnam")
	return rv

Setuid(uid_t uid)
	if setuid(uid)
		failed("setuid")

Setgid(gid_t gid)
	if setgid(gid)
		failed("setgid")

Seteuid(uid_t euid)
	if seteuid(euid)
		failed("seteuid")

Setegid(gid_t egid)
	if setegid(egid)
		failed("setegid")

Setreuid(uid_t ruid, uid_t euid)
	if setreuid(ruid, euid)
		failed("setreuid")

Setregid(gid_t rgid, gid_t egid)
	if setregid(rgid, egid)
		failed("setregid")

sighandler_t sigact(int signum, sighandler_t handler, int sa_flags)
	struct sigaction act, oldact
	act.sa_handler = handler
	sigemptyset(&act.sa_mask)
	act.sa_flags = sa_flags
	if sigaction(signum, &act, &oldact) < 0
		return SIG_ERR
	return oldact.sa_handler

Sigprocmask(int how, const sigset_t *set, sigset_t *oldset)
	if sigprocmask(how, set, oldset)
		failed("sigprocmask")

sigset_t Sig_defer(int signum)
	return Sig_mask(signum, 1)

sigset_t Sig_pass(int signum)
	return Sig_mask(signum, 0)

sigset_t Sig_mask(int signum, int defer)
	sigset_t set
	sigset_t oldset
	sigemptyset(&set)
	sigaddset(&set, signum)
	Sigprocmask(defer ? SIG_BLOCK : SIG_UNBLOCK, &set, &oldset)
	return oldset

sigset_t Sig_setmask(sigset_t *set)
	sigset_t oldset
	Sigprocmask(SIG_SETMASK, set, &oldset)
	return oldset

sigset_t Sig_getmask()
	sigset_t oldset
	Sigprocmask(SIG_SETMASK, NULL, &oldset)
	return oldset

# TODO define SA_INTERRUPT = 0 for unix systems that don't provide it.

# TODO Sigsuspend, Sigwait

Sigsuspend(const sigset_t *mask)
	if sigsuspend(mask) < 0 && errno != EINTR
		failed("sigsuspend")

# This was some code using Sigsuspend, it's not needed, because raise doesn't
# return until after the signal was handled / delivered.  It makes sense if the
# call to "raise" is removed.
#
#	let(mask, Sig_defer(sig_execfailed))
#	Sigdfl(sig_execfailed)
#	Sigdelset(&mask, sig_execfailed)
#	raise(sig_execfailed)
#	Sigsuspend(&mask)

int Sigwait(const sigset_t *mask)
	int sig
	sigwait(mask, &sig)
	return sig

Nice(int inc)
	errno = 0
	if nice(inc) == -1 && errno
		failed("nice")

Sched_yield()
	if sched_yield() < 0
		failed("sched_yield")

def SH_QUIET "exec 2>/dev/null; "

exit_exec_failed()
	if sig_execfailed
		Sigdfl(sig_execfailed)
		Sig_pass(sig_execfailed)
		Raise(sig_execfailed)

	Exit(exit__execfailed)

Sigdfl_all()
	for(i, 1, SIGRTMAX+1)
		if among(i, SIGKILL, SIGSTOP) || (i>=32 && i<SIGRTMIN)
			continue
		sigdfl(i)

def set_child_handler(sigchld_handler)
	Sigact(SIGCHLD, sigchld_handler)

def nochldwait(signum) signum == SIGCHLD ? SA_NOCLDSTOP : 0

int Getgrouplist(const char *user, gid_t group, vec *groups)
	int ngroups = veclen(groups)
	int rv
	int count = 0
	do
		rv = getgrouplist(user, group, (gid_t*)vec0(groups), &ngroups)
		vec_set_size(groups, ngroups)
	 while rv < 0 && !count++
	if rv < 0
		failed("getgrouplist")
	return ngroups

# TODO fix vec to work like new buffer does

# TODO don't use buffer underneath it

# can we unify the buffer and vector abstractions?  why not?

struct vec
	buffer b
	ssize_t element_size
	ssize_t space
	ssize_t size

vec_init_el_size(vec *v, ssize_t element_size, ssize_t space)
	v->space = space ? space : 1
	buffer_init(&v->b, v->space * element_size)
	v->element_size = element_size
	v->size = 0

Def vec_init(v, element_type, space) vec_init_el_size(v, sizeof(element_type), (space))
Def vec_init(v, element_type) vec_init(v, element_type, 1)

vec_clear(vec *v)
	buffer_clear(&v->b)
	v->size = 0

vec_free(vec *v)
	buffer_free(&v->b)

vec_Free(vec *v)
	for_vec(i, v, void*)
		Free(*i)
	vec_free(v)

vec_space(vec *v, ssize_t space)
	v->space = space ? space : 1
	buffer_set_space(&v->b, v->space * v->element_size)

vec_size(vec *v, ssize_t size)
	ssize_t cap = v->space
	if size > cap
		do
			cap *= 2
		while size > cap
		vec_space(v, cap)
	v->size = size
	buffer_set_size(&v->b, size * v->element_size)

vec_double(vec *v)
	vec_space(v, v->space * 2)

vec_squeeze(vec *v)
	vec_space(v, v->size)

# TODO make this a macro?

void *vec_element(vec *v, ssize_t index)
	#if index < 0
	#	index += v->size
	return v->b.start + index * v->element_size

void *vec_top(vec *v, ssize_t index)
	return vec_element(v, v->size - 1 - index)
#	return v->b.start + (v->size -1 - index) * v->element_size
def vec_top(v) vec_top(v, 0)

void *vec_push(vec *v)
	if v->size == v->space
		vec_double(v)
	++v->size
	buffer_grow(&v->b, v->element_size)
	return vec_element(v, v->size-1)
def vec_push(v, data)
	*(typeof(data) *)vec_push(v) = data

vec_pop(vec *v)
	--v->size
	buffer_grow(&v->b, - v->element_size)
Def vec_pop(v, data)
	let(my(p), castto_ref(vec_top(v), &data))
	data = *my(p)
	vec_pop(v)

vec_grow(vec *v, ssize_t delta_size)
	vec_set_size(v, veclen(v) + delta_size)

vec_grow_squeeze(vec *v, ssize_t delta_size)
	ssize_t size = veclen(v) + delta_size
	vec_set_space(v, size)
	vec_set_size(v, size)

#def vec_from_array(v, a)
#	new(v, vec, *a, array_size(a))
#	vec_set_size(v, array_size(a))
#	let(vfa__i0, a)
#	let(vfa__i1, array_end(a))
#	sametype(vfa__out, a) = vec_get_start(v)
#	for(vfa__i)
#		*out = *vfa__i
#		++out

def vec_get_start(v) vec_element(v, 0)
def vec_get_end(v) vec_element(v, v->size)
def vec_set_size vec_size
def vec_get_size(v) v->size
def vec_is_empty(v) !v->size

Def vec_range(v) vec_get_start(v), vec_get_end(v)
Def vec_range(v, type) vec_get_start(v, type), vec_get_end(v, type)
Def vec_get_start(v, type) (type *)vec_get_start(v)
Def vec_get_end(v, type) (type *)vec_get_end(v)

def vec_dup(from) vec_dup_0(from)
vec *vec_dup_0(vec *from)
	return vec_dup(Talloc(vec), from)
vec *vec_dup(vec *to, vec *from)
 # 'to' should be uninitialized (or after free'd)
	buffer_dup(&to->b, &from->b)
	to->element_size = from->element_size
	to->space = from->space
	to->size = from->size
	return to

Def for_vec(i, v, type)
	state vec *my(v1) = v
	state type *my(end) = vecend(my(v1))
	state type *my(i1) = vec0(my(v1))
	for ; my(i1)!=my(end) ; ++my(i1)
		let(i, my(i1))
		.

Def back_vec(i, v, type)
	state vec *my(v1) = v
	state type *my(end) = (type*)vec0(my(v1))-1
	state type *my(i1) = (type*)vecend(my(v1))-1
	for ; my(i1)!=my(end) ; --my(i1)
		let(i, my(i1))
		.

def For(i, v, type)
	for_vec(i, v, type)
def For(i, v)
	for_vec(i, v, cstr)

def for_vec(i, v)
	state vec *my(v1) = v
	state char *my(end) = vecend(my(v1))
	state char *my(i1) = vec0(my(v1))
	for ; my(i1)!=my(end) ; my(i1) += my(v1)->element_size
		void *i = my(i1)
		.

def vec_set_space vec_space
def vec_get_space(v) v->space

vec_ensure_size(vec *v, ssize_t size)
	if vec_get_size(v) < size
		vec_set_size(v, size)

def vec_ensure_size_init(v, size, init)
	int old_size = vec_get_size(v)
	vec_ensure_size(v, size)
	for(i, old_size+1, size)
		*(typeof(init) *)vec_element(v, i) = init

def vec_copy_element(v, to, from)
	memmove(vec_element(v, to), vec_element(v, from), v->element_size)

def vec_copy_element(v, to, from, type)
	*(type *)vec_element(v, to) = *(type *)vec_element(v, from)

void *vec_to_array(vec *v)
	vec_push(v, NULL)
	vec_squeeze(v)
	vec_pop(v)
	return vec_get_start(v)

array_to_vec(vec *v, void *a)
	v->b.start = a
	v->element_size = sizeof(void*)
	v->size = arylen(a)
	v->space = v->size + 1
	vec_recalc_buffer(v)

def vec_null_terminate(v)
	vec_push(v, NULL)
	vec_pop(v)

def vec_get_el_size(v) v->element_size

def v(vec, i) vec_element(vec, i)

def veclen(v) vec_get_size(v)
def vec0(v) vec_get_start(v)
def vecend(v) vec_get_end(v)
def vecclr(v) vec_clear(v)

vec_splice(vec *v, ssize_t i, ssize_t cut, void *in, ssize_t ins)
	ssize_t e = vec_get_el_size(v)
	buf_splice(&v->b, i*e, cut*e, in, ins*e)
	v->size += ins - cut
	v->space = buffer_get_space(&v->b) / e

def vec_append(v, in, n) vec_insert(v, veclen(v), in, n)

def vec_cut(v, i, n) vec_splice(v, i, n, NULL, 0)
def vec_cut(v, i) vec_cut(v, i, 1)

def vec_grow_at(v, i, n) vec_splice(v, i, 0, NULL, n)

def vec_insert(v, i, in, n) vec_splice(v, i, 0, in, n)

def vec_unshift(v, in, n) vec_insert(v, 0, in, n)
def vec_unshift(v, in) vec_unshift(v, in, 1)

def vec_shift(v, n) vec_cut(v, 0, n)
def vec_shift(v) vec_shift(v, 1)

def Subvec(v, i, n) Subvec(v, i, n, 0)
vec *Subvec(vec *v, ssize_t i, ssize_t n, ssize_t extra)
	vec *sub = Talloc(vec)
	subvec(sub, v, i, n)
	buf_dup_guts(&sub->b, extra * vec_get_el_size(sub))
	sub->space += extra
	return sub

# FIXME to be OO, subvec should take v as first parameter

vec *subvec(vec *sub, vec *v, ssize_t i, ssize_t n)
	# warning: subvec takes an uninitialised vec and sets it to access
	# an area that is actually inside the old vec.
	# The subvec should not be grown or shrunk! unless you don't mind
	# overwriting the old vec.  Also it should be Free'd not vec_free'd!
	ssize_t e = vec_get_el_size(v)
	subbuf(&sub->b, &v->b, i*e, n*e)
	sub->element_size = e
	sub->space = sub->size = n
	return sub

vec_recalc_from_buffer(vec *v)
	v->space = buffer_get_space(&v->b) / v->element_size
	v->size = buffer_get_size(&v->b) / v->element_size

vec_recalc_buffer(vec *v)
	v->b.end = v->b.start + v->element_size * v->size
	v->b.space_end = v->b.start + v->element_size * v->space

def vec_push_cstr(v, e)
	*(cstr *)vec_push(v) = e

def vec_append(v0, v1) vec_append_vec(v0, v1)
vec_append_vec(vec *v0, vec *v1)
	vec_append(v0, vec0(v1), veclen(v1))

vov_free(vec *v)
	for_vec(i, v, vec*)
		vec_free(*i)

vov_free_maybe_null(vec *v)
	for_vec(i, v, vec*)
		if *i
			vec_free(*i)

vec *vec1(void *e)
	New(v, vec, void*, 1)
	vec_push(v, e)
	return v
export string.h ctype.h
use stdio.h


cstr_dos_to_unix(cstr s)
	cstr p1, p2
	for p1=p2=s; *p1 != '\0'; ++p1
		if *p1 != '\r'
			*p2 = *p1
			++p2
	*p2 = '\0'

# returns malloc'd
cstr cstr_unix_to_dos(cstr s)
	cstr p1
	new(b, buffer, strlen(s)*1.5)
	for p1=s; *p1 != 0; ++p1
		if *p1 == '\n'
			buffer_cat_char(b, '\r')
			buffer_cat_char(b, '\n')
		 else
		 	buffer_cat_char(b, *p1)
	return buffer_to_cstr(b)

cstr cstr_chomp(cstr s)
	char *p = s
	while *p
		if among(*p, '\n', '\r')
			*p = '\0'
			break
		p++
	return s
def chomp(s) cstr_chomp(s)

# TODO implement ends_with and begins_with efficiently

boolean cstr_eq(void *s1, void *s2)
	return strcmp(s1, s2) == 0

boolean cstr_case_eq(void *s1, void *s2)
	return strcasecmp(s1, s2) == 0

boolean cstr_is_empty(cstr s1)
	return *s1 == '\0'

boolean cstr_ends_with(cstr s, cstr substr)
	size_t s_len = strlen(s)
	size_t substr_len = strlen(substr)
	if substr_len > s_len
		return 0
	cstr expect = s + s_len - substr_len
	return cstr_eq(expect, substr)

boolean cstr_case_ends_with(cstr s, cstr substr)
	size_t s_len = strlen(s)
	size_t substr_len = strlen(substr)
	if substr_len > s_len
		return 0
	cstr expect = s + s_len - substr_len
	return cstr_case_eq(expect, substr)

# this returns a pointer to the character after the match, or NULL
# I want it to preserve the constness of the first argument, but C can't.
cstr cstr_begins_with(cstr s, cstr substr)
	repeat
		if *substr == '\0'
			return (cstr)s
		if *substr != *s
			return NULL
		++s ; ++substr

cstr cstr_case_begins_with(cstr s, cstr substr)
	repeat
		if *substr == '\0'
			return (cstr)s
		if tolower((unsigned char)*substr) != tolower((unsigned char)*s)
			return NULL
		++s ; ++substr

Def cstr_range(s) s, cstr_get_end(s)
 # note: cstr_range evaluates its arg three times, so don't call it with a complex expression

def cstr_get_start(s) s          # duh!
def cstr_get_end(s) s+strlen(s)

# cstr_from_str is in str.b for now, to avoid the brace_mk_cc bug

cstr cstr_from_buffer(buffer *b)
	buffer_nul_terminate(b)
	return b->start

cstr cstr_of_size(size_t n)
	cstr cs = Malloc(n + 1)
	cs[n] = '\0'
	return cs

# TODO defs for libc string functions, e.g. cstr_dup -> strdup, cstr_copy -> strcpy ...; and remap

# TODO maybe rename cstr_copy to cstr_dup
def cstr_copy(s) Strdup(s)
def cstr_cat(a, b) format("%s%s", a, b)
def cstr_cat(a, b, c) format("%s%s%s", a, b, c)
def cstr_cat(a, b, c, d) format("%s%s%s%s", a, b, c, d)
def cstr_cat(a, b, c, d, e) format("%s%s%s%s%s", a, b, c, d, e)
def cstr_cat(a, b, c, d, e, f) format("%s%s%s%s%s%s", a, b, c, d, e, f)
def cstr_cat(a, b, c, d, e, f, g) format("%s%s%s%s%s%s%s", a, b, c, d, e, f, g)

cstr cstr_chop_end(cstr c, cstr end)
	Realloc(c, end - c)
	return c

# TODO an alloc that can free the _start_ of a block

## startmust be a pointer into the string c
cstr cstr_chop_start(cstr c, cstr start)
	int len = strlen(start)
	memmove(c, start, len)
	c[len] = '\0'
#	Realloc(c, len+1)
	return c
	# inefficient, who cares

# cstr_chop_foo ??? no nul?


void_cstr(cstr s)
	Free(s)

def cstr_last_char(s) s[(strlen(s) ? strlen(s) : 1)-1]

def cstr_dump(s)
	hexdump(cstr_range(s))

# you need to clear the vec if necessary before calling split

splitv(vec *v, cstr s, char c)
	if *s
		splitv1(v, s, c)

splitv1(vec *v, cstr s, char c)
	vec_push(v, s)
	for_cstr(i, s)
		if *i == c
			*i = '\0'
			vec_push(v, i+1)

def splitv(v, s) splitv(v, s, '\t')

splitv_dup(vec *v, const char *_s, char c)
	char *s = (char *)_s
	for_cstr(i, s)
		if *i == c
			cstr x = Strndup(s, i-s)
			vec_push(v, x)
			s = i+1
	if i >= s
		vec_push(v, Strdup(s))

cstr *split(cstr s, char c)
	new(v, vec, cstr, 16)
	splitv(v, s, c)
	return vec_to_array(v)

cstr *splitn(cstr s, char c, int n)
	new(v, vec, cstr, 16)
	splitvn(v, s, c, n)
	return vec_to_array(v)

splitvn(vec *v, cstr s, char c, int n)
	if *s
		splitvn1(v, s, c, n)

splitvn1(vec *v, cstr s, char c, int n)
	vec_push(v, s)
	if --n
		for_cstr(i, s)
			if *i == c
				*i = '\0'
				vec_push(v, i+1)
				if --n == 0
					break

def split(s) split(s, '\t')
def split(s, c, n) splitn(s, c, n)

cstr *split_dup(const char *s, char c)
	new(v, vec, cstr, 16)
	splitv_dup(v, s, c)
	return vec_to_array(v)

def for_cstr(i, s)
	char *i
	for i=s; *i != '\0'; ++i
		.

cstr join(char sep, cstr *s)
	char sep_cstr[2] = { sep, '\0' }
	return joins(sep_cstr, s)

cstr joinv(char sep, vec *v)
	return join(sep, vec_to_array(v))

cstr joins(cstr sep, cstr *s)
	new(b, buffer, 256)
	if *s
		repeat
			buffer_cat_cstr(b, *s)
			++s
			if !*s
				break
			buffer_cat_cstr(b, sep)
	return buffer_to_cstr(b)

cstr joinsv(cstr sep, vec *v)
	return joins(sep, vec_to_array(v))

char *Strstr(const char *haystack, const char *needle)
	char *rv = strstr(haystack, needle)
	if !rv
		failed0("strstr")
	return rv

char *Strcasestr(const char *haystack, const char *needle)
	char *rv = strcasestr(haystack, needle)
	if !rv
		failed0("strcasestr")
	return rv

char *Strchr(const char *s, int c)
	char *rv = strchr(s, c)
	if !rv
		failed0("strchr")
	return rv

char *Strrchr(const char *s, int c)
	char *rv = strrchr(s, c)
	if !rv
		failed0("strrchr")
	return rv

cstr cstr_tolower(cstr s)
	for_cstr(i, s)
		*i = tolower((unsigned char)*i)
	return s

cstr cstr_toupper(cstr s)
	for_cstr(i, s)
		*i = toupper((unsigned char)*i)
	return s

def lc(s) cstr_tolower(s)
def uc(s) cstr_toupper(s)

def cstr_realloc(s)
	cstr_realloc(s, strlen(s))
def cstr_realloc(s, len)
	Realloc(s, len+1)

boolean is_blank(cstr l)
	return l[strspn(l, " \t")] == '\0'

cstr cstr_begins_with_word(cstr s, cstr substr)
	cstr rv = cstr_begins_with(s, substr)
	if rv
		if *rv == ' '
			return rv+1
		 eif *rv == '\0'
			return rv
	return NULL

def cstr_begins_with_word(s) 1
def cstr_begins_with_word(s, w0, w1) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1))
def cstr_begins_with_word(s, w0, w1, w2) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2))
def cstr_begins_with_word(s, w0, w1, w2, w3) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7, w8) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7, w8))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7, w8, w9))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12))

def cstr_chop(s)
	cstr_chop(s, 1)
cstr_chop(cstr s, long n)
	s[strlen(s)-n] = '\0'

cstr cstr_begins_with_sym(cstr s, cstr substr)
	cstr rv = cstr_begins_with(s, substr)
	if rv && !isword(*rv)
		return rv
	return NULL

char *cstr_not_chr(cstr s, char c)
	while *s == c
		++s
	return s

def strlitlen(s) sizeof(s)-1

cstr make_name(cstr s)
	for_cstr(i, s)
		if !isword(*i)
			*i = '_'
	return s

size_t Strlcpy(char *dst, char *src, size_t size)
	size_t rv
	rv = strlcpy(dst, src, size)
	if rv >= size
		failed("strlcpy", "dst buffer too small")
	return rv

size_t Strlcat(char *dst, char *src, size_t size)
	size_t rv
	rv = strlcpy(dst, src, size)
	if rv >= size
		failed("strlcpy", "dst buffer too small")
	return rv


def strtol(s, base) strtol(s, NULL, base)
def strtol(s) strtol(s, 10)
def strtoll(s, base) strtoll(s, NULL, base)
def strtoll(s) strtoll(s, 10)
def strtod(s) strtod(s, NULL)
def strtof(s) strtof(s, NULL)

long int Strtol(const char *nptr, char **endptr, int base)
	errno = 0
	long int rv = strtol(nptr, endptr, base)
	if errno
		failed("strtol", nptr)
	return rv
def Strtol(nptr, base) Strtol(nptr, NULL, base)
def Strtol(nptr) Strtol(nptr, 10)

long long int Strtoll(const char *nptr, char **endptr, int base)
	errno = 0
	long long int rv = strtoll(nptr, endptr, base)
	if errno
		failed("strtoll", nptr)
	return rv
def Strtoll(nptr, base) Strtoll(nptr, NULL, base)
def Strtoll(nptr) Strtoll(nptr, 10)

double Strtod(const char *nptr, char **endptr)
	errno = 0
	double rv = strtod(nptr, endptr)
	if errno
		failed("strtod", nptr)
	return rv
def Strtod(nptr) Strtod(nptr, NULL)

float Strtof(const char *nptr, char **endptr)
	errno = 0
	float rv = strtof(nptr, endptr)
	if errno
		failed("strtof", nptr)
	return rv
def Strtof(nptr) Strtof(nptr, NULL)

long int STRTOL(const char *nptr, int base)
	char *endptr
	errno = 0
	long int rv = strtol(nptr, &endptr, base)
	if errno || *endptr
		warn("strtol failed? %s %ld %p %p %p %d", nptr, rv, nptr, nptr+strlen(nptr), endptr, *endptr)
		failed("strtol", nptr)
	return rv
def STRTOL(nptr) STRTOL(nptr, 10)

long long int STRTOLL(const char *nptr, int base)
	char *endptr
	errno = 0
	long long int rv = strtoll(nptr, &endptr, base)
	if errno || *endptr
		failed("strtoll", nptr)
	return rv
def STRTOLL(nptr) STRTOLL(nptr, 10)

double STRTOD(const char *nptr)
	char *endptr
	errno = 0
	double rv = strtod(nptr, &endptr)
	if errno || *endptr
		failed("strtod", nptr)
	return rv

float STRTOF(const char *nptr)
	char *endptr
	errno = 0
	float rv = strtof(nptr, &endptr)
	if errno || *endptr
		failed("strtof", nptr)
	return rv


size_t strlcpy(char *dst, char *src, size_t size)
	if size == 0
		return strlen(src)
	char *src0 = src
	do
		if (*dst++ = *src++) == 0
			break
	 while(--size)
	if src[-1]
		dst[-1] = '\0'
		while *src++
			.
	return src - src0 - 1

size_t strlcat(char *dst, char *src, size_t size)
	if size == 0
		return strlen(dst)+strlen(src)
	char *dst0 = dst
	while *dst && size--
		++dst
	return (dst-dst0) + strlcpy(dst, src, size)

# this (together with str.b) is the way I think strings ought to be done

struct ropev
	rope *end
	rope *start
 # end comes before start so that we can distinguish a str from a ropev:

union rope
	str s
	ropev v

def rope_set_null(r) r.s.end = NULL

def rope_is_a_str(r) r.s.start <= r.s.end
def rope_is_a_ropev(r) r.v.start <= r.v.end

def ropev_is_null(v) v.start == NULL
def ropev_is_empty(r) r.v.start == r.v.end

def rope_is_null(r) r.s.end == NULL
def rope_is_empty(r) r.s.start == r.s.end

def cast_to_rope(str_or_ropev) *(rope *)&str_or_ropev
#def cast_to_rope(str_or_ropev) (rope)str_or_ropev

size_t rope_get_size(rope r)
	if rope_is_a_str(r)
		return str_get_size(r.s)
	 else
		return ropev_get_size(r.v)

ropev ropev_ref(rope *start, rope *end)
	ropev v = { end, start }
	return v

ropev ropev_of_size(int size)
	ropev v
	v.start = Nalloc(rope, size)
	v.end = v.start + size
	return v

size_t ropev_get_size(ropev v)
 # this gets the total length of the string, not the number of component strings
	size_t size = 0
	for(i, ropev_range(v))
		size += rope_get_size(*i)
	return size

str str_from_rope(rope r)
	let(s, str_of_size(rope_get_size(r)))
	rope_flatten(s.start, r)
	return s

cstr cstr_from_rope(rope r)
	cstr cs = cstr_of_size(rope_get_size(r) + 1)
	rope_flatten(cs, r)
	return cs

char *rope_flatten(char *to, rope r)
	if rope_is_empty(r)
		return to
	eif rope_is_a_str(r)
		return str_copy(to, r.s)
	else
		return ropev_flatten(to, r.v)

char *ropev_flatten(char *to, ropev v)
	for(i, ropev_range(v))
		to = rope_flatten(to, *i)
	return to

rope rope_cat_2(rope r1, rope r2)
	let(v, ropev_of_size(2))
	rope *p = v.start
	*p++ = r1
	*p = r2
	return cast_to_rope(v)

rope rope_cat_3(rope r1, rope r2, rope r3)
	let(v, ropev_of_size(3))
	rope *p = v.start
	*p++ = r1
	*p++ = r2
	*p = r3
	return cast_to_rope(v)

use stdarg.h

Def ropev_range(v) (rope *)v.start, (rope *)v.end

rope rope_cat_n(size_t n, ...)
	collect(vrope_cat_n, n)

rope vrope_cat_n(size_t n, va_list ap)
	let(v, ropev_of_size(n))
	for(i, ropev_range(v))
		*i = va_arg(ap, rope)
	return cast_to_rope(v)

# these functions want to be called with "rope" args, not "rope *" args...??

def rope_from_cstr(cs) cast_to_rope(str_from_cstr(cs))

def r(cs) rope_from_cstr(cs)
def r(a, b) rope_cat_2(a, b)
def r(a, b, c) rope_cat_3(a, b, c)
def r(a, b, c, d) rope_cat_n(4, a, b, c, d)
def r(a, b, c, d, e) rope_cat_n(5, a, b, c, d, e)

def R(r) cstr_from_rope(r)

def rope_dump(r)
	rope_dump(r, 0)
	nl(stderr)

rope_dump(rope r, int indent)
	tabs(stderr, indent)
	if rope_is_empty(r)
		warn("empty")
	eif rope_is_a_str(r)
		cstr s = CS(r.s)
		warn("str >%s<", s)
		Free(s)
	else
		warn("ropev: %d", ropev_get_size(r.v))
		ropev_dump(r.v, indent+1)

ropev_dump(ropev v, int indent)
	for(i, ropev_range(v))
		rope_dump(*i, indent)


# rope_p

# bitfields for the flag type
# TODO a nice bitfield / enum / flags type for brace?
# auto-squeeze option for enum types?

int rope_p_char = 0
int rope_p_rope = 1
int rope_p_start = 0
int rope_p_end = 1
int rope_p_on = 2

struct rope_p
	vec stack
#	enum { rope_p_char, rope_p_rope } ref_type:8
#	enum { rope_p_start, rope_p_end, rope_p_on } where:8
	uchar ref_type
	uchar where

rope_p_init(rope_p *rp, size_t space)
	vec_init(&rp->stack, void *, space)
def rope_p_init(rope_p *rp) rope_p_init(rp, 1)

rope_p_free(rope_p *rp)
	vec_free(&rp->stack)

rope_p rope_start(rope r)
	new(rp, rope_p)
	vec_push(&rp->stack, r)
	rp->ref_type = rope_p_rope
	rp->where = rope_p_start
	return *rp

rope_p rope_end(rope r)
	new(rp, rope_p)
	vec_push(&rp->stack, r)
	rp->ref_type = rope_p_rope
	rp->where = rope_p_end
	return *rp

boolean rope_p_is_a_rope(rope_p *rp)
	return rp->ref_type == rope_p_rope
boolean rope_p_is_a_char(rope_p *rp)
	return rp->ref_type == rope_p_char

rope_p_enter(rope_p *rp)
	assert(rope_p_is_a_rope(rp), "rope_p: cannot enter, already at char level")
	rope p = *(rope *)vec_top(&rp->stack)
	assert(!rope_is_empty(p), "rope_p: cannot enter, rope is empty")
	assert(!rope_is_null(p), "rope_p: cannot enter, rope is null (it shouldn't be!)")
	assert(rp->where != rope_p_on, "rope_p: cannot enter, where == on")

	if rope_is_a_str(p)
		if rp->where == rope_p_start
#			vec_push(&rp->stack, p.s.start-1)
#			rp->where = rope_p_end
			vec_push(&rp->stack, p.s.start)
		 else
			vec_push(&rp->stack, p.s.end)
			rp->where = rope_p_start
		rp->ref_type = rope_p_char
	 else
		if rp->where == rope_p_start
			vec_push(&rp->stack, p.v.start)
		 else
			vec_push(&rp->stack, p.v.end)

boolean rope_p_at_top(rope_p *rp)
	return vec_get_size(&rp->stack) == 1

rope_p_leave(rope_p *rp)
	assert(!rope_p_at_top(rp), "rope_p: cannot leave, already at top level")
	vec_pop(&rp->stack)

rope_p_next(rope_p *rp)
	use(rp)

# all this is reminiscent of ved!  is it bogus?

rope_p_dup(rope_p *to, rope_p *from)
	vec_dup(&to->stack, &from->stack)
	to->ref_type = from->ref_type
	to->where = from->where

# TODO subropes... , balancing, auto-balancing?, test it!


# TODO automatic dup functions, like C++

# TODO strv?

# TODO convert strv to a vec of iovec for writev compatibility?
# <sys/uio.h>
# typedef struct iovec iovec


def SPC r(" ")
def NL r("\n")
def TAB r("\t")

fprint_rope(FILE *stream, rope r)
	for_str_in_rope(s, r)
		fprint_str(stream, s)
	# TODO use writev?

# this doesn't work, need to run macros before splitting to headers?
#prints_and_says(rope)

print_rope(rope r)
	fprint_rope(stdout, r)

fsay_rope(FILE *stream, rope r)
	fprint_rope(stream, r)
	nl(stream)

say_rope(rope r)
	fsay_rope(stdout, r)

# brace_shuffle is borked
#typedef void (*str_f)(str s)
#
#rope_each_str(rope r, void (*f)(str s))
#	if rope_is_empty(r)
#		.
#	 eif rope_is_a_str(r)
#		(*f)(r.s)
#	 else
#		ropev_each_str(r.v, f)
#
#ropev_each_str(ropev v, void (*f)(str s))
#	for(i, ropev_range(v))
#		rope_each_str(*i, f)

def for_str_in_rope(S, R)
	new(my(q), deq, rope)
	deq_push(my(q), R)
	rope my(r)
	while deq_get_size(my(q))
		deq_shift(my(q), my(r))
		if rope_is_empty(my(r))
			continue
		 eif rope_is_a_ropev(my(r))
		 	for(i, ropev_range(my(r).v))
				deq_push(my(q), i)
			continue
		let(S, my(r).s)

size_t syms_n_buckets = 1021

# interning symbols (cstr)
hashtable syms__struct
hashtable *syms = NULL

sym_init()
	if !syms
		syms = &syms__struct
		init(syms, hashtable, cstr_hash, cstr_eq, syms_n_buckets)
		# TODO rehash if the hashtable gets too full...?

# sym is called with a cstr.  this will be copied if it is put into the "syms" ht
cstr sym(cstr s)
	if !syms
		sym_init()
	list *ref = hashtable_lookup_ref(syms, s)
	if hashtable_ref_exists(ref)
		key_value *kv = hashtable_ref_key_value(ref)
		return (cstr)kv->k

	cstr s1 = cstr_copy(s)
	hashtable_add(syms, s1, NULL)
	return s1
	# should be a "hash_set"
	# or maybe "value" wants to be an int for this, a usage count?
	# or it could be a smallish "symbol ID" number?

	# todo ref count so that can free them??

# sym_this is called with a malloc'd cstr; will be freed if already interned
cstr sym_this(cstr s)
	if !syms
		sym_init()
	list *ref = hashtable_lookup_ref(syms, s)
	if hashtable_ref_exists(ref)
		key_value *kv = hashtable_ref_key_value(ref)
		Free(s)
		return (cstr)kv->k

	hashtable_add(syms, s, NULL)
	return s
	# should be a "hash_set"
	# or maybe "value" wants to be an int for this, a usage count?
	# or it could be a smallish "symbol ID" number?
struct cons
	void *head
	void *tail



# possible problem, if f == "/" we get "//foo" :/
# That's a bug in unix!
# path_cat fixes that

def path_cat(a, b) cstr_cat(cstr_eq(a, path__root) ? path__root_before_sep : a, path__sep_cstr, b)
def path_cat(a, b, c) cstr_cat(cstr_eq(a, path__root) ? path__root_before_sep : a, path__sep_cstr, b, path__sep_cstr, c)
def path_cat(a, b, c, d) cstr_cat(cstr_eq(a, path__root) ? path__root_before_sep : a, path__sep_cstr, b, path__sep_cstr, c, path__sep_cstr, d)

# this splits a string into dir and base parts.  It modifies its argument.
dirbase dirbasename(cstr path)
	dirbase rv
	let(len, strlen(path))
	if len == 0
		rv.dir = "."
		rv.base = "."
		return rv
	if path__is_sep(path[len-1])
		while len && path__is_sep(path[len-1])
			path[len-1] = '\0' ; --len
		if path[0] == '\0'
			rv.dir = path__root
		 else
			rv.dir = path
		rv.base = "."
		return rv

	let(slash, path+len-2)
	repeat
		if slash < path
			slash = NULL
			break
		if path__is_sep(*slash)
			break
		--slash

	if slash
		*slash = '\0'
		if slash == path
			rv.dir = path__root
		else
			rv.dir = path
		rv.base = slash+1
	else
		rv.dir = "."
		rv.base = path
	return rv

struct dirbase
	cstr dir
	cstr base

def dirbasename(path, dirv, basev)
	let(my(rv), dirbasename(path))
	let(dirv, my(rv).dir)
	let(basev, my(rv).base)

cstr dir_name(cstr path)
	let(rv, dirbasename(path))
	return rv.dir

cstr base_name(cstr path)
	let(rv, dirbasename(path))
	return rv.base

# TODO decent non cstr strings ***
# TODO automatic declaration

# path must be malloc'd, may be freed
# returns malloc'd
cstr path_relative_to(cstr path, cstr origin)
	if cstr_begins_with(path, path__root)
		return path
	origin = Strdup(origin)
	let(dir, dir_name(origin))
	let(_path, format("%s" path__sep_cstr "%s", dir, path))
	Free(origin)
	Free(path)
	return _path

# malloc'd -> malloc'd
cstr path_tidy(cstr path)
	let(i, path)
	let(o, path)

	boolean o_uppable = 0
	boolean abs = 0

	if *i == '\0'
		error("path_tidy: empty path not valid")

	if path__is_sep(*i)
		*o++ = path__sep ; i++
		abs = 1
	
	repeat
		assert((i == path || path__is_sep(i[-1])) && (o == path || path__is_sep(o[-1])),
		 "borked in path_tidy")

		if path__is_sep(*i)
			++i
		 eif i[0] == '.' && is_slash_or_nul(i[1])
			i += 2
		 else
			boolean dotdot = i[0] == '.' && i[1] == '.' && is_slash_or_nul(i[2])
			if dotdot && o_uppable
				i += 3
				--o_uppable
				do
					--o
				 until(o == path || path__is_sep(o[-1]))
			 eif dotdot && abs
				i += 3
			 else
				assert(!dotdot || (dotdot && !abs && !o_uppable), "borked in path_tidy 2")
				unless(dotdot)
					++o_uppable
				do
					*o++ = *i++
				 until(is_slash_or_nul(i[-1]))
		if i[-1] == '\0'
			break
		 eif o != path
			o[-1] = path__sep

	if (o-path > 1 && path__is_sep(o[-1])) ||
	  (o-path > 0 && o[-1] == '\0')
		--o
	if o == path
		*o++ = '.'
	*o = '\0'

	Realloc(path, o - path + 1)
	return path

# might as well do this for things that "process" their arg:
# TODO rename the main functions to _foo, and these to take thier place
def Path_tidy(path)
	path = path_tidy(path)

def Path_relative_to(path, origin)
	path = path_relative_to(path, origin)
	

# TODO use triple space for indenting continued lines??

def is_slash_or_nul(c) path__is_sep(c) || c == '\0'

# child: malloc'd -> rv
cstr path_under(cstr parent, cstr child)
	cstr e = cstr_begins_with(child, parent)
	if e
		if path__is_sep(*e)
			cstr_chop_start(child, e+1)
			cstr_realloc(child)
			return child
		 eif *e == '\0'
			Free(child)
			return Strdup(".")
	return NULL

# child: malloc'd -> rv
cstr path_under_maybe(cstr parent, cstr child)
	cstr rv = path_under(parent, child)
	if rv == NULL
		rv = child
	return rv

def best_path(path, parent) path_under_maybe(parent, path_tidy(path))
def best_path(path) best_path(path, Getcwd())
def best_path_main(path) best_path(path, main_dir)

boolean path_hidden(cstr p)
	if p[0] == '.' && p[1] == '\0'
		return 0
	while *p != '\0'
		if path__is_sep(*p)
			++p
		 eif *p == '.'
			if path__is_sep(p[1])
				p += 2
			 eif p[1] == '.' && path__is_sep(p[2])
				p += 3
			 else
				return 1
		 else
			while !path__is_sep(*p)
				if *p == '\0'
					return 0
				++p
	return 0

boolean path_hidden_normal(cstr p)
	return path_hidden(p) &&
	 !(p[1] == '\0' || (p[1] == '.' && p[2] == '\0'))

boolean path_has_component(cstr path, cstr component)
	# XXX inefficient
	# XXX if path uses / but component \ for example on win32, it won't work - fix it using path_tidy first
	let(c0, format(path__sep_cstr "%s" path__sep_cstr, component))
	let(c1, format(path__sep_cstr "%s", component))
	let(c2, format("%s" path__sep_cstr, component))
	boolean has = strstr(path, c0) ||
	 cstr_ends_with(path, c1) ||
	 cstr_begins_with(path, c2) ||
	 cstr_eq(path, component)
	Free(c0)
	Free(c1)
	Free(c2)
	return has

# malloc->malloc
def path_to_abs(path) path_to_abs(path, NULL)
cstr path_to_abs(cstr path, cstr cwd)
	if path_is_abs(path)
		return path
	 else
		if !cwd
			cwd = Getcwd()
		cstr path1 = path_tidy(path_cat(cwd, path))
		Free(path)
		return path1

# PATH is vaguely related to paths..!

cstr which(cstr file)
	cstr PATH = Strdup(Getenv("PATH"))
	new(v, vec, cstr, 32)
	splitv(v, PATH, PATH_sep)
	cstr path = NULL
	for_vec(dir, v, cstr)
		path = path_cat(*dir, file)
		if exists(path)
			break
		Free(path)
		 # sets path = NULL again
	vec_free(v)
	Free(PATH)
	return path

cstr Which(cstr file)
	cstr path = which(file)
	if !path
		failed("which", file)
	return path

PATH_prepend(cstr dir)
	PATH_rm(dir)
	cstr new_PATH = format("%s%c%s", dir, PATH_sep, Getenv("PATH"))
	Setenv("PATH", new_PATH)
	Free(new_PATH)

PATH_append(cstr dir)
	PATH_rm(dir)
	cstr new_PATH = format("%s%c%s", Getenv("PATH"), PATH_sep, dir)
	Setenv("PATH", new_PATH)
	Free(new_PATH)

PATH_rm(cstr dir)
	cstr PATH = Strdup(Getenv("PATH"))
	new(v, vec, cstr, 32)
	splitv(v, PATH, PATH_sep)
	ssize_t c = veclen(v)
	grep(i, v, cstr, !cstr_eq(*i, dir), void)
	if veclen(v) != c
		cstr new_PATH = joinv(PATH_sep, v)
		Setenv("PATH", new_PATH)
		Free(new_PATH)
	Free(PATH)

def path__sep '/'
def path__is_sep(c) c == '/'
def path__sep_cstr "/"
def path__root_before_sep ""
def path__root "/"
def PATH_sep ':'
def EXE ""
def SO ".so"

boolean path_is_abs(cstr path)
	return path__is_sep(path[0])
def fix_path void

int nonmingw_path = 1
export time.h
export sys/time.h
export locale.h
use math.h
use stdio.h
use stdlib.h
use string.h


def time_forever -1e100

# datetime:
#
#    struct tm {
#            int     tm_sec;         /* seconds */
#            int     tm_min;         /* minutes */
#            int     tm_hour;        /* hours */
#            int     tm_mday;        /* day of the month */
#            int     tm_mon;         /* month */
#            int     tm_year;        /* year */
#            int     tm_wday;        /* day of the week */
#            int     tm_yday;        /* day in the year */
#            int     tm_isdst;       /* daylight saving time */
#    };


def Sleep(time) Rsleep(time)
  # to be consistent, this should really be like sleep(int time)
  # - but rsleep(num time) behaves the same given an int arguement.

Rsleep(num time)
	repeat
		time = rsleep(time)
		if time == 0
			break
		if time == -1
			failed("nanosleep")

num rsleep(num time)
	if time <= 0
		return 0
	struct timespec delay
	rtime_to_timespec(time, &delay)
	if nanosleep(&delay, &delay) == -1
		if errno == EINTR
			return timespec_to_rtime(&delay)
		return -1
	return 0

def Sleep_forever()
	repeat
		Sleep(1e6)

# it would be good to have a "cached time" function that only
# calls gettimeofday(2) if the process has blocked since the
# last call to cached_time...

num rtime()
	struct timeval tv
	Gettimeofday(&tv)
	return timeval_to_rtime(&tv)

Gettimeofday(struct timeval *tv)
	if gettimeofday(tv) != 0
		failed("gettimeofday")

def gettimeofday(tv) gettimeofday(tv, NULL)

def time() time(NULL)

# there is no Time because X11 defines it

# it would be good to have an "automatically declare a temporary
# struct for something to be returned in" feature in NIPL.

def datetime_init(dt)
	.

Gmtime(double t, datetime *result)
	time_t t1 = (time_t)t
	if gmtime_r(&t1, result) == NULL
		failed("gmtime_r")

Localtime(double t, datetime *result)
	time_t t1 = (time_t)t
	if localtime_r(&t1, result) == NULL
		failed("localtime_r")

int Mktime(datetime *t)
	int rv = mktime(t)
	if rv == -1
		failed("mktime")
	return rv

cstr dt_format = "%F %T"
cstr dt_format_tz = "%F %T %z"
# Y-m-d h-m-s

# as usual, this APPENDS to a buffer, so clear it first.
Timef(buffer *b, const datetime *tm, const char *format)
	int len
	repeat
		b->start[0] = 'x'
		len = strftime(b->end,
		 buffer_get_free(b), format, tm)
		if len != 0 || b->start[0] == '\0'
			break
		# XXX I hope this is correct!
		buffer_double(b)
	buffer_set_size(b, len + 1)

# this returns a cstr, you should free it
def Timef(dt, format) Timef_cstr(dt, format)
def Timef(dt) Timef_cstr(dt, dt_format)
cstr Timef_cstr(datetime *dt, const char *format)
	new(b, buffer)
	Timef(b, dt, format)
	# squeeze - once have made buffer always end in nul
	return buffer_get_start(b)

def datetime_init(dt, year, month, day) datetime_init(year, month, day, 0, 0, 0)

datetime_init(datetime *dt, int year, int month, int day,  int hour, int min, int sec)
	dt->tm_year = year - 1900
	dt->tm_mon = month - 1
	dt->tm_mday = day
	
	dt->tm_hour = hour
	dt->tm_min = min
	dt->tm_sec = sec

# FIXME I doubt this stuff needs to use long double

boolean sleep_debug = 0

# csleep: cumulative sleep.
# You should call it once first outside the loop to initialize it.
# The first time you call it, it records csleep_last, and optionally syncs the
# current time to match the step so printing the time will make more sense.  If
# one sleep is to short, the next will probably be longer.  If too long, the
# next should be shorter.
# TODO do this as an object, and make it proc compatible.

long double csleep_last = 0
def csleep(step) csleep(step, 0, 1, 0)
csleep(long double step, boolean sync, boolean use_asleep, boolean rush)
	long double t = rtime()
	long double to_sleep
	if !csleep_last
		# first step
		if sync
			long double t1 = rdiv(t, step)*step+step
			to_sleep = t1 - t
			xsleep(to_sleep, t, use_asleep)
			csleep_last = t1
		 else
			xsleep(step, t, use_asleep)
			csleep_last = t + step
	 else
		long double dt = t - csleep_last
		long double to_sleep = step - dt
		if to_sleep > 0
			xsleep(to_sleep, t, use_asleep)
			csleep_last += step
		 else
			# adjust for possible stoppage, etc
			if sleep_debug
				warn("sleep_step running late")
			if sync
				csleep_last += (rdiv(dt, step)+1)*step
				to_sleep = csleep_last - t
				xsleep(to_sleep, t, use_asleep)
			 eif !rush
				csleep_last = t
	if sleep_debug
		warn("%f %Lf", rtime(), csleep_last)

def xsleep(dt, t, use_asleep)
	if use_asleep
		asleep(dt, t)
	 else
		Sleep(dt)

# this asleep (accurate sleep) is still a bit dodgy,
# e.g. asleep_small probably should vary by machine
# TODO maybe start asleep_small very small, and double it every time asleep
# fails to be accurate?

def asleep(dt) asleep(dt, rtime())
long double asleep(long double dt, long double t)
	if dt <= 0.0
		return t
	t += dt
	if dt <= asleep_small
		long double t1
		while (t1=rtime()) < t
			.
			# sched_yield might makes this busy loop a little less busy if other processes need to run?
			# any other way to do it?  a real-time alarm?
			#sched_yield()
		return t1
	 else
		lsleep(dt-asleep_small)
		long double t2 = rtime()
		long double dt2 = t - t2
		if dt2 > 0
			return asleep(dt2, t2)
		 eif dt < 0
			asleep_small *= 2
			if sleep_debug
				warn("asleep: slept too long, doubling asleep_small to %f", asleep_small)
		return t2


# benchmarking stuff

num bm_start = 0
num bm_end = 0
boolean bm_enabled = 1

def bm_block(msg)
	post(my(x))
		bm(msg)
	pre(my(x))
		bm_start()

def bm_block(msg, reps)
	post(my(x))
		bm_ps(msg, reps)
	pre(my(x))
		bm_start()

def bm_start()
	if bm_enabled
		bm_start = rtime()

def bm()
	if bm_enabled
		if bm_start == 0
			bm_start()
		else
			bm_end = rtime()

def bm(s)
	bm()
	if bm_end
		warn("%s: %f", s, bm_end-bm_start)

def bm(s, n)
	bm()
	if bm_end
		warn("%s: %f = %f * %d", s, bm_end-bm_start, (bm_end-bm_start)/n, (size_t)n)

def bm_ps(s)
	bm_ps(s, 1)
def bm_ps(s, n)
	bm()
	if bm_end
		warn("%s: %f / sec", s, n / (bm_end-bm_start))

rtime_to_timeval(num rtime, struct timeval *tv)
	tv->tv_sec = (long)rtime
	tv->tv_usec = (long)((rtime - tv->tv_sec) * 1e6)

rtime_to_timespec(num rtime, struct timespec *ts)
	ts->tv_sec = (long)rtime
	ts->tv_nsec = (long)((rtime - ts->tv_sec) * 1e9)

num timeval_to_rtime(const struct timeval *tv)
	return (num)tv->tv_sec + tv->tv_usec / 1e6

num timespec_to_rtime(const struct timespec *ts)
	return (num)ts->tv_sec + ts->tv_nsec / 1e9

int rtime_to_ms(num rtime)
	return (int)(rtime * 1000)

num ms_to_rtime(int ms)
	return ms / 1000.0

int delay_to_ms(num delay)
	if delay == time_forever
		return -1
	 else
		return rtime_to_ms(delay)

struct timespec *delay_to_timespec(num delay, struct timespec *p)
	if delay == time_forever
		return NULL
	 else
		rtime_to_timespec(delay, p)
		return p

struct timeval *delay_to_timeval(num delay, struct timeval *p)
	if delay == time_forever
		return NULL
	 else
		rtime_to_timeval(delay, p)
		return p

date_rfc1123_init()
	setlocale(LC_TIME, "POSIX")
	Putenv("TZ=GMT")
	tzset()

char *date_rfc1123(time_t t)
	static char date[32]
	static char maxdate[32]
	static time_t maxtime = -1
	if t == maxtime
		return maxdate
	char *d = date
	if t > maxtime
		maxtime = t
		d = maxdate
	strftime(d, sizeof(date), "%a, %d %b %Y %H:%M:%S GMT", gmtime(&t))
	return d

# NOTE can use timeradd etc when necessary.  BSD.

## this delay loop shite might work in the kernel, it doesn't work here!
#
#num loops_per_sec
#
#unsigned long delay_loop_init_count = 0
#
#num delay_loop_init(num secs)
##	set_priority(getpid(), sched_get_priority_max(SCHED_FIFO))
##	Sleep(0.1)
#	sighandler_t sigh_old = Sigact(SIGALRM, catch_signal_delay_loop_init)
#	num t0 = rtime()
#	Ualarm(secs)
##	unsigned long loops = ((unsigned long)-1)
##	unsigned long loops = 300000000
#	unsigned long loops = 1000000000
#	delay_loop(loops)
#	num t1 = rtime()
#	loops -= delay_loop_init_count
#	loops_per_sec = loops / (t1-t0)
#	Sigact(SIGALRM, sigh_old)
#	warn("delay_loop_init: %d loops, %f secs, %f loops_per_sec", loops, t1-t0, loops_per_sec)
#	return loops_per_sec
#
#void catch_signal_delay_loop_init(int sig)
#	use(sig)
#	delay_loop_init_count = delay_loop_d0
#	delay_loop_stop()
#
#volatile unsigned long delay_loop_d0
#
#__attribute__((__noinline__)) delay_loop(unsigned long loops)
#	if loops
#		register volatile unsigned long delay_loop_d0 = loops
#		do
#			--delay_loop_d0
#		 while delay_loop_d0 != 0
#
#delay_loop_stop()
#	delay_loop_d0 = 1
#
#delay_loop_sleep(num secs)
#	delay_loop(secs * loops_per_sec)

boolean lsleep_inited = 0
lsleep_init()
	Sigact(SIGALRM, catch_signal_null)
	lsleep_inited = 1

lsleep(num dt)
	if !lsleep_inited
		lsleep_init()
#	itimerval v
#	rtime_to_timeval(dt, &v.it_value)
#	v.it_interval.tv_sec = v.it_interval.tv_usec = 0
#	Setitimer(ITIMER_REAL, &v, NULL)
	Ualarm(dt)
	rsleep(dt+1)

typedef struct itimerval itimerval

Getitimer(int which, struct itimerval *value);
	if getitimer(which, value)
		failed("getitimer")

Setitimer(int which, const struct itimerval *value, struct itimerval *ovalue);
	if setitimer(which, value, ovalue)
		failed("setitimer")

Ualarm(num dt)
	itimerval v
	rtime_to_timeval(dt, &v.it_value)
	v.it_interval.tv_sec = v.it_interval.tv_usec = 0
	Setitimer(ITIMER_REAL, &v, NULL)

long double asleep_small = 0.03  # 0.0001
export math.h stdlib.h limits.h float.h

#Def trig_unit rad
Def trig_unit deg
# TODO: trig01, trig_neg1_to_1, grad

const num pi = M_PI
const num e = M_E

def Rad(a) deg2rad(a)
def deg2rad(a) a * pi / 180.0

#num deg2rad(num a)
#	return a * pi / 180.0

def Deg(a) rad2deg(a)
def rad2deg(a) a * 180.0 / pi

#num rad2deg(num a)
#	return a * 180.0 / pi

Def angle_360 trig_unit^^_360
Def angle_180 trig_unit^^_180
Def angle_90 trig_unit^^_90
Def angle_60 trig_unit^^_60
Def angle_30 trig_unit^^_30

def rad_360 2*pi
def rad_180 pi
def rad_90 pi/2
def rad_60 pi/3
def rad_45 pi/4
def rad_30 pi/6

def deg_360 360.0
def deg_180 180.0
def deg_90 90.0
def deg_60 60.0
def deg_45 45.0
def deg_30 30.0

def Sin(a) sin(angle2rad(a))
def Cos(a) cos(angle2rad(a))
def Tan(a) tan(angle2rad(a))

def Acos(x) rad2angle(acos(x))
def Asin(y) rad2angle(asin(y))
def Atan(m) rad2angle(atan(m))
def Atan2(y, x) rad2angle(atan2(y, x))

# todo: once macro-closures are working, change to sin, cos, tan...

# todo can also have an dynamic2rad, so can change settings in mid program.
# Actually, you could change settings mid program with local macros!

int sgn(num x)
	if x < 0
		return -1
	if x > 0
		return 1
	return 0

num nmin(num x, num y)
	if x < y
		return x
	return y

num nmax(num x, num y)
	if x > y
		return x
	return y

int imin(int x, int y)
	if x < y
		return x
	return y

long lmin(long x, long y)
	if x < y
		return x
	return y

int imax(int x, int y)
	if x > y
		return x
	return y

long lmax(long x, long y)
	if x > y
		return x
	return y

def nmax(x, y, z) nmax(nmax(x, y), z)
def imax(x, y, z) imax(imax(x, y), z)
def lmax(x, y, z) lmax(lmax(x, y), z)

def sqr(x) x*x

# use hypot instead
#real pythag(real x, real y)
#	return sqrt(x*x + y*y)
num notpot(num hypotenuse, num x)
	return sqrt(sqr(hypotenuse) - sqr(x))

def randi() (long)(random() & 0x7fffffff)
def randi(max) (int)(max*Rand())
def randi(min, max) randi(max-min)+min

def RANDOM_TOP (1UL<<31)
def RANDOM_MAX RANDOM_TOP-1
def RANDI_TOP RANDOM_TOP
def RANDI_MAX RANDOM_MAX
def RANDL_TOP (unsigned long long int)RANDI_TOP*RANDI_TOP
def RANDL_MAX (unsigned long)RANDL_TOP-1

def randl() (long long int)random()*RANDI_TOP+random()
  # not full 64 bit positive, only 62 bits!

def Rand() (num)((long double)randl()/RANDL_TOP)
def Rand(max) Rand()*max
def Rand(min, max) Rand(max-min)+min
#def toss() Rand()>0.5
def toss() randi() > RANDI_MAX/2
# TODO speed up some other rand functions like with toss

seed()
	int s = (int)((rmod(rtime()*1000, pow(2, 32)))) ^ (getpid()<<16)
	seed(s)
def seed(s) srandom(s)

# TODO remap to Mod ?
int mod(int i, int base)
	if i < 0
		return base - 1 - (-1 - i) % base
	else
		return i % base

int Div(int i, int base)
	if i>=0
		return i/base
	return -((-i-1)/base + 1)

def mod_fast(ans, i, base)
	int my(_i) = i
	int my(_b) = base
	if my(_i) >= 0
		ans = my(_i)%my(_b)
	 else
		ans = my(_b)-1 - (-1-my(_i))%my(_b)

num rmod(num r, num base)
	int d = rdiv(r, base)
	return r - d * base

def rmod_fast(num m, num r, num base)
	num my(_r) = r
	num my(_b) = base
	m = my(_r) - rdiv(my(_r), my(_b)) * my(_b)

def rdiv(r, base) floor(r / base)

# typedef real vec2[2]
# typedef real vec3[3]
# 
# vec2 unit2(real a)
# 	vec2 v
# 	v[0] = cos(a)
# 	v[1] = sin(a)
# 
# def Unit2(a) unit2(deg2rad(a)

num dist(num x0, num y0, num x1, num y1)
	return hypot(x1-x0, y1-y0)

def rad2rad Id
def deg2deg Id

Def angle2rad trig_unit^^2^^rad
Def angle2deg trig_unit^^2^^deg
Def rad2angle rad2^^trig_unit
Def deg2angle deg2^^trig_unit
  # !! how awesome !!
  # TODO allow token pasting in normal parsage too
  #   think about when it's done

def polar_to_rec(x0, y0, a, r, x1, y1)
	let(x1, Cos(a)*r + x0)
	let(y1, Sin(a)*r + y0)

def avg(x) x
def avg(x, y) (x+y)/2.0
def avg(x, y, z) (x+y+z)/3.0

def avg(a0, a1, a2, a3) (a0 + a1 + a2 + a3)/4.0
def avg(a0, a1, a2, a3, a4) (a0 + a1 + a2 + a3 + a4)/5.0
def avg(a0, a1, a2, a3, a4, a5) (a0 + a1 + a2 + a3 + a4 + a5)/6.0
def avg(a0, a1, a2, a3, a4, a5, a6) (a0 + a1 + a2 + a3 + a4 + a5 + a6)/7.0
def avg(a0, a1, a2, a3, a4, a5, a6, a7) (a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7)/8.0
def avg(a0, a1, a2, a3, a4, a5, a6, a7, a8) (a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8)/9.0
def avg(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) (a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9)/10.0

num double_or_nothing(num factor)
	# this returns 1, 2, 4, 1/2, 1/4 only (the closest)
	return pow(2, floor(log(factor)/log(2)+.5))

divmod(int i, int base, int *div, int *_mod)
	*div = Div(i, base)
	*_mod = mod(i, base)

divmod_range(int i, int low, int high, int *div, int *_mod)
	i -= low
	divmod(i, high-low, div, _mod)
	*_mod += low

rdivmod(num r, num base, num *div, num *_mod)
	*div = rdiv(r, base)
	*_mod = rmod(r, base)

rdivmod_range(num r, num low, num high, num *div, num *_mod)
	r -= low
	rdivmod(r, high-low, div, _mod)
	r += low

def xor(a, b) (a&&1)^(b&&1)

def tinynum 1e-12
def bignum INFINITY

Def sincos(a, r) sin(a) * r, cos(a) * r
Def SinCos(a, r) Sin(a) * r, Cos(a) * r

def rand_angle_unsigned() Rand(angle_360)

def rand_angle_signed() Rand(-angle_180, angle_180)

def rand_angle() rand_angle_signed()

num clamp(num x, num min, num max)
	return x < min ? min : x > max ? max : x

int iclamp(int x, int min, int max)
	return x < min ? min : x > max ? max : x

long lclamp(long x, long min, long max)
	return x < min ? min : x > max ? max : x

def byte_clamp(x) iclamp(x, 0, 255)
def byte_clamp_top(x) x&0xFF
def n_to_byte(x) byte_clamp((int)x*256)
def n_to_byte_top(x) (int)(x*256)&0xFF

def Floor(x) (int)(x+tinynum)

def num_eq(a, b) fabs(b-a)<tinynum
def num_lt(a, b) a<b-tinynum
def num_le(a, b) a<b+tinynum
def num_gt(a, b) a>b+tinynum
def num_ge(a, b) a>b-tinynum
def num_ne(a, b) !num_eq(a, b)

num spow(num b, num e)
	if b >= 0
		return pow(b, e)
	 else
		return -pow(-b, e)
def ssqrt(b) spow(b, 0.5)
def ssqr(b) spow(b, 2)

# FIXME this is inefficient, and anyway if using this method should have varargs macros!
def max(a0) a0
def max(a0, a1) nmax(a0, a1)
def max(a0, a1, a2) max(max(a0, a1), a2)
def max(a0, a1, a2, a3) max(max(a0, a1, a2), a3)
def max(a0, a1, a2, a3, a4) max(max(a0, a1, a2, a3), a4)
def max(a0, a1, a2, a3, a4, a5) max(max(a0, a1, a2, a3, a4), a5)
def max(a0, a1, a2, a3, a4, a5, a6) max(max(a0, a1, a2, a3, a4, a5), a6)
def max(a0, a1, a2, a3, a4, a5, a6, a7) max(max(a0, a1, a2, a3, a4, a5, a6), a7)
def max(a0, a1, a2, a3, a4, a5, a6, a7, a8) max(max(a0, a1, a2, a3, a4, a5, a6, a7), a8)
def max(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) max(max(a0, a1, a2, a3, a4, a5, a6, a7, a8), a9)

def rand_normal(av, sd) rand_normal()*sd+av

num rand_normal()
	num U = Rand()
	num V = Rand()
	num X = sqrt(-2 * log(U)) * cos(2*pi*V)
#	num Y = sqrt(-2 * log(V)) * sin(2*pi*U)
	return X

def ln(x) log(x)

# rand_normal uses the box-mueller method, from:
# http://en.wikipedia.org/wiki/Normal_distribution#Generating_values_for_normal_random_variables
# The Ziggurat method is faster, I could try that later.

num blend(num i, num x0, num x1)
	return (x1-x0)*i + x0

def iabs(a) a >= 0 ? a : -a

struct pointi1
	int x[1]
struct pointi2
	int x[2]
struct pointi3
	int x[3]
struct pointn1
	num x[1]
struct pointn2
	num x[2]
struct pointn3
	num x[3]
use stdlib.h


extern char **environ

#TODO error handler support, i.e. a longjmp to an error handler if there is one

char *env__required = (char *)-1

# TODO change to use regular opt_err instead of env__required etc

char *Getenv(const char *name, char *_default)
	char *value = getenv(name)
	if value == NULL
		if _default == env__required
			error("missing required env arg: %s\n", name)
		value = _default
	return value

def Getenv(name) Getenv(name, "")

def Getenv_or_null(name) Getenv(name, NULL)
def Getenv_required(name) Getenv(name, env__required)

def env(name) Getenv(name)
def env(name, _default) Getenv(name, _default)

boolean is_env(const char *name)
	return *Getenv(name, "")

Putenv(char *string)
	if putenv(string) != 0
		failed("putenv")

# TODO Setenvf (or just use Putenv with format)

Setenv(const char *name, const char *value, int overwrite)
	if setenv(name, value, overwrite)
		failed("setenv")

def Setenv(name, value)
	Setenv(name, value, 1)

dump_env()
	for_env_raw(e)
		Sayf("%s", e)

def for_env_raw(e)
	let(my(p), environ)
	for ; my(p) && *my(p); ++my(p)
		let(e, *my(p))

def for_env(k)
	for_env(k, my(v))
def for_env(k, v)
	for_env_raw(k)
		let(v, strchr(k, '='))
		if !v
			error("bad environment varaible >%s<", k)
		*v = '\0'
		++v

# TODO use a normal hashtable for config instead of the environment?
# then should load environment into the hashtable also.

load_config(cstr file)
	F_in(file)
		eachline(l)
			if among(*l, '#', '\0')
				continue
			cstr key = Strdup(l)
			cstr val = strchr(key, '=')
			if val
				*val++ = '\0'
			 else
				val = "1"
			if !is_env(key)
				if *val == '"'
					*val++ = '\0'
				cstr lastq = strchr(val, '"')
				if lastq
					*lastq = '\0'
				Setenv(key, val)

Clearenv()
	if clearenv() != 0
		failed("clearenv")
use stdlib.h

# FIXME these aren't in mingw, they are less standard apparently
# I should implement setenv at least for mingw.
# unsetenv can be implemented with putenv too.
# clearenv might be done with environ = NULL ?

Unsetenv(const char *name)
	unsetenv(name)

#def clearenv() clear_env()

# is this okay?
#int clear_env(void)
#	environ = NULL

int clear_env(void)
	new(k, buffer, 256)
	while *environ
		char *equals = strchr(*environ, '=')
		buffer_clear(k)
		if !equals
			buffer_cat_cstr(k, *environ)
		 else
			buffer_cat_str(k, new_str(*environ, equals))
		Say(buffer_get_start(k))
#		unsetenv(k)
	buffer_free(k)
	return 0

cstr homedir()
	return Getenv("HOME", path__root)

# the handler must free the filename

# typedef void (*find_handler)(cstr filename, lstats *s)
# 
# find(deq *q, find_handler h)
# 	cstr f
# 	while deq_get_size(q)
# 		deq_shift(q, f)
# 		new(buf, lstats, f)
# 		if S_EXISTS(buf->st_mode)
# 			if S_ISDIR(buf->st_mode)
# 				find__its_a_dir(f)
# 			(*h)(f, buf)
# 
# def find__its_a_dir(f)
# 	new(v, vec, cstr)
# 	let(dir, Opendir(f))
# 	repeat
# 		let(ent, Readdir(dir))
# 		if ent == NULL
# 			break
# 		cstr new_f = ent->d_name
# 		unless(cstr_eq(new_f, ".") || cstr_eq(new_f, ".."))
# 			new_f = cstr_cat(f, path__sep_cstr, new_f)
# 			# possible problem, if f == "/" we get "//foo" :/
# 			# That's a bug in unix!
# 			# TODO write & use path_cat
# #			deq_push(v, new_f)
# 			vec_push(v, new_f)
# 	
# 	# I'm not happy with this temporary vec
# 	# -- is there a better way?  could use recursion...  :/
# 	# maybe find shouldn't try to preserve order at all..
# 	# That's reasonable but it's a cop out!
# 	# Could have a rope-like thing for vec/deq, that would be ok.
# 	
# 	while vec_get_size(v)
# 		cstr f
# 		vec_pop(v, f)
# 		deq_unshift(q, f)

# this is a bit bogus, what is a better way to handle closures/methods?
# a "global" this pointer, which can be stored/restored?
#  typedef void (*find__handler)(cstr filename, lstats *s, ...)

# something as big as find as a macro, it's not ideal..
# but the syntax of using it is nice I guess,
# and we can possibly have a way to convert macro-format stuff to functions
# including temporary functions and passing the necessary args, later..

# XXX TODO should free the deq q !

def find(root, f, s)
	find_x(normal, root, f, s)
		.

def find_init(q, root)
	new(q, deq, cstr)
	deq_push(q, root)

def find_x(what, root, f, s)
	find_init(my(q), root)
	find_deq_^^what(my(q), f, s)
		.

def find_deq_x(what, q, f, s)
	find_deq_^^what(q, f, s)
		.

def find_deq_normal(q, f, s)
	find_deq(q, f, s)
		.

def find_1(root, f, s)
	find_x(1, root, f, s)
		.

def find_files(root, f, s)
	find_x(files, root, f, s)
		.

def find_all(root, f, s)
	find_x(all, root, f, s)
		.

def find_all_files(root, f, s)
	find_x(all_files, root, f, s)
		.

def find_dirs(root, f, s)
	find_x(dirs, root, f, s)
		.

def find_reg(root, f, s)
	find_x(reg, root, f, s)
		.

def find_lnk(root, f, s)
	find_x(lnk, root, f, s)
		.

# IDEA - non-homogenous deq, queue, etc?  nah!  couldn't do random access..
# not that I ever do anyway yet

def find_deq_1(q, f, s)
	cstr f
	while deq_get_size(q)
		deq_shift(q, f)
		new(s, lstats, f)
		if !S_EXISTS(s->st_mode)   # why wouldn't it exist?? maybe if a bad parameter?
			warn("find: can't stat: %s", f)
			continue
		.

def find_deq_recurse(q, f, s)
	if S_ISDIR(s->st_mode)
		find__its_a_dir(q, f)

def find_deq_all(q, f, s)
	find_deq_1(q, f, s)
		find_deq_recurse(q, f, s)
		.

def find_deq(q, f, s)
	find_deq_1(q, f, s)
		find_skip_hidden(f)
		find_deq_recurse(q, f, s)
		.

def find_skip_dir(s)
	if S_ISDIR(s->st_mode)
		continue

def find_skip_hidden(f)
	if path_hidden(f)
		continue

def find_only_dir(s)
	if !S_ISDIR(s->st_mode)
		continue

def find_only_hidden(f)
	if !path_hidden(f)
		continue

def find_only_reg(s)
	if !S_ISREG(s->st_mode)
		continue

def find_only_lnk(s)
	if !S_ISLNK(s->st_mode)
		continue

def find_deq_files(q, f, s)
	find_deq(q, f, s)
		find_skip_dir(s)
		.

def find_deq_all_files(q, f, s)
	find_deq_all(q, f, s)
		find_skip_dir(s)
		.

def find_deq_dirs(q, f, s)
	find_deq_all(q, f, s)
		find_only_dir(s)
		.

def find_deq_reg(q, f, s)
	find_deq(q, f, s)
		find_only_reg(s)
		.

def find_deq_lnk(q, f, s)
	find_deq(q, f, s)
		find_only_lnk(s)
		.

# IDEA - for a particular directory, do all files first,
# then do subdirectories.

# we could assume all "find" arguments are directories only,
# or make a separate _find that assumes this

def find__its_a_dir(q, f)
	new(my(v), vec, cstr)
	let(my(dir), opendir(f))
	if !my(dir)
		warn("find: can't opendir %s", f)
	else
		repeat
			let(my(ent), Readdir(my(dir)))
			if my(ent) == NULL
				break
			cstr my(new_f) = my(ent)->d_name
			unless(cstr_eq(my(new_f), ".") || cstr_eq(my(new_f), ".."))
				my(new_f) = path_cat(f, my(new_f))
				vec_push(my(v), my(new_f))
		Closedir(my(dir))
		
		while vec_get_size(my(v))
			cstr my(new_f)
			vec_pop(my(v), my(new_f))
			deq_unshift(q, my(new_f))

# I'm not happy with this temporary vec
# -- is there a better way?  could use recursion...  :/
#   *** or a "manual" context stack, yes that's better.  how to do that with coros/process ---->  this is good
# maybe find shouldn't try to preserve order at all..
# That's reasonable but it's a cop out!
# Could have a rope-like thing for vec/deq, that would be ok.

# TOO MUCH "my"  :)

def find_main(f, s)
	find_main(normal, f, s)

def find_main(what, f, s)
	new(my(q), deq, cstr)
	find_main(what, my(q), f, s)

def find_main(what, q, f, s)
	eacharg(a)
		deq_push(q, path_tidy(Strdup(a)))
	# I removed support for 0 args -> . ; it's inconsistent.
#	if args == 0
#		cstr dot = Strdup(".")
#		deq_push(q, dot)
	
	find_deq_x(what, q, f, s)
		.

#def find(h)
#	new(my(q), deq, cstr)
#	cstr my(dot) = Strdup(".")
#	deq_push(my(q), my(dot))
#	find(my(q), h)

find_vec(cstr root, vec *v)
	find_vec_x(normal, root, v)

def find_vec_x(what, root, v)
	find_x(what, root, f, s)
		vec_push(v, f)

find_vec_all(cstr root, vec *v)
	find_vec_x(all, root, v)

find_vec_files(cstr root, vec *v)
	find_vec_x(files, root, v)
export complex.h

typedef double complex cmplx

# complex number extensions

def cabs2(w) creal(w*(creal(w)-cimag(w)*I))

cmplx cis(num ang)
	return cos(ang)+sin(ang)*I

# TODO use intersection of C and C++ complex numbers, check
# the web / bookmarked with dsp stuff for how...

# once using that, move this back to m.h

# public domain code for computing the FFT
# contributed by Christopher Diggins, 2005
# adapted and converted from C++ to brace by Sam Watkins

fft(cmplx *in, cmplx *out, int log2_n)
	int n = 1 << log2_n
	for(i, 0, n)
		out[bit_reverse(i)] = in[i]
	for(s, 1, log2_n+1)
		int m = 1 << s
		cmplx w = 1
		cmplx wm = cis(2*pi/m)
		for(j, 0, m/2)
			for(k, j, n, m)
				cmplx t = w * out[k + m/2]
				cmplx u = out[k]
				out[k] = u + t
				out[k + m/2] = u - t
			w = w * wm
# proc library - lightweight coroutine processes!


def proc_debug void
#def proc_debug warn

typedef int (*proc_func)(proc *p)
struct proc
	proc_func f
	int pc
typedef proc *proc_p
proc_init(proc *p, proc_func f)
	p->f = f
	p->pc = 1

int resume(proc *p)
	proc_debug("resuming: %010p at %d", p, p->pc)
	int rv = (*p->f)(p)
	proc_debug("resuming %010p returned: %d", p, rv)
	if rv
		p->pc = rv
	return rv

# primitives:
# start is defined in sched.b

def stop
	return 0

def yield()
		proc_debug("yeilding")
		return b__pc_next
		b__pc_inc
	b__pc	.

def wait
		b__p->pc = b__pc_next
		stop
		b__pc_inc
	b__pc	.

#Def coro_f(name)
#	int name^^_f(proc *p)
#		name *d = (name *)p
#		switch p->pc
#		b__pc	.
#		.
##		...
##		stop

def b__d(foo) This->foo

# a fancy macro to declare and init a proc
# XXX does not work if the proc init function takes arguments
Def proc(var_name, proc_name)
	proc_name var_name
	proc_name^^_init(&var_name)

# a hack to support 1,2,3 arg proc init functions
Def proc(var_name, proc_name, a1)
	proc_name var_name
	proc_name^^_init(&var_name, a1)
Def proc(var_name, proc_name, a1, a2)
	proc_name var_name
	proc_name^^_init(&var_name, a1, a2)
Def proc(var_name, proc_name, a1, a2, a3)
	proc_name var_name
	proc_name^^_init(&var_name, a1, a2, a3)

proc_dump(proc *p)
	Fprintf(stderr, "%010p(%010p %d) ", p, p->f, p->pc)

# this is a binary help implementation of a priority queue

typedef vec priq

def priq_p(i) (i-1)/2
def priq_c1(i) i*2+1

def priq_init(q, element_type, space)
	init(q, vec, element_type, space)

def priq_free(q)
	vec_free(q)

def priq_get_size(q) vec_get_size(q)

def priq_element(q, i) vec_element(q, i)

def priq_clear(q) vec_set_size(q, 0)

def priq_empty(q) priq_get_size(q) == 0

def priq_peek(q) priq_element(q, 0)

def priq_shift(q, type, cmp)
	priq_shift(q, type, cmp, void, NULL)

def priq_shift(q, type, cmp, move_notify, move_notify_arg)
	priq_remove(q, type, cmp, 0, move_notify, move_notify_arg)

def priq_remove(q, type, cmp, i)
	priq_remove(q, type, cmp, i, void, NULL)

def priq_remove(q, type, cmp, i, move_notify, move_notify_arg)
	int my(last_i) = priq_get_size(q) - 1
	priq_remove(q, type, cmp, i, move_notify, move_notify_arg, my(last_i))

def priq_remove(q, type, cmp, i, move_notify, move_notify_arg, last_i)
	priq_remove(q, type, cmp, i, move_notify, move_notify_arg, last_i, my(size), my(c1), my(c2), my(last), my(j))

def priq_remove(q, type, cmp, i, move_notify, move_notify_arg, last_i, size, c1, c2, last, j)
	# 1. look at the highest element
	# 2. we have a hole at i
	# 3. find the lower child of the hole
	# 4. if it has a child, and the lower child is lower than the highest element, move the lower child to the hole. now the hole is at the lower child. goto 2
	# 5. else, move the highest element to the hole
	# 6. vec_pop() to reduce the size of the priq. done!

	int j = i
	int size = priq_get_size(q)
	int c1, c2
	void *last = priq_element(q, size-1)
	repeat
		c1 = priq_c1(j)
		c2 = c1+1
		if c2 >= size
			break
		if cmp(priq_element(q, c2), priq_element(q, c1)) < 0
			c1 = c2
		if cmp(priq_element(q, c1), last) >= 0
			break
		priq_move(q, type, j, c1, move_notify, move_notify_arg)
		j = c1
	if j != size-1
		priq_move(q, type, j, size-1, move_notify, move_notify_arg, last_i)
	
	vec_pop(q)

def priq_push(q, type, cmp, element_p)
	priq_push(q, type, cmp, element_p, my(i), void, NULL)

def priq_push(q, type, cmp, element_p, i)
	priq_push(q, type, cmp, element_p, i, void, NULL)

def priq_push(q, type, cmp, element_p, i, move_notify, move_notify_arg)
	vec_push(q)
	int i = priq_get_size(q)-1
	priq_push_from(q, type, cmp, element_p, i, move_notify, move_notify_arg)

def priq_push_from(q, type, cmp, element_p, i, move_notify, move_notify_arg)
	for ; i>0 && cmp(element_p, priq_element(q, priq_p(i))) < 0 ; i = priq_p(i)
		priq_move(q, type, i, priq_p(i), move_notify, move_notify_arg)
	*(type *)priq_element(q, i) = *element_p

def priq_move(q, type, to, from, move_notify, move_notify_arg)
	int my(old_i) = from
	priq_move(q, type, to, from, move_notify, move_notify_arg, my(old_i))

def priq_move(q, type, to, from, move_notify, move_notify_arg, old_i)
	vec_copy_element(q, to, from, type)
	if to != old_i
		move_notify(q, to, old_i, move_notify_arg)

def priq_check(q, cmp)
	priq_check(ok, q, cmp, my(size), my(i), my(c), my(p))
def priq_check(ok, q, cmp, size, i, c, p)
	int size = priq_get_size(q)
	for(i, 1, size)
		void *c = priq_element(q, i)
		void *p = priq_element(q, priq_p(i))
		if cmp(p, c) > 0
			fault("priq broken")

# priq_repos
# method -
# if it is < the parent node, move it down using the "push" method
# else add a new element and move it to that "last element"
# remove the hole where it was. It will get copied back in from the last element.

def priq_repos(q, type, cmp, i)
	priq_repos(q, type, cmp, i, void, NULL)

def priq_down(q, type, cmp, i)
	priq_down(q, type, cmp, i, void, NULL)

def priq_up(q, type, cmp, i)
	priq_up(q, type, cmp, i, void, NULL)

def priq_repos(q, type, cmp, i, move_notify, move_notify_arg)
	priq_down(q, type, cmp, i, move_notify, move_notify_arg)
	else
		priq_up(q, type, cmp, i, move_notify, move_notify_arg)

def priq_down(q, type, cmp, i, move_notify, move_notify_arg)
	priq_down(q, type, cmp, i, move_notify, move_notify_arg, my(to), my(tmp))

def priq_down(q, type, cmp, i, move_notify, move_notify_arg, to, tmp)
	if cmp(priq_element(q, i), priq_element(q, priq_p(i))) < 0
		type tmp = *(type*)priq_element(q, i)
		int to = i
		priq_push_from(q, type, cmp, &tmp, to, move_notify, move_notify_arg)
		move_notify(q, to, i, move_notify_arg)
		i = to

def priq_up(q, type, cmp, i, move_notify, move_notify_arg)
	priq_up(q, type, cmp, i, move_notify, move_notify_arg, my(c1), my(c2), my(e), my(size), my(last_i))

def priq_up(q, type, cmp, i, move_notify, move_notify_arg, c1, c2, e, size, last_i)
	vec_push(q)
	int size = priq_get_size(q)
	vec_copy_element(q, size-1, i, type)
	int last_i = i
	priq_remove(q, type, cmp, i, move_notify, move_notify_arg, last_i)


typedef priq timeouts

typedef timeout *timeout_p

struct timeout
	num time
	thunk handler
	int i

def timeout_init(timeout, time, func)
	timeout_init(timeout, time, func, timeout)

def timeout_init(timeout, time, func, obj)
	timeout_init(timeout, time, func, obj, NULL)

timeout_init(timeout *timeout, num time, thunk_func *func, void *obj, void *common_arg)
	new(th, thunk, func, obj, common_arg)
	timeout_init_thunk(timeout, time, th)

timeout_init_thunk(timeout *timeout, num time, thunk *handler)
	timeout->time = time
	timeout->handler = *handler

def timeouts_init(q)
	timeouts_init(q, 64)

def timeouts_init(q, space)
	init(q, priq, timeout_p, space)

def timeouts_free(q)
	priq_free(q)

def timeouts_cmp_macro(a, b) (*(timeout_p*)a)->time - (*(timeout_p*)b)->time

timeouts_add(timeouts *q, timeout *o)
	priq_push(q, timeout_p, timeouts_cmp_macro, &o, i, timeouts_move_notify, NULL)
	o->i = i

timeouts_rm(timeouts *q, timeout *o)
	if o->i >= 0
		priq_remove(q, timeout_p, timeouts_cmp_macro, o->i, timeouts_move_notify, NULL)
		o->i = -1

def timeouts_move_notify(q, to, from, arg_dummy)
	(*(timeout_p*)vec_element(q, to))->i = to

timeout *timeouts_next(timeouts *q)
	return *(timeout_p*)priq_peek(q)

timeouts_shift(timeouts *q)
	priq_shift(q, timeout_p, timeouts_cmp_macro)

def timeouts_empty(q) priq_empty(q)

def timeout_call(timeout)
	timeout_call_keep(timeout)
	
def timeout_call_keep(timeout) thunk_call(&timeout->handler)
 # no specific_arg for timeouts as of yet

timeouts_call(timeouts *timeouts, num time)
	while !timeouts_empty(timeouts)
		timeout *timeout_next = timeouts_next(timeouts)
		if timeout_next->time > time
			break
		timeouts_call_next(timeouts)

def timeouts_call_next(timeouts)
	timeout *my(next) = timeouts_next(timeouts)
	timeout_call(my(next))
	if !timeouts_empty(timeouts) && timeouts_next(timeouts) == my(next)
		timeouts_shift(timeouts)

num timeouts_delay(timeouts *timeouts, num time)
	if timeouts_empty(timeouts)
		return -1
	 else
		timeout *next = timeouts_next(timeouts)
		num delay = next->time - time
		if delay < 0
			delay = 0
		return delay

timeouts_delay_tv(timeouts *timeouts, num time, timeval **tv)
	num d = timeouts_delay(timeouts, time)
	if d < 0
		*tv = NULL
	 else
		rtime_to_timeval(d, *tv)

timeouts_delay_ts(timeouts *timeouts, num time, timespec **ts)
	num d = timeouts_delay(timeouts, time)
	if d < 0
		*ts = NULL
	 else
		rtime_to_timespec(d, *ts)

int timeouts_delay_ms(timeouts *timeouts, num time)
	num d = timeouts_delay(timeouts, time)
	if d < 0
		return -1
	 else
		return (int)d*1000


typedef struct sockaddr sockaddr
typedef struct sockaddr_in sockaddr_in
typedef struct sockaddr_un sockaddr_un
typedef struct in_addr in_addr

int listen_backlog = SOMAXCONN

int Socket(int domain, int type, int protocol)
	int fd = socket(domain, type, protocol)
	if fd == -1
		get_winsock_errno()
		failed("socket")
	winsock_open_osfhandle(fd)
	return fd

Bind(int sockfd, struct sockaddr *my_addr, socklen_t addrlen)
	if bind(fd_to_socket(sockfd), my_addr, addrlen) != 0
		get_winsock_errno()
		failed("bind")

Listen(int sockfd, int backlog)
	if listen(fd_to_socket(sockfd), backlog) != 0
		get_winsock_errno()
		failed("listen")
def Listen(sockfd) Listen(sockfd, listen_backlog)

int Accept(int earfd, struct sockaddr *addr, socklen_t *addrlen)
	int sockfd = accept(fd_to_socket(earfd), addr, addrlen)
	if sockfd == -1
		get_winsock_errno()
		failed("accept")
	winsock_open_osfhandle(sockfd)
	return sockfd
def Accept(ear)
	Accept(ear, NULL, 0)

Connect(int sockfd, const struct sockaddr *serv_addr, socklen_t addrlen)
	if connect(fd_to_socket(sockfd), serv_addr, addrlen) != 0
		get_winsock_errno()
		failed("connect")

Sockaddr_in(struct sockaddr_in *sa, char *addr, int port)
	sa->sin_family = AF_INET
	sa->sin_port = htons(port)
	if inet_aton(addr, &sa->sin_addr) == 0
		error("Invalid IP address `%s'.\n", addr)
	memset(&sa->sin_zero, 0, 8)

typedef struct hostent hostent
hostent *Gethostbyname(const char *name)
	let(rv, gethostbyname(name))
	if rv == NULL
		get_h_errno()
		failed("gethostbyname")
	return rv

#       The variable h_errno can have the following values:
#
#       HOST_NOT_FOUND
#              The specified host is unknown.
#
#       NO_ADDRESS or NO_DATA
#              The requested name is valid but does not have an IP address.
#
#       NO_RECOVERY
#              A non-recoverable name server error occurred.
#
#       TRY_AGAIN
#              A  temporary  error  occurred on an authoritative name server.  Try again
#              later.

# Warning: name_to_ip returns either its argument (if already an IP address) or
# a pointer to a static buffer from inet_ntoa.  So you might want to use Strdup
# to duplicate the result before it is overwritten later.

cstr name_to_ip(const char *name)
	struct in_addr addr
	if inet_aton(name, &addr)
		return (char*)name
	let(he, Gethostbyname(name))
	if he->h_addrtype != AF_INET
		error("name_to_ip: does not support ip6 yet")
	return inet_ntoa(*(struct in_addr *)(he->h_addr_list[0]))

int Server_tcp(char *addr, int port)
	addr = name_to_ip(addr)
	int ear = Socket(PF_INET, SOCK_STREAM, 0)
	reuseaddr(ear)
	struct sockaddr_in sa
	Sockaddr_in(&sa, addr, port)
	Bind(ear, (sockaddr *)&sa, sizeof(sockaddr_in))
	Listen(ear)
	return ear

Setsockopt(int s, int level, int optname, const void *optval, socklen_t optlen)
	if setsockopt(fd_to_socket(s), level, optname, optval, optlen)
		get_winsock_errno()
		failed("setsockopt")

int Client_tcp(char *addr, int port)
	addr = name_to_ip(addr)
	int sock = Socket(PF_INET, SOCK_STREAM, 0)
	struct sockaddr_in sa
	Sockaddr_in(&sa, addr, port)
	Connect(sock, (sockaddr *)&sa, sizeof(sockaddr))
	return sock

def Server(addr, port) Server_tcp(addr, port)
def Client(addr, port) Client_tcp(addr, port)

# is caching hostname a good idea?
# beware if writing a program to change hostname!
def hostname__max_len 256
char hostname__[hostname__max_len] = ""
cstr Hostname()
	if hostname__[0] == '\0'
		if gethostname(hostname__, hostname__max_len) != 0
			get_winsock_errno()
			failed("gethostname")
		hostname__[hostname__max_len-1] = '\0'
	return hostname__


# FIXME wrap this!
#
# struct hostent *gethostbyaddr(const void *addr, int len, int type);

def Send(s, buf, len) Send(s, buf, len, 0)
ssize_t Send(int s, const void *buf, size_t len, int flags)
	ssize_t rv = send(fd_to_socket(s), buf, len, flags)
	if rv == -1
		get_winsock_errno()
		if errno == EAGAIN
			rv = 0
		 else
			failed("send")
	return rv

def Recv(s, buf, len) Recv(s, buf, len, 0)
ssize_t Recv(int s, void *buf, size_t len, int flags)
	errno = 0
	ssize_t rv = recv(fd_to_socket(s), buf, len, flags)
	if rv == -1
		get_winsock_errno()
		if errno == EAGAIN
			rv = 0
		 else
			failed("recv")
	return rv

def Recv_eof(fd) errno == 0

def SendTo(s, buf, len, to, tolen) Send(s, buf, len, 0, to, tolen)
ssize_t SendTo(int s, const void *buf, size_t len, int flags, const struct sockaddr *to, socklen_t tolen)
	ssize_t rv = sendto(fd_to_socket(s), buf, len, flags, to, tolen)
	if rv == -1
		get_winsock_errno()
		if errno == EAGAIN
			rv = 0
		 else
			failed("sendto")
	return rv

def RecvFrom(s, buf, len, from, fromlen) RecvFrom(s, buf, len, 0, from, fromlen)
ssize_t RecvFrom(int s, void *buf, size_t len, int flags, struct sockaddr *from, socklen_t *fromlen)
	errno = 0
	ssize_t rv = recvfrom(fd_to_socket(s), buf, len, flags, from, fromlen)
	if rv == -1
		get_winsock_errno()
		if errno == EAGAIN
			rv = 0
		 else
			failed("recvfrom")
	return rv

# shutdown's "how" can be SHUT_RD, SHUT_WR or SHUT_RDWR

def Shutdown(s) Shutdown(s, SHUT_WR)
Shutdown(int s, int how)
	int rv = shutdown(fd_to_socket(s), how)
	if rv == -1
		get_winsock_errno()
		failed("shutdown")

Closesocket(int fd)
	if closesocket(fd_to_socket(fd)) != 0
		failed("closesocket")

def keepalive(fd) keepalive(fd, 1)
keepalive(int fd, int keepalive)
	Setsockopt(fd, SOL_SOCKET, SO_KEEPALIVE, &keepalive, sizeof(keepalive))

def nodelay(fd) nodelay(fd, 1)
nodelay(int fd, int nodelay)
	Setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, &nodelay, sizeof(nodelay))

def reuseaddr(fd) reuseaddr(fd, 1)
reuseaddr(int fd, int reuseaddr)
	Setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &reuseaddr, sizeof(reuseaddr))

Getsockopt(int s, int level, int optname, void *optval, socklen_t *optlen)
	if getsockopt(s, level, optname, optval, optlen)
		get_winsock_errno()
		failed("getsockopt")

int Getsockerr(int fd)
	int err
	socklen_t size = sizeof(err)
	Getsockopt(fd, SOL_SOCKET, SO_ERROR, &err, &size)
	return err

# TODO add / use getaddrinfo

export sys/socket.h
export netinet/in.h
export netinet/tcp.h
export arpa/inet.h
export netdb.h
export sys/un.h
use string.h
def INVALID_SOCKET -1
def UNIX_PATH_MAX 108
typedef int SOCKET
typedef struct sockaddr_un sockaddr_un

def closesocket(s) close(s)

#extern int h_errno

int Server_unix_stream(char *addr)
	int ear = Socket(PF_UNIX, SOCK_STREAM, 0)
	struct sockaddr_un sa
	Sockaddr_unix(&sa, addr)
	Bind(ear, (sockaddr *)&sa, sizeof(sockaddr_un))
	Listen(ear, 20)
	return ear

int Client_unix_stream(char *addr)
	int sock = Socket(PF_UNIX, SOCK_STREAM, 0)
	struct sockaddr_un sa
	Sockaddr_unix(&sa, addr)
	Connect(sock, (sockaddr *)&sa, sizeof(sockaddr))
	return sock

def Server(addr) Server_unix_stream(addr)
def Client(addr) Client_unix_stream(addr)

Sockaddr_unix(struct sockaddr_un *sa, char *addr)
	sa->sun_family = AF_UNIX
	if strlen(addr) > UNIX_PATH_MAX-1
		error("pathname to unix socket too long: %s", addr)
	strcpy(addr, sa->sun_path)

def get_winsock_errno()
	.

def get_h_errno()
	errno = h_errno
	# TODO I haven't checked if strerror gives messages for this yet

def winsock_open_osfhandle(fd)
	winsock_open_osfhandle(fd, 0)
def winsock_open_osfhandle(fd, flags)
	void(fd, flags)

def fd_to_socket(fd) fd

def winsock_close(fd)
	.
def winsock_fclose(fd)
	.

def winsock_vfprintf(file, format, ap)
	.
def winsock_fsay(file, s)
	.
def winsock_vfsayf(file, format, ap)
	.
def winsock_putc(file, c)
	if 0
		.
def winsock_fwrite(ptr, size, nmemb, stream)
	.
def winsock_fflush(file)
	.

export sys/sendfile.h

ssize_t Sendfile(int out_fd, int in_fd, off_t *offset, size_t count)
	ssize_t rv = sendfile(out_fd, in_fd, offset, count)
	if rv == -1
		if errno == EAGAIN
			rv = 0
		 else
			failed("sendfile")
	return rv

def cork(fd) cork(fd, 1)
cork(int fd, int cork)
	Setsockopt(fd, IPPROTO_TCP, TCP_CORK, &cork, sizeof(cork))

# vstream contextual io!


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
	new(b, buffer, 128)
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
	read_file_to_vec(v, file, int, l, (int)atoi(l))
	return v

vec *read_nums(cstr file)
	read_file_to_vec(v, file, num, l, (num)atof(l))
	return v

vec *read_cstrs(cstr file)
	read_file_to_vec(v, file, cstr, l, Strdup(l))
	return v

def read_file_to_vec(v, file, type, l, map)
	New(v, vec, type, 200)
	F_in(file)
		eachline(l)
			vec_push(v, map)
	vec_squeeze(v)


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
		nmemb = circbuf_get_size(b) / size
		l = size * nmemb
		if !l
			return 0
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

vcp()
	char buf[block_size]
	repeat
		size_t bytes = vs_read(buf, block_size)
		if bytes == 0
			break
		vs_write(buf, bytes)
export stdio.h sys/stat.h fcntl.h unistd.h dirent.h stdarg.h string.h utime.h



size_t block_size = 1024

# todo split io and fs

int Open(const char *pathname, int flags, mode_t mode)
	int fd = open(pathname, flags, mode)
	if fd == -1
		char msg[8]
		cstr how = ""
		strcpy(msg, "open ")
		which flags & 3
		O_RDONLY	how = "r"
		O_WRONLY	how = "w"
		O_RDWR	how = "rw"
		strcat(msg, how)
		failed(msg, pathname)
	return fd
def Open(pathname, flags) Open(pathname, flags, 0666)

def openin(pathname) Open(pathname, O_RDONLY)
def openout(pathname, mode) Open(pathname, O_WRONLY|O_CREAT, mode)
def openout(pathname) openout(pathname, 0666)
def Open(pathname) openin(pathname)
def open(pathname) open(pathname, O_RDONLY)

# FIXME many uses of openout would want O_TRUNC

Close(int fd)
	winsock_close(fd)
	if close(fd) != 0
		failed("close")

# Read_some (and Read) return 0 at EOF, and also return 0 if a non-blocking fd
# has no bytes to read. In that case, use Read_eof(fd) to check errno whether
# it is 0 (eof) or EAGAIN (no bytes were read).

ssize_t Read_some(int fd, void *buf, size_t count)
	errno = 0
	ssize_t bytes_read = read(fd, buf, count)
	if bytes_read == -1
		if errno == EAGAIN
			bytes_read = 0
		 else
			failed("read")
	return bytes_read

ssize_t Read(int fd, void *buf, size_t count)
	ssize_t bytes_read_tot = 0
	repeat
		ssize_t bytes_read = Read_some(fd, buf, count)
		bytes_read_tot += bytes_read
		count -= bytes_read
		if count == 0 || bytes_read == 0
			break
		buf = (char *)buf + bytes_read
	return bytes_read_tot

def Read_eof(fd) errno == 0

ssize_t Write_some(int fd, const void *buf, size_t count)
	ssize_t bytes_written = write(fd, buf, count)
	if bytes_written == -1
		if errno == EAGAIN
			bytes_written = 0
		 else
			failed("write")
	return bytes_written

Write(int fd, const void *buf, size_t count)
	repeat
		ssize_t bytes_written = Write_some(fd, buf, count)
		count -= bytes_written
		if count == 0
			break
		buf = (char *)buf + bytes_written

slurp_2(int fd, buffer *b)
	int space = buffer_get_space(b)
	int size = buffer_get_size(b)
	char *start = buffer_get_start(b)
	repeat
		let(bytes_read, Read(fd, start + size, space - size))
		if bytes_read == 0
			break
		buffer_grow(b, bytes_read)
		size += bytes_read
		if size == space
			buffer_double(b)
			space = buffer_get_space(b)
			size = buffer_get_size(b)
			start = buffer_get_start(b)

# TODO fix slurp(fd, buffer) so that it does the fstat instead of this one

buffer *slurp_1(int filedes)
	decl(st, Stats)
	Fstat(filedes, st)
	int size = st->st_size

	if size == 0
		size = 1024
	 else
	 	++size
		# to avoid a problem with
		# doubling the buffer on the last read at EOF.
		# Also this is handy if client wants to convert to a cstr :)

	New(b, buffer, size)
	slurp_2(filedes, b)

	return b

def slurp(fd, b) slurp_2(fd, b)
def slurp(fd) slurp_1(fd)
def slurp() slurp(STDIN_FILENO)

def spurt(b) spurt(STDOUT_FILENO, b)

spurt(int fd, buffer *b)
	Write(fd, buffer_get_start(b), buffer_get_size(b))

fslurp_2(FILE *s, buffer *b)
	int space = buffer_get_space(b)
	int size = buffer_get_size(b)
	char *start = buffer_get_start(b)
	repeat
		int to_read = space - size
		ssize_t bytes_read = Fread(start + size, 1, to_read, s)
		buffer_grow(b, bytes_read)
		size += bytes_read
		if bytes_read < to_read
			break
		if size == space
			buffer_double(b)
			space = buffer_get_space(b)
			size = buffer_get_size(b)
			start = buffer_get_start(b)

# TODO fix slurp(fd, buffer) so that it does the fstat instead of this one

buffer *fslurp_1(FILE *s)
	decl(st, Stats)
	Fstat(Fileno(s), st)
	int size = st->st_size

	if size == 0
		size = 1024
	 else
	 	++size
		# to avoid a problem with
		# doubling the buffer on the last read at EOF.
		# Also this is handy if client wants to convert to a cstr :)

	New(b, buffer, size)
	fslurp_2(s, b)

	return b

def fslurp(s, b) fslurp_2(s, b)
def fslurp(s) fslurp_1(s)
def fslurp() fslurp(stdin)

def fspurt(b) fspurt(stdout, b)

fspurt(FILE *s, buffer *b)
	Fwrite(buffer_get_start(b), 1, buffer_get_size(b), s)

FILE *Fopen(const char *path, const char *mode)
	FILE *f = fopen(path, mode)
	if f == NULL
		failed("fopen", mode, path)
	return f
def Fopen(pathname) Fopen(pathname, "rb")
def Fopenout(pathname) Fopen(pathname, "wb")

Fclose(FILE *fp)
	winsock_fclose(fp)
	if fclose(fp) == EOF
		failed("fclose")

char *Fgets(char *s, int size, FILE *stream)
	errno = 0
	char *rv = fgets(s, size, stream)
	if errno
		failed("fgets")
	return rv

# NOTE you should reset the size of the buffer to 0
# before calling Freadline, else it will append the line to the buffer.
int Freadline(buffer *b, FILE *stream)
	ssize_t len = buffer_get_size(b)
	repeat
		char *rv = Fgets(b->start+len, buffer_get_space(b)-len, stream)
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

int Readline(buffer *b)
	return Freadline(b, stdin)

def Readline() Freadline(stdin)
def Freadline(stream) Freadline_1(stream)

cstr Freadline_1(FILE *stream)
	new(b, buffer, 128)
	if Freadline(b, stream)
		buffer_free(b)
		return NULL
	return buffer_to_cstr(b)

int Printf(const char *format, ...)
	collect(Vprintf, format)
int Vprintf(const char *format, va_list ap)
	winsock_vfprintf(stdout, format, ap)
	int len = vprintf(format, ap)
	if len < 0
		failed("vprintf")
	return len

int Fprintf(FILE *stream, const char *format, ...)
	collect(Vfprintf, stream, format)
int Vfprintf(FILE *stream, const char *format, va_list ap)
	winsock_vfprintf(stream, format, ap)
	int len = vfprintf(stream, format, ap)
	if len < 0
		failed("vfprintf")
	return len

Fflush(FILE *stream)
	winsock_fflush(stream)
	if fflush(stream) != 0
		failed("fflush")
def Fflush()
	Fflush(stdout)
def Fflush_all()
	Fflush(NULL)

# don't forget to use the "b" flag, e.g. "r+b"
FILE *Fdopen(int filedes, const char *mode)
	FILE *f = fdopen(filedes, mode)
	if f == NULL
		failed("fdopen")
#	windows_setmode_binary(f)
	return f
def Fdopen(filedes) Fdopen(filedes, "r+b")

def nl(stream)
	Putc('\n', stream)
def nl()
	nl(stdout)
def nls(stream, n)
	repeat(n)
		nl(stream)
def nls(n)
	nls(stdout, n)
Nl(FILE *stream)
	nl(stream)
def Nl() Nl(stdout)

def tab(stream)
	Putc('\t', stream)
def tab()
	tab(stdout)
def tabs(stream, n)
	repeat(n)
		tab(stream)
def tabs(n)
	tabs(stdout, n)

def spc(stream)
	Putc(' ', stream)
def spc()
	spc(stdout)
def spcs(stream, n)
	repeat(n)
		spc(stream)
def spcs(n)
	spcs(stdout, n)

crlf(FILE *stream)
	Fprint(stream, "\r\n")
def crlf()
	crlf(stdout)

# like perl, Say adds a newline, Print doesn't
def Print(s)
	Fprint(stdout, s)
def Fprint(stream, s)
	Fprintf(stream, "%s", s)

def Say(s)
	Puts(s)
Puts(const char *s)
	winsock_fsay(stdout, s)
	if puts(s) < 0
		failed("puts")

Fsay(FILE *stream, const char *s)
	winsock_fsay(stream, s)
	Fputs(s, stream)
	nl(stream)

Fputs(const char *s, FILE *stream)
	winsock_fsay(stream, s)
	if fputs(s, stream) < 0
		failed("fputs")

int Sayf(const char *format, ...)
	collect(Vsayf, format)
int Vsayf(const char *format, va_list ap)
	winsock_vfsayf(stdout, format, ap)
	int len = Vprintf(format, ap)
	nl()
	return len

int Fsayf(FILE *stream, const char *format, ...)
	collect(Vfsayf, stream, format)
int Vfsayf(FILE *stream, const char *format, va_list ap)
	winsock_vfsayf(stdout, format, ap)
	int len = Vfprintf(stream, format, ap)
	nl(stream)
	return len

# TODO: improve brace so can make this var-args stuff nicer

char *Input(const char *prompt)
	return Inputf("%s", prompt)
def Input() Input("")

# XXX Inputf doesn't handle lines with '\0' in them properly
# XXX Inputf calls fgets too many times.  should use a static buffer then
# copy to return?  but it's meant for terminal input, who cares if it's slow?

char *Inputf(const char *format, ...)
	collect(Vinputf, format)
char *Vinputf(const char *format, va_list ap)
	return Vfinputf(stdin, stdout, format, ap)
char *Vfinputf(FILE *in, FILE *out, const char *format, va_list ap)
	if *format
		Vfprintf(out, format, ap)
	Fflush(out)
	
	new(b, buffer, 2)
	int rv = Freadline(b, in)
	if rv == 0
		return buffer_to_cstr(b)
	else
		buffer_free(b)
		return NULL

char *Finput(FILE *in, FILE *out, const char *prompt)
	return Finputf(in, out, "%s", prompt)
def Finput(in, out) Finput(in, out, "")

char *Finputf(FILE *in, FILE *out, const char *format, ...)
	collect(Vfinputf, in, out, format)

char *Sinput(FILE *s, const char *prompt)
	return Sinputf(s, "%s", prompt)
def Sinput(s) Sinput(s, "")

char *Sinputf(FILE *s, const char *format, ...)
	collect(Vfinputf, s, s, format)

# TODO would be good to use sscanf to scan a line?

# TODO: BelchIfChanged

DIR *Opendir(const char *name)
	DIR *d = opendir(name)
	if d == NULL
		failed("opendir")
	return d

typedef struct dirent dirent
dirent *Readdir(DIR *dir)
	errno = 0
	struct dirent *e = readdir(dir)
	if errno
		failed("readdir")
	return e

Closedir(DIR *dir)
	if closedir(dir) != 0
		failed("closedir")

def Ls-a(name) Ls(name, 1)
def Ls(name) Ls(name, 0)
vec *Ls(const char *name, int all)
	vec *v = ls(name, all)
	if !v
		failed("ls", name)
	return v

# TODO use dir->d_type ?

def ls(name) ls(name, 0)
def ls-a(name) ls(name, 1)
vec *ls(const char *name, boolean all)
	New(v, vec, cstr, 64)
	return ls_(name, all, v)

vec *ls_(const char *name, boolean all, vec *v)
	struct dirent *e
	DIR *dir = opendir(name)
	if dir == NULL
		return NULL
	repeat
		errno = 0
		e = readdir(dir)
		if errno
			Free(v)
			v = NULL
			break
		if !e
			break
		if e->d_name[0] == '.' &&
		 (!all || e->d_name[1] == '\0' ||
		  (e->d_name[1] == '.' && e->d_name[2] == '\0'))
				continue
		*(cstr*)vec_push(v) = Strdup(e->d_name)

	closedir(dir)
	return v

def slurp_lines() slurp_lines_0()
vec *slurp_lines_0()
	New(lines, vec, cstr, 256)
	return slurp_lines(lines)

vec *slurp_lines(vec *lines)
	eachline(s)
		vec_push(lines, Strdup(s))
	return lines

def lines() slurp_lines()
def lines(v) slurp_lines(v)

Remove(const char *path)
	if remove(path) != 0
		failed("remove")

int Temp(buffer *b, char *prefix, char *suffix)
	return Tempfile(b, prefix, suffix, NULL, 0, 0600)

int Tempdir(buffer *b, char *prefix, char *suffix)
	return Tempfile(b, prefix, suffix, NULL, 1, 0600)

# TODO while else, for else and do-while else loops

int Tempfile(buffer *b, char *prefix, char *suffix, char *tmpdir, int dir, int mode)
	int n_random_chars = 6
	char random[n_random_chars + 1]
	char *pathname = b->start
	if tmpdir == NULL
		tmpdir = "/tmp"
	ssize_t len = strlen(tmpdir) + 1 + strlen(prefix) + strlen(suffix) + n_random_chars + 1
	if buffer_get_space(b) < len
		buffer_set_space(b, len)
	random[n_random_chars] = '\0'
	int try
	for try=0; try < 10; ++try
		int i
		for i=0; i<n_random_chars; ++i
			random[i] = random_alphanum()
		snprintf(pathname, len, "%s/%s%s%s", tmpdir, prefix, random, suffix)
		buffer_set_size(b, strlen(pathname))
		if dir
			if mkdir(pathname, mode) == 0
				return -1
		else
			int fd = open(pathname, O_RDWR|O_CREAT|O_EXCL, mode)
			if fd >= 0
				return fd
	serror("cannot create tempfile of form %s/%sXXXXXX%s", tmpdir, prefix, suffix)
	# this is not reached, just to keep cc happy
	return -1

char random_alphanum()
	int r = randi(10 + 26 * 2)
	if r < 10
		return '0' + r
	if r < 10 + 26
		return 'A' + r - 10
	return 'a' + r - 10 - 26

# Theoretically don't need to stat a file to find out if it exists -
# (just look for the directory entry).  but no quick way to do that
# - a unix bug?

int exists(const char *file_name)
	struct stat buf
	return !stat(file_name, &buf)

int lexists(const char *file_name)
	struct stat buf
	return !lstat(file_name, &buf)

def stat_exists(st) S_EXISTS(st->st_mode)

off_t file_size(const char *file_name)
	struct stat buf
	Stat(file_name, &buf)
	return buf.st_size

off_t fd_size(int fd)
	struct stat buf
	Fstat(fd, &buf)
	return buf.st_size

# Stat returns 1 if the file exists, 0 if not
# FIXME is this ok?  not consistent with stat(2)

int Stat(const char *file_name, struct stat *buf)
	errno = 0
	int rv = stat(file_name, buf)
	if rv == 0
		return 1
	if errno == ENOENT || errno == ENOTDIR
		return 0
	failed("stat", file_name)
	# keep gcc happy
	return 0

int is_file(const char *file_name)
	struct stat buf
	return Stat(file_name, &buf) && S_ISREG(buf.st_mode)

int is_dir(const char *file_name)
	struct stat buf
	return Stat(file_name, &buf) && S_ISDIR(buf.st_mode)

int is_symlink(const char *file_name)
	struct stat buf
	return Lstat(file_name, &buf) && S_ISLNK(buf.st_mode)

int is_real_dir(const char *file_name)
	struct stat buf
	return Lstat(file_name, &buf) && S_ISDIR(buf.st_mode)

# TODO make io stateful, so use like
#   out(channel) say(...)
#   instead of e.g. Fsay(channel, ...)
#  then get rid of all the ffoo functions
#  Problem: I already used "out" and "in" for redirection of stdout, stdin
#  to a named file.
#  another problem: should save the current stream in a "process local"
#  variable I guess.  although processes should really use a different sort of
#  IO altogether.

Fstat(int filedes, struct stat *buf)
	if fstat(filedes, buf) == -1
		failed("fstat")

cx(const char *path)
	chmod_add(path, S_IXUSR | S_IXGRP | S_IXOTH)

cnotx(const char *path)
	chmod_sub(path, S_IXUSR | S_IXGRP | S_IXOTH)

chmod_add(const char *path, mode_t add_mode)
	new(s, Stats, path)
	Chmod(path, s->st_mode | add_mode)

chmod_sub(const char *path, mode_t sub_mode)
	new(s, Stats, path)
	Chmod(path, s->st_mode & ~sub_mode)

typedef struct stat stats
typedef struct stat lstats
typedef struct stat Stats
typedef struct stat Lstats

Stats_init(stats *s, const char *file_name)
	if !Stat(file_name, s)
		bzero(s)

Lstats_init(stats *s, const char *file_name)
	if !Lstat(file_name, s)
		bzero(s)

stats_init(stats *s, const char *file_name)
	if stat(file_name, s)
		bzero(s)

lstats_init(stats *s, const char *file_name)
	if lstat(file_name, s)
		bzero(s)

def S_EXISTS(m) m

int Lstat(const char *file_name, struct stat *buf)
	errno = 0
	int rv = lstat(file_name, buf)
	if rv == 0
		return 1
	if errno == ENOENT || errno == ENOTDIR
		return 0
	failed("lstat", file_name)
	# keep gcc happy
	return 0

#struct stat Stat(const char *file_name)
#	decl(s, struct stat)
#	Stat(file_name, s)
#	return struct__s
#def Stat(file_name, buf) _Stat(file_name, buf)

FILE *Popen(const char *command, const char *type)
	FILE *rv = popen(command, type)
	if rv == NULL
		failed("popen")
	return rv

int Pclose(FILE *stream)
	int rv = pclose(stream)
	if rv == -1
		failed("pclose")
	return -1

int Fgetc(FILE *stream)
	int c = fgetc(stream)
	if c == EOF && ferror(stream)
		failed("fgetc")
	return c

def Getc(c, stream)
	c = getc(stream)
	if c == EOF && ferror(stream)
		failed("getc")

def Getchar(c)
	c = getchar()
	if c == EOF && ferror(stdin)
		failed("getchar")
def Getchar()
	# this is only useful to wait for an unneeded keypress or something
	int my(c)
	Getchar(my(c))

Fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream)
	winsock_fwrite(ptr, size, nmemb, stream)
	size_t count = fwrite(ptr, size, nmemb, stream)
	if count != nmemb
		failed("fwrite")

size_t Fread(void *ptr, size_t size, size_t nmemb, FILE *stream)
	size_t count = fread(ptr, size, nmemb, stream)
	if count < nmemb && ferror(stream)
		failed("fread")
	return count

size_t Fread_all(void *ptr, size_t size, size_t nmemb, FILE *stream)
	size_t count = fread(ptr, size, nmemb, stream)
	if count < nmemb
		failed("fread")
	return count

Fwrite_str(FILE *stream, str s)
	Fwrite(s.start, str_get_size(s), 1, stream)

Fwrite_buffer(FILE *stream, buffer *b)
	Fwrite(buffer_get_start(b), buffer_get_size(b), 1, stream)

size_t Fread_buffer(FILE *stream, buffer *b)
	return Fread(buffer_get_end(b), buffer_get_free(b), 1, stream)

Fputc(int c, FILE *stream)
	winsock_putc(c, stream)
	eif fputc(c, stream) == EOF
			failed("fputc")

# TODO swap args? or an alias that has them in the right order?
def Putc(c, stream)
	winsock_putc(c, stream)
	eif putc(c, stream) == EOF
		failed("putc")

def Putchar(c)
	winsock_putc(c, stdout)
	eif putchar(c) == EOF
		failed("putchar")

Fseek(FILE *stream, long offset, int whence)
	if fseek(stream, offset, whence)
		failed("fseek")

long Ftell(FILE *stream)
	long ret = ftell(stream)
	if ret == -1
		failed("ftell")
	return ret

# these don't seem to work:
#Fseeko(FILE *stream, off_t offset, int whence)
#	if fseeko(stream, offset, whence)
#		failed("fseeko")
#
#off_t Ftello(FILE *stream)
#	off_t ret = ftello(stream)
#	if ret == -1
#		failed("ftello")
#	return ret

off_t Lseek(int fd, off_t offset, int whence)
	off_t ret = lseek(fd, offset, whence)
	if ret == -1
		failed("lseek")
	return ret

def Lseek(fd, offset) Lseek(fd, offset, SEEK_SET)

Truncate(const char *path, off_t length)
	int ret = truncate(path, length)
	if ret
		failed("truncate")

Ftruncate(int fd, off_t length)
	int ret = ftruncate(fd, length)
	if ret
		failed("ftruncate")

_Readlink(const char *path, buffer *b)
	repeat
		let(len, readlink(path, buffer_get_end(b), buffer_get_free(b)))
		if len == -1
			if errno == ENAMETOOLONG
				buffer_double(b)
			 else
				failed("readlink")
		 else
			buffer_grow(b, len)
			return

def Readlink(path, b) _Readlink(path, b), buffer_to_cstr(b)

# this returns a malloc'd cstr

cstr Readlink(const char *path)
	new(b, buffer, 256)
	return Readlink(path, b)

# readlinks must be called with a malloc'd string
# i.e. use Strdup.
# it will free it if it was a link
# the string it returns will also be malloc'd

# this does NOT necessarily resolve to the canonical name,
# it just reads links recursively

cstr readlinks(cstr path, opt_err if_dead)
#	path = Strdup(path)

	decl(stat_b, Stats)
	repeat
		if !Lstat(path, stat_b)
			return opt_err_do(if_dead, (any){.cs=path}, (any){.cs=NULL}, "file does not exist: %s", path).cs
		if !S_ISLNK(stat_b->st_mode)
			break
		let(path1, Readlink(path))
		Path_relative_to(path1, path)
		Free(path)
		path = path1
	return path

def readlinks(path) readlinks(path, OE_ERROR)

_Getcwd(buffer *b)
	repeat
		if getcwd(buffer_get_end(b), buffer_get_free(b)) == NULL
			if errno == ERANGE
				buffer_double(b)
			 else
				failed("getcwd")
		 else
			buffer_grow(b, strlen(buffer_get_end(b)))
#			if buffer_last_char(b) != '/'
#				buffer_cat_char(b, '/')
			return

Def Getcwd(b) _Getcwd(b)

# this returns a malloc'd cstr

cstr Getcwd()
	new(b, buffer, 256)
	Getcwd(b)
	return buffer_to_cstr(b)

Chdir(const char *path)
	if chdir(path) != 0
		failed("chdir", path)

Mkdir(const char *pathname, mode_t mode)
	int rv = mkdir(pathname, mode)
	if rv
		failed("mkdir", pathname)

def Mkdir(pathname) Mkdir(pathname, 0777)

Mkdir_if(const char *pathname, mode_t mode)
	if !is_dir(pathname)
		Mkdir(pathname, mode)

def Mkdir_if(pathname) Mkdir_if(pathname, 0777)

say_cstr(cstr s)
	Say(s)
	Free(s)

Rename(const char *oldpath, const char *newpath)
	if rename(oldpath, newpath) == -1
		failed("rename")

Chmod(const char *path, mode_t mode)
	if chmod(path, mode) != 0
		failed("chmod")

Symlink(const char *oldpath, const char *newpath)
	if symlink(oldpath, newpath) == -1
		failed("symlink", oldpath, newpath)

Link(const char *oldpath, const char *newpath)
	if link(oldpath, newpath) == -1
		failed("link")

Pipe(int filedes[2])
	if pipe(filedes) != 0
		failed("pipe")

int Dup(int oldfd)
	int fd = dup(oldfd)
	if fd == -1
		failed("dup")
	return fd

int Dup2(int oldfd, int newfd)
	int fd = dup2(oldfd, newfd)
	# FIXME should call close(newfd) explicitly and check for errors? nah!
	if fd == -1
		failed("dup2")
	return fd

FILE *Freopen(const char *path, const char *mode, FILE *stream);
	FILE *f = freopen(path, mode, stream)
	if f == NULL
		failed("freopen")
	return f

print_range(char *start, char *end)
	fprint_range(stdout, start, end)
fprint_range(FILE *stream, char *start, char *end)
	Fwrite(start, 1, end-start, stream)
say_range(char *start, char *end)
	fsay_range(stdout, start, end)
fsay_range(FILE *stream, char *start, char *end)
	fprint_range(stream, start, end)

stats_dump(Stats *s)
	Sayf("dev\t%d", s->st_dev)
	Sayf("ino\t%d", s->st_ino)
	Sayf("mode\t%d", s->st_mode)
	Sayf("nlink\t%d", s->st_nlink)
	Sayf("uid\t%d", s->st_uid)
	Sayf("gid\t%d", s->st_gid)
	Sayf("rdev\t%d", s->st_rdev)
	Sayf("size\t%d", s->st_size)
	
	# not in mingw
	#	Sayf("blksize\t%d", s->st_blksize)
	#	Sayf("blocks\t%d", s->st_blocks)
	
	Sayf("atime\t%d", s->st_atime)
	Sayf("mtime\t%d", s->st_mtime)
	Sayf("ctime\t%d", s->st_ctime)

mode_t mode(const char *file_name)
	new(s, Stats, file_name)
	return s->st_mode

def cp(oldpath, newpath) cp(oldpath, newpath, 0666)
cp(const char *from, const char *to, int mode)
	int in, out
	in = openin(from)
	out = openout(to, mode)
	cp_fd(in, out)
	Close(out)
	Close(in)

off_t cp_fd(int in, int out)
	char buf[4096]
	off_t count = 0
	repeat
		size_t len = Read(in, buf, sizeof(buf))
		if len == 0
			break
		Write(out, buf, len)
		count += len
	return count

fcp(FILE *in, FILE *out)
	char buf[4096]
	repeat
		size_t len = Fread(buf, 1, sizeof(buf), in)
		if len == 0
			break
		Fwrite(buf, 1, len, out)

# this can return -1 on EINTR

int Select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, num timeout)
	struct timeval timeout_tv
	int rv = select(nfds, readfds, writefds, exceptfds, delay_to_timeval(timeout, &timeout_tv))
	if rv < 0 && errno != EINTR
		failed("select")
	return rv

def Select(nfds, readfds, writefds, exceptfds) Select(nfds, readfds, writefds, exceptfds, NULL)

fd_set_init(fd_set *o)
	fd_zero(o)


def fd_clr(fd, set)
	FD_CLR(fd_to_socket(fd), set)
def fd_isset(fd, set) FD_ISSET(fd_to_socket(fd), set)
def fd_set(fd, set)
	FD_SET(fd_to_socket(fd), set)
def fd_zero(set)
	FD_ZERO(set)

fd_set *tmp_fd_set = NULL

def can_read(fd) can_read(fd, 0)
def can_write(fd) can_write(fd, 0)
def has_error(fd) has_error(fd, 0)

int can_read(int fd, num timeout)
	select_wrap(fd, tmp_fd_set, NULL, NULL, timeout)

int can_write(int fd, num timeout)
	select_wrap(fd, NULL, tmp_fd_set, NULL, timeout)

int has_error(int fd, num timeout)
	select_wrap(fd, NULL, NULL, tmp_fd_set, timeout)

def select_wrap(fd, read_fds, write_fds, except_fds, timeout)
	if !tmp_fd_set
		global(tmp_fd_set, fd_set)
	timeval tv
	fd_set(fd, tmp_fd_set)
	int n_ready = select(fd+1, read_fds, write_fds, except_fds, delay_to_timeval(timeout, &tv))
	fd_clr(fd, tmp_fd_set)
	if n_ready == -1
		failed("select")
	return n_ready

def dir1rest(path, d, b)
	let(d, path)
	let(b, path)
	while path__is_sep(*b)
		++b
	while *b != '\0' && !path__is_sep(*b)
		++b
	if *b
		*b = '\0'
		++b
	 else
		b = NULL

Mkdirs(const char *pathname, mode_t mode)
	cstr my(cwd) = Getcwd()
	Mkdirs_cwd(pathname, mode, my(cwd))
	Free(my(cwd))

Mkdirs_cwd(const char *pathname, mode_t mode, cstr basedir)
	cstr dir1 = Strdup(pathname)
	cstr dir = dir1
	repeat
		dir1rest(dir, d, b)
		mkdir(d, mode)
		Chdir(d)
		if !b || !*b
			break
		dir = b
	
	Free(dir1)
	Chdir(basedir)

def Mkdirs(pathname) Mkdirs(pathname, 0777)

Rmdir(const char *pathname)
	if rmdir(pathname)
		failed("rmdir")

Rmdirs(const char *pathname)
	cstr dir = Strdup(pathname)
	repeat
		if rmdir(dir)
			break
		let(d, dir_name(dir))
		if (*d == '.' || *d == '/') && d[1] == '\0'
			break
		dir = d
	
	Free(dir)

boolean newer(const char *file1, const char *file2)
	new(s1, Stats, file1)
	new(s2, Stats, file2)
	return s1->st_mtime - s2->st_mtime > 0

lnsa(cstr from, cstr to, cstr cwd)
	cstr cwd1 = path_cat(cwd, "")
	from = path_tidy(path_relative_to(Strdup(from), cwd1))
	if is_dir(to)
		cstr from1 = Strdup(from)  # this is ugly, write a base_name which does not modify the string
		cstr to1 = path_cat(to, base_name(from1))
		Free(from1)
		remove(to1)
		Symlink(from, to1)
		Free(to1)
	 else
		remove(to)
		Symlink(from, to)
	Free(cwd1)
	Free(from)

buffer _Cp_symlink, *Cp_symlink = NULL

def Cp(from, to)
	new(my(sf), Lstats, from)
	Cp(from, to, sf)
Cp(cstr from, cstr to, Lstats *sf)
	if S_ISLNK(sf->st_mode)
		if !Cp_symlink
			Cp_symlink = &_Cp_symlink
			init(Cp_symlink, buffer, 256)
		buffer_clear(Cp_symlink)
		Symlink(Readlink(from, Cp_symlink), to)
	 eif S_ISREG(sf->st_mode)
		cp(from, to)
	 else
		warn("irregular file %s not copied", from)

def CP(from, to)
	new(my(sf), Lstats, from)
	CP(from, to, my(sf))
CP(cstr from, cstr to, Lstats *sf)
	Cp(from, to, sf)
	cp_attrs_st(sf, to)

cp_attrs(cstr from, cstr to)
	new(sf, Lstats, from)
	cp_attrs_st(sf, to)

cp_mode(Stats *sf, cstr to)
	if chmod(to, sf->st_mode)
		warn("chmod %s %0d failed", to, sf->st_mode)

Utime(const char *filename, const struct utimbuf *times)
	if utime(filename, (struct utimbuf *)times)
		failed("utime", filename)

cp_times(Lstats *sf, cstr to)
	struct utimbuf times
	times.actime = sf->st_atime
	times.modtime = sf->st_mtime
	if utime(to, &times)
		warn("utime %s failed", to)

def cp_atime(sf, to)
	new(my(st), Lstats, to)
	cp_atime(sf, to, st)
cp_atime(Lstats *sf, cstr to, Lstats *st)
	struct utimbuf times
	times.actime = sf->st_atime
	times.modtime = st->st_mtime
	Utime(to, &times)

def cp_mtime(sf, to)
	new(my(st), Lstats, to)
	cp_mtime(sf, to, st)
cp_mtime(Lstats *sf, cstr to, Lstats *st)
	struct utimbuf times
	times.actime = st->st_atime
	times.modtime = sf->st_mtime
	Utime(to, &times)

def Sayd(x) Sayf("%d", (int)x)
def Sayl(x) Sayf("%ld", (long)x)
def Sayn(x) Sayf("%f", x)
def Sayp(x) Sayf("%010p", x)
def Sayx(x) Sayf("%08lx", (long)x)
def Sayb(x) Sayf("%02x", (int)x)

def Sayd(s, x) Sayf("%s%d", s, (int)x)
def Sayl(s, x) Sayf("%s%ld", s, (long)x)
def Sayn(s, x) Sayf("%s%f", s, x)
def Sayp(s, x) Sayf("%s%010p", s, x)
def Sayx(s, x) Sayf("%s%08lx", s, (long)x)
def Sayb(s, x) Sayf("%s%02x", s, (int)x)

def Printd(x) Printf("%d", (int)x)
def Printl(x) Printf("%ld", (long)x)
def Printn(x) Printf("%f", x)
def Printp(x) Printf("%010p", x)
def Printx(x) Printf("%08lx", (long)x)
def Printb(x) Printf("%02x", (int)x)

def Printd(s, x) Printf("%s%d", s, (int)x)
def Printl(s, x) Printf("%s%ld", s, (long)x)
def Printn(s, x) Printf("%s%f", s, x)
def Printp(s, x) Printf("%s%010p", s, x)
def Printx(s, x) Printf("%s%08lx", s, (long)x)
def Printb(s, x) Printf("%s%02x", s, (int)x)

def Setvbuf(stream, mode) Setvbuf(stream, NULL, mode, 0)
Setvbuf(FILE *stream, char *buf, int mode, size_t size)
	if setvbuf(stream, buf, mode, size)
		failed("setvbuf")
def Setlinebuf(stream) Setvbuf(stream, _IOLBF)

ssize_t Readv(int fd, const struct iovec *iov, int iovcnt)
	ssize_t rv = readv(fd, iov, iovcnt)
	if rv < 0
		failed("readv")
	return rv

ssize_t Writev(int fd, const struct iovec *iov, int iovcnt)
	ssize_t rv = writev(fd, iov, iovcnt)
	if rv < 0
		failed("writev")
	return rv

def nonblock(fd) nonblock(fd, 1)

# This returns 0 for same, 1 for different

int file_cmp(cstr fa, cstr fb)
	int cmp
	new(sta, Stats, fa)
	new(stb, Stats, fb)
	if sta->st_size != stb->st_size
		return 1
	new(a, buffer, 4096)
	new(b, buffer, 4096)
	ssize_t na, nb
	int fda = open(fa)
	if fda == -1
		return 1
	int fdb = open(fb)
	if fdb == -1
		Close(fda)
		return 1
	repeat
		na = Read(fda, buf0(a), buffer_get_space(a))
		nb = Read(fdb, buf0(b), buffer_get_space(b))
		if na != nb
			cmp = 1
			break
		if memcmp(buf0(a), buf0(b), na)
			cmp = 1
			break
		if na < buffer_get_space(a)
			cmp = 0
			break
	Close(fda)
	Close(fdb)
	return cmp


create_hole(cstr file, off_t size)
	int fd = Open(file, O_WRONLY|O_CREAT|O_TRUNC)
	Ftruncate(fd, size)
	Close(fd)

insert_hole(cstr file, off_t offset, off_t size)
	int block_size = 4096
	int fd = Open(file, O_RDWR|O_CREAT)
	off_t old_size = fd_size(fd)
	off_t end = offset+size
	if end >= old_size
		Ftruncate(fd, offset)
		Ftruncate(fd, end)
	 else
		# This is designed not to use lots of extra disk space, only one block or so.
		# It reads two files backwards block by block, which might be inefficient.

		char b[block_size]
		new(temp_name, buffer, 128)
		int temp_fd = Temp(temp_name, "hole_", ".tmp")
		off_t n = (old_size - end + block_size - 1) / block_size

		back(i, n, 0)
			off_t from = end + i * block_size
			off_t l = block_size
			if from+l > old_size
				l = old_size - from
			Lseek(fd, from)
			Read(fd, b, block_size)
			int is_hole = 1
			for(check, 0, l)
				if b[check] != 0
					is_hole = 0
					break
			if is_hole
				Lseek(temp_fd, block_size, SEEK_CUR)
			 else
				Write(temp_fd, b, block_size)
			Ftruncate(fd, from)

		Ftruncate(fd, offset)
		Lseek(fd, end)

		# Now the tail of the file has been cut off into the temp file.
		# It is stored in reverse order, the last block of the tail is
		# stored in the first block of the temp file.

		for(i, 0, n)
			off_t from = (n-1-i) * block_size
			off_t to = end + i * block_size
			off_t l = block_size
			if to+l > old_size
				l = old_size - to
			Lseek(temp_fd, from)
			Read(temp_fd, b, block_size)
			int is_hole = 1
			for(check, 0, l)
				if b[check] != 0
					is_hole = 0
					break
			if is_hole
				Lseek(fd, l, SEEK_CUR)
			 else
				Write(fd, b, l)
			Ftruncate(temp_fd, from)

		Ftruncate(fd, imax(old_size, offset+size))

		Close(temp_fd)
		Remove(buffer_to_cstr(temp_name))

	Close(fd)

int Fileno(FILE *stream)
	int rv = fileno(stream)
	if rv < 0
		failed("fileno")
	return rv

# TODO should use try / finally here, and make it re-throw (by default?)
# TODO this will not work on mingw as it is

def stdio_redirect(stream, to_stream)
	stdio_redirect(stream, to_stream, my(real_fd), my(saved_fd), my(x))
def stdio_redirect(stream, to_stream, real_fd, saved_fd, x)
	int real_fd = Fileno(stream)
	int saved_fd
	post(x)
		Fflush(stream)
		Dup2(saved_fd, real_fd)
		Close(saved_fd)
	pre(x)
		Fflush(stream)
		saved_fd = Dup(real_fd)
		Dup2(Fileno(to_stream), real_fd)

fprint_vec_cstr(FILE *s, cstr h, vec *v)
	Fprint(s, h)
	for_vec(i, v, cstr)
		Fprintf(s, " %s", *i)
	nl(s)

def warn_vec_cstr(s, v) fprint_vec_cstr(stderr, s, v)
def print_vec_cstr(s, v) fprint_vec_cstr(stdout, s, v)

cstr read_lines(vec *lines, cstr in_file)
	FILE *in = Fopen(in_file, "r")
	cstr data = buffer_to_cstr(fslurp(in))
	Fclose(in)
	cstr l = data
	for_cstr(i, data)
		if *i == '\n'
			*i = '\0'
			vec_push(lines, l)
			l = i + 1
	return data

write_lines(vec *lines, cstr out_file)
	F_out(out_file)
		dump_lines(lines)

dump_lines(vec *lines)
	for_vec(i, lines, cstr)
		say(*i)

warn_lines(vec *lines, cstr msg)
	if msg
		warn("<< dumping lines: %s <<", msg)
	f_out(stderr)
		dump_lines(lines)
	if msg
		warn(">> done dumping lines: %s >>", msg)

Fspurt(cstr file, cstr content)
	F_out(file)
		print(content)

cstr Fslurp(cstr file)
	FILE *s = fopen(file, "rb")
	if !s
		return Strdup("")
	cstr rv = buffer_to_cstr(fslurp(s))
	Fclose(s)
	return rv

cstr dotfile(cstr f)
	return path_cat(homedir(), f)

cstr print_space = " "

def pr(type)
	.
def pr(type, a0)
	pr_^^type(a0)
	print(print_space)
def pr(type, a0, a1)
	pr(type, a0)
	pr(type, a1)
def pr(type, a0, a1, a2)
	pr(type, a0, a1)
	pr(type, a2)
def pr(type, a0, a1, a2, a3)
	pr(type, a0, a1, a2)
	pr(type, a3)
def pr(type, a0, a1, a2, a3, a4)
	pr(type, a0, a1, a2, a3)
	pr(type, a4)
def pr(type, a0, a1, a2, a3, a4, a5)
	pr(type, a0, a1, a2, a3, a4)
	pr(type, a5)

def Pr(type)
	.
def Pr(type, a0)
	pr_^^type(a0)
	sf()
def Pr(type, a0, a1)
	pr(type, a0)
	Pr(type, a1)
def Pr(type, a0, a1, a2)
	pr(type, a0, a1)
	Pr(type, a2)
def Pr(type, a0, a1, a2, a3)
	pr(type, a0, a1, a2)
	Pr(type, a3)
def Pr(type, a0, a1, a2, a3, a4)
	pr(type, a0, a1, a2, a3)
	Pr(type, a4)
def Pr(type, a0, a1, a2, a3, a4, a5)
	pr(type, a0, a1, a2, a3, a4)
	Pr(type, a5)

def pr_cstr(a0)
	pf("%s", a0)

def pr_int(a0)
	pf("%d", a0)
def pr_short(a0)
	pf("%h", a0)
# pr_char prints as an integer 123 not %
def pr_char(a0)
	pf("%hhd", a0)
def pr_long(a0)
	pf("%ld", a0)
def pr_long_long(a0)
	pf("%lld", a0)

def pr_unsigned_int(a0)
	pf("%ud", a0)
def pr_unsigned_short(a0)
	pf("%uh", a0)
# pr_unsigned_char prints as an integer 123 not %
def pr_unsigned_char(a0)
	pf("%uhhd", a0)
def pr_unsigned_long(a0)
	pf("%uld", a0)
def pr_unsigned_long_long(a0)
	pf("%ulld", a0)

def pr_num(a0)
	pf("%f", a0)
def pr_double(a0)
	pf("%f", a0)
def pr_float(a0)
	pf("%f", a0)
def pr_long_double(a0)
	pf("%Lf", a0)

def sc(type, l)
	.
def sc(type, l, a0)
	l = scan_^^type(&a0, l)
def sc(type, l, a0, a1)
	sc(type, l, a0)
	sc(type, l, a1)
def sc(type, l, a0, a1, a2)
	sc(type, l, a0, a1)
	sc(type, l, a2)
def sc(type, l, a0, a1, a2, a3)
	sc(type, l, a0, a1, a2)
	sc(type, l, a3)
def sc(type, l, a0, a1, a2, a3, a4)
	sc(type, l, a0, a1, a2, a3)
	sc(type, l, a4)
def sc(type, l, a0, a1, a2, a3, a4, a5)
	sc(type, l, a0, a1, a2, a3, a4)
	sc(type, l, a5)

def Sc(type, l)
	.
def Sc(type, l, a0)
	type a0
	sc(type, l, a0)
def Sc(type, l, a0, a1)
	Sc(type, l, a0)
	Sc(type, l, a1)
def Sc(type, l, a0, a1, a2)
	Sc(type, l, a0, a1)
	Sc(type, l, a2)
def Sc(type, l, a0, a1, a2, a3)
	Sc(type, l, a0, a1, a2)
	Sc(type, l, a3)
def Sc(type, l, a0, a1, a2, a3, a4)
	Sc(type, l, a0, a1, a2, a3)
	Sc(type, l, a4)
def Sc(type, l, a0, a1, a2, a3, a4, a5)
	Sc(type, l, a0, a1, a2, a3, a4)
	Sc(type, l, a5)

cstr scan_cstr(cstr *a, cstr l)
	*a = l
	return scan_skip(l)

cstr scan_int(int *a, cstr l)
	scan_x(int, "%d", a, l)

cstr scan_short(short *a, cstr l)
	scan_x(short, "%hd", a, l)

# NOTE scan_char reads an integer like 123, not a character like %
cstr scan_char(char *a, cstr l)
	scan_x(signed_char, "%hhd", (signed char *)a, l)

cstr scan_long(long *a, cstr l)
	scan_x(long, "%ld", a, l)

cstr scan_long_long(long long *a, cstr l)
	scan_x(long long, "%lld", a, l)

cstr scan_num(num *a, cstr l)
	scan_x(num, "%lf", a, l)

cstr scan_double(double *a, cstr l)
	scan_x(double, "%lf", a, l)

cstr scan_float(float *a, cstr l)
	scan_x(float, "%f", a, l)

cstr scan_long_double(long double *a, cstr l)
	scan_x(double, "%Lf", a, l)

cstr scan_skip(cstr l)
	cstr next
	while *l && !(next = is_scan_space(l))
		++l
	if *l
		*l = '\0'
		l = next
	 else
		l = NULL
	return l

def scan_x(type, format, a, l)
	if is_scan_space(l)
		error("scan_x: found space")
	if sscanf(l, format, a) != 1
		error("scan_x: not found")
	return scan_skip(l)

cstr scan_space = NULL
cstr is_scan_space(cstr s)
	if scan_space
		return cstr_begins_with(s, scan_space)
#		return strchr(scan_space, *s) ? s+1 : NULL
	 else
		return isspace(*s) ? s+1 : NULL

do_delay(num t)
	if t != time_forever
		if can_read(STDIN_FILENO, t)
			Readline()
	 else
	 	Readline()

def scan_kv(l, key, value)
	Sc(cstr, l, key)
	cstr value = l

kv_io_init()
	scan_space = ": "
	print_space = ": "


def chars(stream, c, n)
	repeat(n)
		Putc(c, stream)
def strs(stream, s, n)
	repeat(n)
		Fprint(stream, s)
def chars(c, n)
	chars(stdout, c, n)
def strs(s, n)
	chars(stdout, s, n)

int Fgetline(buffer *b, FILE *stream)
	buffer_clear(b)
	let(rv, Freadline(b, stream))
#	buffer_nul_terminate(b)
	return rv

int Getline(buffer *b)
	return Fgetline(b, stdin)

def fopen_close(fp, file)
	fopen_close(fp, file, "rb")
def fopen_close(fp, file, mode)
	FILE *fp = Fopen(file, mode)
	post(my(x))
		Fclose(fp)
	pre(my(x))
		.

def cd_block(dir)
	cstr old_dir = Getcwd()
	post(my(x))
		Chdir(old_dir)
	pre(my(x))
		Chdir(dir)


# I don't know about this file_type thing, might be too complicated and different for no good reason.
# the idea was to be able to return info on the file type, and also if it exists, if it was a link,
# if it is some sort of file (not a dir).

typedef enum { FT_REG=1, FT_DIR=2, FT_CHR=3, FT_BLK=4, FT_FIFO=5, FT_SOCK=6, FT_EXISTS=8, FT_FILE=16, FT_LINK=32, FT_TYPE_MASK=7 } filetype_t

filetype_t file_type(const char *file_name)
	filetype_t type = 0
	mode_t ft = lstat_ft(file_name)
	if ft == S_IFLNK
		type |= FT_LINK
		ft = stat_ft(file_name)
		if !ft
			return type
	type |= FT_EXISTS
	if ft == S_IFDIR
		type |= FT_DIR
	 else
		type |= FT_FILE
		which ft
		S_IFREG	type |= FT_REG
		S_IFIFO	type |= FT_FIFO
		S_IFSOCK	type |= FT_SOCK
		S_IFCHR	type |= FT_CHR
		S_IFBLK	type |= FT_BLK
	return type


mode_t stat_ft(const char *file_name)
	struct stat buf
	return Stat(file_name, &buf) ? buf.st_mode & S_IFMT : 0

mode_t lstat_ft(const char *file_name)
	struct stat buf
	return Lstat(file_name, &buf) ? buf.st_mode & S_IFMT : 0

export sys/select.h poll.h sys/ioctl.h sys/socket.h


# this can return -1 on EINTR

int Pselect(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, num timeout, const sigset_t *sigmask)
	struct timespec timeout_ts
	int rv = pselect(nfds, readfds, writefds, exceptfds, delay_to_timespec(timeout, &timeout_ts), sigmask)
	if rv < 0 && errno != EINTR
		failed("pselect")
	return rv

typedef struct pollfd pollfd

int Poll(struct pollfd *fds, nfds_t nfds, num timeout)
	int rv = poll(fds, nfds, delay_to_ms(timeout))
	if rv == -1 && errno != EINTR
		failed("poll")
	return rv

def Poll(fds, nfds) Poll(fds, nfds, -1)

#int Ppoll(struct pollfd *fds, nfds_t nfds, num timeout, const sigset_t *sigmask)
#	struct timespec timeout_ts
#	int rv = ppoll(fds, nfds, delay_to_timespec(timeout, &timeout_ts), sigmask)
#	if rv == -1 && errno != EINTR
#		failed("ppoll")
#	return rv

int fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len)
	struct flock fl
	fl.l_type = type
	fl.l_whence = whence
	fl.l_start = start
	fl.l_len = len
	int rv = fcntl(fd, cmd, &fl)
	return rv

int Fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len)
	int rv = fcntl_flock(fd, cmd, type, whence, start, len)
	if rv == -1
		failed("fcntl flock")
	return rv

def wrlck(fd) fcntl_flock(fd, F_SETLKW, F_WRLCK, SEEK_SET, 0, 0)
def rdlck(fd) fcntl_flock(fd, F_SETLKW, F_RDLCK, SEEK_SET, 0, 0)
def unlck(fd) fcntl_flock(fd, F_SETLKW, F_UNLCK, SEEK_SET, 0, 0)

def wrlck_nb(fd) fcntl_flock(fd, F_SETLK, F_WRLCK, SEEK_SET, 0, 0)
def rdlck_nb(fd) fcntl_flock(fd, F_SETLK, F_RDLCK, SEEK_SET, 0, 0)
def unlck_nb(fd) fcntl_flock(fd, F_SETLK, F_UNLCK, SEEK_SET, 0, 0)

def Wrlck(fd) Fcntl_flock(fd, F_SETLKW, F_WRLCK, SEEK_SET, 0, 0)
def Rdlck(fd) Fcntl_flock(fd, F_SETLKW, F_RDLCK, SEEK_SET, 0, 0)
def Unlck(fd) Fcntl_flock(fd, F_SETLKW, F_UNLCK, SEEK_SET, 0, 0)

def Wrlck_nb(fd) Fcntl_flock(fd, F_SETLK, F_WRLCK, SEEK_SET, 0, 0)
def Rdlck_nb(fd) Fcntl_flock(fd, F_SETLK, F_RDLCK, SEEK_SET, 0, 0)
def Unlck_nb(fd) Fcntl_flock(fd, F_SETLK, F_UNLCK, SEEK_SET, 0, 0)

def Lock(lockfile)
	Lock(lockfile, my(fd), my(x))

def Lock(lockfile, fd, x)
	int fd = Open(lockfile, O_RDWR|O_CREAT, 0777)
	Wrlck(fd)
	post(x)
		Remove(lockfile)
		Unlck(fd)
		Close(fd)
	pre(x)
		.

def lock(lockfile)
	lock(lockfile, my(fd), my(x))

def lock(lockfile, fd, x)
	int fd = open(lockfile, O_RDWR|O_CREAT, 0777)
	if fd >= 0
		Wrlck(fd)
	post(x)
		if fd >= 0
			remove(lockfile)
			unlck(fd)
			close(fd)
	pre(x)
		.

def fd_full(new_fd, set) new_fd >= FD_SETSIZE

#def windows_setmode_binary(f)
#	void(f)

int Fcntl_getfd(int fd)
	int rv = fcntl(fd, F_GETFD)
	if rv == -1
		error("fcntl_getfd")
	return rv

Fcntl_setfd(int fd, long arg)
	int rv = fcntl(fd, F_SETFD, arg)
	if rv == -1
		error("fcntl_setfd")

int Fcntl_getfl(int fd)
	int rv = fcntl(fd, F_GETFL)
	if rv == -1
		error("fcntl_getfl")
	return rv

Fcntl_setfl(int fd, long arg)
	int rv = fcntl(fd, F_SETFL, arg)
	if rv == -1
		error("fcntl_setfl")

#cloexec(int fd)
#	Fcntl_setfd(fd, Fcntl_getfd(fd) | FD_CLOEXEC)
#cloexec_off(int fd)
#	Fcntl_setfd(fd, Fcntl_getfd(fd) & ~FD_CLOEXEC)

# the following assumes no other flag exists / is set except FD_CLOEXEC
cloexec(int fd)
	Fcntl_setfd(fd, FD_CLOEXEC)
cloexec_off(int fd)
	Fcntl_setfd(fd, 0)

def mkdir(pathname) mkdir(pathname, 0777)

Chown(const char *path, uid_t uid, gid_t gid)
	if chown(path, uid, gid) != 0
		failed("chown")

Lchown(const char *path, uid_t uid, gid_t gid)
	if lchown(path, uid, gid) != 0
		failed("lchown")

cp_attrs_st(Lstats *sf, cstr to)
	if !S_ISLNK(sf->st_mode)
		cp_mode(sf, to)
	if Getuid() == uid_root
		cp_owner(sf, to)
	cp_times(sf, to)

cp_owner(Lstats *sf, cstr to)
	if chown(to, sf->st_uid, sf->st_gid)
		warn("chown %s %0d:%0d failed", to, sf->st_uid, sf->st_gid)

def Socketpair(sv[2]) Socketpair(AF_UNIX, SOCK_STREAM, 0, sv)
Socketpair(int d, int type, int protocol, int sv[2])
	if socketpair(d, type, protocol, sv) != 0
		failed("socketpair")

nonblock(int fd, int nb)
	if ioctl(fd, FIONBIO, &nb) == -1
		failed("ioctl")
export stdlib.h
use stdio.h

def alloc_type normal
#def alloc_type memlog

int memlog_on = 0

def Malloc(size) alloc_type^^_Malloc(size)
def Free(ptr) alloc_type^^_Free(ptr), ptr = NULL
def Realloc(ptr, size) ptr = alloc_type^^_Realloc(ptr, size)
def Calloc(nmemb, size) alloc_type^^_Calloc(nmemb, size)
def Strdup(s) alloc_type^^_Strdup(s)
def Strndup(s, n) alloc_type^^_Strndup(s, n)

void *normal_Malloc(size_t size)
	void *ptr = malloc(size)
	if ptr == NULL
		failed("malloc")
	return ptr

void *normal_Realloc(void *ptr, size_t size)
	if size == 0
		size = 1
	ptr = realloc(ptr, size)
	if (ptr == NULL)
		failed("realloc")
	return ptr

def Calloc(nmemb) Calloc(nmemb, 1)
void *normal_Calloc(size_t nmemb, size_t size)
	void *ptr = calloc(nmemb, size)
	if (ptr == NULL)
		failed("calloc")
	return ptr

def Talloc(type) Nalloc(type, 1)
def Nalloc(type, nmemb) (type *)Malloc(nmemb * sizeof(type))
def Zalloc(type) Zalloc(type, 1)
def Zalloc(type, nmemb) (type *)Calloc(nmemb, sizeof(type))

def Renalloc(ptr, type, nmemb) Realloc(ptr, nmemb * sizeof(type))

def normal_Free(ptr) free(ptr)

cstr normal_Strdup(const char *s)
	cstr rv = strdup(s)
	if rv == NULL
		failed("strdup")
	return rv

char *normal_Strndup(const char *s, size_t n)
	char *rv = strndup(s, n)
	if !rv
		failed("strndup")
	return rv

# reference counting
# after rc_malloc, count == 1.  The object is freed
# when it reaches 0.

void *rc_malloc(size_t size)
	count_t *count = Malloc(sizeof(count_t) + size)
	*count = 1
	void *obj = count + 1
	return obj

count_t rc_use(void *obj)
	count_t *count = ((count_t *)obj) - 1
	return ++ *count

count_t rc_done(void *obj)
	count_t *count = ((count_t *)obj) - 1
	return -- *count

rc_free(void *obj)
	count_t *count = ((count_t *)obj) - 1
	Free(count)

# FIXME this does not clear the memory like calloc does!
void *rc_calloc(size_t nmemb, size_t size)
	return rc_malloc(nmemb * size)

def rc_talloc(type) (type *)rc_malloc(sizeof(type))

def rc_nalloc(nmemb, type) (type *)rc_malloc(nmemb * sizeof(type))

# memlog, for debugging forgot-to-free errors
# TODO memlog might not cope well with fork,
# would need a separate one for each process

local FILE *memlog = NULL

memlog_stderr()
	memlog_on = 1
	memlog = stderr

def memlog_file()
	memlog_file("mem.log")

memlog_file(cstr file)
	memlog_on = 1
	memlog = Fopen(file, "w")
	Setlinebuf(memlog)

def memlog_Malloc(size) memlog_Malloc(size, __FILE__, __LINE__)
def memlog_Free(ptr) memlog_Free(ptr, __FILE__, __LINE__)
def memlog_Realloc(ptr, size) memlog_Realloc(ptr, size, __FILE__, __LINE__)
def memlog_Calloc(ptr, size) memlog_Calloc(ptr, size, __FILE__, __LINE__)
def memlog_Strdup(s) memlog_Strdup(s, __FILE__, __LINE__)
def memlog_Strndup(s, n) memlog_Strndup(s, n, __FILE__, __LINE__)

void *memlog_Malloc(size_t size, char *file, int line)
	void *rv = normal_Malloc(size)
	if memlog_on
		Fprintf(memlog, "A\tmalloc\t%010p\t%d\t%s:%d\n", rv, size, file, line)
	return rv

memlog_Free(void *ptr, char *file, int line)
	normal_Free(ptr)
	if memlog_on
		Fprintf(memlog, "F\tfree\t%010p\t\t%s:%d\n", ptr, file, line)

void *memlog_Realloc(void *ptr, size_t size, char *file, int line)
	void *rv = normal_Realloc(ptr, size)
	if memlog_on
		Fprintf(memlog, "F\trealloc\t%010p\t\t%s:%d\n", ptr, file, line)
		Fprintf(memlog, "A\trealloc\t%010p\t%d\t%s:%d\n", rv, size, file, line)
	return rv

void *memlog_Calloc(size_t nmemb, size_t size, char *file, int line)
	void *rv = normal_Calloc(nmemb, size)
	if memlog_on
		Fprintf(memlog, "A\tcalloc\t%010p\t%d\t%s:%d\n", rv, nmemb*size, file, line)
	return rv

cstr memlog_Strdup(const char *s, char *file, int line)
	cstr rv = normal_Strdup(s)
	if memlog_on
		Fprintf(memlog, "A\tstrdup\t%010p\t%d\t%s:%d\n", rv, strlen(rv), file, line)
	return rv

cstr memlog_Strndup(const char *s, size_t n, char *file, int line)
	cstr rv = normal_Strndup(s, n)
	if memlog_on
		Fprintf(memlog, "A\tstrndup\t%010p\t%d\t%s:%d\n", rv, strlen(rv), file, line)
	return rv


# tofree
# TODO a proper block alloc / free, where I can free a whole block together

vec *tofree_vec = NULL

def tofree_block()
	tofree_block(my(x))
def tofree_block(x)
	vec *tofree_vec_old = tofree_vec
	post(x)
		free_all(tofree_vec)
		tofree_vec = tofree_vec_old
	pre(x)
		NEW(tofree_vec, vec, void*, 16)
		.

void *tofree(void *obj)
	if obj
		vec_push(tofree_vec, obj)
	return obj

free_all(vec *v)
	for_vec(i, v, void*)
		Free(*i)
	vec_set_size(v, 0)

export sys/mman.h

void *Mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
	void *rv = mmap(addr, length, prot, flags, fd, offset)
	if rv == MAP_FAILED
		failed("mmap")
	return rv

int Munmap(void *addr, size_t length)
	int rv = munmap(addr, length)
	if rv < 0
		failed("munmap")
	return rv

export stdarg.h string.h strings.h

def my(a) skip(1, `my__prefix)^^a

def unless(cond)
	if !cond

def until(cond)
	while !cond

# todo print chars too
def hexdump_width 16
hexdump(FILE *stream, char *b0, char *b1)
	let(n, b1 - b0)
	while n > 0
		let(c, imin(n, hexdump_width))
		for(b, b0, b0 + c)
			hexbyte(stream, *b)
		spcs(stream, 3 * (hexdump_width - c) + 4)
		for(_b, b0, b0 + c)
			char_or_dot(stream, *_b)
		b0 += hexdump_width
		n -= hexdump_width
		nl(stream)
	nl(stream)

def hexdump(b0, b1)
	hexdump(stderr, b0, b1)

def hexbyte(stream, b)
	fprintf(stream, "%02x ", (uchar)b)
def hexbyte(b)
	hexbyte(stderr, b)
def char_or_dot(stream, b)
	Putc(printable(b) ? b : '.', stream)
def char_or_dot(b)
	char_or_dot(stderr, b)

boolean printable(uchar c)
	return c >= 32 && c < 128
	#return c >= 32 && c != 127
 # tab is excluded

Def lett(to, from) sametypet(to, from) = from
Def let(to, from) state lett(to, from)
 # the 0; is so we can put a declaration at the start of a "case",
 # perhaps this should be added at each "case" in brace

Def sametypet(to, ref) typeof(ref) to
Def sametype(to, ref) state sametypet(to, ref)

#Def castto(from, type) (*(type *)&(from))
Def castto(from, type) ((type)(from))
Def castto_ref(from, ref) castto(from, typeof(ref))

Def for(v)
	for(v, v^^0, v^^1)

Def for(v, ary)
	for(v, ary^^0, ary^^1)

# FIXME I think it might be better if for and back (especially)
# used inclusive ranges, not excluding "to" - a BIG change!

def for(v, from, to)
	let(my(end), to)
	let(my(v1), from)
	for ; my(v1)<my(end); ++my(v1)
		let(v, my(v1))

def for(v, from, to, step)
	let(my(end), to)
	let(my(st), step)
	let(my(v1), from)
	for ; my(v1)<my(end); my(v1)+=my(st)
		let(v, my(v1))

def for_keep(v, from, to)
	let(v, from)
	let(my(end), to)
	for ; v<my(end); ++v

def for_keep(v, from, to, step)
	let(v, from)
	let(my(end), to)
	let(my(st), step)
	for ; v<my(end); v+=my(st)

def repeat(n)
	for(my(i), 0, n)
		use(my(i))

def back(v, from)
	back(v, from, 0)

# FIXME? make back(i, 0, 7) count 6,5,4,3,2,1,0  instead of back(i, 7, 0)  DANGER be very careful to change all uses!
def back(v, from, to)
	let(my(end), to-1)
	let(my(v1), from-1)
	for ; my(v1)>my(end); --my(v1)
		let(v, my(v1))

def back(v, from, to, step)
	let(my(end), to-1)
	let(my(st), step)
	let(my(v1), from-1)
	for ; my(v1)>my(end); my(v1)-=my(st)
		let(v, my(v1))

def for_step(i, d)
	let(my(end), i^^1+d/2)
	for i = i^^0 ; i < my(end) ; i+=d

def map(out, in, func)
	for(in)
		*out++ = func

#def Map(out_ary, in, func)
#	sametype(my(out), &*out_ary)
#	map(in, out, func)
# TODO use map more widely?

def natatime(v, n, sep)
	int my(i) = 0
	for(v)
		if my(i) == n
			sep
			my(i) = 0
		++my(i)

Def ptrt(var, type)
	type *var

Def ptr(var, type)
	state type *var

Def stack(var, type)
	type struct__^^var
	var = &struct__^^var

Def heap(var, type)
	var = Talloc(type)

#Def decl(var, type)
#	ptr(var, type)
#	stack(var, type)

# This decl can be used as a global too, not in a struct though.

Def declt(var, type)
	type struct__^^var
	type *var = &struct__^^var
#	type *const var = &struct__^^var

Def decl(var, type)
	state type struct__^^var
	state type *var = &struct__^^var
#	type *const var = &struct__^^var

# decl_member was for structs, but I think it is better to do it differently in
# a struct because it would use extra storage.

#Def decl_member(var, type)
#	type struct__^^var, *var

#Def member_init(obj, var, type)
#	obj->var = &obj->struct__^^var
#	init(obj->var, type)

#Def ptr_obj(var, type)
#	var = &struct__^^var

Def Decl(var, type)
	ptr(var, type)
	heap(var, type)

Def new(var, type)
	decl(var, type)
	init(var, type)
Def new(var, type, a1)
	decl(var, type)
	init(var, type, a1)
Def new(var, type, a1, a2)
	decl(var, type)
	init(var, type, a1, a2)
Def new(var, type, a1, a2, a3)
	decl(var, type)
	init(var, type, a1, a2, a3)
Def new(var, type, a1, a2, a3, a4)
	decl(var, type)
	init(var, type, a1, a2, a3, a4)
Def new(var, type, a1, a2, a3, a4, a5)
	decl(var, type)
	init(var, type, a1, a2, a3, a4, a5)

Def New(var, type)
	Decl(var, type)
	init(var, type)
Def New(var, type, a1)
	Decl(var, type)
	init(var, type, a1)
Def New(var, type, a1, a2)
	Decl(var, type)
	init(var, type, a1, a2)
Def New(var, type, a1, a2, a3)
	Decl(var, type)
	init(var, type, a1, a2, a3)
Def New(var, type, a1, a2, a3, a4)
	Decl(var, type)
	init(var, type, a1, a2, a3, a4)
Def New(var, type, a1, a2, a3, a4, a5)
	Decl(var, type)
	init(var, type, a1, a2, a3, a4, a5)

Def NEW(var, type)
	heap(var, type)
	init(var, type)
Def NEW(var, type, a1)
	heap(var, type)
	init(var, type, a1)
Def NEW(var, type, a1, a2)
	heap(var, type)
	init(var, type, a1, a2)
Def NEW(var, type, a1, a2, a3)
	heap(var, type)
	init(var, type, a1, a2, a3)
Def NEW(var, type, a1, a2, a3, a4)
	heap(var, type)
	init(var, type, a1, a2, a3, a4)
Def NEW(var, type, a1, a2, a3, a4, a5)
	heap(var, type)
	init(var, type, a1, a2, a3, a4, a5)

Def init(var, type)
	type^^_init(var)
Def init(var, type, a1)
	type^^_init(var, a1)
Def init(var, type, a1, a2)
	type^^_init(var, a1, a2)
Def init(var, type, a1, a2, a3)
	type^^_init(var, a1, a2, a3)
Def init(var, type, a1, a2, a3, a4)
	type^^_init(var, a1, a2, a3, a4)
Def init(var, type, a1, a2, a3, a4, a5)
	type^^_init(var, a1, a2, a3, a4, a5)

def global(var, type)
	heap(var, type)
	init(var, type)
def global(var, type, a1)
	heap(var, type)
	init(var, type, a1)
def global(var, type, a1, a2)
	heap(var, type)
	init(var, type, a1, a2)
def global(var, type, a1, a2, a3)
	heap(var, type)
	init(var, type, a1, a2, a3)
def global(var, type, a1, a2, a3, a4)
	heap(var, type)
	init(var, type, a1, a2, a3, a4)
def global(var, type, a1, a2, a3, a4, a5)
	heap(var, type)
	init(var, type, a1, a2, a3, a4, a5)

# TODO need ... macro arg!!!

Def declary(var, type, n)
	type struct__^^var[n]
	type *var[n]
	.
		type *declary__p = struct__^^var
		type **declary__pp = var
		type **declary__pp_end = var + n
		while declary__pp != declary__pp_end
			*declary__pp = declary__p
			++declary__pp ; ++declary__p
		# go go gadget, optimizer!!
	array(var)

# this is not working - why?
# TODO break into declary, newary, initary; impl also Newary (for Nalloc'd)
# TODO for ALL arrays, store the start and end (i.e. the range) explicitly;
#   if the end is not used, the compiler could optimise it away.
#   An array ~= a range.
Def initary(var, type, n)
	declary(var, type, n)
	.
		for(initary__i, &var[0], &var[n])
			type^^_init(*initary__i)

Def initary(var, type, n, a1)
	declary(var, type, n)
	.
		for(initary__i, &var[0], &var[n])
			type^^_init(*initary__i, a1)

Def initary(var, type, n, a1, a2)
	declary(var, type, n)
	.
		for(initary__i, &var[0], &var[n])
			type^^_init(*initary__i, a1, a2)

# ...!!!

def array_size(a) sizeof(a)/sizeof(*a)
def array_start(a) &a[0]
def array_end(a) array_end(a, array_size(a))
def array_end(a, n) &a[n]
Def array_range(a) array_start(a), array_end(a)

Def range(v) v->start, v->end
 # this is somewhat generic, it will work for buffer, vec, str, ropev, ...
 # actually it doesn't work for vec unless you cast it! which is a bit weird

Def array(a, n, type)
	type array__^^a[n]
	let(a^^0, (array_start(array__^^a)))
	let(a^^1, (array_end(array__^^a)))
	let(a^^_n, (array_size(array__^^a)))
	let(a, a^^0)
	use(a^^0)
	use(a^^1)
	use(a)
	use(a^^_n)

Def array(a, n)
	let(a^^0, (array_start(a)))
	let(a^^1, (array_end(a, n))
Def array(a)
	let(a^^0, (array_start(a)))
	let(a^^1, (array_end(a)))
# this last is not great, as can't iterate over the array with its own name

Def array(a, n, type, init)
	type array__^^a[n] = init
	let(a^^0, array_start(array__^^a))
	let(a^^1, array_end(array__^^a))
	let(a, a^^0)
# this one doesn't work yet

# Mm to m.b:
Def Max(a, b) a > b ? a : b
Def Min(a, b) a < b ? a : b

def swap(a, b)
	swap(a, b, my(ap), my(bp), my(tmp))
def swap(a, b, ap, bp, tmp)
	let(ap, &a) ; let(bp, &b)
	let(tmp, *bp)
	*bp = *ap ; *ap = tmp

# FIXME why v?

def eacharg(a)
	for(my(i), arg, arg+args)
		let(a, *my(i))
		if a == NULL
			break

def foraryp_null(i, a)
	let(i, &a[0])
	for ; *i ; ++i
		.

def forary_null(e, a)
	foraryp_null(my(i), a)
		let(e, *my(i))
		.

def foraryp(i, a)
	let(my(end), &a[sizeof(a)/sizeof(a[0])])
	let(my(i1), &a[0])
	for ; my(i1)<my(end) ; ++my(i1)
		let(i, my(i1))

def forary(e, a)
	foraryp(my(i), a)
		let(e, *my(i))
		.

def eachline(v)
	new(my(b), buffer)
	repeat
		buffer_clear(my(b))
		if rl(my(b))
			break
		char *v = buffer_get_start(my(b))

# can't do this because of recursion; need a way to map which is non-recursive
#def ln log
#def log log10

def Id(x) x

void *Id_func(void *x)
	return x

def ref(v, obj)
	let(v, &obj)

def then(expr, a, b)
	let(my(temp), expr)
	a(my(temp))
	b(my(temp))

def thenFree(a, expr)
	then(expr, a, Free)

def SayFree(expr)
	then(expr, Say, Free)

def FreeObj(o, type)
	type^^_free(o)

# this is a temp. hack, I could get new to output this instead (if debugging)
def name(obj, name)
	warn("%010p = %s", obj, name)

def void()
	.
def void(a)
	void()
def void(a, b)
	void()
def void(a, b, c)
	void()
def void(a, b, c, d)
	void()

def copy(to, from0, from1, type)
	let(my(_to), (type *)to)
	for(my(i), (type *)from0, (type *)from1)
		*my(_to) = *i
		++my(_to)

# this is used for implementing printf-like functions
# TODO can simplify further, such that printf- and vprintf- like funcs are
# generated from a single template

Def collect(vfunc, arg0)
	va_list ap
	va_start(ap, arg0)
	let(rv, vfunc(arg0, ap))
	va_end(ap)
	return rv
Def collect(vfunc, arg0, arg1)
	va_list ap
	va_start(ap, arg1)
	let(rv, vfunc(arg0, arg1, ap))
	va_end(ap)
	return rv
Def collect(vfunc, arg0, arg1, arg2)
	va_list ap
	va_start(ap, arg2)
	let(rv, vfunc(arg0, arg1, arg2, ap))
	va_end(ap)
	return rv
Def collect(vfunc, arg0, arg1, arg2, arg3)
	va_list ap
	va_start(ap, arg3)
	let(rv, vfunc(arg0, arg1, arg2, arg3, ap))
	va_end(ap)
	return rv

Def collect_void(vfunc, arg0)
	va_list ap
	va_start(ap, arg0)
	vfunc(arg0, ap)
	va_end(ap)
Def collect_void(vfunc, arg0, arg1)
	va_list ap
	va_start(ap, arg1)
	vfunc(arg0, arg1, ap)
	va_end(ap)
Def collect_void(vfunc, arg0, arg1, arg2)
	va_list ap
	va_start(ap, arg2)
	vfunc(arg0, arg1, arg2, ap)
	va_end(ap)
Def collect_void(vfunc, arg0, arg1, arg2, arg3)
	va_list ap
	va_start(ap, arg3)
	vfunc(arg0, arg1, arg3, ap)
	va_end(ap)

def format_add_nl(format1, format)
	size_t my(len) = strlen(format)
	char format1[my(len)+2]
	char *my(e) = format1 + my(len)
	strcpy(format1, format)
	*my(e) = '\n' ; my(e)[1] = '\0'

def readtsv(v, stream)
	new(v, vec, cstr)
	char *my(null) = NULL
	eachline(my(l), md)
		vec_clear(v)
		repeat
			vec_push(v, my(l))
			char *my(c) = strchr(my(l), '\t')
			if my(c) == NULL
				break
			*my(c) = '\0'
			my(l) = my(c)+1
		vec_push(v, my(null))

def bzero(ptr) bzero(ptr, sizeof(*ptr))

def zero(start, end) bzero(start, end-start)  # may be a hazard!
def zero(ptr) bzero(ptr)

def Map(a, b)
	a = a0
	b = b0
	my(ST)
	repeat
		++a
		++b
my(ST)		.
		if a == a1
			break

def Map(a, b, c)
	a = a0
	b = b0
	c = c0
	my(ST)
	repeat
		++a
		++b
		++c
my(ST)		.
		if a == a1
			break

#Def For(v)
#	For(v, v^^0, v^^1)
#
#Def For(v, ary)
#	For(v, ary^^0, ary^^1)
#
#def For(v, from, to)
#	v = from
#	let(my(end), to)
#	for ; v<my(end); ++v

#def use(v) v=v
def use(v)
	(void)v
def use()
	.
def use(v0, v1)
	use(v0) ; use(v1)
def use(v0, v1, v2)
	use(v0, v1) ; use(v2)
def use(v0, v1, v2, v3)
	use(v0, v1, v2) ; use(v3)

## this defines print and say functions for type foo in terms of fprint_foo
#Def prints_and_says(type)
#	print_^^type(type o)
#		fprint_^^type(stdout, o)
#	fsay_^^type(FILE *stream, type o)
#		fprint_^^type(stream, o)
#		nl(stream)
#	say_^^type(type o)
#		fsay_^^type(stdout, o)

# warning, it's a macro, so don't call with an expression as arg
def tween(a, low, high) a >= low && a <= high
def Tween(a, low, high) a >= low && a < high
def TWEEN(a, low, high) a > low && a < high

def among(a) 0
def among(a, b0) a == b0
def among(a, b0, b1) a == b0 || a == b1
def among(a, b0, b1, b2) a == b0 || a == b1 || a == b2
def among(a, b0, b1, b2, b3) a == b0 || a == b1 || a == b2 || a == b3
def among(a, b0, b1, b2, b3, b4) a == b0 || a == b1 || a == b2 || a == b3 || a == b4
def among(a, b0, b1, b2, b3, b4, b5) a == b0 || a == b1 || a == b2 || a == b3 || a == b4 || a == b5
# need better macros!!!

def for_array_ptr(var_name, ary)
	_for_array_ptr(var_name, ary, my(i))
def _for_array_ptr(var_name, ary, i)
	let(i, &ary[0])
	for ; *i != NULL ; ++i
		let(var_name, *i)
# FIXME use a ref so can modify it

# range...  do we want this?
#struct range
#	void *start
#	void *end

# not named memmem because don't want to conflict with one in the library

void *mem_mem(const void* haystack, size_t haystacklen, const void* needle, size_t needlelen)
	int i
	if needlelen > haystacklen
		return 0
	for i=haystacklen-needlelen+1; i; --i, haystack = (char*)haystack+1
		if !memcmp(haystack,needle,needlelen)
			return (void*)haystack
	return 0

def sort_array_num(x)
	qsort(x, array_size(x), sizeof(*x), num_cmp)

#int num_cmp(const void *a, const void *b)
#	num diff = *(num*)a - *(num*)b
#	if num_eq(diff, 0)
#		return 0
#	 eif diff < 0
#		return -1
#	 else
#		return 1

int num_cmp(const void *a, const void *b)
	return ncmp(*(num*)a, *(num*)b)

def sort_array_int(x)
	qsort(x, array_size(x), sizeof(*x), int_cmp)

def ncmp(a, b) a > b ? 1 : a < b ? -1 : 0

int int_cmp(const void *a, const void *b)
	return ncmp(*(int*)a, *(int*)b)
#	int diff = *(int*)a - *(int*)b
#	return diff

int long_cmp(const void *a, const void *b)
	return ncmp(*(long*)a, *(long*)b)

int off_t_cmp(const void *a, const void *b)
	return ncmp(*(off_t*)a, *(off_t*)b)

def sort_array_cstr(x)
	qsort(x, array_size(x), sizeof(*x), cstrp_cmp)

# post / pre usage:
# post(x)
# 	Say("done after")
# pre(x)
# 	Say("done first")

def post(x)
	int x = 0
x	if x == 1
		++x
		.

def pre(x)
	for ; x < 2 ; ++x
		if x == 1
			goto x
		.

# TODO maybe it would be better to append __struct etc. instead of prepending
# struct__, so it would be easier in case of foo->bar__struct  etc.

# instead of having extra pointers in the struct, could use accessor methods /
# macros. But I can't define macros in a macro yet.

size_t arylen(void *_p)
	void **p = _p
	int count = 0
	while (*p++)
		++count
	return count

typedef int (*cmp_t)(const void *, const void *)

vec *sort_vec(vec *v, cmp_t cmp)
	qsort(vec0(v), veclen(v), vec_get_el_size(v), cmp)
	return v

def sort(v) sort(cstr, v)
def sort(type, v) sort_vec(v, type^^_cmp)

int cstr_cmp(const void *_a, const void *_b)
	char * const *a = _a
	char * const *b = _b
	return strcmp(*a, *b)

def cstrp_cmp cstr_cmp

int cstrp_cmp_null(const void *_a, const void *_b)
	char * const *a = _a
	char * const *b = _b
	if !*a || !*b
		if *a
			return -1
		eif *b
			return 1
		return 0
	return strcmp(*a, *b)

comm(vec *merge_v, vec *comm_v, vec *va, vec *vb, cmp_t cmp, free_t *freer)
	size_t maxlen = veclen(va)+veclen(vb)
	vec_set_space(merge_v, maxlen)
	vec_set_space(comm_v, maxlen)
	char *a = vec0(va)
	char *b = vec0(vb)
	char *a_end = vecend(va)
	char *b_end = vecend(vb)
	size_t e = vec_get_el_size(merge_v)
	while a != a_end && b != b_end
		int c = cmp(a, b)
		# can't just use memcmp in general, because there might be
		# unused padding space, or cmp function might not be simple

		void *m
		byte w
		if c == 0
			w = 3 ; m = a
			if freer
				(*freer)(*(void **)b)
			a += e ; b += e
		 eif c < 0
			w = 1 ; m = a
			a += e
		 eif c > 0
			w = 2 ; m = b
			b += e
		void *p = vec_push(merge_v)
		memmove(p, m, e)
		vec_push(comm_v, w)
	size_t n = 0
	byte comm_val
	if a != a_end
		n = (a_end - a) / e
		vec_append(merge_v, a, n)
		comm_val = 1
	 eif b != b_end
		n = (b_end - b) / e
		vec_append(merge_v, b, n)
		comm_val = 2
	if n
		vec_grow(comm_v, n)
		byte *e = vecend(comm_v)
		for(i, e-n, e)
			*i = comm_val
	vec_squeeze(merge_v)
	vec_squeeze(comm_v)

comm_dump_cstr(vec *merge_v, vec *comm_v)
	assert(vec_get_size(comm_v) == vec_get_size(merge_v), "badcall: comm_dump_cstr %d %d", vec_get_size(comm_v), vec_get_size(merge_v))
	vec_null_terminate(merge_v)
	cstr *m = vec_get_start(merge_v)
	byte *c = vec_get_start(comm_v)
	while *m
		Sayf("%d\t%s", *c, *m)
		++m ; ++c

# is this "never" macro a good idea or just namespace pollution?
# IDEA instead of calling macros macros, just call them defs.

def never
	if 0

def ary_null(a)
	void *a[1]
	a[0] = NULL

def ary_null(a, a0)
	sametype(a, a0)[2]
	a[0] = a0
	a[1] = NULL

def ary_null(a, a0, a1)
	sametype(a, a0)[3]
	a[0] = a0 ; a[1] = a1
	a[2] = NULL

def ary_null(a, a0, a1, a2)
	sametype(a, a0)[4]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2
	a[3] = NULL

def ary_null(a, a0, a1, a2, a3)
	sametype(a, a0)[5]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3
	a[4] = NULL

def ary_null(a, a0, a1, a2, a3, a4)
	sametype(a, a0)[6]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4
	a[5] = NULL

def ary_null(a, a0, a1, a2, a3, a4, a5)
	sametype(a, a0)[7]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5
	a[6] = NULL

def ary_null(a, a0, a1, a2, a3, a4, a5, a6)
	sametype(a, a0)[8]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6
	a[7] = NULL

def ary_null(a, a0, a1, a2, a3, a4, a5, a6, a7)
	sametype(a, a0)[9]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7
	a[8] = NULL

def ary_null(a, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	sametype(a, a0)[10]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8
	a[9] = NULL

def ary_null(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	sametype(a, a0)[11]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8 ; a[9] = a9
	a[10] = NULL

def aryp_null(a)
	void *a[1]
	a[0] = NULL

def aryp_null(a, a0)
	sametype(*a, a0)[2]
	a[0] = &a0
	a[1] = NULL

def aryp_null(a, a0, a1)
	sametype(*a, a0)[3]
	a[0] = &a0 ; a[1] = &a1
	a[2] = NULL

def aryp_null(a, a0, a1, a2)
	sametype(*a, a0)[4]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2
	a[3] = NULL

def aryp_null(a, a0, a1, a2, a3)
	sametype(*a, a0)[5]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3
	a[4] = NULL

def aryp_null(a, a0, a1, a2, a3, a4)
	sametype(*a, a0)[6]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4
	a[5] = NULL

def aryp_null(a, a0, a1, a2, a3, a4, a5)
	sametype(*a, a0)[7]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5
	a[6] = NULL

def aryp_null(a, a0, a1, a2, a3, a4, a5, a6)
	sametype(*a, a0)[8]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6
	a[7] = NULL

def aryp_null(a, a0, a1, a2, a3, a4, a5, a6, a7)
	sametype(*a, a0)[9]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7
	a[8] = NULL

def aryp_null(a, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	sametype(*a, a0)[10]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8
	a[9] = NULL

def aryp_null(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	sametype(*a, a0)[11]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8 ; a[9] = &a9
	a[10] = NULL

def ary(a)
	void *a[0]

def ary(a, a0)
	sametype(a, a0)[1]
	a[0] = a0

def ary(a, a0, a1)
	sametype(a, a0)[2]
	a[0] = a0 ; a[1] = a1

def ary(a, a0, a1, a2)
	sametype(a, a0)[3]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2

def ary(a, a0, a1, a2, a3)
	sametype(a, a0)[4]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3

def ary(a, a0, a1, a2, a3, a4)
	sametype(a, a0)[5]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4

def ary(a, a0, a1, a2, a3, a4, a5)
	sametype(a, a0)[6]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5

def ary(a, a0, a1, a2, a3, a4, a5, a6)
	sametype(a, a0)[7]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7)
	sametype(a, a0)[8]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	sametype(a, a0)[9]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	sametype(a, a0)[10]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8 ; a[9] = a9

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	sametype(a, a0)[11]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8 ; a[9] = a9 ; a[10] = a10

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	sametype(a, a0)[12]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8 ; a[9] = a9 ; a[10] = a10 ; a[11] = a11

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
	sametype(a, a0)[13]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8 ; a[9] = a9 ; a[10] = a10 ; a[11] = a11 ; a[12] = a12

def aryp(a)
	void *a[0]

def aryp(a, a0)
	sametype(*a, a0)[1]
	a[0] = &a0

def aryp(a, a0, a1)
	sametype(*a, a0)[2]
	a[0] = &a0 ; a[1] = &a1

def aryp(a, a0, a1, a2)
	sametype(*a, a0)[3]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2

def aryp(a, a0, a1, a2, a3)
	sametype(*a, a0)[4]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3

def aryp(a, a0, a1, a2, a3, a4)
	sametype(*a, a0)[5]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4

def aryp(a, a0, a1, a2, a3, a4, a5)
	sametype(*a, a0)[6]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5

def aryp(a, a0, a1, a2, a3, a4, a5, a6)
	sametype(*a, a0)[7]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6

def aryp(a, a0, a1, a2, a3, a4, a5, a6, a7)
	sametype(*a, a0)[8]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7

def aryp(a, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	sametype(*a, a0)[9]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8

def aryp(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	sametype(*a, a0)[10]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8 ; a[9] = &a9

def aryp(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	sametype(*a, a0)[11]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8 ; a[9] = &a9 ; a[10] = &a10

def aryp(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	sametype(*a, a0)[12]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8 ; a[9] = &a9 ; a[10] = &a10 ; a[11] = &a11



def eachp(i)
	never
		.

def eachp(i, a0)
	.
		let(i, &a0)
		.

def eachp(i, a0, a1)
	aryp(my(ary), a0, a1)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2)
	aryp(my(ary), a0, a1, a2)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3)
	aryp(my(ary), a0, a1, a2, a3)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4)
	aryp(my(ary), a0, a1, a2, a3, a4)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5)
	aryp(my(ary), a0, a1, a2, a3, a4, a5)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6, a7)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6, a7)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	forary(i, my(ary))
		.

def each(e)
	never
		.

def each(e, a0)
	.
		let(e, a0)
		.

def each(e, a0, a1)
	ary(my(ary), a0, a1)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2)
	ary(my(ary), a0, a1, a2)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3)
	ary(my(ary), a0, a1, a2, a3)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4)
	ary(my(ary), a0, a1, a2, a3, a4)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5)
	ary(my(ary), a0, a1, a2, a3, a4, a5)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
	forary(e, my(ary))
		.

def local(var, val)
	let(my(old), var)
	var = val
	post(x)
		var = my(old)
	pre(x)
		.

def implies(cond, then) cond ? then : 1

# abba is an "occult macro" that needs a double-indent, so the user needs to
# double indent the block! that looks ok with switch stuff though. It does
# things either in one order or the reverse order. Reminds me of Duff's device.
# I was going to use this in splice, but didn't.
# How unlikely that I will ever use this..
#
# e.g.:
#
# abba(toss())
# 	0	Say("hello")
# 	1	Say("world")

def abba(choice)
	each(my(i), choice, !choice)  # assuming booleans are 0 or 1 here.
		which(my(i))
			.

def memdup(src, n) memdup(src, n, 0)
void *memdup(const void *src, size_t n, size_t extra)
	void *dest = Malloc(n+extra)
	memcpy(dest, src, n)
	return dest

# this is an inplace grep
def grep(i, v, type, test)
	grep(i, v, type, test, void)
def grep(i, v, type, test, Free_or_void)
	grep(i, v, type, test, Free_or_void, my(o))
def grep(i, v, type, test, Free_or_void, o)
	type *o = vec0(v)
	for_vec(i, v, type)
		if test
			*o++ = *i
		 else
			Free_or_void(*i)
	vec_set_size(v, o-(type *)vec0(v))
	# does not call vec_squeeze, my dodgy uniq depends on that!

# e.g.:
#   uniq(i, v, cstr, !strcmp(i[0], i[1]), Free)
#   uniq(i, v, int, i[0] == i[1], void)
def uniq(i, v, type, eq)
	uniq(i, v, type, eq, void)
def uniq(i, v, type, eq, Free_or_void)
	if vec_get_size(v)
		vec_grow(v, -1)
		type *last = (type*)vecend(v)
		grep(i, v, type, !eq, Free_or_void)
		vec_push(v, *last)

# TODO grep and map that work with blocks instead of expressions:
# def grep(i, v, type, keep)
# problematic because of can't-multi-indent expansion issue

# TODO make map work with vec too?  normal map shouldn't be inplace though,
# because the types may be different.

cstr_set_add(vec *set, cstr s)
	for_vec(i, set, cstr)
		if cstr_eq(*i, s)
			return
	vec_push(set, s)

# this could be sped up if necessary
unsigned int bit_reverse(unsigned int x)
	int n = 0
	while x
		n <<= 1
		n |= (x & 1)
		x >>= 1
	return n

# get and put endian words, e.g. from binary files
# TODO 64 bit?

# this stuff assumes 8 bit bytes etc

def byte(p) (unsigned char)p[0]
def us(x) (unsigned long)x
def si(x) (long)x

def le2(p) byte(p) | (byte(p+1)<<8)
def le3(p) byte(p) | (byte(p+1)<<8) | (byte(p+2)<<16)
def le4(p) byte(p) | (byte(p+1)<<8) | (byte(p+2)<<16) | (byte(p+3)<<24)

def be2(p) (byte(p)<<8) | byte(p+1)
def be3(p) (byte(p)<<16) | (byte(p+1)<<8) | byte(p+2)
def be4(p) (byte(p)<<24) | (byte(p+1)<<16) | (byte(p+2)<<8) | byte(p+3)

def le2(p, i)
	p[0] = us(i) ; p[1] = (us(i)>>8)
def le3(p, i)
	p[0] = us(i) ; p[1] = (us(i)>>8) ; p[2] = (us(i)>>16)
def le4(p, i)
	p[0] = us(i) ; p[1] = (us(i)>>8) ; p[2] = (us(i)>>16) ; p[3] = (us(i)>>24)

def be2(p, i)
	p[0] = (us(i)>>8) ; p[1] = us(i)
def be3(p, i)
	p[0] = (us(i)>>16) ; p[1] = (us(i)>>8) ; p[2] = us(i)
def be4(p, i)
	p[0] = (us(i)>>24) ; p[1] = (us(i)>>16) ; p[2] = (us(i)>>8) ; p[3] = us(i)

def sbyte(p) ((long)byte(p)) << 24 >> 24

def sle2(p) ((long)le2(p)) << 16 >> 16
def sle3(p) ((long)le3(p)) << 8 >> 8
def sle4(p) ((long)le4(p))

def sbe2(p) ((long)be2(p)) << 16 >> 16
def sbe3(p) ((long)be3(p)) << 8 >> 8
def sbe4(p) ((long)be4(p))


def boolean(s) !among(*s, '\0', '0', 'n', 'N')

# version_ge TODO a-z

boolean version_ge(cstr v0, cstr v1)
	cstr digits = "0123456789"
	repeat
		int i = atoi(v0), j = atoi(v1)
		if i > j
			return 1
		if i < j
			return 0
		v0 += strspn(v0, digits) ; v0 += strcspn(v0, digits)
		v1 += strspn(v1, digits) ; v1 += strcspn(v1, digits)
		if *v0 == '\0'
			return 1
		if *v1 == '\0'
			return 0

cstr hashbang(cstr file)
	cstr exe
	F_in(file)
		exe = rl()
		if exe
			cstr_chomp(exe)
			if cstr_begins_with(exe, "#!") == 0
				cstr_chop_start(exe, exe+2)
			 else
				Free(exe)
	return exe

def dflt(p) dflt(p, "")
void *dflt(void *p, void *dflt)
	return p ? p : dflt

def call_each(macro)
	.
def call_each(macro, a0)
	macro(a0)
def call_each(macro, a0, a1)
	macro(a0)
	macro(a1)
def call_each(macro, a0, a1, a2)
	macro(a0)
	call_each(macro, a1, a2)
def call_each(macro, a0, a1, a2, a3)
	macro(a0)
	call_each(macro, a1, a2, a3)
def call_each(macro, a0, a1, a2, a3, a4)
	macro(a0)
	call_each(macro, a1, a2, a3, a4)
def call_each(macro, a0, a1, a2, a3, a4, a5)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18)

def i2p(i) (void*)(intptr_t)i
def p2i(p) (intptr_t)p

remove_null(vec *v)
	grep(i, v, void*, *i)
	vec_squeeze(v)

# uniqo and already keep a count
# the count will not ever go back to 0
# counting should not slow it down much compared to the hash lookups

def uniqo_default_hashsize 1001

def uniqo(v, hash, eq)
	uniqo(v, hash, eq, void)
def uniqo(v, hash, eq, Free_or_void)
	uniqo(v, hash, eq, Free_or_void, uniqo_default_hashsize)
def uniqo(v, hash, eq, Free_or_void, hashsize)
	uniqo(v, hash, eq, Free_or_void, hashsize, my(already_ht))
def uniqo(v, hash, eq, Free_or_void, hashsize, already_ht)
	uniqo_keep(v, hash, eq, Free_or_void, hashsize, already_ht)
	hashtable_free(already_ht)
def uniqo_keep(v, hash, eq, Free_or_void, hashsize, already_ht)
	new(already_ht, hashtable, hash, eq, hashsize)
	uniqo_cont(v, hash, eq, Free_or_void, already_ht)
def uniqo_cont(v, hash, eq, Free_or_void, already_ht)
	grep(i, v, void*, !already(already_ht, *i), Free_or_void)


void *orp(void *a, void *b)
	return a ? a : b

int ori(int a, int b)
	return a ? a : b

def nul_to_space(a, b) nul_to(a, b, ' ')

def nul_to_nl(a, b) nul_to(a, b, '\n')

cstr nul_to(char *a, char *b, char replacement)
	for(i, a, b)
		if !*i
			*i = replacement
	return a

uniq_vos(vec *v)
	uniqo(v, cstr_hash, cstr_eq)

uniq_vovos(vec *v)
	uniqo(v, vos_hash, vos_eq)


def cache(ht, key, init) cachekv(ht, key, init)->v
def cachekv(ht, key, init) (cache__ref = hashtable_lookup_ref(ht, key))->next ? (void)0 : hashtable_ref_add(cache__ref, key, i2p(init)), hashtable_ref_lookup(cache__ref)
list *cache__ref
  # cache is non reentrant at present, it uses this instead of a local variable

Def tok_paste(x, y) x^^y

#def isword(c) char_name2(c)

boolean isword(char c)
	return isalnum(c) || c == '_'

# these boolean ops evaluate the args more than once, so are of limited use

def or() 0
def or(a) a
def or(a, b) a ? a : b
def or(a, b, c) a ? a : b ? b : c

def and() 1
def and(a) a
def and(a, b) a ? b : 0
def and(a, b, c) a ? b ? c : 0 : 0

# these boolean ops create a variable and use it as a temporary,
# and evaluate each arg only once

def Or(v)
	let(v, 0)
def Or(v, a)
	let(v, a)
def Or(v, a, b)
	let(v, a)
	if !v
		v = b
def Or(v, a, b, c)
	let(v, a)
	if !v
		v = b
		if !v
			v = c

def And(v)
	let(v, 1)
def And(v, a)
	let(v, a)
def And(v, a, b)
	let(v, a)
	if v
		v = b
def And(v, a, b, c)
	let(v, a)
	if v
		v = b
		if v
			v = c

def cstr_to_cstr(x) Id(x)
def cstr_to_int(x) atoi(x)
def cstr_to_long(x) atol(x)
def cstr_to_num(x) cstr_to_double(x)
def cstr_to_double(x) atof(x)
def cstr_to_float(x) (float)atof(x)

# 2d flood fill algorithm!

def flood_4(seeds, x0, y0, x1, y1, blank, test, fill)
	while(deqlen(seeds))
		pointi2 p
		pointi2 new
		deq_shift(seeds, p)
		if blank(p)
			fill(p)
			new = p
			boolean t
			if p.x[0] > x0
				new.x[0] = p.x[0] - 1
				flood_test_push(p, new, blank, test, t, seeds)
			if p.x[0] < x1-1
				new.x[0] = p.x[0] + 1
				flood_test_push(p, new, blank, test, t, seeds)
			new.x[0] = p.x[0]
			if p.x[1] > y0
				new.x[1] = p.x[1] - 1
				flood_test_push(p, new, blank, test, t, seeds)
			if p.x[1] < y1-1
				new.x[1] = p.x[1] + 1
				flood_test_push(p, new, blank, test, t, seeds)

def flood_test_push(p, new, blank, test, t, seeds)
	if blank(new)
		test(t, p, new)
		if t
			deq_push(seeds, new)

def decl_cast(v, type, o)
	type *v = (type *)o

struct key_value
	void *k
	void *v

struct cstr2cstr
	cstr k
	cstr v

struct long2cstr
	long k
	cstr v

struct cstr2long
	cstr k
	long v

struct cstr2long
	cstr k
	long v

struct node_kv
	list l
	key_value kv

def lookup_cstr(ix, key) lookup_cstr(ix, key, NULL)
cstr lookup_cstr(cstr2cstr *ix, cstr key, cstr default_val)
	let(i, ix)
	for i=ix; i->k != NULL; ++i
		if cstr_eq(i->k, key)
			return i->v
	return default_val

cstr Lookup_cstr(cstr2cstr *ix, cstr key)
	cstr val = lookup_cstr(ix, key, badptr)
	if val == badptr
		failed("lookup_cstr", key)
	return val

def badptr (void*)-1

def delimit(p, s, c)
	p = strchr(s, c)
	if p
		*p++ = '\0'

def tmpnul(p)
	char my(tmp)
	post(x)
		*p = my(tmp)
	pre(x)
		my(tmp) = *p ; *p = '\0'

def bounce(x, vx, wall, cmp, vfac)
	if x cmp wall
		x = 2*wall - x
		vx = -vx*vfac
 # TODO angular bounce!

def NULL(p)
	*p = NULL
def NULL(p, n)
	for(my(i), p, p+n)
		NULL(my(i))

def io_init io_selector^^_init
def io_fd_top io_selector^^_fd_top
def io_count io_selector^^_count
def io_wait io_selector^^_wait
def io_events io_selector^^_events
def io_add io_selector^^_add
def io_rm io_selector^^_rm
def io_read io_selector^^_read
def io_write io_selector^^_write
def io_clr_read io_selector^^_clr_read
def io_clr_write io_selector^^_clr_write
#def io_exists io_selector^^_exists


def io_selector io_select

struct io_select
	fd_set readfds, writefds, exceptfds
	fd_set readfds_ready, writefds_ready, exceptfds_ready
	int max_fd_plus_1
	int count

io_select_init(io_select *io)
	init(&io->readfds, fd_set)
	init(&io->writefds, fd_set)
	init(&io->exceptfds, fd_set)
	io->max_fd_plus_1 = 0
	io->count = 0

def io_select_fd_top(io) io->max_fd_plus_1
def io_select_count(io) io->count

int io_select_wait(io_select *io, num delay, sigset_t *sigmask)
	io->readfds_ready = io->readfds
	io->writefds_ready = io->writefds
	io->exceptfds_ready = io->exceptfds
	int n_ready = Pselect(io->max_fd_plus_1, &io->readfds_ready, &io->writefds_ready, &io->exceptfds_ready, delay, sigmask)
	return n_ready

def io_select_events(io, fd, can_read, can_write, has_error)
	state int fd
	for fd=0; fd < io_select_fd_top(io); ++fd
		if !io_select_exists(io, fd)
			continue
		state boolean can_read = io_select_can_read(io, fd)
		state boolean can_write = io_select_can_write(io, fd)
		state boolean has_error = io_select_has_error(io, fd)
		unless(can_read || can_write || has_error)
			continue
		.

# TODO for select, could try fds in order of expected matches, i.e.
# ones with most recent IO first, and quit when n_ready == 0

def io_select_exists(io, fd) fd_isset(fd, &io->exceptfds)

def io_select_add(io, fd) io_select_add(io, fd, 0)

int io_select_add(io_select *io, int fd, boolean et)
	use(et)  # ignored
	if io_select_full(io, fd)
		return -1
	fd_set(fd, &io->exceptfds)
	if fd >= io->max_fd_plus_1
		io->max_fd_plus_1 = fd + 1
		return 1
	return 0

io_select_rm(io_select *io, int fd)
	if fd_isset(fd, &io->readfds)
		io_select_clr_read(io, fd)
	if fd_isset(fd, &io->writefds)
		io_select_clr_write(io, fd)
	fd_clr(fd, &io->exceptfds)

def io_select_read(io, fd)
	fd_set(fd, &io->readfds)
	++io->count

def io_select_write(io, fd)
	fd_set(fd, &io->writefds)
	++io->count

def io_select_clr_read(io, fd)
	fd_clr(fd, &io->readfds)
	--io->count

def io_select_clr_write(io, fd)
	fd_clr(fd, &io->writefds)
	--io->count

# internal methods

def io_select_can_read(io, fd) fd_isset(fd, &io->readfds_ready)
def io_select_can_write(io, fd) fd_isset(fd, &io->writefds_ready)
def io_select_has_error(io, fd) fd_isset(fd, &io->exceptfds_ready)

def io_select_full(io, fd) fd_full(fd, &io->exceptfds)
#  scheduler


#def io_selector io_epoll
#def io_selector io_select

num sched_delay = 0
    # = 0      # don't sleep between steps
    # = 0.01   # sleep for 0.01 secs at each IO check / wait

int sched_busy = 16
    # = 0       # check IO / wait only when no procs queued
    # = 1       # check IO / wait at every step
    # = n       # check IO / wait when no queue or every n steps

int sched__children_n_buckets = 1009

struct scheduler
	int exit
	deq q
	io_selector io
	vec readers
	vec writers
	num now
	timeouts tos
	hashtable children
	int step
	int n_children
	int got_sigchld

scheduler struct__sched, *sched = &struct__sched

def sched_init()
	scheduler_init(sched)

scheduler_init(scheduler *sched)
	sched->exit = 0
	init(&sched->q, deq, proc_p, 8)
	init(&sched->io, io_selector)
	init(&sched->readers, vec, proc_p, 8)
	init(&sched->writers, vec, proc_p, 8)
	sched->now = -1
	init(&sched->tos, timeouts)
	init(&sched->children, hashtable, int_hash, int_eq, sched__children_n_buckets)
	sched->step = 0
	sched->n_children = 0
	sched->got_sigchld = 0
	set_child_handler(sigchld_handler)

def sched_free()
	scheduler_free(sched)

scheduler_free(scheduler *sched)
	deq_free(&sched->q)
	vec_free(&sched->readers)
	vec_free(&sched->writers)
	timeouts_free(&sched->tos)

start_f(proc *p)
#	Fprintf(stderr, "start_f: "); proc_dump(p); nl(stderr)
	*(proc **)deq_push(&sched->q) = p

def start(coro)
	start_f(&coro->p)

run()
	sched->exit = 0
	while !sched->exit
		step()
#		queue_dump(&sched->q)

step()
	int need_select
	num delay
	int n_ready = 0
	io_selector *io = &sched->io
	timeouts *tos = &sched->tos

	if !timeouts_empty(tos)
		delay = timeouts_delay(tos, sched_get_time())
	 eif sched->q.size
		delay = io_count(io) ? sched_delay : 0
	 else
		delay = time_forever

	if delay == time_forever && io_count(io) == 0 && sched->n_children == 0
		sched->exit = 1
		return

	need_select = delay ||
	 (sched_busy && io_count(io) && sched->step % sched_busy == 0)

	sigset_t oldsigmask, *oldsigmaskp = NULL

	int got_sigchld = 0

	if need_select
		if sched->n_children
			oldsigmaskp = &oldsigmask
			if sched_sig_child_exited(oldsigmaskp)
				delay = 0
		proc_debug("polling %d waiters for %f secs", io_count(io), delay)
#		proc_debug_selectors()

		n_ready = io_wait(io, delay, oldsigmaskp)
		sched_forget_time()

		proc_debug("polling done")

		if sched->n_children
			if sched_sig_child_exited_2(oldsigmaskp)
				got_sigchld = 1

	if got_sigchld
		pid_t pid
		while sched->n_children && (pid = Child_done())
			proc *p = get(&sched->children, pid)
			if p
				clr_waitchild(pid)
				waitchild__pid = pid
				waitchild__status = wait__status
				proc_debug("child %d finished - resuming %010p", pid, p)
				sched_resume(p)
			 else
				warn("no waiter for child %d", pid)

	# TODO test timeouts, modify to work with procs directly?
	if !timeouts_empty(tos)
		timeouts_call(tos, sched_get_time())

	if n_ready > 0
		io_events(io, fd, can_read, can_write, has_error)
			if has_error
				# XXX how to handle errors properly?
				# I think it might be better if I just ignore errors,
				# and let them fall through to read / write / whatever
				errno = Getsockerr(fd)
				if !among(errno, ECONNRESET, EPIPE)
					swarning("sched: fd %d has an error", fd)
#				fd_has_error(fd)
#				continue
			if can_read
				proc *p = *(proc **)vec_element(&sched->readers, fd)
				clr_reader(fd)
				proc_debug("fd %d ready to read - resuming %010p", fd, p)
				if p
					sched_resume(p)
			if can_write
				proc *p = *(proc **)vec_element(&sched->writers, fd)
				clr_writer(fd)
				proc_debug("fd %d ready to write - resuming %010p", fd, p)
				if p
					sched_resume(p)

	if sched->q.size
		proc *p = *(proc **)deq_element(&sched->q, 0)
		deq_shift(&sched->q)
		proc_debug("resuming %010p", p)
		sched_resume(p)

	++sched->step

#def proc_debug_selectors()
#	for(fd, 0, io_fd_top(io))
#		if fd_isset(fd, &sched->readfds)
#			proc_debug("wantread %d", fd)
#		if fd_isset(fd, &sched->writefds)
#			proc_debug("wantwrite %d", fd)
#		if fd_isset(fd, &sched->exceptfds)
#			proc_debug("wantexcept %d", fd)

#def fd_alive(fd) io_exists(&sched->io, fd)   # FIXME

def sched_resume(p)
	if resume(p)
		proc_debug("  resume %010p returned %d, enqueuing again", p, p->pc)
		start_f(p)
	 else
		proc_debug("  resume %010p returned 0, stopped", p)

def sched_dump(&sched->q)
	Fprintf(stderr, "queue dump: ")
	for(i, 0, deq_get_size(&sched->q))
		let(p, *(proc **)deq_element(&sched->q, i))
		proc_dump(p)
	nl(stderr)

def add_fd(fd) add_fd(fd, 1)
def add_fd(fd, et) scheduler_add_fd(sched, fd, et)

int scheduler_add_fd(scheduler *sched, int fd, int et)
	int rv = io_add(&sched->io, fd, et)
	if rv == 1
		vec_ensure_size(&sched->readers, fd+1)
		vec_ensure_size(&sched->writers, fd+1)
		rv = 0
	if rv == 0
		scheduler_clr(sched, fd)
	return rv

def rm_fd(fd)
	scheduler_rm_fd(sched, fd)

def scheduler_rm_fd(sched, fd)
	io_rm(&sched->io, fd)
	scheduler_clr(sched, fd)

def scheduler_clr(sched, fd)
	*(proc **)vec_element(&sched->readers, fd) = NULL
	*(proc **)vec_element(&sched->writers, fd) = NULL

fd_has_error(int fd)
	rm_fd(fd)
	close(fd)

def read(fd)
		set_reader(fd, b__p)
		wait

def write(fd)
		set_writer(fd, b__p)
		wait

set_reader(int fd, proc *p)
	proc_debug("set_reader %d", fd)
#	assert(!fd_isset(fd, &sched->readfds), "set_reader: reader already set")
	*(proc**)vec_element(&sched->readers, fd) = p
	io_read(&sched->io, fd)

set_writer(int fd, proc *p)
	proc_debug("set_writer %d", fd)
#	assert(!fd_isset(fd, &sched->writefds), "set_writer: writer already set")
	*(proc**)vec_element(&sched->writers, fd) = p
	io_write(&sched->io, fd)

clr_reader(int fd)
#	assert(fd_isset(fd, &sched->readfds), "clr_reader: reader not set")
	*(proc**)vec_element(&sched->readers, fd) = NULL
	io_clr_read(&sched->io, fd)

clr_writer(int fd)
#	assert(fd_isset(fd, &sched->writefds), "clr_writer: writer not set")
	*(proc**)vec_element(&sched->writers, fd) = NULL
	io_clr_write(&sched->io, fd)

pid_t waitchild__pid
int waitchild__status

def waitchild(pid, status)
		set_waitchild(pid, b__p)
		wait
		status = waitchild__status

# waitchild(0) or waitchild(-1) do not work yet

set_waitchild(pid_t pid, proc *p)
	proc_debug("set_waitchild %d", pid, p)
	assert(get(&sched->children, pid) == NULL, "set_waitchild: waiter already set")
	put(&sched->children, pid, p)
	++sched->n_children

clr_waitchild(pid_t pid)
	proc_debug("clr_waitchild %d", pid)
	del(&sched->children, pid)
	--sched->n_children

sigchld_handler(int signum)
	use(signum)
	sched->got_sigchld = 1

num sched_get_time()
	if sched->now < 0
		sched_set_time()
	return sched->now

# You should call sched_forget_time after anything that is likely to be slow.
# sched calls it after pselect returns

sched_forget_time()
	sched->now = -1

sched_set_time()
	sched->now = rtime()

def sched_exit()
	sched->exit = 1

boolean sched_sig_child_exited(sigset_t *oldsigmask)
	*oldsigmask = Sig_defer(SIGCHLD)
	return sched->got_sigchld

boolean sched_sig_child_exited_2(sigset_t *oldsigmask)
	boolean got_sigchld = 0
	if sched->got_sigchld
		got_sigchld = 1
		sched->got_sigchld = 0
	Sig_setmask(oldsigmask)
	return got_sigchld
use stdlib.h
 # for NULL
 # for start()
 # for boolean
 # for assert

# type-specific shuttle structs

def shuttle(type)
	struct sh(type)
		shuttle sh
		type d

# this sh(type) is a bit dodgy because doesn't work for complex C types,
# need to use typedef, e.g. char * -> cstr

struct shuttle
	proc *current
	proc *other
	enum { ACTIVE, WAITING, GONE } other_state
shuttle_init(shuttle *sh, proc *p1, proc *p2)
	sh->current = p1
	sh->other = p2
	sh->other_state = ACTIVE

# here are the general shuttle methods:
# pull - receives the shuttle from partner, returns 0 if partner is gone,
# does nothing if we already have shuttle
# push - sends the shuttle to partner, returns 0 if partner is gone,
# does nothing if we don't have shuttle

# XXX these are not "optimal" yet
# TODO push_pull_f ?

boolean pull_f(shuttle *s, proc *p)
	proc_debug("%010p %010p %010p: pull_f", p, s, s->current)
	boolean must_wait = s->current != p
	if must_wait
		s->other_state = WAITING
		proc_debug("  waiting")
	return must_wait

push_f(shuttle *s, proc *p)
	proc_debug("%010p %010p: push_f", p, s)
	if s->current == p
		proc_debug("  pushing")
		proc *other = s->other
#		Fprintf(stderr, "    other: "); proc_dump(other); nl(stderr)
		s->current = other
		s->other = p
		int other_state = s->other_state
		s->other_state = ACTIVE
		if other_state == WAITING
			proc_debug("  starting other (%010p)", other)
			start_f(other)

def pull(s)
	if pull_f(&This->s->sh, b__p)
		wait

def push(s)
	push_f(&This->s->sh, b__p)

def here(s) This->s->sh.current == b__p

Def sh(type) shuttle_^^type

# fancy macros to connect two procs' ports with a shuttle

def sh_init(s, from_proc, to_proc)
	sh_init(s, from_proc, out, to_proc, in)

def sh_init(s, from_proc, from_port, to_proc, to_port)
	shuttle_init(&s->sh, &from_proc->p, &to_proc->p)
	from_proc->from_port = s
	to_proc->to_port = s
	proc_debug("sh_init: %010p = %010p -> %010p", s, from_proc, to_proc)

def sh(type, from_proc, to_proc)
	sh(my(sh), type, from_proc, to_proc)
def sh(type, from_proc, from_port, to_proc, to_port)
	sh(my(sh), type, from_proc, from_port, to_proc, to_port)
def sh(var_name, type, from_proc, to_proc)
	shuttle(var_name, type, from_proc, to_proc)
def sh(var_name, type, from_proc, from_port, to_proc, to_port)
	shuttle(var_name, type, from_proc, from_port, to_proc, to_port)
def shuttle(var_name, type, from_proc, to_proc)
	shuttle(var_name, type, from_proc, out, to_proc, in)
def shuttle(var_name, type, from_proc, from_port, to_proc, to_port)
	decl(var_name, sh(type))
	sh_init(var_name, from_proc, from_port, to_proc, to_port)

# these are the "passive" (non-controlling) rd/wr

def wr(s, v)
	proc_debug("%010p %010p: wr", b__p, s)
	pull(s)
	s = v
	push(s)

def rd(s, v)
	proc_debug("%010p %010p: rd", b__p, s)
	pull(s)
	v = s
	push(s)

# next does a push,pull on a shuttle - this is different way to use the channel, where the function needs to be in control of the object at all times while it is active.

# coros that use "next" should call "pull" initially to make sure they have the
# shuttle if they need to write to it initially

def next(s)
	proc_debug("%010p %010p: next", b__p, s)
	push(s)
	pull(s)

# this is "cut", which closes a shuttle

#int cut_f(shuttle *s, proc *p)
#	int must_wait = s->controlling == p
#	if must_wait
#		r(s)->waiting = NULL
#	return must_wait
#
#cut_f(shuttle *s, proc *p)
#	assert(s->controlling == p, "cut_f must only called after pull")
#		if s->waiting
#			s->controlling = s->waiting
#			start_f(s->waiting)
#			s->waiting = NULL
#
#def cut(s)
#	pull(s)
#	s->d = 1
#	push(s)
#
#	int must_wait
#	# being in control of a shuttle where no one is waiting is 
#	push_f(s, NULL)
#
#def cl(s)
#	pull(s)
#	cut(s)
#
#def CL(s)
#	cut(s)
export stdint.h

struct sock
	int fd
	sockaddr *sa
	socklen_t len

typedef sock *sock_p

sock_init(sock *s, socklen_t socklen)
	s->fd = -1
	s->sa = Malloc(socklen)
	s->len = socklen
	bzero(s->sa, socklen)

sock_free(sock *s)
	if s->fd != -1
		close(s->fd)
	s->fd = -1
	Free(s->sa)

in_addr sock_in_addr(sock *s)
	return ((sockaddr_in*)s->sa)->sin_addr

uint16_t sock_in_port(sock *s)
	return ntohs(((sockaddr_in*)s->sa)->sin_port)

struct shuttle_buffer
	shuttle sh
	buffer d

struct shuttle_sock_p
	shuttle sh
	sock_p d

listener_tcp_init(listener *p, cstr listen_addr, int listen_port)
	int listen_fd = Server(listen_addr, listen_port)
	init(p, listener, listen_fd, sizeof(sockaddr_in))

#def listener listener_sel
def listener listener_try

proc listener_sel(int listen_fd, socklen_t socklen)
	port sock_p out
	state sock_p s
	if add_fd(listen_fd, 0)
		Close(listen_fd)
		error("listener: can't create listener, too many sockets")
	cloexec(listen_fd)
	nonblock(listen_fd)
	repeat
		NEW(s, sock, socklen)
		read(listen_fd)
		s->fd = accept(listen_fd, (struct sockaddr *)s->sa, &s->len)
		if s->fd < 0
			sock_free(s)
			if errno == EAGAIN  # can happen if forked
				.
			 eif errno == EMFILE || errno == ENFILE
				warn("listener: maximum number of file descriptors exceeded, rejecting %d", s->fd)
			 else
				failed("accept")
		 eif add_fd(s->fd)
			warn("listener: maximum number of sockets exceeded, rejecting %d", s->fd)
			sock_free(s)
		 else
			cloexec(s->fd)
			nonblock(s->fd)
			keepalive(s->fd)
			wr(out, s)

proc listener_try(int listen_fd, socklen_t socklen)
	port sock_p out
	state sock_p s
	if add_fd(listen_fd, 1)
		Close(listen_fd)
		error("listener: can't create listener, too many sockets")
	cloexec(listen_fd)
	nonblock(listen_fd)
	repeat
		NEW(s, sock, socklen)
		s->fd = accept(listen_fd, (struct sockaddr *)s->sa, &s->len)
		if s->fd < 0
			sock_free(s)
			if errno == EAGAIN  # can happen if forked
				.
			 eif errno == EMFILE || errno == ENFILE
				warn("listener: maximum number of file descriptors exceeded, rejecting %d", s->fd)
			 else
				failed("accept")
			read(listen_fd)
		 eif add_fd(s->fd)
			warn("listener: maximum number of sockets exceeded, rejecting %d", s->fd)
			sock_free(s)
		 else
			cloexec(s->fd)
			nonblock(s->fd)
			keepalive(s->fd)
			wr(out, s)

typedef listener listener_tcp
typedef listener listener_unix

# this was for debugging

proc write_sock()
	port sock_p in
	state sock_p s
	repeat
		rd(in, s)
		Sayf("%d", s->fd)
		rm_fd(s->fd)
		sock_free(s)

# TODO use circbuf instead to avoid having to shift?

# NOTE at EOF, reader will return an ungrown buffer, might not be an empty buffer
# they need to check for that.

def reader reader_try
def writer writer_try
#def reader reader_sel
#def writer writer_sel

def reader_sel_init(r, fd)
	reader_sel_init(r, fd, block_size)

def reader_sel_init(r, fd, block_size, sel_first)
	reader_sel_init(r, fd, block_size)

# Here are the reader and writer that call select first,
# to check if it's ready to read or write.

proc reader_sel(int fd, size_t block_size)
	port buffer out
	state boolean done = 0
	while !done
		proc_debug("reader %010p - before pull", b__p)
		pull(out)
		proc_debug("reader %010p - after pull", b__p)
		buffer_ensure_free(&out, block_size)
		proc_debug("reader %010p - calling read(%d)", b__p, fd)
		read(fd)
		ssize_t n = read(fd, bufend(&out), buffer_get_free(&out))
		if n == -1
			n = 0
			if errno != ECONNRESET
				swarning("reader %010p: error", b__p)
		 eif n
			buffer_grow(&out, n)
		if n == 0
			# XXXXXX not sure if this is a good idea to clear the buffer on EOF!
			proc_debug("reader %010p fd %d at EOF", b__p, fd)
			buffer_clear(&out)
			done = 1
		push(out)

def writer_sel_init(w, fd, sel_first)
	writer_sel_init(w, fd)

proc writer_sel(int fd)
	port buffer in
	state boolean done = 0
	while !done
		proc_debug("writer %010p - before pull", b__p)
		pull(in)
		proc_debug("writer %010p - after pull", b__p)
		if !buflen(&in)
			shutdown(fd, SHUT_WR)
			done = 1
		while buflen(&in)
			proc_debug("writer %010p - calling write(%d)", b__p, fd)
			write(fd)
			ssize_t n = write(fd, buf0(&in), buflen(&in))
			if n == -1
				n = 0
				swarning("writer %010p: error", b__p)
				# signals the caller that we have an error,
				# by the fact that the buffer is not empty.
				done = 1
				break
			 else
				buffer_shift(&in, n)
		push(in)

def bread(in)
	bread(in, 1)
def bread(in, size)
	if here(in) && !buflen(&in)
		buffer_ensure_space(&in, size)
		push(in)
	repeat
		pull(in)
		if (size_t)buflen(&in) >= (size_t)size || !buflen(&in)
			break
		buffer_ensure_space(&in, size-buflen(&in))
		push(in)
	# can return an empty buffer at EOF

# bflush: remember to call it some time after bwrite, bprint etc.
# This sock buffered io does not ever at the moment auto flush.
# this assumes writer will (try to) write all the data
def bflush(out)
	proc_debug("bflush - start - pulling")
	pull(out)
	if !buflen(&out)
		proc_debug("bflush - buffer is empty")
	 else
		proc_debug("bflush - pushing")
		push(out)
		pull(out)
		proc_debug("bflush - done")

def bwrite(out, start, end)
	pull(out)
	buffer_cat_range(&out, start, end)

def bwrite_direct(out, _start, _end)
	state buffer bwrite_direct__saved_buffer = out
	pull(out)
	out.start = _start
	out.end = _end
	out.space_end = _end
	bflush(out)
	out = bwrite_direct__saved_buffer

int max_line_length = 0

def breadln(in)
	breadln(in, 0)
def breadln(in, start)
	char *my(c)
	breadln(in, start, my(c))
def breadln(in, start, c)
	breaduntil(in, start, '\n', c)
def breaduntil(in, start, eol, c)
	# this is getting ugly, need to do it better.
	if here(in) && buflen(&in) <= start
		push(in)
	repeat
		pull(in)
		if buflen(&in) <= start
			break
		c = memchr(b(&in, start), eol, buflen(&in)-start)
		if c
			*c = '\0'
		if max_line_length &&
		 ((c && c-b(&in, start) >= max_line_length) ||
		  (!c && buflen(&in)-start >= max_line_length))
			warn("received line longer than max_line_length %d - closing", max_line_length)
			bufclr(&in)
			break
		if c
			break
		push(in)
#		warn("breadln: buflen %d\n[%s]\n", buflen(&in), buffer_nul_terminate(&in))
#		buffer_dump(stderr, &in)
#	warn("breadln: %s", !buflen(&in) ? NULL : buf0(&in))
	proc_debug("breadln: %s", !buflen(&in) ? NULL : buf0(&in))
	# can return an empty buffer at EOF

def bprint(out, s)
	pull(out)
	buffer_cat_cstr(&out, s)

def bsay(out, s)
	pull(out)
	buffer_cat_cstr(&out, s)
	buffer_cat_char(&out, '\n')

def bnl(out)
	pull(out)
	buffer_cat_char(&out, '\n')

def bcrlf(out)
	pull(out)
	buffer_cat_cstr(&out, "\r\n")


def bprintf(out, fmt)
	pull(out)
	Sprintf(&out, fmt)
def bprintf(out, fmt, a0)
	pull(out)
	Sprintf(&out, fmt, a0)
def bprintf(out, fmt, a0, a1)
	pull(out)
	Sprintf(&out, fmt, a0, a1)
def bprintf(out, fmt, a0, a1, a2)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2)
def bprintf(out, fmt, a0, a1, a2, a3)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3)
def bprintf(out, fmt, a0, a1, a2, a3, a4)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3, a4)
def bprintf(out, fmt, a0, a1, a2, a3, a4, a5)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3, a4, a5)


def bsayf(out, fmt)
	pull(out)
	Sprintf(&out, fmt)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0)
	pull(out)
	Sprintf(&out, fmt, a0)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0, a1)
	pull(out)
	Sprintf(&out, fmt, a0, a1)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0, a1, a2)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0, a1, a2, a3)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0, a1, a2, a3, a4)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3, a4)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0, a1, a2, a3, a4, a5)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3, a4, a5)
	buffer_cat_char(&out, '\n')

# I remember Paul / Dancer recommending to try writing before selecting.
# (they didn't say anything about anticipating reading).
# I'm not sure it if speeds things up or not.

# Here are the reader and writer that try to read or write first,
# and calling select only if the read / write fails.

def reader_try_init(r, fd)
	reader_try_init(r, fd, block_size)

def reader_try_init(r, fd, block_size)
#	reader_try_init(r, fd, block_size, 1)
	reader_try_init(r, fd, block_size, 0)

proc reader_try(int fd, size_t block_size, boolean sel_first)
	port buffer out
	state boolean done = 0
	if sel_first
		read(fd)
	while !done
		proc_debug("reader %010p - before pull", b__p)
		pull(out)
		proc_debug("reader %010p - after pull", b__p)
		buffer_ensure_free(&out, block_size)
		ssize_t want = buffer_get_free(&out)
		ssize_t n = read(fd, bufend(&out), want)
		if n < 0 && errno != EAGAIN
			n = 0
			if errno != ECONNRESET
				swarning("reader %010p: error", b__p)
		if n >= 0
			if n == 0
				# XXX not sure if a good idea to clear buffer on EOF!
				proc_debug("reader %010p fd %d at EOF", b__p, fd)
				buffer_clear(&out)
				done = 1
			 else
				buffer_grow(&out, n)
			push(out)
		if n < want
			proc_debug("reader %010p - calling read(%d)", b__p, fd)
			read(fd)

def writer_try_init(w, fd)
	writer_try_init(w, fd, 0)

proc writer_try(int fd, boolean sel_first)
	port buffer in
	state boolean done = 0
	if sel_first
		write(fd)
	while !done
		proc_debug("writer %010p - before pull", b__p)
		pull(in)
		proc_debug("writer %010p - after pull", b__p)
		if !buflen(&in)
			shutdown(fd, SHUT_WR)
			done = 1
		while buflen(&in)
			ssize_t want = buflen(&in)
			ssize_t n = write(fd, buf0(&in), want)
			if n < 0 && errno != EAGAIN
#				if errno != EPIPE
				swarning("writer %010p: error", b__p)
				# signal the caller that we have an error,
				# by the fact that the buffer is not empty.
				done = 1
				break
			if n >= 0
				buffer_shift(&in, n)
			if n < want
				proc_debug("writer %010p - calling write(%d)", b__p, fd)
				write(fd)
		push(in)

# FIXME this connect_nb_tcp is a bit long for a macro!
# maybe it should be a proc?

def connect_nb_tcp(sk, addr, port)
	state sock_p sk
	NEW(sk, sock, sizeof(sockaddr_in))
	sk->fd = Socket(PF_INET, SOCK_STREAM, 0)
	if add_fd(sk->fd)
		Close(sk->fd)
		error("can't connect, too many sockets")
	cloexec(sk->fd)
	nonblock(sk->fd)

	Sockaddr_in((sockaddr_in *)sk->sa, name_to_ip(addr), port)
	if connect(sk->fd, sk->sa, sk->len)
		if errno == EINPROGRESS
			write(sk->fd)
			errno = Getsockerr(sk->fd)
		if errno
			failed("connect")

def bshut(out)
	bufclr(&out)
	pull(out)
	push(out)

def bclose(out)
	bshut(out)
	repeat
		bread(in, block_size)
		if !buflen(&in)
			break
	# Now, we have shut writing, and they have shut writing.
	# The socket has not been closed as such yet, sock_free does that.


listener_unix_init(listener *p, cstr addr)
	int listen_fd = Server(addr)
	init(p, listener, listen_fd, sizeof(sockaddr_un))

export setjmp.h
use stdlib.h

# ccoro - coroutines in standard C
# Sam Watkins, 2009
# this code is public domain
#
# ccoro use setjmp and longjmp to achieve plain ANSI C coroutines /
# non-preemptive threading.  It works by allocating all threads stack space on
# the normal stack.  It makes sure that each thread has enough space to run
# using a padding variable, of size 8k by default, which is inserted by a
# function that starts the thread.  Simple, huh?  It uses some fairly simple
# trickery to create new threads that don't overlap with the other threads.
#
# TODO use a free-list instead of always allocating new coros at the top
# TODO why doesn't it work with -O2 on ADM64? (gcc 4.3.2)
#
# This works with at least gcc-4.3, tcc, tendra and lcc on Linux x86 and
# amd64, and with mingw gcc-4.4 and Visual C++ 98 Express on Windows.
#
# An earlier version was reported not to work with tendra on netbsd, I have
# fixed bugs since then so maybe it works now.

def coro_pad 8192

typedef void noret

struct coro
	coro *next
	coro *prev
	jmp_buf j

typedef void (*coro_func)(coro *caller)

noret new_coro_2(coro_func f, coro *caller)

int coro_init_done = 0
coro main_coro
coro *coro_top = &main_coro
coro *current_coro = &main_coro

coro_func new_coro_f

jmp_buf alloc_ret
coro yielder

def coro_code_done  -1
def coro_code_alloc -2
def coro_code_dead  -3

coro_init()
	main_coro.prev = NULL
	main_coro.next = NULL
	coro_init_done = 1

int yield_val_2(coro *c, int val)
	coro *me = current_coro
	int v = setjmp(me->j)
	if (v == 0)         # yield
		longjmp(c->j, val)
	else if (v == coro_code_alloc)   # new - this is top
		coro *caller = current_coro
		current_coro = me
		new_coro_2(new_coro_f, caller)
		# cannot return
	# else returned
	current_coro = me
	return v

int yield_val(coro **c, int val)
	if *c
		int v = yield_val_2(*c, val)
		if v == coro_code_done
			*c = NULL
		return v
	return coro_code_dead

def yield(c) ccoro_yield(c)
int ccoro_yield(coro **c)
	return yield_val(c, 1)

noret new_coro_3(coro_func f, coro *caller)
	coro new
	current_coro = &new

	if coro_top
		coro_top->next = &new
	new.prev = coro_top
	new.next = NULL
	coro_top = &new

	(*f)(caller)

	if current_coro->prev
		current_coro->prev->next = current_coro->next
	if current_coro->next
		current_coro->next->prev = current_coro->prev

	if current_coro == coro_top
		coro_top = current_coro->prev

	current_coro = NULL

	longjmp(caller->j, coro_code_done)  # finished

noret new_coro_2(coro_func f, coro *caller)
	volatile char pad[coro_pad]
	pad[0] = pad[coro_pad-1] = 0;
	new_coro_3(f, caller)
	pad[0] = pad[coro_pad-1] = 0;
	# cannot return

coro *new_coro(coro_func f)
	int v
	coro *me = current_coro
	coro *yielder
	if !coro_init_done
		coro_init()
	new_coro_f = f
	v = setjmp(current_coro->j)
	if (v == 0)            # new
		if current_coro == coro_top
			new_coro_2(f, current_coro)
		else
			longjmp(coro_top->j, coro_code_alloc)
		# cannot return
	# else yielded
	yielder = current_coro
	current_coro = me
	return yielder


int argc
int args
char **argv
char *program_full
char *program_real
char *program
char *program_dir
char **arg
char *main_dir

boolean args_literal = 0
boolean args_list = 0

def Main()
	main(int main__argc, char *main__argv[])
		main__init(main__argc, main__argv)

main__init(int _argc, char *_argv[])
	argc = _argc
	argv = _argv
	vstreams_init()
	error_init()
	main_dir = Getcwd()
	program_full = argv[0]
	if !exists(program_full)
		program_full = Which(program_full)
		# this might fail if PATH was not exported :/
	program_real = readlinks(Strdup(program_full))
	# TODO readlinks?
	dirbasename(Strdup(program_real), d, b)  # this is bogus!  need auto decl
	program_dir = d
	program = b
	if mingw && cstr_ends_with(program, ".exe")
		program[strlen(program)-4] = '\0'
	if program[0] == '.'
		++program
	arg = argv+1
	args = argc - 1
	seed()
	os_main_init()

def shift(n)
	arg += n ; args -= n
def shift()
	shift(1)

# TODO
#namemap
#	main__main main
#	main main__real

# todo module initializers


# options

def opt(name) optlast(name)
def optc(name) optc(O, name)
def optlast(name) optlast(O, name)
def opt1st(name) opt1st(O, name)
def optv(name) optv(O, name)

def opt(O, name) optlast(name)
def optc(O, name) (opt*)mgetc(&O->h, name)
def optlast(O, name) (opt*)mgetlast(&O->h, name)
def opt1st(O, name) (opt*)mget1st(&O->h, name)
def optv(O, name) (opt*)mget(&O->h, name)

struct opts
	vec v
	hashtable h

struct opt
	cstr name
	cstr *arg

#TODO? :

#typedef void (*opt_h)(cstr *arg)

#struct opt
#	cstr opt_short
#	cstr opt_long
#	opt_h h
#	cstr *arg

def opts_init(o) opts_init(o, 257)

opts_init(opts *O, size_t opts_hash_size)
	vec_init(&O->v, opt, 16)
	hashtable_init(&O->h, cstr_hash, cstr_eq, opts_hash_size)

# get_options() modifies its input, both the character data and the actual pointers
# and updates the array arg points at to point at non-option arguments.

def get_options() get_options(NULL)

opts *get_options(cstr options[][3])
	new(short_ht, hashtable, cstr_hash, cstr_eq, 257)

	if options
		table_cstr_to_hashtable(short_ht, options, 3, 0, 1)

	New(O, opts)

	char **p = arg
	char **out = arg
	while *p
		let(i, *p)
		if i[0] != '-' || i[1] == '\0'
			*out++ = *p++
			continue
		if i[1] == '-' && i[2] == '\0'
			++p
			while *p
				*out++ = *p++
			args_literal = 1
			break

		opt *o = vec_push(&O->v)

		boolean short_opt = i[1] != '-'
		if short_opt
			o->name = i + 1
		 	i = o->name + 1
		 else
		 	o->name = i + 2
			i = o->name + strcspn(o->name, "=:")

		o->arg = NULL

		char optargs_type = *i
		*i++ = '\0'

		if short_opt
			cstr name_long = get(short_ht, o->name)
			if name_long
				o->name = name_long
			 else
				o->name = sym(o->name)

		mput(&O->h, o->name, o)

		if optargs_type == '='
			o->arg = Nalloc(cstr, 2)
			if *i != '\0'
				o->arg[0] = i
			 else
				++p
				o->arg[0] = *p
			o->arg[1] = NULL
		 eif optargs_type == ':'
			new(v, vec, cstr, 16)
			if *i != '\0'
				vec_push_cstr(v, i)
			while p[1] && p[1][0] != '-'
				cstr oa = *++p
				# hackery to escape a leading '-' if necessary...
				if oa[0] == '\\'
					++oa
				vec_push_cstr(v, oa)
			o->arg = vec_to_array(v)
		 eif optargs_type != '\0' && short_opt
			# allow to group short options
			*--i = optargs_type
			*--i = '-'
			*p = i
			decl(v, vec)
			array_to_vec(v, p)
			continue
			
		++p

	*out = NULL

	args = out - arg

	if args_literal || args
		args_list = 1

	return O

dump_options(opts *O)
	for_vec(o, &O->v, opt)
		Fprint(stderr, o->name)
		if o->arg
			Fprint(stderr, " =")
			forary_null(j, o->arg)
				Fprintf(stderr, " %s", j)
		nl(stderr)
	nl(stderr)

def version()
	sf("%s version %s", program, version)

def version_description()
	if *description
		sf("%s version %s - %s", program, version, description)
	 else
		version()

def help()
	help_(version, description, usage, options)
help_(cstr version, cstr description, cstr *usage, cstr options[][3])
	version_description()
	say_usage()
	say("options:")

	typeof(&*options) i
	int max_len = 0

	for i = options; (*i)[0]; ++i
		cstr long_opt = (*i)[1]
		int len = strlen(long_opt)
		if len > max_len
			max_len = len

	for i = options; (*i)[0]; ++i
		cstr short_opt = (*i)[0]
		cstr long_opt = (*i)[1]
		cstr desc = (*i)[2]
		if *short_opt
			Sayf("  -%1s  --%-*s  %s", short_opt, max_len, long_opt, desc)
		 else
			Sayf("      --%-*s  %s", max_len, long_opt, desc)

def getargs_(type, a0)
	a0 = cstr_to_^^type(arg[0])
	shift()

def getargs(type)
	.
def getargs(type, a0)
	if args
		getargs_(type, a0)
def getargs(type, a0, a1)
	getargs(type, a0)
	getargs(type, a1)
def getargs(type, a0, a1, a2)
	getargs(type, a0, a1)
	getargs(type, a2)
def getargs(type, a0, a1, a2, a3)
	getargs(type, a0, a1, a2)
	getargs(type, a3)
def getargs(type, a0, a1, a2, a3, a4)
	getargs(type, a0, a1, a2, a3)
	getargs(type, a4)
def getargs(type, a0, a1, a2, a3, a4, a5)
	getargs(type, a0, a1, a2, a3, a4)
	getargs(type, a5)

def Getargs(type)
	.
def Getargs(type, a0)
	if !args
		usage()
	getargs_(type, a0)
def Getargs(type, a0, a1)
	Getargs(type, a0)
	Getargs(type, a1)
def Getargs(type, a0, a1, a2)
	Getargs(type, a0, a1)
	Getargs(type, a2)
def Getargs(type, a0, a1, a2, a3)
	Getargs(type, a0, a1, a2)
	Getargs(type, a3)
def Getargs(type, a0, a1, a2, a3, a4)
	Getargs(type, a0, a1, a2, a3)
	Getargs(type, a4)
def Getargs(type, a0, a1, a2, a3, a4, a5)
	Getargs(type, a0, a1, a2, a3, a4)
	Getargs(type, a5)

def args(type)
	.
def args(type, a0)
	type a0
	Getargs(type, a0)
def args(type, a0, a1)
	args(type, a0)
	args(type, a1)
def args(type, a0, a1, a2)
	args(type, a0, a1)
	args(type, a2)
def args(type, a0, a1, a2, a3)
	args(type, a0, a1, a2)
	args(type, a3)
def args(type, a0, a1, a2, a3, a4)
	args(type, a0, a1, a2, a3)
	args(type, a4)
def args(type, a0, a1, a2, a3, a4, a5)
	args(type, a0, a1, a2, a3, a4)
	args(type, a5)


def getrargs_(type, a0)
	a0 = cstr_to_^^type(arg[--args])

def getrargs(type)
	.
def getrargs(type, a0)
	if args
		getrargs_(type, a0)
def getrargs(type, a0, a1)
	getrargs(type, a0)
	getrargs(type, a1)
def getrargs(type, a0, a1, a2)
	getrargs(type, a0, a1)
	getrargs(type, a2)
def getrargs(type, a0, a1, a2, a3)
	getrargs(type, a0, a1, a2)
	getrargs(type, a3)
def getrargs(type, a0, a1, a2, a3, a4)
	getrargs(type, a0, a1, a2, a3)
	getrargs(type, a4)
def getrargs(type, a0, a1, a2, a3, a4, a5)
	getrargs(type, a0, a1, a2, a3, a4)
	getrargs(type, a5)

def Getrargs(type)
	.
def Getrargs(type, a0)
	if !args
		usage()
	getrargs_(type, a0)
def Getrargs(type, a0, a1)
	Getrargs(type, a0)
	Getrargs(type, a1)
def Getrargs(type, a0, a1, a2)
	Getrargs(type, a0, a1)
	Getrargs(type, a2)
def Getrargs(type, a0, a1, a2, a3)
	Getrargs(type, a0, a1, a2)
	Getrargs(type, a3)
def Getrargs(type, a0, a1, a2, a3, a4)
	Getrargs(type, a0, a1, a2, a3)
	Getrargs(type, a4)
def Getrargs(type, a0, a1, a2, a3, a4, a5)
	Getrargs(type, a0, a1, a2, a3, a4)
	Getrargs(type, a5)

def rargs(type)
	.
def rargs(type, a0)
	type a0
	Getrargs(type, a0)
def rargs(type, a0, a1)
	rargs(type, a0)
	rargs(type, a1)
def rargs(type, a0, a1, a2)
	rargs(type, a0, a1)
	rargs(type, a2)
def rargs(type, a0, a1, a2, a3)
	rargs(type, a0, a1, a2)
	rargs(type, a3)
def rargs(type, a0, a1, a2, a3, a4)
	rargs(type, a0, a1, a2, a3)
	rargs(type, a4)
def rargs(type, a0, a1, a2, a3, a4, a5)
	rargs(type, a0, a1, a2, a3, a4)
	rargs(type, a5)
def os_main_init()
	.

int unix_main = 1

const boolean mingw = 0
# returns malloc'd
cstr darcs_root()
	new(b, buffer, 256)
	until(exists("_darcs"))
		Getcwd(b)
		if cstr_eq(buffer_to_cstr(b), "/")
			error("not in a darcs repository")
		buffer_clear(b)
		Chdir("..")
	Getcwd(b)
	return buffer_to_cstr(b)

# path malloc'd -> malloc'd
cstr _darcs_path(cstr path, cstr root, cstr cwd)
	let(ref, cstr_cat(cwd, "/"))
	Path_relative_to(path, ref)
	Free(ref)
	path = path_tidy(path)
	path = path_under(root, path)
	unless(path)
		error("path outside repository", path)
	return path

def darcs_path(path, root, cwd)
	path = _darcs_path(path, root, cwd)

def darcs_path(path)
	let(my(dir), Getcwd())
	let(my(root), darcs_root())
	darcs_path(path, my(root), my(dir))
	Free(my(dir))
	Free(my(root))

# TODO fix my!

cstr darcs_exists(cstr darcs_path)
	let(rv, cstr_cat("_darcs/current/", darcs_path))
	return exists(rv) ? rv : NULL


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
	if c != EOF
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

cstr html_entity[] = { "&nbsp;", "&amp;", "&quot;", "&lt;", "&gt;", NULL }
char html_entity_char[] = { ' ', '&', '"', '<', '>', '\0' }

_html_encode(buffer *b, cstr v)
	while *v != 0
		for char *c = html_entity_char+1; *c; ++c
			if *v == *c
				buffer_cat_cstr(b, html_entity[c-html_entity_char])
				done
		buffer_cat_char(b, *v)
done		++v

cstr html_encode(cstr v)
	new(b, buffer)
	_html_encode(b, v)
	return buffer_to_cstr(b)
def html_encode(b, v) _html_encode(b, v)

_html_decode(buffer *b, cstr v)
	while *v
		if *v == '&'
			for cstr *s = html_entity; *s; ++s
				int l = strlen(*s)
				if !strncmp(v, *s, l)
					buffer_cat_char(b, html_entity_char[s-html_entity])
					v += l
					done
		buffer_cat_char(b, *v)
		++v
done		.

cstr html_decode(cstr v)
	new(b, buffer)
	_html_decode(b, v)
	return buffer_to_cstr(b)
def html_decode(b, v) _html_decode(b, v)

cstr html2text(cstr html)
	decl(b_html, circbuf)
	circbuf_from_cstr(b_html, html)

	new(b_split, circbuf, 1024)
	cb_io(b_html, b_split)
		html_split()

	new(b_text, circbuf, 1024)

	boolean hide = 0
	boolean at_break = 1

	new(decoded, buffer, 1024)

	cb_io(b_split, b_text)
		eachline(s)
			if s[0] != '<'
				if !hide
					bufclr(decoded)
					html_decode(decoded, s)
					print(buffer_to_cstr(decoded))
					at_break = 0
			 eif (!strncasecmp(s, "<br", 3) && among(s[3], ' ', '>', '/'))
			  || !strcasecmp(s, "</p>") || !strcasecmp(s, "</tr>") || !strcasecmp(s, "</div>")
				if !hide
					say()
					at_break = 1
			 eif !strcasecmp(s, "</td>")
				if !hide
					print("\t")
					at_break = 1
			 else
				if !at_break
					print(" ")
					at_break = 1
				if (!strncasecmp(s, "<script", 7) && among(s[7], ' ', '>')) ||
				  (!strncasecmp(s, "<style", 7) && among(s[7], ' ', '>'))
					hide = 1
				 eif !strcasecmp(s, "</script>") ||
				  !strcasecmp(s, "</style>")
					hide = 0

	buffer_free(decoded)
	circbuf_free(b_split)

	return circbuf_to_cstr(b_text)
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
		if !isalnum(c) && !strchr(":_-/?.", c)
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

# this isn't exactly a core library!
# but if I want to use it in more than one program, it goes in

def hunk(in_file, out_dir)
	hunk(in_file, out_dir, 64*1024, 4*64*1024, 4096)

hunk(cstr in_file, cstr out_dir, int avg_hunk_size, int max_hunk_size, int sum_window_size)
	Mkdir_if(out_dir)
	cp_attrs(in_file, out_dir)
	FILE *in = Fopen(in_file, "r")

	new(b, buffer, avg_hunk_size*2)
	new(out_file, buffer, 256)
	int c
	int sum = 0
	int hunk_count = 0

	off_t offset = 0

	repeat
		Getc(c, in)
		if c != EOF
			buffer_cat_char(b, (char)c)
			sum += c
		if (int)buffer_get_size(b) >= sum_window_size || c == EOF
			if end_of_hunk() || (int)buffer_get_size(b) == max_hunk_size || c == EOF
				buffer_clear(out_file)
				Sprintf(out_file, "%016x", offset)
				# TODO store hunks in a shared directory, unique by sha1, and hard link to the file's own directory using offset file
				char *out_file_path = path_cat(out_dir, buffer_get_start(out_file))
				FILE *out = Fopen(out_file_path, "wb")
				Fwrite(buffer_get_start(b), 1, buffer_get_size(b), out)
				Fclose(out)
				Free(out_file_path)
				++hunk_count
				offset += buffer_get_size(b)
				if c == EOF
					break
				buffer_clear(b)
				sum = 0
			 else
				sum -= buffer_get_start(b)[buffer_get_size(b)-sum_window_size]

	Fclose(in)

def end_of_hunk() sum % avg_hunk_size == 0


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

def qsincos_n 360
 # must be a multiple of 360
def qatan_n 500

num *_qsin
num *_qcos
num *_qatan

qmath_init()
	_qsin = Nalloc(num, qsincos_n)
	_qcos = Nalloc(num, qsincos_n)
	_qatan = Nalloc(num, qatan_n+1)
	for(i, 0, qsincos_n)
		num a = i*2*pi/qsincos_n
		_qsin[i] = sin(a)
		_qcos[i] = cos(a)
	for(j, 0, qatan_n+1)
		_qatan[j] = atan(j/(num)qatan_n)

def qsin(s, a)
	int my(ang)
	mod_fast(my(ang), a*(qsincos_n/(2*pi)), qsincos_n)
	s = _qsin[my(ang)]

def qSin(s, a)
	qsin(s, angle2rad(a))

def qcos(c, a)
	int my(ang)
	mod_fast(my(ang), a*(qsincos_n/(2*pi)), qsincos_n)
	c = _qcos[my(ang)]

def qCos(c, a)
	qcos(c, angle2rad(a))

def qatan(a, t)
	num my(_t) = t
	if my(_t) > 0
		if my(_t) <= 1
			a = _qatan[(int)(my(_t)*qatan_n)]
		 else
			a = pi/2 - _qatan[(int)(qatan_n/my(_t))]
	 else
		if my(_t) >= -1
			a = -_qatan[(int)(-qatan_n*my(_t))]
		 else
			a = _qatan[(int)(-qatan_n/my(_t))] - pi/2

def qatan2(a, y, x)
	num my(_x) = x
	num my(_y) = y
	if my(_x) == 0
		a = my(_y) >= 0 ? pi/2 : -pi/2
	 else
		qatan(a, my(_y)/my(_x))
		if my(_x) < 0
			if my(_y) < 0
				a -= pi
			 else
				a += pi

def qAtan(a, t)
	qatan(a, t)
	a = rad2angle(a)

def qAtan2(a, y, x)
	qatan2(a, y, x)
	a = rad2angle(a)

# quick random numbers (in a macro)

def rand_M ((1U<<31) -1)
def rand_A 48271
def rand_Q 44488
def rand_R 3399

unsigned int rand_v = 1
def qrand() (unsigned int)(rand_v = rand_A*(rand_v%rand_Q) - rand_R*(rand_v/rand_Q))
def qtoss() (qrand() % 2)

cstr mimetypes_file = "/etc/mime.types"

mimetypes_init()
	if !mimetypes
		mimetypes = &struct__mimetypes
		init(mimetypes, hashtable, cstr_hash, cstr_eq, mimetypes_n_buckets)

def load_mimetypes()
	load_mimetypes(mimetypes_file)
def load_mimetypes(file)
	F_in(file)
		load_mimetypes_vio()

size_t mimetypes_n_buckets = 1009
hashtable struct__mimetypes, *mimetypes = NULL
load_mimetypes_vio()
	mimetypes_init()
	sym_init()
	eachline(l)
		if among(*l, '#', '\0')
			continue
		cstr type = l
		cstr ext = strrchr(l, '\t')
		if ext++
			*Strchr(type, '\t') = '\0'
			type = sym(type)
			cstr *exts = split(ext, ' ')
			forary_null(e, exts)
				kv(mimetypes, sym(e), type)
#				cstr otype = kv(mimetypes, sym(e), type)->v
#				if otype != type
#					warn("duplicate mimetypes for ext %s: %s %s", e, otype, type)
			Free(exts)

cstr mimetype(cstr ext)
	return get(mimetypes, ext, NULL)

cstr Mimetype(cstr ext)
	return Get(mimetypes, ext)


meta_init()
	NEW(type_ix, hashtable, 1009)

type_add(type *t)
	cstr name = t->name
	put(type_ix, name, t)
	if among(t->type, TYPE_STRUCT, TYPE_UNION)
		decl_cast(s, type__struct_union, t)
		for(i, 0, s->n)
			cstr element_name = format("%s.%s", name, s->e[i].name)
			put(type_ix, element_name, i)

type *type_get(cstr name)
	return get(type_ix, name)

read_structs(vec *v, type__struct_union *t)
	while read_struct(vec_push(v), t)
		.
	vec_pop(v)

write_structs(vec *v, type__struct_union *t)
	for_vec(i, v)
		write_struct(i, t)

# TODO how about "comments" aka markup in the file?
# maybe don't allow nested objects / hierarchical trees, use refs instead..?
# option for extra fields added to an "extra" catch all list or hash in each struct :)

def read_struct(s, t) read_struct(s, t, OE_ERROR)
int read_struct(void *s, type__struct_union *t, opt_err unknown_key)
	zero((char*)s, (char*)s+t->t.size)
	cstr name = t->t.name
	new(b, buffer, 64)
	boolean more = 0
	long i = 0
	long n = t->n
	eachline(l)
		scan_kv(l, k, v)
		if *k
			if !v
				error("read_struct: missing delimiter after key: %s", k)
			make_name(lc(k))
			type__element *e
			repeat
				if i==n
					Sprintf(b, "%s.%s", name, k)
					int i = p2i(get(type_ix, buffer_add_nul(b), -1))
					bufclr(b)
					if i == -1
						if !opt_err_do(unknown_key, (any){.i=1}, (any){.i=0}, "read_struct: unknown key: %s", k).i
							return 0
						 else
							skip
					e = &t->e[i]
					break
				e = &t->e[i]
				if cstr_eq(k, e->name)
					break
				++i
			char *p = (char*)s + e->offset
			if among(e->type, (type*)t_cstr, (type*)t_char_p)
				*(cstr*)p = Strdup(v)
			 eif among(e->type, (type*)t_int, (type*)t_unsigned_int, (type*)t_signed_int)
				sc(int, v, *(int*)p)
			 eif among(e->type, (type*)t_short, (type*)t_unsigned_short, (type*)t_signed_short)
				sc(short, v, *(short*)p)
			 eif among(e->type, (type*)t_char, (type*)t_unsigned_char, (type*)t_signed_char)
				sc(char, v, *(char*)p)
			 eif among(e->type, (type*)t_long, (type*)t_unsigned_long, (type*)t_signed_long)
				sc(long, v, *(long*)p)
			 eif among(e->type, (type*)t_long_long, (type*)t_unsigned_long_long, (type*)t_signed_long_long)
				sc(long_long, v, *(long_long*)p)
			 eif e->type == (type*)t_float
				sc(float, v, *(float*)p)
			 eif e->type == (type*)t_double
				sc(double, v, *(double*)p)
			 eif e->type == (type*)t_long_double
				sc(long_double, v, *(long_double*)p)
			 else
				error("read_struct: only cstr, integer and floating point members, not type %s", e->type->name)
		 else
			more = 1
			break
skip		.

	if more == 0 && i>0
		error("read_struct: missing newline before EOF")
		# to avoid truncated records

	buffer_free(b)
	return more

def write_struct(s, t) write_struct(s, t, OE_ERROR)
boolean write_struct(void *s, type__struct_union *t, opt_err unknown_type)
	for(i, 0, t->n)
		type__element *e = &t->e[i]
		char *p = (char*)s + e->offset
		if among(e->type, (type*)t_cstr, (type*)t_char_p)
			if *(cstr*)p
				pr(cstr, e->name)
				Pr(cstr, *(cstr*)p)
		 else
			pr(cstr, e->name)
			if among(e->type, (type*)t_int, (type*)t_signed_int)
				Pr(int, *(int*)p)
			 eif among(e->type, (type*)t_short, (type*)t_signed_short)
				Pr(short, *(short*)p)
			 eif among(e->type, (type*)t_char, (type*)t_signed_char)
				Pr(char, *(char*)p)
			 eif among(e->type, (type*)t_long, (type*)t_signed_long)
				Pr(long, *(long*)p)
			 eif among(e->type, (type*)t_long_long, (type*)t_signed_long_long)
				Pr(long_long, *(long_long*)p)
			 eif among(e->type, (type*)t_unsigned_int)
				Pr(unsigned_int, *(unsigned_int*)p)
			 eif among(e->type, (type*)t_unsigned_short)
				Pr(unsigned_short, *(unsigned_short*)p)
			 eif among(e->type, (type*)t_unsigned_char)
				Pr(unsigned_char, *(unsigned_char*)p)
			 eif among(e->type, (type*)t_unsigned_long)
				Pr(unsigned_long, *(unsigned_long*)p)
			 eif among(e->type, (type*)t_unsigned_long_long)
				Pr(unsigned_long_long, *(unsigned_long_long*)p)
			 eif e->type == (type*)t_float
				Pr(float, *(float*)p)
			 eif e->type == (type*)t_double
				Pr(double, *(double*)p)
			 eif e->type == (type*)t_long_double
				Pr(long_double, *(long_double*)p)
			 else
				if !opt_err_do(unknown_type, (any){.i=1}, (any){.i=0},
				 "write_struct: only cstr, integer and floating point members, not type %s", e->type->name).i
					return 0
	sf()
	return 1

struct type__element
	type *type
	cstr name
	long offset
#	short bits
#	short offset_bit

struct type__element
	type *type
	cstr name
	long offset


typedef enum { TYPE_VOID, TYPE_INT, TYPE_FLOAT, TYPE_POINT, TYPE_ARRAY, TYPE_STRUCT, TYPE_UNION, TYPE_FUNC, TYPE_DEF } type_t

typedef enum { SIGNED_NORMAL, SIGNED_SIGNED, SIGNED_UNSIGNED=-1 } signed_t

struct type__size
	int size
	int var_size

type__size type__sizes[] =
	{ sizeof(type__void), 0 },
	{ sizeof(type__int), 0 },
	{ sizeof(type__float), 0 },
	{ sizeof(type__point), 0 },
	{ sizeof(type__array), sizeof(int) },
	{ sizeof(type__struct_union), sizeof(type__element) },
	{ sizeof(type__struct_union), sizeof(type__element) },
	{ sizeof(type__func), sizeof(type *) },
	{ sizeof(type__def), 0 }

struct type__element
	type *type
	cstr name
	long offset
#	short bits
#	short offset_bit

struct type
	type_t type
	cstr name
	long size

struct type__void
	type t

struct type__int
	type t
	signed_t sign

struct type__float
	type t

struct type__point
	type t
	type *ref

struct type__array
	type t
	int dims
	type *ref
	int n[]

struct type__struct_union
	type t
	long n
	type__element e[]

struct type__func
	type t
	int n
	type *ret
	type *arg[]

struct type__def
	type t
	type *ref

type__int t_ints[] =
	{ { TYPE_INT, "int", sizeof(int) }, SIGNED_NORMAL },
	{ { TYPE_INT, "char", sizeof(char) }, SIGNED_NORMAL },
	{ { TYPE_INT, "short", sizeof(short) }, SIGNED_NORMAL },
	{ { TYPE_INT, "long", sizeof(long) }, SIGNED_NORMAL },
	{ { TYPE_INT, "long long", sizeof(long long) }, SIGNED_NORMAL },

	{ { TYPE_INT, "signed int", sizeof(signed int) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed char", sizeof(signed char) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed short", sizeof(signed short) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed long", sizeof(signed long) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed long long", sizeof(signed long long) }, SIGNED_SIGNED },

	{ { TYPE_INT, "unsigned int", sizeof(unsigned int) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned char", sizeof(unsigned char) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned short", sizeof(unsigned short) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned long", sizeof(unsigned long) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned long long", sizeof(unsigned long long) }, SIGNED_UNSIGNED }

def t_int t_ints + 0
def t_char t_ints + 1
def t_short t_ints + 2
def t_long t_ints + 3
def t_long_long t_ints + 4

def t_signed_int t_ints + 5
def t_signed_char t_ints + 6
def t_signed_short t_ints + 7
def t_signed_long t_ints + 8
def t_signed_long_long t_ints + 9

def t_unsigned_int t_ints + 10
def t_unsigned_char t_ints + 11
def t_unsigned_short t_ints + 12
def t_unsigned_long t_ints + 13
def t_unsigned_long_long t_ints + 14

type__float t_floats[] =
	{ { TYPE_FLOAT, "float", sizeof(float) } },
	{ { TYPE_FLOAT, "double", sizeof(double) } },
	{ { TYPE_FLOAT, "long double", sizeof(long double) } }

def t_float t_floats + 0
def t_double t_floats + 1
def t_long_double t_floats + 2

type__void t_voids[] =
	{ { TYPE_VOID, "void", 0 } }

def t_void t_voids + 0

type__point t_points[] =
	{ { TYPE_POINT, "char *", sizeof(char *) }, &t_char->t },
	{ { TYPE_POINT, "void *", sizeof(void *) }, &t_void->t }

def t_char_p t_points + 0
def t_void_p t_points + 1

type__def t_defs[] =
	{ { TYPE_DEF, "cstr", sizeof(cstr) }, &t_char_p->t }

def t_cstr t_defs + 0

hashtable struct__type_ix, *type_ix = &struct__type_ix

def struct_ref(s, offset) (void *)(((char *)s)+offset)
def struct_ref_ptr(s, offset) (void **)struct_ref(s, offset)
def struct_ref_int(s, offset) (int *)struct_ref(s, offset)

def struct_set_ptr(s, offset, value) *struct_ref_ptr(s, offset) = value
def struct_get_ptr(s, offset) *struct_ref_ptr(s, offset)

typedef float sample
typedef double sample2
	# The float format has 23-bit mantissa,
	# and is able to hold a 24-bit int.
	# We can convert 24-bit audio to floats losslessly.

typedef vec sound
# of samples

struct range
	sample min, max

range check_range(sample *s0, sample *s1)
	range r
	r.min = 1e100
	r.max = -1e100
	for(s)
		if *s < r.min
			r.min = *s
		if *s > r.max
			r.max = *s
	return r

boolean range_ok(sample *s0, sample *s1)
	range r = check_range(s0, s1)
	return r.min >= -1 && r.max <= 1

sound_print(sample *s0, sample *s1)
	natatime(s, 2, Nl())
		printf("%.2f ", *s)
	nl() ; nl()

def fit(s0, s1)
	normalize(s0, s1, 1)

def normalize(s0, s1)
	normalize(s0, s1, 0)

normalize(sample *s0, sample *s1, boolean softer)
	range r = check_range(s0, s1)
	sample vol0 = fabs(r.min)
	sample vol1 = fabs(r.max)
	sample max = Max(vol0, vol1)
	if !softer || max > 1
		amplify(s0, s1, 1.0/max)
		clip(s0, s1)

amplify(sample *s0, sample *s1, num factor)
	for(s)
		*s *= factor

clip(sample *s0, sample *s1)
	for(s)
		if *s < -1
			*s = -1
		eif *s > 1
			*s = 1

add_noise(sample *s0, sample *s1, num vol)
	for(i, s0, s1)
		*i += Rand(vol)-vol/2

# TODO a proper "normalize" function - would need to consider "strays" when
# dealing with real audio data, i.e. partly clip then amplify.  for synth data
# doesn't matter

sound_init(sound *s, ssize_t size)
	vec_init(s, sample, size)
	vec_set_size(s, size)
#	sound_clear(s)

sound_clear(sound *s)
	# FIXME this don't work because brace_macro doesn't eval macros inside args first
	#for(i, (sample *)vec_range(s))
	for(i, sound_get_start(s), sound_get_end(s))
		*i = 0

mix_range(sample *up, sample *a0, sample *a1)
	while a0 != a1
		*up += *a0
		++up ; ++a0

sound_same_size(sound *s1, sound *s2)
	sound_grow(s1, sound_get_size(s2))
	sound_grow(s2, sound_get_size(s1))

sound_grow(sound *s, ssize_t size)
	let(old_size, sound_get_size(s))
	if old_size < size
		sound_set_size(s, size)
		for(i, sound_get_start(s)+old_size, sound_get_end(s))
			*i = 0

mix(sound *up, sound *add)
	sound_grow(up, sound_get_size(add))
	mix_range(sound_get_start(up), sound_range(add))

mix_to_new(sample *out, sample *a0, sample *a1, sample *b0, sample *b1)
	while a0 != a1 && b0 != b1
		*out = *a0 + *b0
		++out
		++a0 ; ++b0
	if b0 == b1
		swap(a0, b0)
		swap(a1, b1)
	while a0 != a1
		*out = *a0
		++out
		++a0

int sound_rate = 0
num sound_dt = 0

sound_set_rate(int r)
	sound_rate = r
	sound_dt = 1.0 / sound_rate

def sound_get_start(s) (sample *)vec_get_start(s)
def sound_get_end(s) (sample *)vec_get_end(s)
def sound_set_size vec_set_size
def sound_get_size vec_get_size
Def sound_range(s) sound_get_start(s), sound_get_end(s)


struct audio
	int channels
	int bits_per_sample
	long sample_rate
	size_t n_samples
	sound *sound   # one for each channel

audio_init(audio *a)
	use(a)
def audio_init(a, channels)
	audio_init(a, channels, 1)
def audio_init(a, channels, n_samples)
	audio_init_2(a, channels, n_samples)

audio_init_2(audio *a, int channels, int n_samples)
	a->channels = channels
	a->n_samples = n_samples
	a->sound = Nalloc(sound, channels)
	for(i, 0, channels)
		sound_init(&a->sound[i], n_samples)
		sound_set_size(&a->sound[i], 0)

# TODO load_wav, read until EOF for wav with unknown length

load_wav(audio *a)
	size_t header_size_1 = 36
	size_t header_size_2 = 8
	char headers[header_size_1 + header_size_2]
	if vs_read(headers, header_size_1) != header_size_1
		failed0("load_wav", "file too short")
	if strncmp(headers, "RIFF", 4) || strncmp(headers+8, "WAVEfmt ", 8)
		failed0("load_wav", "invalid / unknown wav format")

	size_t format_size = le4(headers + 16)
	if format_size < 0x10
		failed0("load_wav", "format_size too small")

	int compression_code = le2(headers + 20)
	if compression_code != 1
		failed0("load_wav", "compression not supported")
	size_t size = le4(headers+4) - 20 - format_size

	discard(format_size - 0x10)

	if vs_read(headers + header_size_1, header_size_2) != header_size_2
		failed0("load_wav", "file too short")

	if strncmp(headers + header_size_1, "data", 4)
		failed0("load_wav", "data chunk not found")

	if (size_t)le4(headers + header_size_1 + 4) != size
		failed0("load_wav", "file size mismatch")

	a->channels = le2(headers + 22)
	a->sample_rate = le4(headers + 24)
	int bytes_per_second = le4(headers + 28)
	use(bytes_per_second)
	int block_align = le2(headers + 32)
	a->bits_per_sample = le2(headers + 34)
	if a->bits_per_sample * a->channels != 8 * block_align
		failed0("load_wav", "bits_per_sample * channels != 8 * block_align")
	if size % block_align
		failed0("load_wav", "size is not a whole number of blocks")
	if a->bits_per_sample % 8
		failed0("load_wav", "bits_per_sample is not a multiple of 8")
	int bytes_per_sample = a->bits_per_sample / 8
	a->n_samples = size / bytes_per_sample / a->channels

#	warn("bits_per_sample: %d", a->bits_per_sample)
#	warn("sample_rate: %d", a->sample_rate)
#	warn("block_align: %d", block_align)
#	warn("channels: %d", a->channels)
#	warn("size: %d", size)
#	warn("n_samples: %d", a->n_samples)

	a->sound = Nalloc(sound, a->channels)
	for(i, 0, a->channels)
		sound_init(&a->sound[i], a->n_samples)

	float divide = 1<<(a->bits_per_sample-1)
	float origin = bytes_per_sample == 1 ? (divide/2) : 0

	which bytes_per_sample
	1	read_samples(a->sound, a->channels, a->n_samples, 1, byte, divide, origin)
	2	read_samples(a->sound, a->channels, a->n_samples, 2, sle2, divide, origin)
	3	read_samples(a->sound, a->channels, a->n_samples, 3, sle3, divide, origin)
	4	read_samples(a->sound, a->channels, a->n_samples, 4, sle4, divide, origin)
	else	failed0("load_wav", "bytes_per_sample is not 1, 2, 3 or 4")

def read_samples(o, channels, n, bytes_per_sample, sample_reader, divide, origin)
	read_samples(o, channels, n, bytes_per_sample, sample_reader, divide, origin, my(chunk_size), my(chunk_samples), my(remain), my(to_read), my(to_read_bytes), my(in), my(end))

def read_samples(o, channels, n, bytes_per_sample, sample_reader, divide, origin, chunk_size, chunk_samples, remain, to_read, to_read_bytes, in, end)
	.
		sample *O[channels]
		for(i, 0, channels)
			O[i] = sound_get_start(&o[i])
		int chunk_size = block_size - block_size % (bytes_per_sample * channels)
		int chunk_samples = chunk_size / (bytes_per_sample * channels)
		int remain = n
		char buf[chunk_size]
		while remain
#			warn("remain: %d", remain)
			int to_read = imin(chunk_samples, remain)
			size_t to_read_bytes = to_read * channels * bytes_per_sample
			if vs_read(buf, to_read_bytes) != to_read_bytes
				failed0("read_samples", "file too short")
			remain -= to_read
			char *in = buf
			char *end = buf + to_read_bytes
			while in < end
				for(i, 0, channels)
					*(O[i]++) = sample_reader(in) / divide - origin
					in += bytes_per_sample
#		if vs_read(buf, chunk_size) != 0
#			failed0("read_samples", "extra data at EOF")

# linux OSS "/dev/dsp" audio driver
# 44100 Hz 16 bit mono native byte order

# FIXME use "local" vars

int dsp_rate = 44100
int bits_per_sample = 16
int dsp_channels = 1
num dsp_buf_initial_duration = 1
int bytes_per_sample = 2
# bits_per_sample/8*dsp_channels

char *dsp_outfile = "/dev/dsp"
int use_dsp = 1

int dsp_fd

def play(s)
	dsp_play_sound(s)
def play(a, b)
	dsp_play_sound(a, b)
def dsp_play_sound(s)
	dsp_play_sound(sound_get_start(s), sound_get_end(s))
dsp_play_sound(sample *i, sample *e)
	size_t buf_size = dsp_buffer_get_size(dsp_buf)
	short *buf0 = dsp_buffer_get_start(dsp_buf)
	while i < e
		size_t count = imin(e-i, buf_size)
		fit(i, i+count)
		dsp_encode(i, i+count, buf0)
		dsp_play((char *)buf0, (char *)(buf0 + count))
		i += count

# decl(dsp_buf, dsp_buffer)
# this don't work because brace_header does not run brace_macro over things
# that look like functions

dsp_buffer struct__dsp_buf
dsp_buffer *dsp_buf = &struct__dsp_buf

dsp_init()
	# for "play"
	dsp_buffer_init(dsp_buf, dsp_rate * dsp_buf_initial_duration)

	dsp_fd = Open(dsp_outfile, O_WRONLY|O_CREAT|O_APPEND)
	
	if use_dsp
		int arg
		int status
		arg = bits_per_sample
		status = ioctl(dsp_fd, SOUND_PCM_WRITE_BITS, &arg)
		if status == -1
			error("SOUND_PCM_WRITE_BITS ioctl failed")
		if (arg != bits_per_sample)
			error("unable to set sample size")
		
		arg = dsp_channels
		status = ioctl(dsp_fd, SOUND_PCM_WRITE_CHANNELS, &arg)
		if (status == -1)
			error("SOUND_PCM_WRITE_CHANNELS ioctl failed")
		if (arg != dsp_channels)
			error("unable to set number of channels")
		
		arg = dsp_rate
		status = ioctl(dsp_fd, SOUND_PCM_WRITE_RATE, &arg)
		if (status == -1)
			error("SOUND_PCM_WRITE_RATE ioctl failed")
		if arg != dsp_rate
			warn("using sample rate %d instead of %d\n", arg, dsp_rate)
			dsp_rate = arg

	sound_set_rate(dsp_rate)

dsp_play(char *b0, char *b1)
	size_t size = b1 - b0
	Write(dsp_fd, b0, size)

dsp_sync()
	if use_dsp
		int status = ioctl(dsp_fd, SOUND_PCM_SYNC, 0)
		if (status == -1)
			error("SOUND_PCM_SYNC ioctl failed")

typedef vec dsp_buffer

dsp_buffer_init(dsp_buffer *b, size_t size)
	vec_init_el_size(b, bytes_per_sample, size)
	dsp_buffer_set_size(b, size)
	dsp_buffer_clear(b)

dsp_buffer_print(dsp_buffer *b)
	buffer_dump(&b->b)

size_t dsp_sample_size()
	return bytes_per_sample

dsp_encode(sample *in0, sample *in1, short *out)
	assert(bits_per_sample == 16 && dsp_channels == 1 && bytes_per_sample == 2, "dsp_encode can only produce 16bit mono sound at the moment")
	assert(sizeof(short) == bytes_per_sample, "short type is not two bytes!! oh dear")
	
	# for the sake of symmetry, we don't use the -0x8000 value
	map(out, in, 0x7fff * *in)

# TODO dsp_decode

def dsp_buffer_clear(b)
	#for(i, dsp_buffer_range(b))
	for(i, dsp_buffer_get_start(b), dsp_buffer_get_end(b))
		*i = 0

def dsp_buffer_get_start(b) (short *)vec_get_start(b)
def dsp_buffer_get_end(b) (short *)vec_get_end(b)
def dsp_buffer_set_size vec_set_size
def dsp_buffer_get_size vec_get_size
Def dsp_buffer_range vec_range


use linux/soundcard.h

use unistd.h
use fcntl.h
use sys/types.h
use sys/ioctl.h
# chord(int n, real p[])

dur(num d)
	_dur = d

vol(num v)
	_vol = v

freq(num f)
	_freq = f

relfreq(num rf)
	_rf = rf
	_freq = relfreq2freq(rf)
	_p = relfreq2pitch(rf)

pitch(num p)
	_p = p
	_rf = pitch2relfreq(_p)
	_freq = relfreq2freq(_rf)

def note(p)
	harmony(p)
	note()
	# TODO convert vol (loudness) to amp?  how?  logarithmic, or squared?

def Note(p)
	pitch(p)
	note()
	# TODO convert vol (loudness) to amp?  how?  logarithmic, or squared?

def NOTE(rf)
	relfreq(rf)
	note()

note()
	new(buf, sound, _dur * sound_rate)
	wavegen(buf)
	play(buf)
	dsp_sync()

envelope(num attack, num release)
	_attack = attack
	_release = release
vibrato(num power, num freq)
	# note: power's base is 1 - that means no vibrato
	# a power of 2 means from /2 to *2 volume, etc
	assert(power >= 1, "vibrato power must be >= 1")
	vibrato_power = power
	vibrato_freq = freq
tremolo(num dpitch, num freq)
	tremolof(pitch2relfreq(dpitch), freq)
tremolof(num power, num freq)
	# note: power's base is 1 - that means no tremolo
	# a tremolo of 2 will bend an octave either way!!!
	tremolo_power = power
	tremolo_freq = freq

def wavegen(s)
	wavegen(sound_get_start(s), sound_get_end(s))

wavegen(float *from, float *to)
#	num loud_factor = pow(ref_freq / _freq, 1)  # this may not be quite right, seems good
	num loud_factor = 1

	num dur = _dur
	num peak = _vol * loud_factor
	num attack = _attack
	num release = _release
	num sustain = _dur - (attack + release)

#	warn("%f", peak)

	if sustain < 0
		num factor = dur / (attack + release)
		attack *= factor
		release *= factor
		peak *= factor
		sustain = 0

	size_t attack_c = attack * sound_rate
	size_t sustain_c = sustain * sound_rate
	size_t release_c = release * sound_rate

	num attack_dvol = peak / attack_c
	num sustain_dvol = 0
	num release_dvol = -peak / release_c
	
	float t = 0.0
	num evol = 0
	for(v, from, to)
		num vol
		if vibrato_power > 1
			vol = pow(vibrato_power, sin(2*pi*t*vibrato_freq)) * evol
		else
			vol = evol
		num freq
		if tremolo_power > 1
			freq = pow(tremolo_power, sin(2*pi*t*tremolo_freq)) * _freq
		else
			freq = _freq
		*v += vol*(*music_wave)(t*freq)

		if attack_c
			--attack_c
			evol += attack_dvol
		eif sustain_c
			--sustain_c
			evol += sustain_dvol
		eif release_c
			--release_c
			evol += release_dvol
		t += sound_dt

typedef num (*wave_f)(num t)

wave_f music_wave = puretone

num puretone(num t)
	return sin(2*pi*t)

num sawtooth(num t)
	return rmod(t, 1)*2-1

# todo envelope as a (coro) generator? or as object method?

chordf(int n, num f[])
	new(buf, sound, _dur * sound_rate)
	for(i, 0, n)
		freq(f[i])
		wavegen(buf)
	play(buf)
	dsp_sync()

rfChord(int n, num relfreq[])
	num freq[n]
	for(i, 0, n)
		freq[i] = relfreq2freq(relfreq[i])
	chordf(n, freq)

chord(int n, num pitch[])
	num relfreq[n]
	for(i, 0, n)
		relfreq[i] = pitch2relfreq(pitch[i])
	rfChord(n, relfreq)

chord2f(num a0, num a1)
	num a[2] = { a0, a1 }
	chordf(2, a)
rfChord2(num a0, num a1)
	num a[2] = { a0, a1 }
	rfChord(2, a)
chord2(num a0, num a1)
	num a[2] = { a0, a1 }
	chord(2, a)
chord3f(num a0, num a1, num a2)
	num a[3] = { a0, a1, a2 }
	chordf(3, a)
rfChord3(num a0, num a1, num a2)
	num a[3] = { a0, a1, a2 }
	rfChord(3, a)
chord3(num a0, num a1, num a2)
	num a[3] = { a0, a1, a2 }
	chord(3, a)
chord4f(num a0, num a1, num a2, num a3)
	num a[4] = { a0, a1, a2, a3 }
	chordf(4, a)
rfChord4(num a0, num a1, num a2, num a3)
	num a[4] = { a0, a1, a2, a3 }
	rfChord(4, a)
chord4(num a0, num a1, num a2, num a3)
	num a[4] = { a0, a1, a2, a3 }
	chord(4, a)

# old, but gold?
note_1_in_bits(num freq)
	int buf_dur = imin(1, _dur)
	# 1 second
	int rate = sound_rate
	int whole_size = _dur * rate
	int buf_size = buf_dur * rate
	
	new(buf, sound, buf_size)

	float t = 0.0

	while whole_size > 0
		int size = imin(buf_size, whole_size)
		sound_set_size(buf, size)
		#for(v, sound_range(buf))
		for(v, sound_get_start(buf), sound_get_end(buf))
			*v = _vol*sin(2*pi*t*freq)
			t += sound_dt

		play(buf)

		whole_size -= size
	
	dsp_sync()

num ref_freq = 440.0
num key_freq = 440.0

num _vol = 0.5
num _dur = 0.25
num _freq = 440
num _rf = 1
num _p = 0
num _attack = 0.05
num _release = 0.1
num vibrato_power = 1
num vibrato_freq = 4
num tremolo_power = 1
num tremolo_freq = 4

key_note_freq(num freq)
	key_freq = freq

key_note(num pitch)
	key_freq = ref_freq
	key_freq = pitch2freq(pitch)

num pitch2freq(num pitch)
	return relfreq2freq(pitch2relfreq(pitch))

num freq2pitch(num freq)
	return relfreq2pitch(freq2relfreq(freq))

num pitch2relfreq(num pitch)
	return pow(2, pitch/12)

num relfreq2pitch(num freq)
	return 12 * log(freq) / log(2)

num relfreq2freq(num relfreq)
	return relfreq * key_freq

num freq2relfreq(num relfreq)
	return relfreq / key_freq

harmony(int p)
	relfreq(harmony2relfreq(p))

num _harmony[12] =
	3.0/4, 4.0/5, 5.0/6, 8.0/9, 15.0/16,
	1, 16.0/15, 9.0/8, 6.0/5, 5.0/4, 4.0/3,
	45.0/32 # this is the rising 6
	#1.41421356237309504880, # sqrt(2) ?? or could use 45/32 rising to 3/2, or 32/45 falling to 2/3

num harmony2relfreq(int p)
	int octave, degree
	divmod_range(p, -5, 7, &octave, &degree)
	return pow(2, octave) * _harmony[degree + 5]

num harmony2freq(int p)
	return harmony2relfreq(p) * key_freq

colour black
def black() col(black)
colour white
def white() col(white)
colour red
def red() col(red)
colour orange
def orange() col(orange)
colour yellow
def yellow() col(yellow)
colour green
def green() col(green)
colour blue
def blue() col(blue)
colour indigo
def indigo() col(indigo)
colour violet
def violet() col(violet)
colour purple
def purple() col(purple)
colour magenta
def magenta() col(magenta)
colour midnightblue
def midnightblue() col(midnightblue)
colour brown
def brown() col(brown)
colour beige
def beige() col(beige)
colour grey
def grey() col(grey)
colour darkgrey
def darkgrey() col(darkgrey)
colour lightgrey
def lightgrey() col(lightgrey)
colour cyan
def cyan() col(cyan)
colour pink
def pink() col(pink)
colours_init()
	black = coln("black")
	white = coln("white")
	red = coln("red")
	orange = coln("orange")
	yellow = coln("yellow")
	green = coln("green")
	blue = coln("blue")
	indigo = coln("indigo")
	violet = coln("violet")
	purple = coln("purple")
	magenta = coln("magenta")
	midnightblue = coln("midnightblue")
	brown = coln("brown")
	beige = coln("beige")
	grey = coln("grey")
	darkgrey = coln("darkgrey")
	lightgrey = coln("lightgrey")
	cyan = coln("cyan")
	pink = coln("pink")
typedef unsigned long colour
colour coln(char *name)
# TODO make these xpm compatible!

ldef debug void

typedef unsigned long pix_t

def pix_r(p) p>>16 & 0xFF
def pix_g(p) p>>8 & 0xFF
def pix_b(p) p & 0xFF
def pix_a(p) p>>24 & 0xFF

def pix_rgb(r, g, b) (pix_t)r<<16 | (pix_t)g<<8 | (pix_t)b
def pix_rgb_safish(r, g, b) pix_rgb(byte_clamp_top(r), byte_clamp_top(g), byte_clamp_top(b))
  # does not handle negatives
def pix_rgb_safe(r, g, b) pix_rgb(byte_clamp(r), byte_clamp(g), byte_clamp(b))

def pix_rgba(r, g, b, a) (pix_t)a<<24 | pix_rgb(r, g, b)
def pix_rgba_safish(r, g, b, a) pix_rgba(byte_clamp_top(r), byte_clamp_top(g), byte_clamp_top(b), byte_clamp_top(a))
  # does not handle negatives
def pix_rgba_safe(r, g, b) pix_rgba(byte_clamp(r), byte_clamp(g), byte_clamp(b), byte_clamp(a))

def pixn_r(p) pix_r(p) / 256.0
def pixn_g(p) pix_g(p) / 256.0
def pixn_b(p) pix_b(p) / 256.0
def pixn_a(p) pix_a(p) / 256.0

def pixn_rgb(r, g, b) pix_rgb(r*256, g*256, b*256)
def pixn_rgb_safish(r, g, b) pix_rgb(n_to_byte_top(r), n_to_byte_top(g), n_to_byte_top(b))
def pixn_rgb_safe(r, g, b) pix_rgb(n_to_byte(r), n_to_byte(g), n_to_byte(b))

def pixn_rgba(r, g, b, a) pix_rgba(r*256, g*256, b*256, a*256)
def pixn_rgba_safish(r, g, b, a) pix_rgba(n_to_byte_top(r), n_to_byte_top(g), n_to_byte_top(b), n_to_byte_top(a))
def pixn_rgba_safe(r, g, b, a) pix_rgba(n_to_byte(r), n_to_byte(g), n_to_byte(b), n_to_byte(a))


struct sprite
	pix_t *pixels
	long width
	long height
	long stride

sprite_init(sprite *s, long width, long height)
	s->pixels = Nalloc(pix_t, width*height)
	s->width = width
	s->height = height
	s->stride = width

def sprite_clear(s)
	sprite_clear(s, 0)

sprite_clear(sprite *s, pix_t c)
	pix_t *p = s->pixels
	for long y=0; y<s->height; ++y
		for long x=0; x<s->width; ++x
			*p++ = c
		p += s->stride - s->width

sprite_screen(sprite *s)
	s->width = w
	s->height = h
	s->stride = w
	s->pixels = (pix_t *)pixel(vid, 0, 0)

sprite_clip(sprite *target, sprite *source, sprite *target_full, sprite *source_full, long x, long y)
	*source = *source_full

	sprite_clip_1(x, width, 1)
	sprite_clip_1(y, height, source->stride)

	target->stride = target_full->stride
	target->pixels = target_full->pixels + y*target->stride + x
	target->width = source->width
	target->height = source->height

def sprite_clip_1(x, width, step)
	if x < 0
		source->width += x
		source->pixels -= x * step
		if source->width < 0
			source->width = 0
		x = 0
	long my(x_over) = x + source->width - target_full->width
	if my(x_over) > 0
		source->width -= my(x_over)
		if source->width < 0
			source->width = 0

sprite_blit(sprite *to, sprite *from)
	pix_t *i = from->pixels
	pix_t *o = to->pixels
	long w = imin(from->width, to->width)
	long h = imin(from->height, to->height)
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			*o++ = *i++
		i += from->stride - w
		o += to->stride - w

sprite_blit_transl(sprite *to, sprite *from)
	pix_t *i = from->pixels
	pix_t *o = to->pixels
	long w = imin(from->width, to->width)
	long h = imin(from->height, to->height)
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			pix_t c = *i++
			int a = pix_a(c)
			if a == 0
				*o = c
			 eif a < 255
				pix_t old = *o
				int a1 = 255 - a
				int r = (pix_r(c) * a1 + pix_r(old) * a) / 255
				int g = (pix_g(c) * a1 + pix_g(old) * a) / 255
				int b = (pix_b(c) * a1 + pix_b(old) * a) / 255
				*o = pix_rgb(r, g, b)
			++o
		i += from->stride - w
		o += to->stride - w

sprite_blit_transp(sprite *to, sprite *from)
	pix_t *i = from->pixels
	pix_t *o = to->pixels
	long w = imin(from->width, to->width)
	long h = imin(from->height, to->height)
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			pix_t c = *i++
			int a = pix_a(c)
			if a != 255
				*o = c
			++o
		i += from->stride - w
		o += to->stride - w

def sprite_put(to, from, x, y)
	sprite_put_x(, to, from, x, y)
def sprite_put_transp(to, from, x, y)
	sprite_put_x(_transp, to, from, x, y)
def sprite_put_transl(to, from, x, y)
	sprite_put_x(_transl, to, from, x, y)
def sprite_put_x(plottype, to, from, x, y)
	sprite_put_x(plottype, to, from, x, y, my(source), my(target))
def sprite_put_x(plottype, to, from, x, y, source, target)
	decl(source, sprite)
	decl(target, sprite)
	sprite_clip(target, source, to, from, x, y)
	sprite_blit^^plottype(target, source)
	gr__change_hook()

sprite_gradient(sprite *s, colour c00, colour c10, colour c01, colour c11)
	sprite_gradient_angle(s, c00, c10, c01, c11, 0)

sprite_gradient_angle(sprite *s, colour c00, colour c10, colour c01, colour c11, num angle)
	pix_t *p = s->pixels
	long w = s->width
	long h = s->height
	num r0 = pixn_r(c00), g0 = pixn_g(c00), b0 = pixn_b(c00)
	num r1 = pixn_r(c10), g1 = pixn_g(c10), b1 = pixn_b(c10)
	num r01 = pixn_r(c01), g01 = pixn_g(c01), b01 = pixn_b(c01)
	num r11 = pixn_r(c11), g11 = pixn_g(c11), b11 = pixn_b(c11)

	if angle != 0
		num s = sin(angle), c = cos(angle)
		num r0a = grad_value((s-c+1)/2, (-c-s+1)/2, r0, r1, r01, r11)
		num r1a = grad_value((s+c+1)/2, (-c+s+1)/2, r0, r1, r01, r11)
		num r01a = grad_value((-s-c+1)/2, (c-s+1)/2, r0, r1, r01, r11)
		num r11a = grad_value((-s+c+1)/2, (c+s+1)/2, r0, r1, r01, r11)
		r0 = r0a ; r1 = r1a ; r01 = r01a ; r11 = r11a
		num g0a = grad_value((s-c+1)/2, (-c-s+1)/2, g0, g1, g01, g11)
		num g1a = grad_value((s+c+1)/2, (-c+s+1)/2, g0, g1, g01, g11)
		num g01a = grad_value((-s-c+1)/2, (c-s+1)/2, g0, g1, g01, g11)
		num g11a = grad_value((-s+c+1)/2, (c+s+1)/2, g0, g1, g01, g11)
		g0 = g0a ; g1 = g1a ; g01 = g01a ; g11 = g11a
		num b0a = grad_value((s-c+1)/2, (-c-s+1)/2, b0, b1, b01, b11)
		num b1a = grad_value((s+c+1)/2, (-c+s+1)/2, b0, b1, b01, b11)
		num b01a = grad_value((-s-c+1)/2, (c-s+1)/2, b0, b1, b01, b11)
		num b11a = grad_value((-s+c+1)/2, (c+s+1)/2, b0, b1, b01, b11)
		b0 = b0a ; b1 = b1a ; b01 = b01a ; b11 = b11a

	num dr0 = (r01 - r0) / h, dg0 = (g01 - g0) / h, db0 = (b01 - b0) / h
	num dr1 = (r11 - r1) / h, dg1 = (g11 - g1) / h, db1 = (b11 - b1) / h
	for long y=0; y<h; ++y
		num r = r0, g = g0, b = b0
		num dr = (r1 - r0) / w, dg = (g1 - g0) / w, db = (b1 - b0) / w
		for long x=0; x<w; ++x
			pix_t c = pixn_rgb_safe(r, g, b)
			*p++ = c
			r += dr ; g += dg ; b += db
		p += s->stride - w
		r0 += dr0 ; g0 += dg0 ; b0 += db0
		r1 += dr1 ; g1 += dg1 ; b1 += db1

num grad_value(num x, num y, num v00, num v10, num v01, num v11)
	num v0 = v00 + (v01 - v00) * y
	num v1 = v10 + (v11 - v10) * y
	num v = v0 + (v1 - v0) * x
	return v

sprite_translucent(sprite *s, num a)
	pix_t *p = s->pixels
	long w = s->width
	long h = s->height
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			pix_t c = *p
			int a_old = 255 - pix_a(c)
			int A = (int)(255 - a_old * a) << 24
			c &= ~0xFF000000
			c |= A
			*p++ = c
		p += s->stride - w

sprite_circle(sprite *s)
	pix_t *p = s->pixels
	long w = s->width
	long h = s->height
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			num X = (x*2.0 / w) - 1
			num Y = (y*2.0 / h) - 1
			num R2 = X*X + Y*Y
			if R2 > 1
				*p |= 0xFF000000
			++p
		p += s->stride - w

sprite_circle_aa(sprite *s)
	# this will not be right for non-circular ovals I think
	pix_t *p = s->pixels
	long w = s->width
	long h = s->height
	num u = 4.0/(w+h)
#	num u = 2.0/w
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			num X = (x*2.0 / w) - 1
			num Y = (y*2.0 / h) - 1
			num R = hypot(X, Y)
			if R > 1+u/2
				*p |= 0xFF000000
			 eif R > 1-u/2
				num f = (R - (1-u/2)) / u
				*p |= iclamp(255*f, 0, 255) << 24
			++p
		p += s->stride - w

def sprite_load_png(filename) sprite_load_png(Talloc(sprite), filename)

sprite *sprite_load_png(sprite *s, cstr filename)
	fopen_close(fp, filename)
		sprite_load_png_stream(s, fp)
	return s

def sprite_load_png_stream(in) sprite_load_png_stream(Talloc(sprite), in)

sprite *sprite_load_png_stream(sprite *s, FILE *in)
#	unsigned char header[8]
#	Fread_all(header, 1, 8, in)
#	if png_sig_cmp(header, 0, 8)
#		error("sprite_load_png: not a png image")

	png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, (png_voidp)NULL, NULL, NULL)
	if !png_ptr
		failed("png_create_read_struct")

	png_infop info_ptr = png_create_info_struct(png_ptr)
	if !info_ptr
		png_destroy_read_struct(&png_ptr, (png_infopp)NULL, (png_infopp)NULL)
		failed("png_create_info_struct")

	png_infop end_info = png_create_info_struct(png_ptr)
	if !end_info
		png_destroy_read_struct(&png_ptr, &info_ptr, (png_infopp)NULL)
		failed("png_create_info_struct")

	if setjmp(png_jmpbuf(png_ptr))
		png_destroy_read_struct(&png_ptr, &info_ptr, &end_info)
		error("sprite_load_png: failed")

	png_init_io(png_ptr, in)
#	png_set_sig_bytes(png_ptr, 8)

#	png_read_png(png_ptr, info_ptr, 0, NULL)
	png_read_info(png_ptr, info_ptr)
	png_uint_32 width, height
	int bit_depth, color_type, interlace_type, compression_type, filter_type
	png_get_IHDR(png_ptr, info_ptr, &width, &height, &bit_depth, &color_type, &interlace_type, &compression_type, &filter_type)

	if color_type == PNG_COLOR_TYPE_PALETTE
		debug("png_set_palette_to_rgb")
		png_set_palette_to_rgb(png_ptr)
	if color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8
		debug("png_set_expand_gray_1_2_4_to_8")
		png_set_expand_gray_1_2_4_to_8(png_ptr)
	if png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS)
		debug("png_set_tRNS_to_alpha")
		png_set_tRNS_to_alpha(png_ptr)
	if bit_depth == 16
		debug("png_set_strip_16")
		png_set_strip_16(png_ptr)
	png_set_invert_alpha(png_ptr)
	if among(color_type, PNG_COLOR_TYPE_RGB, PNG_COLOR_TYPE_GRAY, PNG_COLOR_TYPE_PALETTE)
		debug("png_set_add_alpha")
		png_set_add_alpha(png_ptr, 0x0, PNG_FILLER_AFTER)
#	if among(color_type, PNG_COLOR_TYPE_RGB_ALPHA, PNG_COLOR_TYPE_GRAY_ALPHA)
#		debug("png_set_swap_alpha")
#		png_set_swap_alpha(png_ptr)
	if among(color_type, PNG_COLOR_TYPE_GRAY, PNG_COLOR_TYPE_GRAY_ALPHA)
		debug("png_set_gray_to_rgb")
		png_set_gray_to_rgb(png_ptr)
	if among(color_type, PNG_COLOR_TYPE_RGB, PNG_COLOR_TYPE_RGB_ALPHA, PNG_COLOR_TYPE_PALETTE)
		png_set_bgr(png_ptr)

#	# gamma
#	cstr gamma_str
#	double gamma, screen_gamma
#
#	if (gamma_str = getenv("SCREEN_GAMMA")) != NULL
#		screen_gamma = atof(gamma_str)
#	else
#		screen_gamma = 2.2  # A good guess for a PC monitor in a bright office or a dim room
#		# screen_gamma = 2.0  # A good guess for a PC monitor in a dark room
#		# screen_gamma = 1.7 or 1.0  # A good guess for Mac systems
#
#	if png_get_gAMA(png_ptr, info_ptr, &gamma)
#		png_set_gamma(png_ptr, screen_gamma, gamma)
#	else
#		png_set_gamma(png_ptr, screen_gamma, 1/2.2)
##		png_set_gamma(png_ptr, screen_gamma, 0.45455)

	if interlace_type == PNG_INTERLACE_ADAM7
		debug("png_set_interlace_handling")
		int number_of_passes = png_set_interlace_handling(png_ptr)
		use(number_of_passes)

	png_read_update_info(png_ptr, info_ptr)

	png_uint_32 rowbytes = png_get_rowbytes(png_ptr, info_ptr)
	
	if rowbytes != width * 4
		error("sprite_load_png: rowbytes != width * 4 ; %ld != %ld", (long)rowbytes, (long)width*4)

	init(s, sprite, width, height)
	png_bytep row_pointers[height]
	for long y=0; y<(long)height; ++y
		row_pointers[y] = (png_bytep)(s->pixels + y * width)
	
	png_read_image(png_ptr, row_pointers)
	png_read_end(png_ptr, end_info)
	png_destroy_read_struct(&png_ptr, &info_ptr, &end_info)
	
	return s

pix_t pix_transp = pix_rgba(0, 0, 0, 255)

pix_t sprite_at(sprite *s, long x, long y):
	if x < 0 || y < 0 || x >= s->width || y >= s->height:
		return pix_transp
	return s->pixels[y*s->stride + x]

# TODO jpeg
# TODO sprite_put_behind ...

use png.h
export stdarg.h

int root_w, root_h
int w, h
int w_2, h_2
num ox, oy, sc
int _xflip = 0
int _yflip = 0
sprite struct__screen, *screen = &struct__screen

boolean fullscreen = 0
boolean _deco = 1
gr_deco(int _d)
	_deco = _d

gr_fullscreen()
	gr_deco(0)
	fullscreen = 1

# last x and y position
num lx = 0, ly = 0   # current pos
num lx2 = 0, ly2 = 0 # prev pos

boolean _autopaint = 0
num _delay = 0

boolean paint_handle_events = 1

num text_origin_x, text_origin_y, text_wrap_sx
int text_at_col0 = 1

char *vid = NULL

xflip()
	_xflip = !_xflip
	text_origin_x *= -1
yflip()
	_yflip = !_yflip
	text_origin_y *= -1

colour col(colour pixel)

colour bg_col, fg_col

def paper(w, h)
	paper(w, h, white)
def paper(w, h, bg)
	paper(w, h, bg, black)
def paper(w, h, bg, fg)
	gr_init()
	_paper(w, h, bg, fg)
def paper()
	paper(white)
def paper(bg)
	gr_fullscreen()
	paper(0, 0, bg)

def space(w, h)
	space(w, h, black)
def space(w, h, bg)
	paper(w, h, bg, white)
def space()
	paper(black)
	col(white)
def space(bg)
	paper(bg)
	col(white)

num a_pixel = 1

boolean gr_done = 0

def gr_exit(status)
	gr_done = 1
	exit(status)

origin(num _ox, num _oy)
	ox = _ox ; oy = _oy

def home() move(0, 0)
def text_home() move_to_text_origin()

zoom(num _sc)
	sc = _sc
	a_pixel = isd(1)

# TODO independent X and Y scales?
# using macros to define the transforms, like for deg / rad.

Def screen_trans full
 # can change with def screen_trans fast

def SX(x) SX_^^screen_trans(x)
def SY(y) SY_^^screen_trans(y)
def SD(d) SD_^^screen_trans(d)

def SX_fast(x) (int)sx(x)
def SY_fast(y) (int)sy(y)
def SD_fast(d) (int)sd(d)

def SX_full(x) (int)(sx(x)+0.5)
def SY_full(y) (int)(sy(y)+0.5)
def SD_full(d) (int)(sd(d)+0.5)

def sx(x) sx_^^screen_trans(x)
def sy(y) sy_^^screen_trans(y)
def sd(d) sd_^^screen_trans(d)

def sx_fast(x) sx_center(x)
def sy_fast(y) sy_center(y)
def sd_fast(d) d

def sx_full(x) sx_center(sx_flip(sx_zoom(sx_origin(x))))
def sy_full(x) sy_center(sy_flip(sy_zoom(sy_origin(x))))
def sd_full(d) sd_zoom(d)

def sx_origin(x) x-ox
def sx_zoom(x) x*sc
def sx_flip(x) _xflip ? -x-1 : x
def sx_center(x) w_2+x

def sy_origin(y) y-oy
def sy_zoom(y) y*sc
def sy_flip(y) _yflip ? -y-1 : y
def sy_center(y) h_2-1-y

def sd_zoom(d) d*sc


# old sx,sy,sd functions

#num sx(num x)
#	x = (x-ox)*sc
#	return (_xflip ? w_2-x : w_2+x)
#
#num sy(num y)
#	y = (y-oy)*sc
#	return (_yflip ? h_2+y : h_2-y)
#
#num sd(num d)
#	return d*sc

# inverse functions isx isy isd  (not accelerated yet, no need?)

num isx(num sx)
	if _xflip
		sx = w_2-1-sx
	else
		sx = sx-w_2
	return sx/sc+ox

num isy(num sy)
	if _yflip
		sy = sy-h_2
	else
		sy = h_2-1-sy
	return sy/sc+oy

num isd(num sd)
	return sd/sc


def update_last(x, y)
	move(x, y)

move(num x, num y)
	lx2 = lx ; ly2 = ly
	lx = x ; ly = y

# TODO change "last" to "pos" ?
# XXX need (auto) namespaces!
move2(num x1, num y1, num x2, num y2)
	lx2 = x1 ; ly2 = y1
	lx = x2 ; ly = y2

draw(num x, num y)
	line(lx, ly, x, y)

# these circle routines are excessively complicated now!
# I tried to make circle_fill draw `nice' small circles

def disc(x, y, r) circle_fill(x, y, r)
def dot(x, y, r) circle_fill(x, y, r)

# text functions
# XXX should we have a separate text cursor and graphics cursor?
# TODO wrapping

num _xanc = -1, _yanc = 1

num gprint_tab_width = 2  #  * font_height

gprint_anchor(num xanc, num yanc)
	_xanc = xanc; _yanc = yanc

int gprintf(const char *format, ...)
	collect(vgprintf, format)

int vgprintf(const char *format, va_list ap)
	new(b, buffer)
	int len = Vsprintf(b, format, ap)
	buffer_add_nul(b)
	gprint(buffer_get_start(b))
	buffer_free(b)
	return len

# TODO vgprintf


# not sure if adding _font->ascent is the right thing to do
# TODO different anchors
gsay(char *p)
	gprint(p)
	gnl()

# TODO
int gsayf(const char *format, ...)
	collect(vgsayf, format)

# TODO
int vgsayf(const char *format, va_list ap)
	int len = vgprintf(format, ap)
	gnl()
	return len

gnl()
	num dy = -font_height() # * n FIXME
	if _yflip
		dy = -dy
	move(text_origin_x, ly + dy)
#	move(lx, ly + dy)
	text_at_col0 = 1
def gnl(n) gnl() # XXX FIXME

text_origin(num x, num y)
	text_origin_x = x
	text_origin_y = y

move_to_text_origin()
	move(text_origin_x, text_origin_y)



bg(colour bg)
	bg_col = bg

def clear(c)
	bg(c)
	clear()

Clear(colour c)
	clear(c)
	gr_sync()

def pix_clear() pix_clear(bg_col)
pix_clear(colour c)
	bg(c)
	with_pixel_type(pix_clear_1)

def pix_clear_1(pixel_type)
	pixel_type *px = pixel()
	repeat(w*h)
		*px++ = c

# change this to a macro?
gr__change_hook()
	if _autopaint
		paint()
	if _delay
		Sleep(_delay)

def thin()
	width(0)

def triangle(x0, y0, x1, y1, x2, y2)
	move2(x0, y0, x1, y1)
	triangle(x2, y2)

def quad(x0, y0, x1, y1, x2, y2, x3, y3)
	move2(x0, y0, x1, y1)
	quad(x2, y2, x3, y3)

def quad(x2, y2, x3, y3)
	quadrilateral(x2, y2, x3, y3)

gr_fast()
	autopaint(0)
	gr_delay(0)

autopaint(boolean ap)
	_autopaint = ap

def gr_delay() gr_delay(0)
gr_delay(num delay)
	autopaint(1)
	_delay = delay

num
 rb_red_angle, rb_green_angle, rb_blue_angle,
 rb_red_power, rb_green_power, rb_blue_power

colour rb[360]

rainbow_init()
	rb_red_angle = deg2rad(-120)
	rb_green_angle = 0
	rb_blue_angle = deg2rad(120)

	rb_red_power = 1
#	rb_green_power = 0.8
	rb_green_power = 0.9
	rb_blue_power = 1

	for(i, 0, 360)
		rb[i] = _rainbow(deg2rad(i))

def rainbow(a) _rainbow(angle2rad(a))
colour _rainbow(num a)
	num r = rb_red_power * (cos(a-rb_red_angle)+1)/2
	num g = rb_green_power * (cos(a-rb_green_angle)+1)/2
	num b = rb_blue_power * (cos(a-rb_blue_angle)+1)/2
	return rgb(r, g, b)

random_colour()
	rgb(rand(), rand(), rand())

def grey(p) rgb(p, p, p)

# I'm not sure if this HSV model is correct / standard
def hsv(hue, sat, val) _hsv(angle2rad(hue), sat, val)
colour _hsv(num hue, num sat, num val)
	num r = rb_red_power * (cos(hue-rb_red_angle)+1)/2
	num g = rb_green_power * (cos(hue-rb_green_angle)+1)/2
	num b = rb_blue_power * (cos(hue-rb_blue_angle)+1)/2
	r *= sat
	g *= sat
	b *= sat
	r = 1-(1-r)*(1-val)
	g = 1-(1-g)*(1-val)
	b = 1-(1-b)*(1-val)
	return rgb(r, g, b)

def point()
	point(lx,ly)

# dodgy, need a better way?
def triangle(a, b, c)
	triangle(a.lx, a.ly, b.lx, b.ly, c.lx, c.ly)

def circle(r)
	circle(lx, ly, r)

def circle_fill(r)
	circle_fill(lx, ly, r)

def disc(r)
	disc(lx, ly, r)

boolean curve_at_start = 1
def curve()
	curve_at_start = 1
curve(num x, num y)
	if curve_at_start
		move(x, y)
		curve_at_start = 0
	 else
	 	draw(x, y)

def for_pixels(px)
	pixel_type *px = pixel()
	pixel_type *my(end) = px + w*h
	for ; px != my(end) ; ++px
		.
export X11/Xlib.h
export X11/Xutil.h
export X11/extensions/XShm.h
use sys/ipc.h
use sys/shm.h
#use X11/Xutil.h - what was this for, again?  I think something in my graph program...
use string.h
use stdio.h
#ld -L/usr/X11R6/lib -lX11 -lXext ??



Display *display
Window root_window, window
Visual *visual
XVisualInfo *visual_info
int depth
num pixel_size
int pixel_size_i
Pixmap gr_buf
Colormap colormap
GC gc
XGCValues gcvalues
XFontStruct *_font = NULL
XColor color
int screen_number
XShmSegmentInfo *shmseginfo = NULL
Atom wm_protocols, wm_delete
int x11_fd

font(cstr name, int size)
	let(xfontname, format("-*-%s-r-normal--%d-*-100-100-p-*-iso8859-1", name, size))
	xfont(xfontname)
	Free(xfontname)

#local vec struct__gr__stack
#local vec *gr__stack = &struct__gr__stack
# # of gc
#gr_push()
#	*(GC *)vec_push(gc_stack) = gc
#gr_pop()
#	gc = *(GC *)vec_top(gc_stack, 0)
#	vec_pop(gr__stack)
#
#gr_

boolean fullscreen_grab_keyboard = 1
boolean gr_alloced = 0

gr_init()
#	vec_init(gr__stack, sizeof(GC), 8)
	
	if (display = XOpenDisplay(NULL)) == NULL
		error("cannot open display")

	x11_fd = ConnectionNumber(display)

	screen_number = DefaultScreen(display)
	visual = DefaultVisual(display, screen_number)

	int nitems_return
	XVisualInfo vinfo_template
	vinfo_template.visualid = XVisualIDFromVisual(visual);
	visual_info = XGetVisualInfo(display, VisualIDMask, &vinfo_template, &nitems_return)
	if visual_info == NULL || nitems_return != 1
		failed("XGetVisualInfo")

	depth = DefaultDepth(display, screen_number)
	white = WhitePixel(display, screen_number)  # TODO remove this, colours_init() can do it?
	black = BlackPixel(display, screen_number)
	colormap = DefaultColormap(display, screen_number)

	# not sure if the following is correct for all visuals, or how to get it more sensibly
	pixel_size = depth / 8.0
	if pixel_size == 3
		pixel_size = 4
	pixel_size_i = (int)pixel_size

	gc = DefaultGC(display, screen_number)
	gcvalues.function = GXcopy
	gcvalues.foreground = white
	gcvalues.cap_style = CapNotLast
	gcvalues.line_width = _line_width
	XChangeGC(display, gc, GCFunction|GCForeground|GCCapStyle|GCLineWidth, &gcvalues)
	
	#xfont("-adobe-helvetica-medium-r-normal--11-80-100-100-p-56-iso8859-1")

	root_window = DefaultRootWindow(display)
	colours_init()

	font("helvetica-medium", 12)

	XWindowAttributes window_attributes
	if XGetWindowAttributes(display, root_window, &window_attributes)
		root_w = window_attributes.width
		root_h = window_attributes.height

	rainbow_init()

	Atexit(gr_at_exit)

	event_handler_init()

	gr_alloced = 1

gr_at_exit()
	if !gr_done
		Paint()
		event_loop()
	gr_free()

_paper(int width, int height, colour _bg_col, colour _fg_col)
	if width
		w = width ; h = height
	 else
		w = root_w ; h = root_h

	bg_col = _bg_col ; fg_col = _fg_col
	w_2 = w/2 ; h_2 = h/2
	ox = oy = 0
	sc = 1
	text_origin(-w_2, h_2)
	text_wrap_sx = width

	#window = XCreateSimpleWindow(display, root_window, 0, 0, w, h, 0, white, black)

	unsigned long valuemask = 0
	XSetWindowAttributes attributes
	if !_deco
		valuemask |= CWOverrideRedirect
		attributes.override_redirect = True
	window = XCreateWindow(display, root_window, 0, 0, w, h, 0, CopyFromParent, InputOutput, CopyFromParent, valuemask, &attributes)
#	XSetWindowBorderWidth(display, window, 0)

	int shm_major, shm_minor
	Bool shm_pixmaps

	Bool shm_ok = XShmQueryVersion(display, &shm_major, &shm_minor, &shm_pixmaps) && shm_pixmaps ==True && XShmPixmapFormat(display) == ZPixmap

	if shm_ok
		shmseginfo = Talloc(XShmSegmentInfo)
		bzero(shmseginfo)

		shmseginfo->shmid = shmget(IPC_PRIVATE, w * h * pixel_size, IPC_CREAT|0777)
		if shmseginfo->shmid < 0
			failed("shmget")
		shmseginfo->shmaddr = shmat(shmseginfo->shmid, NULL, 0)
		vid = (char *)shmseginfo->shmaddr
		if !vid
			failed("shmat")
		shmseginfo->readOnly = False

		if !XShmAttach(display, shmseginfo)
			failed("XShmAttach")

		gr_buf = XShmCreatePixmap(display, window, vid, shmseginfo, w, h, depth)
	 else
		gr_buf = XCreatePixmap(display, window, w, h, depth)

#	XSetWindowBackgroundPixmap(display, window, gr_buf)

	XSizeHints *normal_hints ; XWMHints *wm_hints ; XClassHint  *class_hints
	normal_hints = XAllocSizeHints()
	wm_hints = XAllocWMHints()
	class_hints = XAllocClassHint()
	normal_hints->flags = PPosition | PSize
	wm_hints->initial_state = NormalState
	wm_hints->input = True
	wm_hints->flags = StateHint | InputHint
	class_hints->res_name = program ; class_hints->res_class = program

	XTextProperty xtp_name
	XStringListToTextProperty(&program, 1, &xtp_name)
	XSetWMProperties(display, window, &xtp_name, &xtp_name, argv, argc, normal_hints, wm_hints, class_hints)
	wm_protocols = XInternAtom(display, "WM_PROTOCOLS", False)
	wm_delete = XInternAtom(display, "WM_DELETE_WINDOW", False)
	XSetWMProtocols(display, window, &wm_delete, 1)

	XSelectInput(display, window, ExposureMask|ButtonPressMask|ButtonReleaseMask|ButtonMotionMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask)
	XMapWindow(display, window)

	if fullscreen && fullscreen_grab_keyboard
		XGrabKeyboard(display, window, True, GrabModeAsync, GrabModeAsync, CurrentTime)

	sprite_screen(screen)

	clear()
	Paint()

gr_free()
	if gr_alloced
		if fullscreen && fullscreen_grab_keyboard
			XUngrabKeyboard(display, CurrentTime)
		if visual_info
			XFree(visual_info)
		if shmseginfo
			XShmDetach(display, shmseginfo)
		XFreePixmap(display, gr_buf)
		if shmseginfo
			shmdt(shmseginfo->shmaddr)
			shmctl(shmseginfo->shmid, IPC_RMID, NULL)
			Free(shmseginfo)
#		XFreeGC(display, gc)
		XDestroyWindow(display, window)
		XCloseDisplay(display)
		gr_alloced = 0

xfont(const char *font_name)
#	gnl()
	# XXX does this have a memory leak?
	if (_font = XLoadQueryFont(display, font_name)) == NULL
		error("cannot load font %s", font_name)
	gcvalues.font = _font->fid
	XChangeGC(display, gc, GCFont, &gcvalues)
#	gnl(-1)
def font(name) xfont(name)

colour rgb(num red, num green, num blue)
	colour c
	int r = iclamp(red*256, 0, 255)
	int g = iclamp(green*256, 0, 255)
	int b = iclamp(blue*256, 0, 255)
	if depth >= 24
		c = r<<16 | g<<8 | b
		col(c)
	 else
		# XXX this way is slow and crap!
		char name[8]
		snprintf(name, sizeof(name), "#%02x%02x%02x", r, g, b)
		c = coln(name)
	return c

colour col(colour pixel)
	gcvalues.foreground = pixel
	XChangeGC(display, gc, GCForeground, &gcvalues)
	fg_col = pixel
	return pixel

colour coln(char *name)
	# TODO cache colours in a hashtable to speed this up?
	if XAllocNamedColor(display, colormap, name, &color, &color)
		return col(color.pixel)
	return white

line_width(num width)
	_line_width = width
	int w = SD(width)
	gcvalues.line_width = w
	XChangeGC(display, gc, GCLineWidth, &gcvalues)
def width(w) line_width(w)
num _line_width = 0

rect(num x, num y, num w, num h)
	move(x, y)
	draw(x+w-1, y)
	draw(x+w-1, y+h-1)
	draw(x, y+h-1)
	draw(x, y)

rect_fill(num x, num y, num w, num h)
	# this impl won't work with a rotated transform
	int X, Y, W, H
	X = SX(x) ; Y = SY(y) ; W = SD(w) ; H = SD(h)
	if !_yflip
		Y -= H
	XFillRectangle(display, gr_buf, gc, X, Y, W, H)
	gr__change_hook()

line(num x0, num y0, num x1, num y1)
	XDrawLine(display, gr_buf, gc, SX(x0), SY(y0), SX(x1), SY(y1))
	update_last(x1, y1)
	gr__change_hook()

point(num x, num y)
	XDrawPoint(display, gr_buf, gc, SX(x), SY(y))
	gr__change_hook()

circle(num x, num y, num r)
	int x0, y0, x1, y1, w, h, tmp
	x0 = SX(x-r) ; y0 = SY(y-r)
	x1 = SX(x+r) ; y1 = SY(y+r)
	if (x1 < x0)
		tmp = x0 ; x0 = x1 ; x1 = tmp
	if (y1 < y0)
		tmp = y0 ; y0 = y1 ; y1 = tmp
	w = x1 - x0
	h = y1 - y0
	# printf("%d %d %d %d\n", x0, y0, w, h)
	if w == 0
		# && h = 0, I hope!
		XDrawPoint(display, gr_buf, gc, x0, y0)
	else
		XDrawArc(display, gr_buf, gc, x0, y0, w, h, 0, 64*360)
	#rgb(1, 0, 0)
	#point(x, y)
	#rgb(1, 1, 1)
	gr__change_hook()

circle_fill(num x, num y, num r)
	int old_width = _line_width
	line_width(0)
	int x0, y0, x1, y1, w, h, tmp
	x0 = SX(x-r) ; y0 = SY(y-r)
	x1 = SX(x+r) ; y1 = SY(y+r)
	if (x1 < x0)
		tmp = x0 ; x0 = x1 ; x1 = tmp
	if (y1 < y0)
		tmp = y0 ; y0 = y1 ; y1 = tmp
	w = x1 - x0
	h = y1 - y0
	# printf("%d %d %d %d\n", x0, y0, w, h)
	if w == 0
		# && h = 0, I hope!
		XDrawPoint(display, gr_buf, gc, x0, y0)
	 else
		XFillArc(display, gr_buf, gc, x0, y0, w, h, 0, 64*360)
		XDrawArc(display, gr_buf, gc, x0, y0, w, h, 0, 64*360)
	#rgb(1, 0, 0)
	#point(x, y)
	#rgb(1, 1, 1)
	gr__change_hook()
	line_width(old_width)

# polygons, outline and filled...  but how to do hollow polygons?  ah, who cares!
# we'll paint the lakes over the land...

# FIXME why are these polygons not implemented using vec? maybe I did this first?

# should really try to do this generically
# this really wants to be written in C++
struct polygon
	XPoint *points
	int n_points
	int space

polygon_start(struct polygon *p, int n_points_estimate)
	p->points = Malloc(n_points_estimate * sizeof(XPoint))
	p->n_points = 0
	p->space = n_points_estimate

# should be `local' (static) but it's not working right,
# 1. brace doesn't insert void automatically if there's a `local'
# 2. brace_header extracts static / local functions too
_polygon_point(struct polygon *p, short x, short y)
	if p->n_points == p->space
		p->space = p->n_points * 2
		Realloc(p->points, p->space * sizeof(XPoint))
	XPoint *point = p->points + p->n_points
	point->x = x
	point->y = y
	++p->n_points

polygon_point(struct polygon *p, num x, num y)
	_polygon_point(p, SX(x), SY(y))

polygon_draw(struct polygon *p)
	# close the polygon
	XPoint *first_point = p->points
	_polygon_point(p, first_point->x, first_point->y)
	# and draw it
	XDrawLines(display, gr_buf, gc, p->points, p->n_points, CoordModeOrigin)
	# now unclose it again!
	--(p->n_points)
	gr__change_hook()

polygon_fill(struct polygon *p)
	XFillPolygon(display, gr_buf, gc, p->points, p->n_points, Complex, CoordModeOrigin)
	# make sure the thing shows up if it's small
	XDrawPoint(display, gr_buf, gc, p->points->x, p->points->y)
	# should probably use Nonconvex instead of Complex,
	# it might be faster
	gr__change_hook()

polygon_end(struct polygon *p)
	Free(p->points)

def gprint_debug()
	colour oldcol = fg_col
	yellow()
	XFillRectangle(display, gr_buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(_yanc+1)/2.0+0.5)-_font->ascent, text_width, _font->ascent+_font->descent)
	red()
	XFillRectangle(display, gr_buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(_yanc+1)/2.0+0.5)-_font->ascent, text_width, _font->ascent)
	col(oldcol)

def gprint_debug()
	void()

num text_width(char *p)
	# tab support, limited to indent for now!
	int tabs_width = 0
	while *p == '\t'
		tabs_width += gprint_tab_width * font_height()
		++p

	int len = strlen(p)
	return tabs_width + isd(XTextWidth(_font, p, len))

# this one doesn't do word wrapping but does do anchors!
gprint(char *p)
#	gprint_debug()

	# tab support, limited to indent for now!
	while *p == '\t'
		lx += gprint_tab_width * font_height()
		++p

	int len = strlen(p)
	int text_width = XTextWidth(_font, p, len)

#	XDrawString(display, gr_buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+(_font->ascent+_font->descent)*(_yanc-1)/2.0+1)+_font->ascent, p, len)
# the anchoring uses the ascent portion of the box only, this looks better
	XDrawString(display, gr_buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(_yanc+1)/2.0+0.5), p, len)
	move(lx + text_width, ly)
	gr__change_hook()

## not sure if adding _font->ascent is the right thing to do
## TODO different anchors
#gprint(char *p)
#	char *q
#	int len
#	repeat
#		len = strcspn(p, " \n")
#		q = p + len
#		if *q == ' '
#			++len
#		int text_width = XTextWidth(_font, p, len)
#		if text_width + SX(lx) > text_wrap_sx && !text_at_col0
#			gnl()
#		eif len
#			text_at_col0 = 0
#		if len
#			XDrawString(display, gr_buf, gc, SX(lx), SY(ly)+_font->ascent, p, len)
#			move(lx + isd(text_width), ly)
#		if *q == '\n'
#			gnl()
#		 eif *q == '\0' || len == 0
#			break
#		p = q+1
#	gr__change_hook()

num font_height()
	return isd(_font->ascent + _font->descent)

# TODO bbox function for fonts / text

paint()
	paint_sync(1)

Paint()
	paint_sync(2)

paint_sync(int syncage)
	XCopyArea(display, gr_buf, window, gc, 0, 0, w, h, 0, 0)
#	XClearWindow(display, window)

	# XClearWindow doesn't work to render the pixmap, I think the X server
	# was trying to be clever and remembered that it hadn't changed the
	# pixmap or the window since it was last painted.  but I changed it
	# through shm!

	which syncage
	2	gr_sync()
	1	XFlush(display)

	if paint_handle_events || veclen(gr_need_delay_callbacks)
		handle_events(0)


gr_sync()
	XSync(display, False)

gr_flush()
	XFlush(display)

clear()
	colour fg = fg_col
	col(bg_col)
	XFillRectangle(display, gr_buf, gc, 0, 0, w, h)
	col(fg)
	gr__change_hook()
	# need to call paint also to update the actual window

triangle(num x2, num y2)
	XPoint p[3]
	xpoint_set(p[0], lx2, ly2)
	xpoint_set(p[1], lx, ly)
	xpoint_set(p[2], x2, y2)
	XFillPolygon(display, gr_buf, gc, p, 3, Convex, CoordModeOrigin)
	move2(lx, ly, x2, y2)

def xpoint_set(xpoint, X, Y)
	xpoint.x = SX(X)
	xpoint.y = SY(Y)

quadrilateral(num x2, num y2, num x3, num y3)
	XPoint p[4]
	xpoint_set(p[0], lx2, ly2)
	xpoint_set(p[1], lx, ly)
	xpoint_set(p[2], x2, y2)
	xpoint_set(p[3], x3, y3)
	XFillPolygon(display, gr_buf, gc, p, 4, Convex, CoordModeOrigin)
	move2(x2, y2, x3, y3)

def pixel(X, Y) pixel(vid, X, Y)
def pixel(vid, X, Y) (void *)(((char *)vid) + ((int)Y*w + (int)X) * pixel_size_i)
def pixel() pixel(0, 0)
def pixel(pixmap) pixel(pixmap, 0, 0)

# type can be png, gif, jpeg ...


dump_img(cstr type, cstr file, num scale)
	cstr file_out = ""
	cstr scale_filter = ""
	cstr tool
	if cstr_eq(type, "png")
		tool = "pnmtopng"
	 eif cstr_eq(type, "gif")
		tool = "ppmquant 256 | ppmtogif"
	 eif cstr_eq(type, "jpeg")
		tool = "pnmtojpeg"
	 else
		error("dump_img: unsupported image type: %s", type)
		return  # keep gcc happy
	if file
		new(b, buffer, 256)
		system_quote(file, b)
		cstr file_q = buffer_to_cstr(b)
		file_out = format("> %s", file_q)
		Free(file_q)
	if scale != 1
		scale_filter = format("pnmscale %f |", scale)
	Systemf(SH_QUIET "xwd -id %ld | xwdtopnm | %s %s %s", window, scale_filter, tool, file_out)
	 # pnmcrop -black
	if file
		Free(file_out)
	if scale != 1
		Free(scale_filter)

def dump_img()
	dump_img("png")
def dump_img(type)
	dump_img(type, NULL)
def dump_img(type, file)
	dump_img(type, file, 1)

def with_pixel_type(macro)
	if depth > 16
		macro(ulong)
	 eif depth == 16
		macro(ushort)
	 eif depth == 8
		macro(uchar)
	 else
		error("unsupported video depth: %d", depth)

boolean gr_do_delay_done
gr_do_delay(num dt)
	gr_do_delay_done = 0
	thunk old_handler = key_handler_default
	key_handler_default = thunk(gr_do_delay_handler)
	if dt == time_forever
		while !gr_do_delay_done
#			warn("gr_do_delay forever looping calling handle_events: veclen(gr_need_delay_callbacks) = %d", veclen(gr_need_delay_callbacks))
			handle_events(1)
#			int n = handle_events(1)
#			warn("  %d", n)
	 else
		num t = rtime()
		num t1 = t + dt
		while t < t1 && !gr_do_delay_done
			if events_queued(0) || veclen(gr_need_delay_callbacks) || can_read(x11_fd, t1-t)
#				warn("gr_do_delay %f looping calling handle_events", dt)
				handle_events(0)
			t = rtime()
	key_handler_default = old_handler

void *gr_do_delay_handler(void *obj, void *a0, void *event)
	use(obj, a0)
	gr_event *e = event
	if e->type == KeyPress:
		gr_do_delay_done = 1
	return thunk_yes

struct gr_event
	int type  # KeyPress, ButtonPress, ButtonRelease, MotionNotify
	int which
	int x, y
	int state
	long time

boolean gr_key_ignore_release = 0
boolean gr_key_auto_repeat = 0

# controller -------------------------------------------------

controller *control = &control_normal

struct controller
	thunk keyboard
	thunk mouse

controller control_null, control_normal

control_init()
	control_null = (controller){ thunk(), thunk() }
	control_normal = (controller){ thunk(key_handler_main), thunk(mouse_handler_main) }
	key_handlers_init()
	mouse_handlers_init()

control_default:
	key_handlers_default()
	mouse_handlers_default()

control_ignore:
	key_handlers_ignore()
	mouse_handlers_ignore()

# event handler ----------------------------------------------

event_handler_init()
	init(gr_need_delay_callbacks, vec, gr_event_callback, 4)
	control_init()

event_loop()
	while !gr_done
		handle_events(1)
		# FIXME it was busy waiting!  whoops.  (fixed)
		# select for next event / other IO events / timeout
		# include need_delay_callbacks in timeouts
		# allow to work with scheduler / coros, but don't depend on coros..?

# FIXME maybe have a wait_for_events() function instead of that boolean?  or a config variable?

int handle_events(boolean wait_for_event)
	int n = gr_call_need_delay_callbacks()
	while !gr_done && handle_event_maybe(wait_for_event)
		++n
		wait_for_event = 0
	return n

# this is to hack around dodgy X auto-repeat -----------------

num gr_need_delay_callbacks_sleep = 0.001   # 1 ms
vec struct__gr_need_delay_callbacks,
 *gr_need_delay_callbacks = &struct__gr_need_delay_callbacks

struct gr_event_callback
	thunk t
	gr_event e
	num time

int gr_call_need_delay_callbacks()
	int n = 0
	size_t old_size = veclen(gr_need_delay_callbacks)
	for_vec(i, gr_need_delay_callbacks, gr_event_callback)
		if thunk_call(&i->t, &i->e)
			++n
	vec_shift(gr_need_delay_callbacks, old_size)
	return n

# simple input functions -------------------------------------

int gr_getc_char
int gr_getc()
	gr_getc_char = -1
	thunk old_handler = key_handler_default
	key_handler_default = thunk(gr_getc_handler)
	while gr_getc_char < 0
		handle_events(1)
	key_handler_default = old_handler
	return gr_getc_char

void *gr_getc_handler(void *obj, void *a0, void *event)
	use(obj, a0)
	gr_event *e = event
	if e->type == KeyPress
		gr_getc_char = e->which
	return thunk_yes

# event handler ----------------------------------------------


XEvent x_event

int events_queued(boolean wait_for_event)
#	return XEventsQueued(display, QueuedAfterReading)
#	warn("events_queued: wait_for_event = %d", wait_for_event)
#	int n = XEventsQueued(display, wait_for_event||can_read(x11_fd) ? QueuedAfterReading : QueuedAlready)
	int n = XEventsQueued(display, QueuedAlready)
#	warn("   = %d", n)
	if !n:
#		warn("  selecting...")
		num timeout = wait_for_event && !veclen(gr_need_delay_callbacks) ? time_forever : 0
		gr_flush()
		if can_read(x11_fd, timeout):
#			warn("  reading...")
			n = XEventsQueued(display, QueuedAfterReading)
#			warn("  n = %d", n)
	return n
		# is can_read necessary?

boolean handle_event_maybe(boolean wait_for_event)
	int n = events_queued(wait_for_event)
	if n
		handle_event()
	 else
		gr_flush()
	return n

#handle_event()
#	XNextEvent(display, &x_event)
#	which x_event.type
#	Expose	if x_event.xexpose.count == 0
#			paint()

handle_event()
	XNextEvent(display, &x_event)
#	if x_event.type != NoExpose
#		debug("handling event: %s", event_type_name(x_event.type))
	switch x_event.type
	ClientMessage	.
		if x_event.xclient.message_type == wm_protocols && x_event.xclient.format == 32 && (Atom)x_event.xclient.data.l[0] == wm_delete
			quit(NULL, NULL, &x_event)
		 else
			debug("unhandled %s event: %s", event_type_name(x_event.type), XGetAtomName(display, x_event.xclient.message_type))
		break
	ConfigureNotify	.
		skip_to_last_event(x_event, ConfigureNotify)
		configure_notify()
		break
	Expose	.
	GraphicsExpose	.
		if x_event.xexpose.count == 0
			paint()
		break
	NoExpose	.
		break
	MapNotify	.
		break
	UnmapNotify	.
		break
	ReparentNotify	.
		break

	KeyRelease	.
	KeyPress	.
			gr_event e =
				x_event.type, x_event.xkey.keycode, -1, -1,
				x_event.xkey.state, x_event.xkey.time
			thunk_call(&control->keyboard, &e)
		break

	MotionNotify	.
		# FIXME this is dodgy, we could skip a release/press pair...
		skip_to_last_event(x_event, MotionNotify)
	ButtonPress	.
	ButtonRelease	.
			gr_event e =
				x_event.type, x_event.xbutton.button,
				x_event.xbutton.x, x_event.xbutton.y,
				x_event.xbutton.state, x_event.xkey.time
			thunk_call(&control->mouse, &e)
		break

	else	.
		debug("unhandled %s event", event_type_name(x_event.type))

def skip_to_last_event(x_event, type)
	while XCheckTypedEvent(display, type, &x_event)
		.

# key handlers -----------------------------------------------

num gr_key_auto_repeat_avoidance_delay = 1.99   # in ms  XXX X is evil

def n_key_events 2
int key_first, key_last
thunk (*key_handlers)[n_key_events]
char *key_down
thunk key_handler_default
def gr_n_keys key_last-key_first+1

key_handlers_init()
	XDisplayKeycodes(display, &key_first, &key_last)
	key_handlers = (void*)Nalloc(thunk, gr_n_keys*n_key_events)
	key_down = Zalloc(char, gr_n_keys)
	key_handlers_default()

cstr quit_key = "Escape"

key_handlers_default()
	key_handlers_ignore()
	key_handler(quit_key, KeyPress) = thunk(quit)

key_handlers_ignore()
	for(i, 0, gr_n_keys)
		for(j, 0, n_key_events)
			key_handlers[i][j] = thunk()
	key_handler_default = thunk()

void *quit(void *obj, void *a0, void *event)
	use(obj, a0, event)
	gr_exit(0)
	return thunk_yes

def key_handler(keystr, event_type) key_handlers[keystr_ix(keystr)][key_event_type_ix(event_type)]
def key_handler_keysym(keysym, event_type) key_handlers[keysym_ix(keystr)][key_event_type_ix(event_type)]

int keystr_ix(cstr keystr)
	return XKeysymToKeycode(display, XStringToKeysym(keystr)) - key_first
int keysym_ix(KeySym keysym)
	return XKeysymToKeycode(display, keysym) - key_first

int key_event_type_ix(int event_type)
	which event_type
	KeyPress	event_type = 0
	KeyRelease	event_type = 1
	else	error("unknown key event type: %d = %s", event_type, event_type_name(event_type))
	return event_type

void *key_handler_main(void *obj, void *a0, void *event)
	use(obj);use(a0)
	static int last_release_key = -1, last_release_time = -1
	static num last_release_time_real = -1
	int is_callback = p2i(a0)
	gr_event *e = event
	boolean ignore = 0
	int event_type = 0

	which e->type
	KeyPress	.
		event_type = 0
		if gr_key_auto_repeat == 0 && last_release_key == e->which &&
		  e->time - last_release_time <= (int)gr_key_auto_repeat_avoidance_delay
			ignore = 1
		 eif key_down[e->which-key_first]
			key_event_debug("ignoring %s - key already down: %s", e)
			ignore = 1
		if !ignore
#			debug("setting key down %s", key_string(e->which))
			key_down[e->which-key_first] = 1
		last_release_key = -1

	KeyRelease	.
		event_type = 1
		if !key_down[e->which-key_first]
			key_event_debug("ignoring %s - key not down: %s", e)
			ignore = 1
		boolean push_callback = 0
		if gr_key_auto_repeat == 0
#			debug("gr_key_auto_repeat is off - good!")
			# this is ugly, silly X.
			# XXX it is still not 100% reliable if many keys pressed at once.
			# maybe check KeyRelease with XQueryKeymap :(
			# http://www.ypass.net/blog/2009/06/detecting-xlibs-keyboard-auto-repeat-functionality-and-how-to-fix-it/
			if is_callback
#				debug("key_handler_main in callback %s %s", key_string(last_release_key), key_string(e->which))
				if last_release_key == -1
					ignore = 1
				 eif rtime()-last_release_time_real <= gr_key_auto_repeat_avoidance_delay/1000.0
#					debug("callback came too soon - will push callback again")
					push_callback = 1
			 else
				push_callback = 1

			if push_callback
#				debug("pushing callback")
				if !is_callback
					last_release_time_real = rtime()
				gr_event_callback *cb = Talloc(gr_event_callback)
				cb->t = thunk(key_handler_main, NULL, i2p(1))
				cb->e = *e
				cb->time = rtime()
				vec_push(gr_need_delay_callbacks, *cb)
				ignore = 1
		if !ignore
			key_down[e->which-key_first] = 0
#			debug("clearing key down %s", key_string(e->which))
		if !ignore || push_callback
			last_release_key = e->which
			last_release_time = e->time
#		 else
#			debug("ignoring KeyRelease")
		if gr_key_ignore_release
			ignore = 1

	if !ignore && XKeycodeToKeysym(display, e->which, e->state & ShiftMask && 1) == NoSymbol
		ignore = 1

	if ignore
		return thunk_yes

	thunk *handler = &key_handlers[e->which-key_first][event_type]
	void *rv = thunk_call(handler, e)
	if !rv
		rv = thunk_call(&key_handler_default, e)
	if !rv
		key_event_debug("unhandled %s: %s", e)
	return rv

key_event_debug(cstr format, gr_event *e)
	use(format)
	cstr key_string = event_key_string(e)
	if key_string != NULL  # ignore unmapped keys
		debug(format, event_type_name(e->type), key_string)

# TODO allow programs to handle all keys (or all typing keys, etc)
# with a single handler function, not one for each key!  and same for mouse


# mouse handlers --------------------------------------------

# TODO move part to main event.b

def n_mouse_events 3
def mouse_first 1
def mouse_last 3
def gr_n_mouse_buttons mouse_last-mouse_first+1
thunk mouse_handlers[gr_n_mouse_buttons][n_mouse_events]
thunk mouse_handler_default

mouse_handlers_init()
	mouse_handlers_default()

mouse_handlers_default()
	mouse_handlers_ignore()

mouse_handlers_ignore()
	for(i, 0, gr_n_mouse_buttons)
		for(j, 0, n_mouse_events)
			mouse_handlers[i][j] = thunk()
	mouse_handler_default = thunk()

def mouse_handler(button, event_type) mouse_handlers[button-mouse_first][mouse_event_type_ix(event_type)]

int mouse_event_type_ix(int event_type)
	which event_type
	ButtonPress	event_type = 0
	ButtonRelease	event_type = 1
	MotionNotify	event_type = 2
	else	error("unknown mouse event type: %d = %s", event_type, event_type_name(event_type))
	return event_type

void *mouse_handler_main(void *obj, void *a0, void *event)
	use(obj);use(a0)
	static int button = 0
	gr_event *e = event
	boolean ok = 0
	int event_type = 0
	which e->type
	ButtonPress	.
		event_type = 0
		if button != 0
			debug("press %d then press %d - reset", button, e->which)
			button = 0
		 else
			button = e->which
			ok = 1
	ButtonRelease	.
		event_type = 1
		if button == 0
			debug("no press then release b%d - reset", e->which)
		 eif e->which != button
			debug("press b%d then release b%d - reset", button, e->which)
		 else
			ok = 1
		button = 0
	MotionNotify	.
		event_type = 2
		if button == 0
			debug("no press then drag b%d - reset", e->which)
		 else
			e->which = button
			ok = 1
	if ok && e->type != MotionNotify && !tween(e->which, mouse_first, mouse_last)
		debug("unhandled %s: b%d unknown", event_type_name(e->type), e->which)
		return thunk_no
	if ok
		thunk *handler = &mouse_handlers[e->which-mouse_first][event_type]
		void *rv = thunk_call(handler, e)
		if !rv
			rv = thunk_call(&mouse_handler_default, e)
		if !rv
			debug("unhandled %s: b%d", event_type_name(e->type), e->which)
		return rv
			
	return thunk_yes  # ignored ~= handled


# recentering when the window is resized ---------------------

configure_notify()
	int _x, _y
	Window _root
	unsigned int _border, _depth, new_width, new_height

	debug("configure notify")

	XGetGeometry(display, window, &_root, &_x, &_y, &new_width, &new_height, &_border, &_depth)

	if (int)new_width != w || (int)new_height != h
		debug("window resized to %d %d - ignored for now", new_width, new_height)
#		w = new_width; h = new_height
#		calculate_viewpoint_transform()
#		redraw(True, True)

# event type names ---------------------------------------

cstr event_type_name(int type)
	foraryp(i, event_type_names)
		if i->k == type
			return i->v
	return NULL

long2cstr event_type_names[] =
	{ KeyPress, "KeyPress" },
	{ KeyRelease, "KeyRelease" },
	{ ButtonPress, "ButtonPress" },
	{ ButtonRelease, "ButtonRelease" },
	{ MotionNotify, "MotionNotify" },
	{ EnterNotify, "EnterNotify" },
	{ LeaveNotify, "LeaveNotify" },
	{ FocusIn, "FocusIn" },
	{ FocusOut, "FocusOut" },
	{ KeymapNotify, "KeymapNotify" },
	{ Expose, "Expose" },
	{ GraphicsExpose, "GraphicsExpose" },
	{ NoExpose, "NoExpose" },
	{ VisibilityNotify, "VisibilityNotify" },
	{ CreateNotify, "CreateNotify" },
	{ DestroyNotify, "DestroyNotify" },
	{ UnmapNotify, "UnmapNotify" },
	{ MapNotify, "MapNotify" },
	{ MapRequest, "MapRequest" },
	{ ReparentNotify, "ReparentNotify" },
	{ ConfigureNotify, "ConfigureNotify" },
	{ ConfigureRequest, "ConfigureRequest" },
	{ GravityNotify, "GravityNotify" },
	{ ResizeRequest, "ResizeRequest" },
	{ CirculateNotify, "CirculateNotify" },
	{ CirculateRequest, "CirculateRequest" },
	{ PropertyNotify, "PropertyNotify" },
	{ SelectionClear, "SelectionClear" },
	{ SelectionRequest, "SelectionRequest" },
	{ SelectionNotify, "SelectionNotify" },
	{ ColormapNotify, "ColormapNotify" },
	{ ClientMessage, "ClientMessage" },
	{ MappingNotify, "MappingNotify" },

cstr event_key_string(gr_event *e)
	int shift = e->state & ShiftMask && 1
	return key_string(e->which, shift)

def key_string(keycode) key_string(keycode, 0)
cstr key_string(int keycode, boolean shift)
	return XKeysymToString(XKeycodeToKeysym(display, keycode, shift))

num turtle_a = 0
num turtle_pendown = 1

north(num d)
	north()
	forward(d)
def north() _turn_to(0)

east(num d)
	east()
	forward(d)
def east() _turn_to(pi/2)

south(num d)
	south()
	forward(d)
def south() _turn_to(pi)

west(num d)
	west()
	forward(d)
def west() _turn_to(-pi/2)

turtle_go(num dx, num dy)
	num x = lx + (_xflip ? -dx : dx)
	num y = ly + (_yflip ? -dy : dy)
	if turtle_pendown
		draw(x, y)
	 else
	 	move(x, y)

def _turn(da) turtle_a += da
def _turn_to(a) turtle_a = a
def turn(a) _turn(angle2rad(a))
def turn_to(a) _turn_to(angle2rad(a))
def right(a) turn(a)
def left(a) turn(-a)
def turn_around() _turn(pi)

forward(num d)
	turtle_go(sincos(turtle_a, d))
back(num d)
	turtle_go(sincos(turtle_a+pi, d))

def move() turtle_pendown = 0
def draw() turtle_pendown = 1
def pen_toggle() turtle_pendown = !turtle_pendown
def pen_down() draw()
def pen_up() move()
def fd(d) forward(d)
def bk(d) back(d)
def lt(a) left(a)
def rt(a) right(a)

struct turtle_pos
	num lx, ly
	num lx2, ly2
	num turtle_a

turtle_pos get_pos()
	turtle_pos p = { lx, ly, lx2, ly2, turtle_a }
	return p

set_pos(turtle_pos p)
	lx = p.lx
	ly = p.ly
	lx2 = p.lx2
	ly2 = p.ly2
	turtle_a = p.turtle_a

def turtle_branch()
	let(my(p), get_pos())
	post(my(x))
		set_pos(my(p))
	pre(my(x))

# design: how to use triangle() or quad() with turtle?

# dodgy, need a better way?
def triangle(a, b, c)
	triangle(a.lx, a.ly, b.lx, b.ly, c.lx, c.ly)
	gr__change_hook()  # put in main triangle func

# design: how to use triangle() or quad() with turtle?

#int turtle_flip_factor = 1
#
#def turtle_flip()
#	turtle_flip_factor *= -1
#
#def _turn(da) turtle_a += da * turtle_flip_factor
#
# todo: turtle_zoom ?

def read_tsv_vec(v)
	read_tsv_vec(v, my(l))
def read_tsv_vec(v, l)
	repeat
		cstr l = Input()
		if l == NULL
			break
		splitv(v, l)

def read_tsv_vec_n(v, n)
	read_tsv_vec_n(v, n, my(l))
def read_tsv_vec_n(v, n, l)
	read_tsv_vec(v, l)
		if vec_get_size(v) != n
			error("read_tsv_vec_n: expected %d columns, got %d", n, vec_get_size(v))

# this is a degenerate case! but they are usually important to have
def read_tsv()
	_read_tsv(my(v))
def _read_tsv(v)
	new(v, vec, cstr, 0)
	read_tsv_vec_n(v, 0)
		.
#FIXME Free(v)!

# this is sort of degenerate but not really!
def read_tsv(a1)
	_read_tsv(my(v), a1)
def _read_tsv(v, a1)
	new(v, vec, cstr, 1)
	read_tsv_vec_n(v, 1)
		cstr a1 = *(cstr *)vec_element(v, 0)
#FIXME Free(v)!

def read_tsv(a1, a2)
	_read_tsv(my(v), a1, a2)
def _read_tsv(v, a1, a2)
	new(v, vec, cstr, 2)
	read_tsv_vec_n(v, 2)
		cstr a1 = *(cstr *)vec_element(v, 0)
		cstr a2 = *(cstr *)vec_element(v, 1)
#FIXME Free(v)!

def read_tsv(a1, a2, a3)
	_read_tsv(my(v), a1, a2, a3)
def _read_tsv(v, a1, a2, a3)
	new(v, vec, cstr, 3)
	read_tsv_vec_n(v, 3)
		cstr a1 = *(cstr *)vec_element(v, 0)
		cstr a2 = *(cstr *)vec_element(v, 1)
		cstr a3 = *(cstr *)vec_element(v, 2)
#FIXME Free(v)!

def read_tsv(a1, a2, a3, a4)
	_read_tsv(my(v), a1, a2, a3, a4)
def _read_tsv(v, a1, a2, a3, a4)
	new(v, vec, cstr, 4)
	read_tsv_vec_n(v, 4)
		cstr a1 = *(cstr *)vec_element(v, 0)
		cstr a2 = *(cstr *)vec_element(v, 1)
		cstr a3 = *(cstr *)vec_element(v, 2)
		cstr a4 = *(cstr *)vec_element(v, 3)
#FIXME Free(v)!

# etc!  need snazzy variadic macros :)
use stdio.h
use termios.h
use unistd.h
use stdlib.h


typedef struct termios termios
termios term, term_orig

raw()
	int rv
	rv = tcgetattr(STDIN_FILENO, &term)
	if rv < 0
		error("tcgetattr failed")
	term_orig = term

	term.c_iflag &= ~(IGNBRK|BRKINT|PARMRK|ISTRIP|INLCR|IGNCR|ICRNL|IXON)
	term.c_iflag |= IGNBRK | BRKINT
	term.c_oflag |= OPOST
	term.c_lflag &= ~(ECHO|ECHONL|ICANON|IEXTEN)
	term.c_lflag |= ISIG
	term.c_cflag &= ~(CSIZE|PARENB)
	term.c_cflag |= CS8

	term.c_cc[VMIN] = 1
	term.c_cc[VTIME] = 0

	rv = tcsetattr(STDIN_FILENO, TCSANOW, &term)
	if rv < 0
		error("tcsetattr failed")

cooked()
	int rv
	rv = tcsetattr(STDIN_FILENO, TCSAFLUSH, &term_orig)
	if rv < 0
		error("tcsetattr failed")

noecho()
	int rv
	rv = tcgetattr(STDIN_FILENO, &term)
	if rv < 0
		error("tcgetattr failed")
	term_orig = term

	term.c_lflag &= ~(ECHO|ECHONL)
	term.c_lflag |= ISIG

	rv = tcsetattr(STDIN_FILENO, TCSANOW, &term)
	if rv < 0
		error("tcsetattr failed")

key_init()
	raw()
	Sigact(SIGCONT, cont_handler)
	Sigact(SIGINT, int_handler)
	Sigact(SIGPIPE, int_handler)

key_final()
	cooked()

int key()
	unsigned char c
	ssize_t s
	s = read(STDIN_FILENO, &c, 1)
	if s == 0
		return -1
	return c

cont_handler(int signum)
	use(signum)
	raw()

int_handler(int signum)
	use(signum)
	cooked()
	Exit(1)

def Input_passwd() Input_passwd("Password: ")
cstr Input_passwd(cstr prompt)
	noecho()
	cstr pass = Input(prompt)
	nl()
	cooked()
	return pass
# This includes all the headers you're likely to need.



# export tty
#   curses has conflicting symbols with libb etc, see ../curses_syms_conflicts
