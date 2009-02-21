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
					draw_star()
				 else
					point()
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

def turtle_branch()
	let(my(p), get_pos())
	for(my(i), 0, 2)
		if my(i)==1
			set_pos(my(p))
			break

north(num d)
	north()
	forward(d)
def north() _turn_to(0)

east(num d)
	east()
	forward(d)
def east() _turn_to(pi/2)

south(num d)
	south()
	forward(d)
def south() _turn_to(pi)

west(num d)
	west()
	forward(d)
def west() _turn_to(-pi/2)

def point()
	point(lx,ly)

def space(bg)
	paper(bg)
	col(white)
