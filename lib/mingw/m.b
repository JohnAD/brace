# mingw doesn't have BSD random / srandom
#def random() rand()
#def srandom(seed) srand(seed)

use stdint.h

local unsigned long m__seed = 407355683

srandom_(unsigned long seed)
	m__seed = seed

ldef M (1U<<31)-1
ldef A 48271
ldef Q 44488
ldef R 3399

long random():
	int32_t X
	X = m__seed
	X = A*(X%Q) - R * (int32_t)(X/Q)
	if X < 0:
		X = X+M+1
	m__seed = X
	return (long)X
