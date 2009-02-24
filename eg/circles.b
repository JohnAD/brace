#!/lang/b
use b
Main()
	space()
	gr_fast()
	int mr = hypot(w_2, h_2)
	int count = 0
	repeat
		int x = Randint(-w_2, w_2)
		int y = Randint(-h_2, h_2)
		int r = Randint(0, mr)
		hsv(Randint(360), Rand(0.8, 1), Rand(0.2))
#		col(rb[Randint(360)])
		circle(x, y, r)
		if ++count % 100 == 0
			paint()
def trig_unit deg
