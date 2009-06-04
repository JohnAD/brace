# for mingw, re-implement memmem, memcmp
# these were fairly much nicked from dietlibc :)
# Should sanity test them as memmem manpage suggests history of brokenness

use types

void *memmem(const void* haystack, size_t hl, const void* needle, size_t nl)
	const char *_haystack = haystack
	int i
	if nl > hl
		return 0
	for i=hl-nl+1 ; i ; --i
		if !memcmp(_haystack,needle,nl)
			return (void*)_haystack
		++_haystack
	return 0

int memcmp(const void *dst, const void *src, size_t count)
	int r
	const char *d = dst
	const char *s = src
	++count
	while --count
		r = *d - *s
		if r
			return r
		++d
		++s
	return 0

def bzero(ptr, size) memset(ptr, 0, size)

def on_mingw(what)
	what()
def on_mingw(what, a0)
	what(a0)
def on_mingw(what, a0, a1)
	what(a0, a1)
