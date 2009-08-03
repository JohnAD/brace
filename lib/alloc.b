export stdlib.h
use stdio.h
export types
use error io
use alloc
export vec

def alloc_type normal
#def alloc_type memlog

int memlog_on = 0

def Malloc(size) alloc_type^^_Malloc(size)
def Free(ptr) alloc_type^^_Free(ptr), ptr = NULL
def Realloc(ptr, size) ptr = alloc_type^^_Realloc(ptr, size)
def Calloc(ptr, size) alloc_type^^_Calloc(ptr, size)
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

def Talloc(type) (type *)Malloc(sizeof(type))

def Nalloc(type, nmemb) (type *)Malloc(nmemb * sizeof(type))

def Renalloc(ptr, type, nmemb) ptr = (type *)Realloc(ptr, nmemb * sizeof(type))

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

