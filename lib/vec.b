export buffer
export util

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
	state type *my(end) = (type *)vecend(v)
	for state type *i = (type *)vec0(v) ; i!=my(end) ; ++i
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

def vec_grow_at(v, i, n) vec_splice(v, i, 0, NULL, n)

def vec_insert(v, i, in, n) vec_splice(v, i, 0, in, n)

def vec_unshift(v, in, n) vec_insert(v, 0, in, n)

# def vec_shift ... ?

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

