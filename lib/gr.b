export types
export stdarg.h
use m process
export sprite event
export gr

int root_w, root_h
int w, h
int w_2, h_2
num ox, oy, sc
int _xflip = 0
int _yflip = 0
sprite struct__screen, *screen = NULL
int depth
num pixel_size
int pixel_size_i

boolean fullscreen = 0
boolean _deco = 1

# last x and y position
num lx = 0, ly = 0   # current pos
num lx2 = 0, ly2 = 0 # prev pos

boolean _autopaint = 0
num _delay = 0

boolean paint_handle_events = 1

num text_origin_x, text_origin_y, text_wrap_sx
int text_at_col0 = 1

char *vid = NULL

num a_pixel = 1

boolean gr_done = 1  # set to 0 after successful init
boolean gr_exiting = 0

colour bg_col, fg_col

sighandler_t gr_cleanup_prev_handler[sig_top+1]
int gr_done_signal = 0

int use_vid = 0

num _line_width = 0

colour bg_col_init

gr_deco(int _d)
	_deco = _d

gr_fullscreen()
	fullscreen = 1
	w = root_w ; h = root_h
	gr_deco(0)

xflip()
	_xflip = !_xflip
	text_origin_x *= -1
yflip()
	_yflip = !_yflip
	text_origin_y *= -1

colour col(colour pixel)

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

def gr_exit(status)
	gr_done = 1
	if !gr_exiting
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
	pix_t cp = colour_to_pix(c)
	with_pixel_type(pix_clear_1)

def pix_clear_1(pixel_type)
	pixel_type *px = pixelq()
	repeat(w*h)
		*px++ = cp

# change this to a macro?
gr__change_hook()
	if _autopaint
		paint()
	if _delay
		Rsleep(_delay)

paint()
	paint_sync(1)

Paint()
	paint_sync(2)

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

def pixel(X, Y) pixel(vid, X, Y)
def pixel() pixel(0, 0)
def pixel(pixmap) pixel(pixmap, 0, 0)
def pixelq(vid, X, Y) (void *)(((char *)vid) + ((int)Y*w + (int)X) * pixel_size_i)
def pixelq() pixelq(vid, 0, 0)

colour colour_rand()
	return rgb(Rand(), Rand(), Rand())

gr_at_exit()
#	warn("gr_at_exit done = %d", gr_done)
	gr_exiting = 1
	if !gr_done
#		warn("Paint")
		Paint()
#		warn("event_loop")
		event_loop()
	gr_free()

void gr_cleanup_sig_handler(int sig)
	warn("gr_cleanup_sig_handler: got signal %d, exiting", sig)
	gr_done_signal = sig
	Sigact(sig, gr_cleanup_prev_handler[sig])
	gr_exit(1)

gr_cleanup_catch_signals()
	each(sig, sigs_fatal):
		gr_cleanup_prev_handler[sig] = Sigact(sig, gr_cleanup_sig_handler)

# FIXME on mingw, in the final "exit" event loop, a signal such as SIGINT does
# not result in the sighandler being called.  The shell comes back, but the
# window is not closed, and still responds.

def width(w) line_width(w)  # XXX get rid of this?

def for_screen(px):
	for_sprite(px, screen)
def for_screen(px, d):
	for_sprite(px, screen, d)
def for_screen(px, x, y):
	for_sprite(px, screen, x, y)
def for_screen(px, x, y, w, h):
	for_sprite(px, screen, x, y, w, h)
def for_screen(px, x, y, w, h, d):
	for_sprite(px, screen, x, y, w, h, d)
