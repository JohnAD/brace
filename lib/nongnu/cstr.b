# not sure how this is done is glibc

size_t strnlen(const char *s, size_t n)
	size_t len = 0
	while len < n && *s++
		++len
	return len

char *strndup(const char *s, size_t n)
	char *rv
	size_t len = strnlen(s, n)
	if n > len
		n = len
	rv = malloc(n+1)
	if rv
		strncpy(rv, s, n)
		rv[n] = '\0'
	return rv
