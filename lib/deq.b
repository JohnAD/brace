export circbuf
export util
export vec

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

