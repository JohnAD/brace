export stdlib.h
use string.h
export buffer str
use alloc types error m

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

