#!/lang/b

use stdio.h
use stdlib.h
use string.h

typedef char *str
long str_s = sizeof(str)

long SIZE = 4096
long LINES = 65536

int main(void)
	str *vec = Malloc(LINES * str_s)
	str *vecp = vec
	str buf, r
	buf = Malloc(SIZE)
	
	while 1
		r = fgets(buf, SIZE, stdin)
		if r == NULL
			break
		if r[strlen(r)-1] != '\n'
			die("buffer too small")
		if vecp == vec+LINES
			die("too many lines")
		else
			*vecp = buf
			buf = Malloc(SIZE)
			++vecp
	
	qsort(vec, vecp-vec, str_s, compare)
	for ; vec<vecp ; ++vec
		printf("%s", *vec);
	
	exit(0)

int compare(const void *a, const void *b)
	char *A = *(char **)a, *B = *(char **)b;
	return strcmp(A, B)

void *Malloc(size_t s)
	void *r=malloc(s)
	if r == NULL
		die("malloc failed")
	return r

die(str s)
	fprintf(stderr, "%s", s)
	exit(1)
