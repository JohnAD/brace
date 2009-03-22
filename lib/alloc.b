export stdlib.h
use error io
export types

use stdio.h

def alloc_type normal
#def alloc_type memlog

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

#local char *memlog_file = ".memlog"
local FILE *memlog = NULL

def memlog_open()
	if !memlog
		memlog = stderr
#		memlog = Fopen(memlog_file, "w")
#		Setlinebuf(memlog)

# I doubt I will need this:
def memlog_close()
	if memlog
		Fclose(memlog)

#memlog(const char *format, ...)
#	if !memlog
#		memlog_open()
#	collect(Vfprintf, memlog, format)

def memlog_Malloc(size) memlog_Malloc(size, __FILE__, __LINE__)
def memlog_Free(ptr) memlog_Free(ptr, __FILE__, __LINE__), ptr = NULL
def memlog_Realloc(ptr, size) ptr = memlog_Realloc(ptr, size, __FILE__, __LINE__)
def memlog_Calloc(ptr, size) memlog_Calloc(ptr, size, __FILE__, __LINE__)
def memlog_Strdup(s) memlog_Strdup(s, __FILE__, __LINE__)
def memlog_Strndup(s, n) memlog_Strndup(s, n, __FILE__, __LINE__)

void *memlog_Malloc(size_t size, char *file, int line)
	memlog_open()
	void *rv = normal_Malloc(size)
	Fprintf(memlog, "A\tmalloc\t%010p\t%d\t%s:%d\n", rv, size, file, line)
	return rv

memlog_Free(void *ptr, char *file, int line)
	memlog_open()
	normal_Free(ptr)
	Fprintf(memlog, "F\tfree\t%010p\t\t%s:%d\n", ptr, file, line)

void *memlog_Realloc(void *ptr, size_t size, char *file, int line)
	memlog_open()
	void *rv = normal_Realloc(ptr, size)
	Fprintf(memlog, "F\trealloc\t%010p\t\t%s:%d\n", ptr, file, line)
	Fprintf(memlog, "A\trealloc\t%010p\t%d\t%s:%d\n", rv, size, file, line)
	return rv

void *memlog_Calloc(size_t nmemb, size_t size, char *file, int line)
	memlog_open()
	void *rv = normal_Calloc(nmemb, size)
	Fprintf(memlog, "A\tcalloc\t%010p\t%d\t%s:%d\n", rv, nmemb*size, file, line)
	return rv

cstr memlog_Strdup(const char *s, char *file, int line)
	memlog_open()
	cstr rv = normal_Strdup(s)
	Fprintf(memlog, "A\tstrdup\t%010p\t%d\t%s:%d\n", rv, strlen(rv), file, line)
	return rv

cstr memlog_Strndup(const char *s, size_t n, char *file, int line)
	memlog_open()
	cstr rv = normal_Strndup(s, n)
	Fprintf(memlog, "A\tstrndup\t%010p\t%d\t%s:%d\n", rv, strlen(rv), file, line)
	return rv

