#!/lang/b
# this is a bar graph of Larry's "interesting distribution"
use b
Main()
	int bars = 800
	int counts[bars]
	for(i, 0, bars)
		counts[i] = 0
	int samples = 1e7
	repeat(samples)
		num x = Rand(Rand(Rand()))
		++counts[(int)(x * bars)]
	int max = 0
	for(i, 0, bars)
		if counts[i] > max
			max = counts[i]
	paper(800,600)
	gr_fast()
	origin(400,300)
	for(i, 0, bars)
		line(i, 0, i, counts[i]*600.0/max)
