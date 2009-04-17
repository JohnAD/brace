#!/lang/b
use b

Main()
	int size
	num s0, s1, v0, v1
	
	if args % 4 == 0
		size = 100
	 else
	 	size = atoi(arg[0])
		++arg ; --args
	which args
	0	s0 = s1 = 1
		v0 = 0 ; v1 = 1
	4	s0 = atof(arg[0]) ; s1 = atof(arg[1])
		v0 = atof(arg[2]) ; v1 = atof(arg[3])

	space(size, size)
	
	gr_fast()

	num r = min(w_2, h_2) - 10

	for(x, -w_2, w_2)
		for(y, -h_2, h_2)
			num a = Atan2(x, y)
			num i = hypot(x, y) / r
			
#			if !tween(a, -120, 120) && i<=1
			
			num s = i*(s1-s0) + s0
			num v = i*(v1-v0) + v0
			hsv(a, s, v)
		
			point(x, y)
		paint()

Def trig_unit deg
 # todo, make it angle_unit ?


def for_exact(var, from, to, step)
	for(var, from+0.0, to+step/2.0, step+0.0)
