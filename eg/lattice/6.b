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
		lt(a)
		clear()
		draw_lattice()
		paint()
#		sleep(100)

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
					rt(a*Cos(hypot(lx,ly)*720/xc)*5)
					num unit = 0.6
#					rt(60*x/2+y/2)
					fill_star(unit)
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

def fill_star(unit)
	move()
	let(o, get_pos())
	fd(unit)
	let(a, get_pos())
	for(i, 0, 6)
		col(rb[i*60])
		set_pos(o)
		rt(60*i)
		rt(30)
		fd(rt3/2 * unit * .65)
		let(b, get_pos())
		triangle(a, o, b)
		col(rb[i*60+30])
		set_pos(o)
		rt(60*i)
		rt(60)
		fd(unit)
		a = get_pos()
		triangle(b, o, a)

# design: how to use triangle() or quad() with turtle?


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

def space(w, h)
	space(w, h, black)
def space(w, h, bg)
	paper(w, h, bg, white)

# dodgy, need a better way?
def triangle(a, b, c)
	triangle(a.lx, a.ly, b.lx, b.ly, c.lx, c.ly)

#int turtle_flip_factor = 1
#
#def turtle_flip()
#	turtle_flip_factor *= -1
#
#def _turn(da) turtle_a += da * turtle_flip_factor

# TODO turtle_zoom ?

