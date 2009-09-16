use tree
use m

Main()
	int forks = 6
	num speed = 0.2

	switch args
	2	speed = atof(arg[1])
	1	forks = atoi(arg[0])
	0	break
	else	usage("[forks [speed]]")

	paper(640, 480, coln("tan"))

	num a0 = 36, a1 = -43
	num da0 = 0, da1 = 0
	num drag = 0.995

	num m0 = .77, m1 = .80

	gr_fast()

	boolean limit = 0

	repeat
		clear()
		tree(forks, 0, -200, 100, 90, a0, a1, m0, m1)
		paint()

		a0 += da0 ; a1 += da1
		da0 += Rand(-speed, speed) ; da1 += Rand(-speed, speed)
		if limit
			if a0 < 10
				da0 += .3
			eif a0 > 60
				da0 -= .3
			if a1 < -60
				da1 += .3
			eif a1 > -10
				da1 -= .3
		
			da0 *= drag ; da1 *= drag

		Sleep(0.02)

use headers
