# mingw doesn't have BSD random / srandom
#def random() rand()
#def srandom(seed) srand(seed)

use stdint.h

local unsigned long m__seed = 407355683

srandom(unsigned long seed)
	m__seed = seed

long random():
	static long M = (1U<<31)-1
	static long A = 48271
	static long Q = 44488
	static long R = 3399
	int32_t X
	X = m__seed
	X = A*(X%Q) - R * (int32_t)(X/Q)
	if X < 0:
		X = X+M+1
	m__seed = X
	return (long)X
