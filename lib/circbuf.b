use alloc
use string.h
export stdlib.h
use types

# this is a circular buffer
# should I integrate this with the general buffer?
# should I make it "inherit" from the general buffer?

# can I integrate this with "string" somehow?

struct circbuf
	size_t size
	size_t space
	size_t start
	char *data

circbuf_init(circbuf *b, size_t space)
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

circbuf_set_space(circbuf *b, size_t space)
	space = space ? space : 1
	char *new_data = Malloc(space)
	size_t max_first_part = b->space - b->start
	ssize_t second_part = b->size - max_first_part
	if second_part <= 0
#		fprintf(stderr, "a %08x %08x %08x\n", new_data, b->data+b->start, b->size)
		memcpy(new_data, b->data+b->start, b->size)
	else
#		fprintf(stderr, "b %08x %08x %08x\n", new_data, b->data+b->start, max_first_part)
		memcpy(new_data, b->data+b->start, max_first_part)
#		fprintf(stderr, "c %08x %08x %08x\n", new_data+max_first_part, b->data, second_part)
		memcpy(new_data+max_first_part, b->data, second_part)
	Free(b->data)
	b->data = new_data
	b->space = space
	b->start = 0

circbuf_set_size(circbuf *b, size_t size)
	size_t space = b->space
	while size > space
		space *= 2
		circbuf_set_space(b, space)
	b->size = size

circbuf_grow(circbuf *b, size_t delta_size)
	circbuf_set_size(b, circbuf_get_size(b) + delta_size)

circbuf_shift(circbuf *b, size_t delta_size)
	b->start += delta_size
	if b->start >= b->space
		b->start -= b->space
	b->size -= delta_size

# TODO push == grow, unshift, pop ???
#   XXX push would not be similar to vec:push

circbuf_double(circbuf *b)
	circbuf_set_space(b, b->space * 2)

circbuf_squeeze(circbuf *b)
	circbuf_set_space(b, b->size)

# TODO circbuf_get_wrap,origin
