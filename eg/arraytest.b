#!/lang/b

Main()
	array(a, 10, num)
	array(b, 10, num)
	array(c, 10, num)

	b = b0
	c = c0
	for(i, 0, a_n)
		*b++ = i
		*c++ = i+7

	Map(a, b, c)
		*a = *b + 2.0 * *c

	For(a)
		Sayf("%f", *a)

use b
