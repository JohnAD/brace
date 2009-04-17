#!/lang/b
use b

Main()
	space(800, 600)
#	gr_fast()
	origin(w_2, h_2)
	new(v, vec, int, 4096)
	int bars = w
	int height = h
	int y[bars]
	int min = 1e9
	int max = -1e9

	for(i, 0, bars)
		y[i] = 0

	eachline(l)
		int x = atoi(l)
		if x < min
			min = x
		if x > max
			max = x
		vec_push(v, x)

	Sayf("%d %d", min, max)

	for_vec(i, v, int)
		int x = *i
		int b = log(x-min)/log(max-min) * bars
		y[b]++

	int max_y = 0
	for(b, 0, bars)
		if y[b] > max_y
			max_y = y[b]

	for(b, 0, bars)
		if y[b]
			int Y = log(y[b])/log(max_y) * height
			line(b, 0, b, Y)

