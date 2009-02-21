num turtle_a = 0
num turtle_pendown = 1

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

turtle_go(num dx, num dy)
	num x = lx + (_xflip ? -dx : dx)
	num y = ly + (_yflip ? -dy : dy)
	if turtle_pendown
		draw(x, y)
	 else
	 	move(x, y)

turtle_go_back(num dx, num dy)
	turtle_go(-dx, -dy)

def _turn(da) turtle_a += da
def _turn_to(a) turtle_a = a
def turn(a) _turn(angle2rad(a))
def turn_to(a) _turn_to(angle2rad(a))
def right(a) turn(a)
def left(a) turn(-a)
def turn_around() _turn(pi)

forward(num d)
	turtle_go(sincos(turtle_a, d))
back(num d)
	turtle_go_back(sincos(turtle_a, d))

def move() turtle_pendown = 0
def draw() turtle_pendown = 1
def pen_toggle() turtle_pendown = !turtle_pendown
def pen_down() draw()
def pen_up() move()
def fd(d) forward(d)
def bk(d) forward(d)
def lt(a) left(a)
def rt(a) right(a)

struct turtle_pos
	num lx, ly
	num lx2, ly2
	num turtle_a

turtle_pos get_pos()
	turtle_pos p = { lx, ly, lx2, ly2, turtle_a }
	return p

set_pos(turtle_pos p)
	lx = p.lx
	ly = p.ly
	lx2 = p.lx2
	ly2 = p.ly2
	turtle_a = p.turtle_a

def turtle_branch()
	let(my(p), get_pos())
	post(my(x))
		set_pos(my(p))
	pre(my(x))

# design: how to use triangle() or quad() with turtle?

# dodgy, need a better way?
def triangle(a, b, c)
	triangle(a.lx, a.ly, b.lx, b.ly, c.lx, c.ly)
	gr__change_hook()  # put in main triangle func

use m util
export gr
