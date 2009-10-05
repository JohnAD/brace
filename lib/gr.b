export types
export stdarg.h
use m
export sprite event
export gr

int root_w, root_h
int w, h
int w_2, h_2
num ox, oy, sc
int _xflip = 0
int _yflip = 0
sprite struct__screen, *screen = &struct__screen

int _deco = 1
gr_deco(int _d)
	_deco = _d

# last x and y position
num lx = 0, ly = 0   # current pos
num lx2 = 0, ly2 = 0 # prev pos

boolean _autopaint = 0
num _delay = 0

num text_origin_x, text_origin_y, text_wrap_sx
int text_at_col0 = 1

char *vid = NULL

xflip()
	_xflip = !_xflip
	text_origin_x *= -1
yflip()
	_yflip = !_yflip
	text_origin_y *= -1

colour col(colour pixel)

colour bg_col, fg_col

def paper(w, h)
	paper(w, h, white)
def paper(w, h, bg)
	paper(w, h, bg, black)
def paper(w, h, bg, fg)
	gr_init()
	_paper(w, h, bg, fg)
def paper()
	paper(white)
def paper(bg)
	gr_deco(0)
	paper(0, 0, bg)

def space(w, h)
	space(w, h, black)
def space(w, h, bg)
	paper(w, h, bg, white)
def space()
	paper(black)
	col(white)
def space(bg)
	paper(bg)
	col(white)

num a_pixel = 1

boolean gr_exit = 0

def gr_exit(status)
	gr_exit = 1
	exit(status)

origin(num _ox, num _oy)
	ox = _ox ; oy = _oy

def home() move(0, 0)
def text_home() move_to_text_origin()

zoom(num _sc)
	sc = _sc
	a_pixel = isd(1)

# TODO independent X and Y scales?
# using macros to define the transforms, like for deg / rad.

Def screen_trans full
 # can change with def screen_trans fast

def SX(x) SX_^^screen_trans(x)
def SY(y) SY_^^screen_trans(y)
def SD(d) SD_^^screen_trans(d)

def SX_fast(x) (int)sx(x)
def SY_fast(y) (int)sy(y)
def SD_fast(d) (int)sd(d)

def SX_full(x) (int)(sx(x)+0.5)
def SY_full(y) (int)(sy(y)+0.5)
def SD_full(d) (int)(sd(d)+0.5)

def sx(x) sx_^^screen_trans(x)
def sy(y) sy_^^screen_trans(y)
def sd(d) sd_^^screen_trans(d)

def sx_fast(x) sx_center(x)
def sy_fast(y) sy_center(y)
def sd_fast(d) d

def sx_full(x) sx_center(sx_flip(sx_zoom(sx_origin(x))))
def sy_full(x) sy_center(sy_flip(sy_zoom(sy_origin(x))))
def sd_full(d) sd_zoom(d)

def sx_origin(x) x-ox
def sx_zoom(x) x*sc
def sx_flip(x) _xflip ? -x-1 : x
def sx_center(x) w_2+x

def sy_origin(y) y-oy
def sy_zoom(y) y*sc
def sy_flip(y) _yflip ? -y-1 : y
def sy_center(y) h_2-1-y

def sd_zoom(d) d*sc


# old sx,sy,sd functions

#num sx(num x)
#	x = (x-ox)*sc
#	return (_xflip ? w_2-x : w_2+x)
#
#num sy(num y)
#	y = (y-oy)*sc
#	return (_yflip ? h_2+y : h_2-y)
#
#num sd(num d)
#	return d*sc

# inverse functions isx isy isd  (not accelerated yet, no need?)

num isx(num sx)
	if _xflip
		sx = w_2-1-sx
	else
		sx = sx-w_2
	return sx/sc+ox

num isy(num sy)
	if _yflip
		sy = sy-h_2
	else
		sy = h_2-1-sy
	return sy/sc+oy

num isd(num sd)
	return sd/sc


def update_last(x, y)
	move(x, y)

move(num x, num y)
	lx2 = lx ; ly2 = ly
	lx = x ; ly = y

# TODO change "last" to "pos" ?
# XXX need (auto) namespaces!
move2(num x1, num y1, num x2, num y2)
	lx2 = x1 ; ly2 = y1
	lx = x2 ; ly = y2

draw(num x, num y)
	line(lx, ly, x, y)

# these circle routines are excessively complicated now!
# I tried to make circle_fill draw `nice' small circles

def disc(x, y, r) circle_fill(x, y, r)
def dot(x, y, r) circle_fill(x, y, r)

# text functions
# XXX should we have a separate text cursor and graphics cursor?
# TODO wrapping

num _xanc = -1, _yanc = 1

num gprint_tab_width = 2  #  * font_height

gprint_anchor(num xanc, num yanc)
	_xanc = xanc; _yanc = yanc

int gprintf(const char *format, ...)
	collect(vgprintf, format)

int vgprintf(const char *format, va_list ap)
	new(b, buffer)
	int len = Vsprintf(b, format, ap)
	buffer_add_nul(b)
	gprint(buffer_get_start(b))
	buffer_free(b)
	return len

# TODO vgprintf


# not sure if adding _font->ascent is the right thing to do
# TODO different anchors
gsay(char *p)
	gprint(p)
	gnl()

# TODO
int gsayf(const char *format, ...)
	collect(vgsayf, format)

# TODO
int vgsayf(const char *format, va_list ap)
	int len = vgprintf(format, ap)
	gnl()
	return len

gnl()
	num dy = -font_height() # * n FIXME
	if _yflip
		dy = -dy
	move(text_origin_x, ly + dy)
#	move(lx, ly + dy)
	text_at_col0 = 1
def gnl(n) gnl() # XXX FIXME

text_origin(num x, num y)
	text_origin_x = x
	text_origin_y = y

move_to_text_origin()
	move(text_origin_x, text_origin_y)



bg(colour bg)
	bg_col = bg

def clear(c)
	bg(c)
	clear()

Clear(colour c)
	clear(c)
	gr_sync()

def pix_clear() pix_clear(bg_col)
pix_clear(colour c)
	bg(c)
	with_pixel_type(pix_clear_1)

def pix_clear_1(pixel_type)
	pixel_type *px = pixel()
	repeat(w*h)
		*px++ = c

# change this to a macro?
gr__change_hook()
	if _autopaint
		paint()
	if _delay
		Sleep(_delay)

def thin()
	width(0)

def triangle(x0, y0, x1, y1, x2, y2)
	move2(x0, y0, x1, y1)
	triangle(x2, y2)

def quad(x0, y0, x1, y1, x2, y2, x3, y3)
	move2(x0, y0, x1, y1)
	quad(x2, y2, x3, y3)

def quad(x2, y2, x3, y3)
	quadrilateral(x2, y2, x3, y3)

gr_fast()
	autopaint(0)
	gr_delay(0)

autopaint(boolean ap)
	_autopaint = ap

def gr_delay() gr_delay(0)
gr_delay(num delay)
	autopaint(1)
	_delay = delay

num
 rb_red_angle, rb_green_angle, rb_blue_angle,
 rb_red_power, rb_green_power, rb_blue_power

colour rb[360]

rainbow_init()
	rb_red_angle = deg2rad(-120)
	rb_green_angle = 0
	rb_blue_angle = deg2rad(120)

	rb_red_power = 1
#	rb_green_power = 0.8
	rb_green_power = 0.9
	rb_blue_power = 1

	for(i, 0, 360)
		rb[i] = _rainbow(deg2rad(i))

def rainbow(a) _rainbow(angle2rad(a))
colour _rainbow(num a)
	num r = rb_red_power * (cos(a-rb_red_angle)+1)/2
	num g = rb_green_power * (cos(a-rb_green_angle)+1)/2
	num b = rb_blue_power * (cos(a-rb_blue_angle)+1)/2
	return rgb(r, g, b)

random_colour()
	rgb(rand(), rand(), rand())

def grey(p) rgb(p, p, p)

# I'm not sure if this HSV model is correct / standard
def hsv(hue, sat, val) _hsv(angle2rad(hue), sat, val)
colour _hsv(num hue, num sat, num val)
	num r = rb_red_power * (cos(hue-rb_red_angle)+1)/2
	num g = rb_green_power * (cos(hue-rb_green_angle)+1)/2
	num b = rb_blue_power * (cos(hue-rb_blue_angle)+1)/2
	r *= sat
	g *= sat
	b *= sat
	r = 1-(1-r)*(1-val)
	g = 1-(1-g)*(1-val)
	b = 1-(1-b)*(1-val)
	return rgb(r, g, b)

def point()
	point(lx,ly)

# dodgy, need a better way?
def triangle(a, b, c)
	triangle(a.lx, a.ly, b.lx, b.ly, c.lx, c.ly)

def circle(r)
	circle(lx, ly, r)

def circle_fill(r)
	circle_fill(lx, ly, r)

def disc(r)
	disc(lx, ly, r)

boolean curve_at_start = 1
def curve()
	curve_at_start = 1
curve(num x, num y)
	if curve_at_start
		move(x, y)
		curve_at_start = 0
	 else
	 	draw(x, y)

def for_pixels(px)
	pixel_type *px = pixel()
	pixel_type *my(end) = px + w*h
	for ; px != my(end) ; ++px
		.
