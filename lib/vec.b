export buffer
export util

# TODO fix vec to work like new buffer does

# TODO don't use buffer underneath it

# can we unify the buffer and vector abstractions?  why not?

struct vec
	buffer b
	size_t element_size
	size_t space
	size_t size

vec_init_el_size(vec *v, size_t element_size, size_t space)
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

vec_space(vec *v, size_t space)
	v->space = space ? space : 1
	buffer_set_space(&v->b, v->space * v->element_size)

vec_size(vec *v, size_t size)
	size_t cap = v->space
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

void *vec_element(vec *v, size_t index)
	#if index < 0
	#	index += v->size
	return v->b.start + index * v->element_size

void *vec_top(vec *v, size_t index)
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

def vec_from_array(v, a)
	new(v, vec, *a, array_size(a))
	vec_set_size(v, array_size(a))
	let(vfa__i0, a)
	let(vfa__i1, array_end(a))
	sametype(vfa__out, a) = vec_get_start(v)
	for(vfa__i)
		*out = *vfa__i
		++out

def vec_get_start(v) vec_element(v, 0)
def vec_get_end(v) vec_element(v, v->size)
def vec_set_size vec_size
def vec_get_size(v) v->size

Def vec_range(v) vec_get_start(v), vec_get_end(v)
Def vec_range(v, type) vec_get_start(v, type), vec_get_end(v, type)
Def vec_get_start(v, type) (type *)vec_get_start(v)
Def vec_get_end(v, type) (type *)vec_get_end(v)

vec_dup(vec *to, vec *from)
 # 'to' should be uninitialized (or after free'd)
	buffer_dup(&to->b, &from->b)
	to->element_size = from->element_size
	to->space = from->space
	to->size = from->size

def for_vec(i, v, type)
	for(i, vec_range(v, type))

def vec_set_space vec_space
def vec_get_space(v) v->space

vec_ensure_size(vec *v, size_t size)
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

