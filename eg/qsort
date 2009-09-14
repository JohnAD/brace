#!/lang/b

use stdio.h
use stdlib.h
use string.h

int main(void):
	cstr *vec = Malloc(LINES * sizeof(*vec))
	cstr *vecp = vec
	cstr buf, r
	buf = Malloc(SIZE)
	
	while 1:
		r = fgets(buf, SIZE, stdin)
		if r == NULL:
			break
		if r[strlen(r)-1] != '\n':
			die("line too long")
		if vecp == vec+LINES:
			die("too many lines")
		else:
			*vecp = buf
			buf = Malloc(SIZE)
			++vecp
	
	qsort(vec, vecp-vec, sizeof(*vec), compare)
	for ; vec<vecp ; ++vec:
		printf("%s", *vec);
	
	exit(0)

long SIZE = 4096
long LINES = 65536

typedef char *cstr

int compare(const void *a, const void *b):
	char *A = *(cstr *)a, *B = *(cstr *)b;
	return strcmp(A, B)

void *Malloc(size_t s):
	void *r = malloc(s)
	if r == NULL:
		die("malloc failed")
	return r

die(cstr s):
	fprintf(stderr, "%s", s)
	exit(1)
