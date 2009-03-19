export stdlib.h
use error io
export types

use stdio.h

def Malloc(size) _Malloc(size)
def Free(ptr) _Free(ptr), ptr = NULL
def Realloc(ptr, size) ptr = _Realloc(ptr, size)
def Calloc(ptr, size) _Calloc(ptr, size)
def Strdup(s) _Strdup(s)
def Strndup(s, n) _Strndup(s, n)

# these defs are used for debugging
# TODO simplify so this can be switched on and off with a single def
#def Malloc(size) memlog_Malloc(size, __FILE__, __LINE__)
#def Free(ptr) memlog_Free(ptr, __FILE__, __LINE__), ptr = NULL
#def Realloc(ptr, size) ptr = memlog_Realloc(ptr, size, __FILE__, __LINE__)
#def Calloc(ptr, size) memlog_Calloc(ptr, size, __FILE__, __LINE__)
#def Strdup(s) memlog_Strdup(s, __FILE__, __LINE__)
#def Strndup(s, n) memlog_Strndup(s, n, __FILE__, __LINE__)

# #def memlog _memlog
# def memlog void
# 
# def memlog_args memlog^^_args
# Def _memlog_args __FILE__, __LINE__
# Def void_args

void *_Malloc(size_t size)
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

def Calloc(nmemb) Calloc(nmemb, 1)
void *_Calloc(size_t nmemb, size_t size)
	void *ptr = calloc(nmemb, size)
	if (ptr == NULL)
		failed("calloc")
	return ptr

def Talloc(type) (type *)Malloc(sizeof(type))

def Nalloc(type, nmemb) (type *)Malloc(nmemb * sizeof(type))

def _Free(ptr) free(ptr)

cstr _Strdup(const char *s)
	cstr rv = strdup(s)
	if rv == NULL
		failed("strdup")
	return rv

char *_Strndup(const char *s, size_t n)
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

void *memlog_Malloc(size_t size, char *file, int line)
	memlog_open()
	void *rv = _Malloc(size)
	Fprintf(memlog, "A\tmalloc\t%08x\t%d\t%s:%d\n", (uint)rv, size, file, line)
	return rv

memlog_Free(void *ptr, char *file, int line)
	memlog_open()
	_Free(ptr)
	Fprintf(memlog, "F\tfree\t%08x\t\t%s:%d\n", (uint)ptr, file, line)

void *memlog_Realloc(void *ptr, size_t size, char *file, int line)
	memlog_open()
	void *rv = _Realloc(ptr, size)
	Fprintf(memlog, "F\trealloc\t%08x\t\t%s:%d\n", (uint)ptr, file, line)
	Fprintf(memlog, "A\trealloc\t%08x\t%d\t%s:%d\n", (uint)rv, size, file, line)
	return rv

void *memlog_Calloc(size_t nmemb, size_t size, char *file, int line)
	memlog_open()
	void *rv = _Calloc(nmemb, size)
	Fprintf(memlog, "A\tcalloc\t%08x\t%d\t%s:%d\n", (uint)rv, nmemb*size, file, line)
	return rv

cstr memlog_Strdup(const char *s, char *file, int line)
	memlog_open()
	cstr rv = _Strdup(s)
	Fprintf(memlog, "A\tstrdup\t%08x\t%d\t%s:%d\n", (uint)rv, strlen(rv), file, line)
	return rv

cstr memlog_Strndup(const char *s, size_t n, char *file, int line)
	memlog_open()
	cstr rv = _Strndup(s, n)
	Fprintf(memlog, "A\tstrndup\t%08x\t%d\t%s:%d\n", (uint)rv, strlen(rv), file, line)
	return rv

