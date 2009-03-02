#!/lang/b
use b
num r1, r2
num rt3
num whiteness

Main()
	rt3 = sqrt(3.0)

#	space(640, 480)
	space()
	gr_fast()
	gprint_anchor(0, 0)
	font("helvetica-bold", 200)
	cstr s = args ? join(" ", arg) : "Hello World!"
	num tw = text_width(s)
	int fs = (int)(200*w/tw * 0.8)

	repeat(50)
		col(rb[Randint(0,360)])
		font("helvetica-medium", fs/Randint(2, 5))
		move(Randint(-w_2, w_2), Randint(-h_2, h_2))
		gsayf(s)

	font("helvetica-bold", fs)
	col(white)
	move(0, 0)
	gsayf(s)

	if !vid
		error("xshm pixmaps are not working")

	if depth > 16
#		shiny(long, 32)
		shiny(long)
	 else
		error("shinytext only works in 32 bit colour for now")

#def shiny(pixel_type, depth)
#	shiny1(pixel_type, r^^depth, g^^depth, b^^depth, fastrgb^^depth)

#def shiny1(pixel_type, r, g, b, rgb)

def shiny(pixel_type)
	int c = 0
	colour cl = white
	repeat
		font("helvetica-bold", fs)
		int m = c++ % 100
		if m == 0
			cl = white
		 eif m == 50
			cl = rb[Randint(0, 360)]
		if Rand() < 0.3
#			move(Randint(-w_2, w_2), Randint(-h_2, h_2))
#			r1 = Rand(5, 50)
#			r2 = r1 * rt3
#			whiteness = Rand(0.2, 0.8)
#			fill_star(0)
			col(rb[Randint(0,360)])
			font("helvetica-medium", fs/Randint(2, 5))
			move(Randint(-w_2, w_2), Randint(-h_2, h_2))
			gsayf(s)
			paint()
		if m == 0 || m == 50
			col(cl)
			font("helvetica-bold", fs)
			move(0, 0)
			gsayf(s)
		pixel_type *px = (pixel_type *)pixel(vid, 1, 1)
		for(y, 1, h-1)
			for(x, 1, w-1)
				pixel_type o
				o=*px
				pixel_type x0=px[-1], x1=px[1], y0=px[-w], y1=px[w]
#				if o == 0 || Rand() < 0.5
				if 1
					o = fastrgb32(
					 fn(r(o), r(x0), r(x1), r(y0), r(y1)),
					 fn(g(o), g(x0), g(x1), g(y0), g(y1)),
					 fn(b(o), b(x0), b(x1), b(y0), b(y1)))
				if Rand() < 0.8 || x<4 || y<4 || x>w-5 || y>h-5
					px[-w-1] = o
				 else
					px[-w-1] = px[Randint(-4, 5) + Randint(-4, 5)*w]
				++px
			px += 2
		back(y, h-2, 0)
			px -= 2
			back(x, w-2, 0)
				--px
				*px = px[-w-1]

		black()
		rect(-w_2, -h_2, w, h)

		Paint()

rect(num x, num y, num w, num h)
	move(x, y)
	draw(x+w-1, y)
	draw(x+w-1, y+h-1)
	draw(x, y+h-1)
	draw(x, y)

# assuming 32 bit colour again:
def r(x) x >> 16 & 0xFF
def g(x) x >> 8 & 0xFF
def b(x) x & 0xFF

def fastrgb32(r0, g0, b0) (long)r0<<16 | (long)g0<<8 | (long)b0

def fnp 3
#def fn(o, x0, x1, x2, x3) iclamp(pow(avg(pow(o, fnp), pow(x0, fnp), pow(x1, fnp), pow(x2, fnp), pow(x3, fnp)), 1.0/fnp)*1.001, 0, 255)

#def fn(o, x0, x1, x2, x3) iclamp(toss() ? avg(o, x0, x1, x2, x3) : max(o, x0, x1, x2, x3)*0.8, 0, 255)
def fn(o, x0, x1, x2, x3) avg(o, x0, x1, x2, x3)

int star_colors[][12] =
	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 },
	{ 7, 6, 9, 8, 11, 10, 1, 0, 3, 2, 5, 4 },
	{ 7, 6, 9, 8, 4, 5, 1, 0, 3, 2, 10, 11 },
	{ 0, 1, 2, 3, 11, 10, 6, 7, 8, 9, 5, 4 },

fill_star(int n)
	move()
	let(o, get_pos())
	fd(r1)
	let(a, get_pos())
	for(i, 0, 6)
		int c = star_colors[n][i*2]
		hsv(c*30, 1, whiteness)
		set_pos(o)
		lt(60*i+30)
		fd(r2)
		let(b, get_pos())
		triangle(a, o, b)
		c = star_colors[n][i*2+1]
		hsv(c*30, 1, whiteness)
		set_pos(o)
		lt(60*i+60)
		fd(r1)
		a = get_pos()
		triangle(b, o, a)
	set_pos(o)
	draw()

def trig_unit deg
