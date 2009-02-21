export circbuf
export util

# TODO implement without circbuf

struct deq
	circbuf b
	size_t element_size
	size_t space
	size_t size
	size_t start

_deq_init(deq *q, size_t element_size, size_t space)
	q->space = space ? space : 1
	circbuf_init(&q->b, q->space * element_size)
	q->element_size = element_size
	q->size = 0
	q->start = 0

Def deq_init(v, element_type, space) _deq_init(v, sizeof(element_type), (space))
def deq_init(v, element_type) deq_init(v, element_type, 1)

deq_free(deq *q)
	circbuf_free(&q->b)

deq_space(deq *q, size_t space)
	q->space = space ? space : 1
	circbuf_set_space(&q->b, q->space * q->element_size)
	if q->b.start == 0
		q->start = 0

deq_size(deq *q, size_t size)
	size_t cap = q->space
	if size > cap
		do
			cap *= 2
		while size > cap
		deq_space(q, cap)
	q->size = size
	q->b.size = size * q->element_size

deq_double(deq *q)
	deq_space(q, q->space * 2)

deq_squeeze(deq *q)
	deq_space(q, q->size)

void *deq_element(deq *q, size_t index)
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
	*(typeof(&data))deq_push(q) = data

deq_pop(deq *q)
	--q->size
	q->b.size -= q->element_size
Def deq_pop(q, var)
	let(my(p), castto_ref(deq_top(q), &var))
	data = *my(p)
	deq_pop(q)

void *deq_top(deq *q, size_t index)
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
def deq_set_size(q) deq_size(q)
def deq_get_size(q) q->size

def deq_get_space_end(q) (void *)(q->b.data + q->b.space)
def deq_get_space_start(q) (void *)(q->b.data)

def for_deq(i, q, type)
	type *i = deq_get_start(q)
	type *my(end) = deq_get_end(q)
	type *my(wrap) = deq_get_space_end(q)
	type *my(origin) = deq_get_space_start(q)
	if deq_get_size(q)
		my(st)
	for ; i != my(end) ; ++i, i = i == my(wrap) ? my(origin) : i
my(st)		.
 # this is a hack!

def deq_set_space deq_space
def deq_get_space(q) q->space
