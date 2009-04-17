#!/lang/b
use b
Main()
	space()
	gr_fast()
	int mr = hypot(w_2, h_2)
	int count = 0
	repeat
		int x = Randi(-w_2, w_2)
		int y = Randi(-h_2, h_2)
		int r = Randi(0, mr)
		hsv(Randi(360), Rand(0.8, 1), Rand(0.2))
#		col(rb[Randint(360)])
		circle(x, y, r)
		if ++count % 100 == 0
			paint()
def trig_unit deg
