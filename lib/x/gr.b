export X11/Xlib.h
export X11/Xutil.h
export X11/extensions/XShm.h
use sys/ipc.h
use sys/shm.h
#use X11/Xutil.h - what was this for, again?  I think something in my graph program...
use string.h
use stdio.h
#ld -L/usr/X11R6/lib -lX11 -lXext ??

export error thunk types colours event
use alloc time vec io m util process main

use gr

typedef int gr__x_error_handler(Display *, XErrorEvent *)

Display *display
Window root_window, window
Visual *visual
XVisualInfo *visual_info

Colormap colormap
GC gc
XGCValues gcvalues
XFontStruct *_font = NULL
XColor color
int screen_number
XShmSegmentInfo *shmseginfo = NULL
Atom wm_protocols, wm_delete
int x11_fd

Pixmap gr_buf
XImage *gr_buf_image = NULL
int use_vid = 0
int shm_major, shm_minor
int shm_version
Bool shm_pixmaps

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

boolean fullscreen_grab_keyboard = 1
boolean gr_alloced = 0

gr_init()
#	vec_init(gr__stack, sizeof(GC), 8)
	
	if (display = XOpenDisplay(NULL)) == NULL
		error("cannot open display")

	x11_fd = ConnectionNumber(display)

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

	Atexit(gr_at_exit)

	event_handler_init()

	gr_alloced = 1

gr_at_exit()
	if !gr_done
		Paint()
		event_loop()
	gr_free()

_paper(int width, int height, colour _bg_col, colour _fg_col)
	cstr geom = Getenv("GEOM", NULL)
	if geom && *geom
		cstr delim = geom+strspn(geom, "0123456789")
		if !*delim || !delim[1] || delim == geom
			error("invalid GEOM %s", geom)
		w = atoi(geom) ; h = atoi(delim+1)
	 eif !width || (geom && !*geom)
		gr_fullscreen()
	 else
		w = width ; h = height

	bg_col = _bg_col ; fg_col = _fg_col
	w_2 = w/2 ; h_2 = h/2
	ox = oy = 0
	sc = 1
	text_origin(-w_2, h_2)
	text_wrap_sx = w

	#window = XCreateSimpleWindow(display, root_window, 0, 0, w, h, 0, white, black)

	unsigned long valuemask = 0
	XSetWindowAttributes attributes
	if !_deco
		valuemask |= CWOverrideRedirect
		attributes.override_redirect = True
	window = XCreateWindow(display, root_window, 0, 0, w, h, 0, CopyFromParent, InputOutput, CopyFromParent, valuemask, &attributes)
#	XSetWindowBorderWidth(display, window, 0)

	if atoi(Getenv("MITSHM", "1"))
		shm_version = XShmQueryVersion(display, &shm_major, &shm_minor, &shm_pixmaps)
	 else
		shm_version = 0 ; shm_pixmaps = 0

	if shm_version
		debug("shm_version = %d %d %d pixmaps %d", shm_version, shm_major, shm_minor, shm_pixmaps)
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

		gr__x_error_handler *old_h = XSetErrorHandler(gr__mitshm_fault_h)
		int attach_ok = XShmAttach(display, shmseginfo)
		gr_sync()
		if !(attach_ok && shm_version)
			shm_version = 0 ; shm_pixmaps = 0 ; vid = NULL
			if shmseginfo
				free_shmseg()
		XSetErrorHandler(old_h)
	 else
		debug("no shm extension")

	if shm_pixmaps && XShmPixmapFormat(display) == ZPixmap:
		gr_buf = XShmCreatePixmap(display, window, vid, shmseginfo, w, h, depth)
		debug("using XShmCreatePixmap")
	 eif shm_version
		gr_buf_image = XShmCreateImage(display, visual, depth, ZPixmap, vid, shmseginfo, w, h)
		debug("using XShmCreateImage")
	 else
		vid = Malloc(w*h*pixel_size_i)
		gr_buf_image = XCreateImage(display, visual, depth, ZPixmap, 0, vid, w, h, BitmapPad(display), 0)
		debug("using XCreateImage")
	if gr_buf_image
		assert(w*h*pixel_size == gr_buf_image->bytes_per_line * gr_buf_image->height, "XShmCreateImage returned a strangely sized image")
	 eif !shm_pixmaps
		failed("XCreateImage")
	if !shm_pixmaps
		gr_buf = XCreatePixmap(display, window, w, h, depth)
		debug("using XCreatePixmap")

#	XSetWindowBackgroundPixmap(display, window, gr_buf)

	XSizeHints *normal_hints ; XWMHints *wm_hints ; XClassHint  *class_hints
	normal_hints = XAllocSizeHints()
	wm_hints = XAllocWMHints()
	class_hints = XAllocClassHint()
	normal_hints->flags = PPosition | PSize
	wm_hints->initial_state = NormalState
	wm_hints->input = True
	wm_hints->flags = StateHint | InputHint
	class_hints->res_name = program ; class_hints->res_class = program

	XTextProperty xtp_name
	XStringListToTextProperty(&program, 1, &xtp_name)
	XSetWMProperties(display, window, &xtp_name, &xtp_name, argv, argc, normal_hints, wm_hints, class_hints)
	wm_protocols = XInternAtom(display, "WM_PROTOCOLS", False)
	wm_delete = XInternAtom(display, "WM_DELETE_WINDOW", False)
	XSetWMProtocols(display, window, &wm_delete, 1)

	XSelectInput(display, window, ExposureMask|ButtonPressMask|ButtonReleaseMask|ButtonMotionMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask)
	XMapWindow(display, window)

	if fullscreen && fullscreen_grab_keyboard
		XGrabKeyboard(display, window, True, GrabModeAsync, GrabModeAsync, CurrentTime)

	sprite_screen(screen)

	clear()
	Paint()

int gr__mitshm_fault_h(Display *d, XErrorEvent *e)
	debug("gr__mitshm_fault_h: display %d error_code %d request_code %d minor_code %d", display, e->error_code, e->request_code, e->minor_code)
	if d == display && e->error_code == BadAccess && e->request_code == 139 /* MIT-SHM */ && e->minor_code == X_ShmAttach
		debug("shared memory attach failed - disabling")
		shm_version = 0
	return 0

gr_free()
	if gr_alloced
		if fullscreen && fullscreen_grab_keyboard
			XUngrabKeyboard(display, CurrentTime)
		if visual_info
			XFree(visual_info)
		if shmseginfo
			XShmDetach(display, shmseginfo)
		XFreePixmap(display, gr_buf)
		if gr_buf_image
			XDestroyImage(gr_buf_image)   # frees vid
		if shmseginfo
			free_shmseg()
#		XFreeGC(display, gc)
		XDestroyWindow(display, window)
		XCloseDisplay(display)
		gr_alloced = 0

free_shmseg()
	shmdt(shmseginfo->shmaddr)
	shmctl(shmseginfo->shmid, IPC_RMID, NULL)
	Free(shmseginfo)

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
	colour c
	int r = iclamp(red*256, 0, 255)
	int g = iclamp(green*256, 0, 255)
	int b = iclamp(blue*256, 0, 255)
	if depth >= 24
		c = r<<16 | g<<8 | b
		col(c)
	 else
		# XXX this way is slow and crap!
		char name[8]
		snprintf(name, sizeof(name), "#%02x%02x%02x", r, g, b)
		c = coln(name)
	return c

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

def gprint_warn()
	colour oldcol = fg_col
	yellow()
	XFillRectangle(display, gr_buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(_yanc+1)/2.0+0.5)-_font->ascent, text_width, _font->ascent+_font->descent)
	red()
	XFillRectangle(display, gr_buf, gc, (int)(SX(lx)-text_width*(_xanc+1)/2.0+1), (int)(SY(ly)+_font->ascent*(_yanc+1)/2.0+0.5)-_font->ascent, text_width, _font->ascent)
	col(oldcol)

def gprint_warn()
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
#	gprint_warn()

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

paint_sync(int syncage)
	if shm_pixmaps || !(use_vid || shm_version)
		debug("painting pixmap with XCopyArea (on server / shared)")
		XCopyArea(display, gr_buf, window, gc, 0, 0, w, h, 0, 0)
	 eif shm_version
		debug("painting image with XShmPutImage (shared)")
		XShmPutImage(display, window, gc, gr_buf_image, 0, 0, 0, 0, w, h, False)
	 eif use_vid
		debug("painting image with XPutImage (client->server)  use_vid = %d", use_vid)
		XPutImage(display, window, gc, gr_buf_image, 0, 0, 0, 0, w, h)

	which syncage
	2	gr_sync()
	1	XFlush(display)

	if paint_handle_events || veclen(gr_need_delay_callbacks)
		handle_events(0)


gr_sync()
	XSync(display, False)

gr_flush()
	XFlush(display)

clear()
	colour fg = fg_col
	col(bg_col)
	XFillRectangle(display, gr_buf, gc, 0, 0, w, h)
	col(fg)
	gr__change_hook()
	# need to call paint also to update the actual window

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

quadrilateral(num x2, num y2, num x3, num y3)
	XPoint p[4]
	xpoint_set(p[0], lx2, ly2)
	xpoint_set(p[1], lx, ly)
	xpoint_set(p[2], x2, y2)
	xpoint_set(p[3], x3, y3)
	XFillPolygon(display, gr_buf, gc, p, 4, Convex, CoordModeOrigin)
	move2(x2, y2, x3, y3)

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
		macro(uint32_t)
	 eif depth == 16
		macro(uint16_t)
	 eif depth == 8
		macro(uint8_t)
	 else
		error("unsupported video depth: %d", depth)

boolean gr_do_delay_done
gr_do_delay(num dt)
	gr_do_delay_done = 0
	thunk old_handler = key_handler_default
	key_handler_default = thunk(gr_do_delay_handler)
	if dt == time_forever
		while !gr_do_delay_done
#			debug("gr_do_delay forever looping calling handle_events: veclen(gr_need_delay_callbacks) = %d", veclen(gr_need_delay_callbacks))
			handle_events(1)
#			int n = handle_events(1)
#			debug("  %d", n)
	 else
		num t = rtime()
		num t1 = t + dt
		while t < t1 && !gr_do_delay_done
			if events_queued(0) || veclen(gr_need_delay_callbacks) || can_read(x11_fd, t1-t)
#				debug("gr_do_delay %f looping calling handle_events", dt)
				handle_events(0)
			t = rtime()
	key_handler_default = old_handler

void *gr_do_delay_handler(void *obj, void *a0, void *event)
	use(obj, a0)
	gr_event *e = event
	if e->type == KeyPress:
		gr_do_delay_done = 1
	return thunk_yes

def pixel(vid, X, Y) (use_vid ? 0 : (vid_init(),0)), pixelq(vid, X, Y)

vid_init()
	debug("vid_init: setting use_vid = 1")
	use_vid = 1
