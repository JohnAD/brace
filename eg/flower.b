#!/lang/b

Main()
	space(600, 600)

	gr_fast()

	int n1, n2, n3, n4

	which args
	4	n1 = atoi(arg[0])
		n2 = atoi(arg[1])
		n3 = atoi(arg[2])
		n4 = atoi(arg[3])
	0	n1 = Randint(1,13)
		n2 = Randint(1,13)
		n3 = Randint(1,13)
		n4 = Randint(1,13)
	else	usage("[n1 n2 n3 n4]  e.g. 10 5 5 10")
		exit(1)

	Sayf("%d %d %d %d", n1, n2, n3, n4)

	for(o, 0.0, 360, 0.5)
		clear()
		for(i, 0, 360, 6)
			hsv(i, Cos(o*13)*0.15+0.85, Sin(o*7)*0.5+0.5)
			move(0,0)
			turn_to(o)
			right(i)
			move()
			forward(20)
			draw()
			forward(80)

			forward(100)

			let(da, Sin(o*n1+i*n2)*10)
			let(d, Cos(o*n3+i*n4)*10+12)
			repeat(20)
				left(da)
				forward(d)
				da = da*1.1
				d = d * 0.9
		paint()
		sleep(0.01)

def trig_unit deg

use b
