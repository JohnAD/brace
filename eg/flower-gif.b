#!/lang/b
use b

Main()
	paper(300, 300)
	zoom(3.0/6.0)
	line_width(8)

	gr_fast()

	int n1, n2, n3, n4

	which args
	4	n1 = atoi(arg[0])
		n2 = atoi(arg[1])
		n3 = atoi(arg[2])
		n4 = atoi(arg[3])
	0	n1 = 9 ; n2 = 12 ; n3 = 5 ; n4 = 12
	else	usage("[n1 n2 n3 n4]  e.g. 10 5 5 10")
		exit(1)

	Sayf("%d %d %d %d", n1, n2, n3, n4)

	int count = 0

	for(oo, 0.0, 90, 0.75)
		num o = Sin(oo*4)*20
		clear()
		for(i, 0, 360, 6)
			hsv(i, 0.85, 0.3)
			move(0,0)
			turn_to(o*2)
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
		gr_sync()

		cstr file = format("flower-%06d.gif", count++)
		dump_img("gif", file, 0.25)
		Free(file)

		Sleep(0.01)

	System("gifsicle --colors 256 -O2 --delay 4 --loopcount flower-*.gif > flower.gif")
	System("rm flower-*.gif")

def trig_unit deg
