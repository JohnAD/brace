export X11/Xlib.h
export X11/Xutil.h
export X11/extensions/XShm.h
use sys/ipc.h
use sys/shm.h
#use X11/Xutil.h - what was this for, again?  I think something in my graph program...
use string.h
use stdio.h
#ld -L/usr/X11R6/lib -lX11 -lXext ??

export types colours
use error alloc time vec io m util process

use gr

Display *display
Window root_window, window
Visual *visual
XVisualInfo *visual_info
int depth
num pixel_size
int pixel_size_i
Pixmap gr_buf
Colormap colormap
GC gc
XGCValues gcvalues
XFontStruct *_font = NULL
XColor color
int screen_number
XEvent x_event
XShmSegmentInfo *shmseginfo = NULL

font(cstr name, int size)
	let(xfontname, format("-*-%s-r-normal--%d-*-100-100-p-*-iso8859-1", name, size))
	xfont(xfontname)
	Free(xfontname)

#local vec struct__gr__stack
#local vec *gr__stack = &struct__gr__stack
# # of gc
#gr_push()
#	*(GC *)vec_push(gc_stack) = gc
#gr_pop()
#	gc = *(GC *)vec_top(gc_stack, 0)
#	vec_pop(gr__stack)
#
#gr_

gr_init()
#	vec_init(gr__stack, sizeof(GC), 8)
	
	if (display = XOpenDisplay(NULL)) == NULL
		error("cannot open display")
	
	screen_number = DefaultScreen(display)
	visual = DefaultVisual(display, screen_number)

	int nitems_return
	XVisualInfo vinfo_template
	vinfo_template.visualid = XVisualIDFromVisual(visual);
	visual_info = XGetVisualInfo(display, VisualIDMask, &vinfo_template, &nitems_return)
	if visual_info == NULL || nitems_return != 1
		failed("XGetVisualInfo")

	depth = DefaultDepth(display, screen_number)
	white = WhitePixel(display, screen_number)  # TODO remove this, colours_init() can do it?
	black = BlackPixel(display, screen_number)
	colormap = DefaultColormap(display, screen_number)

	# not sure if the following is correct for all visuals, or how to get it more sensibly
	pixel_size = depth / 8.0
	if pixel_size == 3
		pixel_size = 4
	pixel_size_i = (int)pixel_size

	gc = DefaultGC(display, screen_number)
	gcvalues.function = GXcopy
	gcvalues.foreground = white
	gcvalues.cap_style = CapNotLast
	gcvalues.line_width = _line_width
	XChangeGC(display, gc, GCFunction|GCForeground|GCCapStyle|GCLineWidth, &gcvalues)
	
	#xfont("-adobe-helvetica-medium-r-normal--11-80-100-100-p-56-iso8859-1")

	root_window = DefaultRootWindow(display)
	colours_init()

	font("helvetica-medium", 12)

	XWindowAttributes window_attributes
	if XGetWindowAttributes(display, root_window, &window_attributes)
		root_w = window_attributes.width
		root_h = window_attributes.height

	rainbow_init()

	if !gr_exit
		Atexit(event_loop_at_exit)

_paper(int width, int height, colour _bg_col, colour _fg_col)
	if width
		w = width ; h = height
	 else
		w = root_w ; h = root_h
	bg_col = _bg_col ; fg_col = _fg_col
	w_2 = w/2 ; h_2 = h/2
	ox = oy = 0
	sc = 1
	text_origin(-w_2, h_2)
	text_wrap_sx = width

	#window = XCreateSimpleWindow(display, root_window, 0, 0, w, h, 0, white, black)

	unsigned long valuemask = 0
	XSetWindowAttributes attributes
	if !_deco
		valuemask |= CWOverrideRedirect
		attributes.override_redirect = True
	window = XCreateWindow(display, root_window, 0, 0, w, h, 0, CopyFromParent, InputOutput, CopyFromParent, valuemask, &attributes)

	int shm_major, shm_minor
	Bool shm_pixmaps

	Bool shm_ok = XShmQueryVersion(display, &shm_major, &shm_minor, &shm_pixmaps) && shm_pixmaps ==True && XShmPixmapFormat(display) == ZPixmap

	if shm_ok
		shmseginfo = Talloc(XShmSegmentInfo)
		bzero(shmseginfo)

		shmseginfo->shmid = shmget(IPC_PRIVATE, w * h * pixel_size, IPC_CREAT|0777)
		if shmseginfo->shmid < 0
			failed("shmget")
		shmseginfo->shmaddr = shmat(shmseginfo->shmid, NULL, 0)
		vid = (char *)shmseginfo->shmaddr
		if !vid
			failed("shmat")
		shmseginfo->readOnly = False

		if !XShmAttach(display, shmseginfo)
			failed("XShmAttach")

		gr_buf = XShmCreatePixmap(display, window, vid, shmseginfo, w, h, depth)
	 else
		gr_buf = XCreatePixmap(display, window, w, h, depth)

#	XSetWindowBackgroundPixmap(display, window, gr_buf)

	XSelectInput(display, window, ExposureMask|ButtonPressMask|ButtonReleaseMask|ButtonMotionMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask)
	XMapWindow(display, window)

	clear()
	Paint()

gr_free()
	if visual_info
		XFree(visual_info)
	if shmseginfo
		XShmDetach(display, shmseginfo)
	XFreePixmap(display, gr_buf)
	if shmseginfo
		shmdt(shmseginfo->shmaddr)
		shmctl(shmseginfo->shmid, IPC_RMID, NULL)
		Free(shmseginfo)
	XFreeGC(display, gc)
	XDestroyWindow(display, window)
	XCloseDisplay(display)

xfont(const char *font_name)
#	gnl()
	# XXX does this have a memory leak?
	if (_font = XLoadQueryFont(display, font_name)) == NULL
		error("cannot load font %s", font_name)
	gcvalues.font = _font->fid
	XChangeGC(display, gc, GCFont, &gcvalues)
#	gnl(-1)
def font(name) xfont(name)

colour rgb(num red, num green, num blue)
	char name[8]
	int r, g, b
	r = iclamp(red*256, 0, 255)
	g = iclamp(green*256, 0, 255)
	b = iclamp(blue*256, 0, 255)
	snprintf(name, sizeof(name), "#%02x%02x%02x", r, g, b)
	return coln(name)

colour col(colour pixel)
	gcvalues.foreground = pixel
	XChangeGC(display, gc, GCForeground, &gcvalues)
	fg_col = pixel
	return pixel

colour coln(char *name)
	# TODO cache colours in a hashtable to speed this up?
	if XAllocNamedColor(display, colormap, name, &color, &color)
		return col(color.pixel)
	return white

line_width(num width)
	_line_width = width
	int w = SD(width)
	gcvalues.line_width = w
	XChangeGC(display, gc, GCLineWidth, &gcvalues)
def width(w) line_width(w)
num _line_width = 0

rect(num x, num y, num w, num h)
	move(x, y)
	draw(x+w-1, y)
	draw(x+w-1, y+h-1)
	draw(x, y+h-1)
	draw(x, y)

rect_fill(num x, num y, num w, num h)
	# this impl won't work with a rotated transform
	int X, Y, W, H
	X = SX(x) ; Y = SY(y) ; W = SD(w) ; H = SD(h)
	if !_yflip
		Y -= H
	XFillRectangle(display, gr_buf, gc, X, Y, W, H)
	gr__change_hook()

line(num x0, num y0, num x1, num y1)
	XDrawLine(display, gr_buf, gc, SX(x0), SY(y0), SX(x1), SY(y1))
	update_last(x1, y1)
	gr__change_hook()

point(num x, num y)
	XDrawPoint(display, gr_buf, gc, SX(x), SY(y))
	gr__change_hook()

circle(num x, num y, num r)
	int x0, y0, x1, y1, w, h, tmp
	x0 = SX(x-r) ; y0 = SY(y-r)
	x1 = SX(x+r) ; y1 = SY(y+r)
	if (x1 < x0)
		tmp = x0 ; x0 = x1 ; x1 = tmp
	if (y1 < y0)
		tmp = y0 ; y0 = y1 ; y1 = tmp
	w = x1 - x0
	h = y1 - y0
	# printf("%d %d %d %d\n", x0, y0, w, h)
	if w == 0
		# && h = 0, I hope!
		XDrawPoint(display, gr_buf, gc, x0, y0)
	else
		XDrawArc(display, gr_buf, gc, x0, y0, w, h, 0, 64*360)
	#rgb(1, 0, 0)
	#point(x, y)
	#rgb(1, 1, 1)
	gr__change_hook()

circle_fill(num x, num y, num r)
	int old_width = _line_width
	line_width(0)
	int x0, y0, x1, y1, w, h, tmp
	x0 = SX(x-r) ; y0 = SY(y-r)
	x1 = SX(x+r) ; y1 = SY(y+r)
	if (x1 < x0)
		tmp = x0 ; x0 = x1 ; x1 = tmp
	if (y1 < y0)
		tmp = y0 ; y0 = y1 ; y1 = tmp
	w = x1 - x0
	h = y1 - y0
	# printf("%d %d %d %d\n", x0, y0, w, h)
	if w == 0
		# && h = 0, I hope!
		XDrawPoint(display, gr_buf, gc, x0, y0)
	 else
		XFillArc(display, gr_buf, gc, x0, y0, w, h, 0, 64*360)
		XDrawArc(display, gr_buf, gc, x0, y0, w, h, 0, 64*360)
	#rgb(1, 0, 0)
	#point(x, y)
	#rgb(1, 1, 1)
	gr__change_hook()
	line_width(old_width)

# polygons, outline and filled...  but how to do hollow polygons?  ah, who cares!
# we'll paint the lakes over the land...

# FIXME why are these polygons not implemented using vec? maybe I did this first?

# should really try to do this generically
# this really wants to be written in C++
struct polygon
	XPoint *points
	int n_points
	int space

polygon_start(struct polygon *p, int n_points_estimate)
	p->points = Malloc(n_points_estimate * sizeof(XPoint))
	p->n_points = 0
	p->space = n_points_estimate

# should be `local' (static) but it's not working right,
# 1. brace doesn't insert void automatically if there's a `local'
# 2. brace_header extracts static / local functions too
_polygon_point(struct polygon *p, short x, short y)
	if p->n_points == p->space
		p->space = p->n_points * 2
		Realloc(p->points, p->space * sizeof(XPoint))
	XPoint *point = p->points + p->n_points
	point->x = x
	point->y = y
	++p->n_points

polygon_point(struct polygon *p, num x, num y)
	_polygon_point(p, SX(x), SY(y))

polygon_draw(struct polygon *p)
	# close the polygon
	XPoint *first_point = p->points
	_polygon_point(p, first_point->x, first_point->y)
	# and draw it
	XDrawLines(display, gr_buf, gc, p->points, p->n_points, CoordModeOrigin)
	# now unclose it again!
	--(p->n_points)
	gr__change_hook()

polygon_fill(struct polygon *p)
	XFillPolygon(display, gr_buf, gc, p->points, p->n_points, Complex, CoordModeOrigin)
	# make sure the thing shows up if it's small
	XDrawPoint(display, gr_buf, gc, p->points->x, p->points->y)
	# should probably use Nonconvex instead of Complex,
	# it might be faster
	gr__change_hook()

polygon_end(struct polygon *p)
	Free(p->points)

def gprint_debug()
	colour oldcol = fg_col
	yellow()
	XFillRectangle(display, gr_buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(_yanc+1)/2.0+0.5)-_font->ascent, text_width, _font->ascent+_font->descent)
	red()
	XFillRectangle(display, gr_buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(_yanc+1)/2.0+0.5)-_font->ascent, text_width, _font->ascent)
	col(oldcol)

def gprint_debug()
	void()

num text_width(char *p)
	# tab support, limited to indent for now!
	int tabs_width = 0
	while *p == '\t'
		tabs_width += gprint_tab_width * font_height()
		++p

	int len = strlen(p)
	return tabs_width + isd(XTextWidth(_font, p, len))

# this one doesn't do word wrapping but does do anchors!
gprint(char *p)
#	gprint_debug()

	# tab support, limited to indent for now!
	while *p == '\t'
		lx += gprint_tab_width * font_height()
		++p

	int len = strlen(p)
	int text_width = XTextWidth(_font, p, len)

#	XDrawString(display, gr_buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+(_font->ascent+_font->descent)*(_yanc-1)/2.0+1)+_font->ascent, p, len)
# the anchoring uses the ascent portion of the box only, this looks better
	XDrawString(display, gr_buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(_yanc+1)/2.0+0.5), p, len)
	move(lx + text_width, ly)
	gr__change_hook()

## not sure if adding _font->ascent is the right thing to do
## TODO different anchors
#gprint(char *p)
#	char *q
#	int len
#	repeat
#		len = strcspn(p, " \n")
#		q = p + len
#		if *q == ' '
#			++len
#		int text_width = XTextWidth(_font, p, len)
#		if text_width + SX(lx) > text_wrap_sx && !text_at_col0
#			gnl()
#		eif len
#			text_at_col0 = 0
#		if len
#			XDrawString(display, gr_buf, gc, SX(lx), SY(ly)+_font->ascent, p, len)
#			move(lx + isd(text_width), ly)
#		if *q == '\n'
#			gnl()
#		 eif *q == '\0' || len == 0
#			break
#		p = q+1
#	gr__change_hook()

num font_height()
	return isd(_font->ascent + _font->descent)

# TODO bbox function for fonts / text

paint()
	XCopyArea(display, gr_buf, window, gc, 0, 0, w, h, 0, 0)
#	XClearWindow(display, window)

	# XClearWindow doesn't work to render the pixmap, I think the X server
	# was trying to be clever and remembered that it hadn't changed the
	# pixmap or the window since it was last painted.  but I changed it
	# through shm!

	XFlush(display)

# this one waits for the paint to complete, in case you are poking the shm pixmap thing
Paint()
	XCopyArea(display, gr_buf, window, gc, 0, 0, w, h, 0, 0)
#	XClearWindow(display, window)
	gr_sync()

gr_sync()
	XSync(display, False)

clear()
	colour fg = fg_col
	col(bg_col)
	XFillRectangle(display, gr_buf, gc, 0, 0, w, h)
	col(fg)
	gr__change_hook()
	# need to call paint also to update the actual window

#def done() event_loop()
event_loop()
	repeat
		XNextEvent(display, &x_event)
		which x_event.type
		Expose	if x_event.xexpose.count == 0
				paint()

triangle(num x2, num y2)
	XPoint p[3]
	xpoint_set(p[0], lx2, ly2)
	xpoint_set(p[1], lx, ly)
	xpoint_set(p[2], x2, y2)
	XFillPolygon(display, gr_buf, gc, p, 3, Convex, CoordModeOrigin)
	move2(lx, ly, x2, y2)

def xpoint_set(xpoint, X, Y)
	xpoint.x = SX(X)
	xpoint.y = SY(Y)

quad(num x2, num y2, num x3, num y3)
	XPoint p[4]
	xpoint_set(p[0], lx2, ly2)
	xpoint_set(p[1], lx, ly)
	xpoint_set(p[2], x2, y2)
	xpoint_set(p[3], x3, y3)
	XFillPolygon(display, gr_buf, gc, p, 4, Convex, CoordModeOrigin)
	move2(x2, y2, x3, y3)

def pixel(X, Y) pixel(vid, X, Y)
def pixel(vid, X, Y) (void *)(((char *)vid) + ((int)Y*w + (int)X) * pixel_size_i)
def pixel() pixel(0, 0)
def pixel(pixmap) pixel(pixmap, 0, 0)

# type can be png, gif, jpeg ...


dump_img(cstr type, cstr file, num scale)
	cstr file_out = ""
	cstr scale_filter = ""
	cstr tool
	if cstr_eq(type, "png")
		tool = "pnmtopng"
	 eif cstr_eq(type, "gif")
		tool = "ppmquant 256 | ppmtogif"
	 eif cstr_eq(type, "jpeg")
		tool = "pnmtojpeg"
	 else
		error("dump_img: unsupported image type: %s", type)
		return  # keep gcc happy
	if file
		new(b, buffer, 256)
		system_quote(file, b)
		cstr file_q = buffer_to_cstr(b)
		file_out = format("> %s", file_q)
		Free(file_q)
	if scale != 1
		scale_filter = format("pnmscale %f |", scale)
	Systemf(SH_QUIET "xwd -id %ld | xwdtopnm | %s %s %s", window, scale_filter, tool, file_out)
	 # pnmcrop -black
	if file
		Free(file_out)
	if scale != 1
		Free(scale_filter)

def dump_img()
	dump_img("png")
def dump_img(type)
	dump_img(type, NULL)
def dump_img(type, file)
	dump_img(type, file, 1)

def with_pixel_type(macro)
	if depth > 16
		macro(long)
	 eif depth == 16
		macro(short)
	 eif depth == 8
		macro(char)
	 else
		error("unsupported video depth: %d", depth)
