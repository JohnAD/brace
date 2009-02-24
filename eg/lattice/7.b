#!/lang/b
use b
def trig_unit deg
num rt3
Main()
	space(midnightblue)
	gr_fast()
	zoom(40)
	rt3 = sqrt(3.0)

	num a = -360
	num da = 0
	num dda = 0.01

	repeat
		move(0, 0)
		east()
		rt(a)
		clear()
		draw_lattice()
		paint()
		a += da
		if a > 0
			dda = -0.01
		 eif a < 0
			dda = 0.01
		da += dda

def draw_lattice()
#	Printf("%f ", rtime())
#	int xc = Floor(w_2/(sc*rt3/2)+1)
#	int yc = Floor(h_2/sc+1)
	int xc = Floor(hypot(w_2, h_2)/(sc*rt3/2)+1)
	int yc = xc
	for(pass, 0, 4)
		which pass
		0	blue()
		1	white()
		2	black()
		3	green()
		for(x, -xc, xc)
			for(y, -yc, yc)
				int X = x - Div(y, 2)
				int Y = y
				turtle_branch()
					move()
					fd(X)
					lt(60)
					fd(Y)
					draw()
					if fabs(lx) > w_2+sc*3 || fabs(ly) > h_2+sc*3
						continue
					if mod(X-Y, 3) == 0
						which pass
						0	draw_star(1)
						1	circle(0.5)
						2	circle(rt3/2)
					 else
						which pass
						2	disc(0.2)
						3	gprintf("%d,%d", X, Y)
	#	Sayf("%f", rtime())

draw_star(num unit)
	repeat(6)
		turtle_branch()
			fd(unit)
		rt(60)
	rt(30)
	repeat(3)
		turtle_branch()
			fd(rt3*unit)
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

def circle(r)
	circle(lx, ly, r)

def disc(r)
	disc(lx, ly, r)


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

