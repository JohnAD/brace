#!/lang/b
use b
Main()
	space(600, 600)
	gr_fast()
	for(x, -300, 300, 1)
		int o = (x % 16) / 2
		for(y, -300+o, 300+o, 1)
			int p = (y % 16) / 2
			if (o+p) % 2 == 0
				rgb(0, 1, 0)
			 else
				rgb(1, 0, 0)
			point(x, y)
		paint()
