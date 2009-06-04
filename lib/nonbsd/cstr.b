use cstr error

size_t Strlcpy(char *dst, char *src, size_t size)
	size_t rv
	rv = strlcpy(dst, src, size)
	if rv >= size
		failed("strlcpy", "dst buffer too small")
	return rv

size_t strlcpy(char *dst, char *src, size_t size)
	if size == 0
		return strlen(src)
	char *src0 = src
	do
		if (*dst++ = *src++) == 0
			break
	 while(--size)
	if src[-1]
		dst[-1] = '\0'
		while *src++
			.
	return src - src0 - 1

size_t Strlcat(char *dst, char *src, size_t size)
	size_t rv
	rv = strlcpy(dst, src, size)
	if rv >= size
		failed("strlcpy", "dst buffer too small")
	return rv

size_t strlcat(char *dst, char *src, size_t size)
	if size == 0
		return strlen(dst)+strlen(src)
	char *dst0 = dst
	while *dst && size--
		++dst
	return (dst-dst0) + strlcpy(dst, src, size)
