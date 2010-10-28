use cstr error

size_t strlcpy(char *dst, const char *src, size_t size)
	if size == 0
		return strlen(src)
	const char *src0 = src
	do
		if (*dst++ = *src++) == 0
			break
	 while(--size)
	if src[-1]
		dst[-1] = '\0'
		while *src++
			.
	return src - src0 - 1

size_t strlcat(char *dst, const char *src, size_t size)
	if size == 0
		return strlen(dst)+strlen(src)
	char *dst0 = dst
	while *dst && size--
		++dst
	return (dst-dst0) + strlcpy(dst, src, size)
