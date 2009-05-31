export string.h ctype.h
use stdio.h

export buffer types vec
use error alloc util

cstr_dos_to_unix(cstr s)
	cstr p1, p2
	for p1=p2=s; *p1 != '\0'; ++p1
		if *p1 != '\r'
			*p2 = *p1
			++p2
	*p2 = '\0'

# returns malloc'd
cstr cstr_unix_to_dos(cstr s)
	cstr p1
	new(b, buffer, strlen(s)*1.5)
	for p1=s; *p1 != 0; ++p1
		if *p1 == '\n'
			buffer_cat_char(b, '\r')
			buffer_cat_char(b, '\n')
		 else
		 	buffer_cat_char(b, *p1)
	return buffer_to_cstr(b)

cstr_chomp(cstr s)
	int l = strlen(s)
	if s[l-1] == '\n'
		s[l-1] = '\0'

## this chomp is interesting, it makes sure we have only a single line even if were multiple lines!
## is this better?
#cstr_chomp(cstr str)
#	while *str
#		if *str == '\n'
#			*str = '\0'
#			return
#		
#		str++

# TODO implement ends_with and begins_with efficiently

boolean cstr_eq(void *s1, void *s2)
	return strcmp(s1, s2) == 0

boolean cstr_case_eq(void *s1, void *s2)
	return strcasecmp(s1, s2) == 0

boolean cstr_is_empty(cstr s1)
	return *s1 == '\0'

boolean cstr_ends_with(cstr s, cstr substr)
	size_t s_len = strlen(s)
	size_t substr_len = strlen(substr)
	if substr_len > s_len
		return 0
	cstr expect = s + s_len - substr_len
	return cstr_eq(expect, substr)

boolean cstr_case_ends_with(cstr s, cstr substr)
	size_t s_len = strlen(s)
	size_t substr_len = strlen(substr)
	if substr_len > s_len
		return 0
	cstr expect = s + s_len - substr_len
	return cstr_case_eq(expect, substr)

# this returns a pointer to the character after the match, or NULL
# I want it to preserve the constness of the first argument, but C can't.
cstr cstr_begins_with(cstr s, cstr substr)
	repeat
		if *substr == '\0'
			return (cstr)s
		if *substr != *s
			return NULL
		++s ; ++substr

cstr cstr_case_begins_with(cstr s, cstr substr)
	repeat
		if *substr == '\0'
			return (cstr)s
		if tolower((unsigned char)*substr) != tolower((unsigned char)*s)
			return NULL
		++s ; ++substr

Def cstr_range(s) s, cstr_get_end(s)
 # note: cstr_range evaluates its arg three times, so don't call it with a complex expression

def cstr_get_start(s) s          # duh!
def cstr_get_end(s) s+strlen(s)

# cstr_from_str is in str.b for now, to avoid the brace_mk_cc bug

cstr cstr_from_buffer(buffer *b)
	buffer_nul_terminate(b)
	return b->start

cstr cstr_of_size(size_t n)
	cstr cs = Malloc(n + 1)
	cs[n] = '\0'
	return cs

# TODO defs for libc string functions, e.g. cstr_dup -> strdup, cstr_copy -> strcpy ...; and remap

# TODO maybe rename cstr_copy to cstr_dup
def cstr_copy(s) Strdup(s)
def cstr_cat(a, b) format("%s%s", a, b)
def cstr_cat(a, b, c) format("%s%s%s", a, b, c)
def cstr_cat(a, b, c, d) format("%s%s%s%s", a, b, c, d)
def cstr_cat(a, b, c, d, e) format("%s%s%s%s%s", a, b, c, d, e)
def cstr_cat(a, b, c, d, e, f) format("%s%s%s%s%s%s", a, b, c, d, e, f)
def cstr_cat(a, b, c, d, e, f, g) format("%s%s%s%s%s%s%s", a, b, c, d, e, f, g)

cstr cstr_chop_end(cstr c, cstr end)
	Realloc(c, end - c)
	return c

# TODO an alloc that can free the _start_ of a block

## startmust be a pointer into the string c
cstr cstr_chop_start(cstr c, cstr start)
	int len = strlen(start)
	memmove(c, start, len)
	c[len] = '\0'
	Realloc(c, len+1)
	return c
	# inefficient, who cares

# cstr_chop_foo ??? no nul?


void_cstr(cstr s)
	Free(s)

def cstr_last_char(s) s[(strlen(s) ? strlen(s) : 1)-1]

def cstr_dump(s)
	hexdump(cstr_range(s))

# you need to clear the vec if necessary before calling split

splitv(vec *v, cstr s, char c)
	if *s
		splitv1(v, s, c)

splitv1(vec *v, cstr s, char c)
	vec_push(v, s)
	for_cstr(i, s)
		if *i == c
			*i = '\0'
			vec_push(v, i+1)

def splitv(v, s) splitv(v, s, '\t')

splitv_dup(vec *v, const char *_s, char c)
	char *s = (char *)_s
	for_cstr(i, s)
		if *i == c
			cstr x = Strndup(s, i-s)
			vec_push(v, x)
			s = i+1
	if i >= s
		vec_push(v, Strdup(s))

cstr *split(cstr s, char c)
	new(v, vec, cstr, 16)
	splitv(v, s, c)
	return vec_to_array(v)

cstr *splitn(cstr s, char c, int n)
	new(v, vec, cstr, 16)
	splitvn(v, s, c, n)
	return vec_to_array(v)

splitvn(vec *v, cstr s, char c, int n)
	if *s
		splitvn1(v, s, c, n)

splitvn1(vec *v, cstr s, char c, int n)
	vec_push(v, s)
	if --n
		for_cstr(i, s)
			if *i == c
				*i = '\0'
				vec_push(v, i+1)
				if --n == 0
					break

def split(s) split(s, '\t')
def split(s, c, n) splitn(s, c, n)

cstr *split_dup(const char *s, char c)
	new(v, vec, cstr, 16)
	splitv_dup(v, s, c)
	return vec_to_array(v)

def for_cstr(i, s)
	char *i
	for i=s; *i != '\0'; ++i
		.

cstr join(cstr sep, cstr *s)
	new(b, buffer, 256)
	if *s
		repeat
			buffer_cat_cstr(b, *s)
			++s
			if !*s
				break
			buffer_cat_cstr(b, sep)
	return buffer_to_cstr(b)

cstr joinv(cstr sep, vec *v)
	return join(sep, vec_to_array(v))

char *Strstr(const char *haystack, const char *needle)
	char *rv = strstr(haystack, needle)
	if !rv
		failed("strstr")
	return rv

char *Strcasestr(const char *haystack, const char *needle)
	char *rv = strcasestr(haystack, needle)
	if !rv
		failed("strcasestr")
	return rv

char *Strchr(const char *s, int c)
	char *rv = strchr(s, c)
	if !rv
		failed("strchr")
	return rv

char *Strrchr(const char *s, int c)
	char *rv = strrchr(s, c)
	if !rv
		failed("strrchr")
	return rv
