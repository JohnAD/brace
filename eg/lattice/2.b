#!/lang/b
use b
def trig_unit deg
Main()
	space(midnightblue)
	gr_fast()
	zoom(40)

	num a
	for a = 0; ; a+=0.5
		move(0, 0)
		east()
		rt(a)
		clear()
		draw_lattice()
		paint()

def draw_lattice()
#	Printf("%f ", rtime())
	num rt3 = sqrt(3.0)
#	int xc = Floor(w_2/(sc*rt3/2)+1)
#	int yc = Floor(h_2/sc+1)
	int xc = Floor(hypot(w_2, h_2)/(sc*rt3/2)+1)
	int yc = xc
	for(x, -xc, xc)
		for(y, -yc, yc)
			turtle_branch()
				move()
				fd(x*rt3/2)
				lt(90)
				if x%2
					fd(0.5)
				fd(y)
				draw()
				if fabs(lx) > w_2+sc*3 || fabs(ly) > h_2+sc*3
					continue
				if mod(y-mod(x,2),3)==0
					fill_star()
#	Sayf("%f", rtime())

def draw_star()
	repeat(6)
		turtle_branch()
			fd(1)
		rt(60)
	rt(30)
	repeat(6)
		turtle_branch()
			fd(rt3)
		rt(60)

def fill_star()
	move()
	let(o, get_pos())
	fd(1)
	let(a, get_pos())
	for(i, 0, 6)
		col(rb[i*60])
		set_pos(o)
		rt(60*i)
		rt(30)
		fd(rt3/2)
		let(b, get_pos())
		triangle(a, o, b)
		col(rb[i*60+30])
		set_pos(o)
		rt(60*i)
		rt(60)
		fd(1)
		a = get_pos()
		triangle(b, o, a)

