#!/lang/b
use b
def trig_unit deg
Main()
	space(midnightblue)
	gr_fast()
#	gr_delay(0.5)

	num a
	for a = 0; ; a+=0.2
		zoom((Cos(a*5)+1)/2*570+30)
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
	int xc = Floor(hypot(w_2, h_2)/(sc*rt3/2)+2)
	int yc = xc
	for(x, -xc, xc)
		for(y, -yc, yc)
			int X = x - Div(y, 2)
			int Y = y
			turtle_branch()
				move()
				fd(X)
				lt(60)
				fd(Y)
				rt(60)
				draw()
				if fabs(lx) > w_2+sc*3 || fabs(ly) > h_2+sc*3
					continue
				if mod(X-Y, 3) == 0
					int Y1 = (Y-X) / 3
					int X1 = (2*X + Y) / 3
					int xm = mod(X1, 2)
					int ym = mod(Y1, 2)
					int n = 2*xm+ym
					fill_star(n)
#					move() ; north(font_height()/2)
#					gprintf("%d,%d", X, Y)
#					gnl()
#					gprintf("%d,%d", X1, Y1)

#	Sayf("%f", rtime())

int star_colors[][12] =
	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
	{ 7, 6, 9, 8, 11, 10, 1, 0, 3, 2, 5, 4 },
	{ 7, 6, 9, 8, 4, 5, 1, 0, 3, 2, 10, 11 },
	{ 0, 1, 2, 3, 11, 10, 6, 7, 8, 9, 5, 4 },
		

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

def fill_star(n)
	num unit = 1
	move()
	let(o, get_pos())
	fd(unit)
	let(a, get_pos())
	for(i, 0, 6)
		int c = star_colors[n][i*2]
		col(rb[c*30])
		set_pos(o)
		lt(60*i)
		lt(30)
		fd(rt3/2*unit)
		let(b, get_pos())
		triangle(a, o, b)
		c = star_colors[n][i*2+1]
		col(rb[c*30])
		set_pos(o)
		lt(60*i)
		lt(60)
		fd(unit)
		a = get_pos()
		triangle(b, o, a)
	set_pos(o)

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

# dodgy, need a better way?
def triangle(a, b, c)
	triangle(a.lx, a.ly, b.lx, b.ly, c.lx, c.ly)
	gr__change_hook()  # put in main triangle func

#int turtle_flip_factor = 1
#
#def turtle_flip()
#	turtle_flip_factor *= -1
#
#def _turn(da) turtle_a += da * turtle_flip_factor

num _xanc = 0, _yanc = 0
gprint_anchor(num xanc, num yanc)
	_xanc = xanc; _yanc = yanc

# this one doesn't do word wrapping but does do anchors!
gprint(char *p)
	int len = strlen(p)
	int text_width = XTextWidth(_font, p, len)
#	yellow()
#	XFillRectangle(display, buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(1-_yanc)/2.0+0.5)-_font->ascent, text_width, _font->ascent+_font->descent)
#	red()
#	XFillRectangle(display, buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(1-_yanc)/2.0+0.5)-_font->ascent, text_width, _font->ascent)
#	white()
#	XDrawString(display, buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+(_font->ascent+_font->descent)*(_yanc-1)/2.0+1)+_font->ascent, p, len)
	XDrawString(display, buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(1-_yanc)/2.0+0.5), p, len)
	gr__change_hook()

# these are the same, just copied here

int gprintf(const char *format, ...)
	collect(vgprintf, format)

int vgprintf(const char *format, va_list ap)
	new(b, buffer)
	int len = Vsprintf(b, format, ap)
	buffer_add_nul(b)
	gprint(buffer_get_start(b))
	buffer_free(b)
	return len

gnl()
	num dy = -font_height() # * n FIXME
	if _yflip
		dy = -dy
	move(lx, ly + dy)
	text_at_col0 = 1
def gnl(n) gnl() # XXX FIXME
