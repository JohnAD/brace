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

cstr cstr_chomp(cstr s)
	char *p = s
	while *p
		if among(*p, '\n', '\r')
			*p = '\0'
			break
		p++
	return s
def chomp(s) cstr_chomp(s)

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
def cstr_cat(a, b) Format("%s%s", a, b)
def cstr_cat(a, b, c) Format("%s%s%s", a, b, c)
def cstr_cat(a, b, c, d) Format("%s%s%s%s", a, b, c, d)
def cstr_cat(a, b, c, d, e) Format("%s%s%s%s%s", a, b, c, d, e)
def cstr_cat(a, b, c, d, e, f) Format("%s%s%s%s%s%s", a, b, c, d, e, f)
def cstr_cat(a, b, c, d, e, f, g) Format("%s%s%s%s%s%s%s", a, b, c, d, e, f, g)

cstr cstr_chop_end(cstr c, cstr end)
	Realloc(c, end - c)
	return c

# TODO an alloc that can free the _start_ of a block

## startmust be a pointer into the string c
cstr cstr_chop_start(cstr c, cstr start)
	int len = strlen(start)
	memmove(c, start, len)
	c[len] = '\0'
#	Realloc(c, len+1)
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

cstr join(char sep, cstr *s)
	char sep_cstr[2] = { sep, '\0' }
	return joins(sep_cstr, s)

cstr joinv(char sep, vec *v)
	return join(sep, vec_to_array(v))

cstr joins(cstr sep, cstr *s)
	new(b, buffer, 256)
	if *s
		repeat
			buffer_cat_cstr(b, *s)
			++s
			if !*s
				break
			buffer_cat_cstr(b, sep)
	return buffer_to_cstr(b)

cstr joinsv(cstr sep, vec *v)
	return joins(sep, vec_to_array(v))

char *Strstr(const char *haystack, const char *needle)
	char *rv = strstr(haystack, needle)
	if !rv
		failed0("strstr")
	return rv

char *Strcasestr(const char *haystack, const char *needle)
	char *rv = strcasestr(haystack, needle)
	if !rv
		failed0("strcasestr")
	return rv

char *Strchr(const char *s, int c)
	char *rv = strchr(s, c)
	if !rv
		failed0("strchr")
	return rv

char *Strrchr(const char *s, int c)
	char *rv = strrchr(s, c)
	if !rv
		failed0("strrchr")
	return rv

cstr cstr_tolower(cstr s)
	for_cstr(i, s)
		*i = tolower((unsigned char)*i)
	return s

cstr cstr_toupper(cstr s)
	for_cstr(i, s)
		*i = toupper((unsigned char)*i)
	return s

def lc(s) cstr_tolower(s)
def uc(s) cstr_toupper(s)

def cstr_realloc(s)
	cstr_realloc(s, strlen(s))
def cstr_realloc(s, len)
	Realloc(s, len+1)

boolean is_blank(cstr l)
	return l[strspn(l, " \t")] == '\0'

cstr cstr_begins_with_word(cstr s, cstr substr)
	cstr rv = cstr_begins_with(s, substr)
	if rv
		if *rv == ' '
			return rv+1
		 eif *rv == '\0'
			return rv
	return NULL

def cstr_begins_with_word(s) 1
def cstr_begins_with_word(s, w0, w1) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1))
def cstr_begins_with_word(s, w0, w1, w2) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2))
def cstr_begins_with_word(s, w0, w1, w2, w3) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7, w8) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7, w8))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7, w8, w9))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11))
def cstr_begins_with_word(s, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12) orp(cstr_begins_with_word(s, w0), cstr_begins_with_word(s, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12))

def cstr_chop(s)
	cstr_chop(s, 1)
cstr_chop(cstr s, long n)
	s[strlen(s)-n] = '\0'

cstr cstr_begins_with_sym(cstr s, cstr substr)
	cstr rv = cstr_begins_with(s, substr)
	if rv && !isword(*rv)
		return rv
	return NULL

char *cstr_not_chr(cstr s, char c)
	while *s == c
		++s
	return s

def strlitlen(s) sizeof(s)-1

cstr make_name(cstr s)
	for_cstr(i, s)
		if !isword(*i)
			*i = '_'
	return s

size_t Strlcpy(char *dst, char *src, size_t size)
	size_t rv
	rv = strlcpy(dst, src, size)
	if rv >= size
		failed("strlcpy", "dst buffer too small")
	return rv

size_t Strlcat(char *dst, char *src, size_t size)
	size_t rv
	rv = strlcpy(dst, src, size)
	if rv >= size
		failed("strlcpy", "dst buffer too small")
	return rv


def strtol(s, base) strtol(s, NULL, base)
def strtol(s) strtol(s, 10)
def strtoll(s, base) strtoll(s, NULL, base)
def strtoll(s) strtoll(s, 10)
def strtod(s) strtod(s, NULL)
def strtof(s) strtof(s, NULL)

long int Strtol(const char *nptr, char **endptr, int base)
	errno = 0
	long int rv = strtol(nptr, endptr, base)
	if errno
		failed("strtol", nptr)
	return rv
def Strtol(nptr, base) Strtol(nptr, NULL, base)
def Strtol(nptr) Strtol(nptr, 10)

long long int Strtoll(const char *nptr, char **endptr, int base)
	errno = 0
	long long int rv = strtoll(nptr, endptr, base)
	if errno
		failed("strtoll", nptr)
	return rv
def Strtoll(nptr, base) Strtoll(nptr, NULL, base)
def Strtoll(nptr) Strtoll(nptr, 10)

double Strtod(const char *nptr, char **endptr)
	errno = 0
	double rv = strtod(nptr, endptr)
	if errno
		failed("strtod", nptr)
	return rv
def Strtod(nptr) Strtod(nptr, NULL)

float Strtof(const char *nptr, char **endptr)
	errno = 0
	float rv = strtof(nptr, endptr)
	if errno
		failed("strtof", nptr)
	return rv
def Strtof(nptr) Strtof(nptr, NULL)

long int STRTOL(const char *nptr, int base)
	char *endptr
	errno = 0
	long int rv = strtol(nptr, &endptr, base)
	if errno || *endptr
		warn("strtol failed? %s %ld %p %p %p %d", nptr, rv, nptr, nptr+strlen(nptr), endptr, *endptr)
		failed("strtol", nptr)
	return rv
def STRTOL(nptr) STRTOL(nptr, 10)

long long int STRTOLL(const char *nptr, int base)
	char *endptr
	errno = 0
	long long int rv = strtoll(nptr, &endptr, base)
	if errno || *endptr
		failed("strtoll", nptr)
	return rv
def STRTOLL(nptr) STRTOLL(nptr, 10)

double STRTOD(const char *nptr)
	char *endptr
	errno = 0
	double rv = strtod(nptr, &endptr)
	if errno || *endptr
		failed("strtod", nptr)
	return rv

float STRTOF(const char *nptr)
	char *endptr
	errno = 0
	float rv = strtof(nptr, &endptr)
	if errno || *endptr
		failed("strtof", nptr)
	return rv
