#!/lang/b

Main()
	paper(1280, 800, black)
	gr_fast()

	colour rb[360]
	for(i, 0, 360)
		rb[i] = rainbow(i)

	for(x, -w_2, w_2)
		for(y, -h_2, h_2)
			int r = hypot(x, y)
			int a = mod(Atan2(y, x)+Sin(r*r/100)*50, 360)

			col(rb[a])
			point(x, y)
		paint()

def trig_unit deg

use b
