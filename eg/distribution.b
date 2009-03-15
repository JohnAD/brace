#!/lang/b
# this is a bar graph of Larry's "interesting distribution"
use b
Main()
	paper(800,600)
	gr_fast()
	origin(w_2,h_2)
	num logbase = log(1.05)
	int bars = w
	int counts[bars]
	for(i, 0, bars)
		counts[i] = 0
	int samples = 1e7
	int count = 0
	int ol = 0
	num lm = log(samples)/logbase
	repeat(samples)
		num x = Rand(Rand(Rand()))
		++counts[(int)(x * bars)]
		int l = log(++count)/logbase
		if l > ol
			grey(1-(num)l/lm)
			clear()
			draw_graph()
			paint()
			ol = l
	int heading_size = 24
	font("helvetica-bold", 24)
	cstr msg
	if toss()
		msg = "Larry's \"interesting distribution\" - Rand(Rand(Rand()))"
	 else
		msg = "print rand rand rand 1, '\\n'; # interesting distribution"
	draw_msg(msg)
	paint()
	Sleep(2)
	repeat
		move(Randi(w), Randi(h))
		hsv(Randi(360), 1, 0.7)
		gprint_anchor(0, 0)
		font("helvetica-medium", Randi(8, 48))
		gprintf("%f", Rand(Rand(Rand())))
		black()
		draw_graph()
		font("helvetica-bold", 24)
		gprint_anchor(-1, 1)
		draw_msg(msg)
		paint()
		++heading_size

def trig_unit deg

def draw_graph()
	int max = 0
	for(i, 0, bars)
		if counts[i] > max
			max = counts[i]
	for(i, 0, bars)
		line(i, 0, i, (num)counts[i]*h/max)

def draw_msg(msg)
	move(0, h)
	gprint(msg)
