# vectors ----------------------------------------------------

# The first field in a vector element must be an int which is
# normally non-negative.  This field is used for the free list
# in non-allocated elements.

struct Vector
	int n, space, first_free
	size_t element_size
	void *elements

struct VectorIterator
	int count
	size_t element_size
	void *element

enum {not_free = -1}

vector_init(Vector *v, size_t element_size)
	v->n = 0
	v->space = 0
	v->first_free = not_free
	v->element_size = element_size
	v->elements = NULL

static boolean is_free(void *e)
	return *(int *)e < 0

static int next_free(void *e)
	return -2-*(int *)e

static void set_next_free(void *e, int i)
	*(int *)e = -2-i

void *vector_alloc(Vector *v)
	int i
	void *e
	if v->first_free == not_free
		i = v->n
		if i == v->space
			v->space = v->space * 2 + 8
			Realloc(v->elements, v->element_size * v->space)
		e = vector_ref(v, i)
	else
		i = v->first_free
		e = vector_ref(v, i)
		v->first_free = next_free(e)
	++v->n
	return e

vector_dealloc(Vector *v, void *e)
	int i = vector_index(v, e)
	set_next_free(e, v->first_free)
	v->first_free = i
	--v->n

void *vector_ref(Vector *v, int i)
	return (char *)v->elements + i * v->element_size

int vector_index(Vector *v, void *e)
	return ((char *)e - (char *)v->elements) / v->element_size

vector_iterator_init(Vector *v, VectorIterator *i)
	i->count = v->n
	i->element_size = v->element_size
	i->element = v->elements

void *vector_iterator_next(VectorIterator *i)
	void *e
	if i->count-- == 0
		return NULL
	while is_free(i->element)
		i->element = ((char *)i->element) + i->element_size
	e = i->element
	i->element = ((char *)i->element) + i->element_size
	return e

use stddef.h

use error types alloc
