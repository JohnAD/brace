#!/lang/b
use b

int r1=180

Main()
	paper()
#	space(640, 480)
#	space(320, 240)
	gr_fast()
	gprint_anchor(0, 0)
	font("helvetica-medium", 200)
	cstr s = args ? join(" ", arg) : "Hello World!"
	num tw = text_width(s)
	int fs = (int)(200*(w-r1*2)/tw * 0.95)
	font("helvetica-medium", fs)
	col(black)
	move(0, 0)
	gsayf(s)
	gr_sync()

	if !vid
		error("xshm pixmaps are not working")

	if depth > 16
#		shiny(long, 32)
		shiny(long)
	 else
		error("shinytext only works in 32 bit colour for now")

def shiny(pixel_type)
	new(corners, vec, XPoint)
	new(left, vec, XPoint)
	new(right, vec, XPoint)
	new(up, vec, XPoint)
	new(down, vec, XPoint)
	pixel_type *px = (pixel_type *)pixel(vid, 1, 1)
	back(y, h_2-2, -h_2)
		for(x, -w_2+1, w_2-1)
			pixel_type o=*px, l=px[-1], r=px[1], u=px[-w], d=px[w]
			if o == black
				int count = 0
				if l == black
					++count
				if r == black
					++count
				if u == black
					++count
				if d == black
					++count
				if count != 4
					XPoint *p
					if count < 3
						p = vec_push(corners)
						red()
						point(x, y)
					 eif count == 3
						if l == white
							p = vec_push(left)
						 eif r == white
							p = vec_push(right)
						 eif u == white
							p = vec_push(up)
						 eif d == white
							p = vec_push(down)
						green()
						point(x, y)
					p->x = x ; p->y = y
			++px
		px += 2
	clear()

	back(r, r1, -1)
		Sayf("%d", r)
		font("helvetica-medium", fs)
		hsv((r*16) % 360, 1, r*1.0/r1)
		for_vec(i, corners, XPoint)
			circle(i->x, i->y, r)
		for_vec(i, up, XPoint)
			point(i->x, i->y + r)
		for_vec(i, right, XPoint)
			point(i->x + r, i->y)
		for_vec(i, down, XPoint)
			point(i->x, i->y - r)
		for_vec(i, left, XPoint)
			point(i->x - r, i->y)
		Paint()

	font("helvetica-medium", fs)
	col(black)
	move(0, 0)
	gsayf(s)
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

def trig_unit deg
