#!/lang/b

use m
use error

use stdio.h
use stdlib.h

num offset(num d, num L, num x)
	return hypot(x+d/2, L) - hypot(x-d/2, L)

int main(int argc, char **argv)
	if argc != 3
		error("syntax: %s d L", argv[0])
	num d = atof(argv[1])
	num L = atof(argv[2])
	
	num x
	for x=0; x < 100; x+= 0.1
		printf("%f\t%f\n", x, offset(d, L, x))
	
	return 0
