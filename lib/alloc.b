export stdlib.h
use error
export types

use stdio.h

void *Malloc(size_t size)
	void *ptr = malloc(size)
	if ptr == NULL
		failed("malloc")
	return ptr

void *_Realloc(void *ptr, size_t size)
	if size == 0
		size = 1
	ptr = realloc(ptr, size)
	if (ptr == NULL)
		failed("realloc")
	return ptr

def Realloc(ptr, size)
	ptr = _Realloc(ptr, size)

def Calloc(nmemb) Calloc(nmemb, 1)
void *Calloc(size_t nmemb, size_t size)
	void *ptr = calloc(nmemb, size)
	if (ptr == NULL)
		failed("calloc")
	return ptr

def Talloc(type) (type *)Malloc(sizeof(type))

def Nalloc(type, nmemb) (type *)Malloc(nmemb * sizeof(type))

def Free(ptr)
	free(ptr)
	ptr = NULL

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
