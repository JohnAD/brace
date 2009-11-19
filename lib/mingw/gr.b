use gr
use main
export gl/gl.h gl/glext.h gl/glu.h
use error alloc m process
export colours

typedef void Display

def gr_mingw_debug void

# here's the GL stuff:

GLUquadric *gl_quad
GLUtesselator *gl_tess

gl_size(GLsizei width, GLsizei height)
	glViewport(0, 0, width, height)
	
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	
	gluOrtho2D(0, width, 0, height)

gr_init()
#	if !gr_done
	Atexit(gr_at_exit)
	gr_cleanup_catch_signals()

	colours_init()

	yflip()  # not ideal, means sx coords will differ between X and mingw/opengl

	rainbow_init()

	event_handler_init()

_paper(int width, int height, colour _bg_col, colour _fg_col)
	if width
		w = width ; h = height
	 else
		w = 800 ; h = 600
	bg_col_init = bg_col = _bg_col ; fg_col = _fg_col
	w_2 = w/2 ; h_2 = h/2
	ox = oy = 0
	sc = 1
	text_origin(-w_2, h_2)
	text_wrap_sx = w
	
	_win_init()

	# speed up GL for 2d
	glDisable(GL_DEPTH_TEST)
	glDepthMask(GL_FALSE)
	glMatrixMode(GL_MODELVIEW)
	glLoadIdentity()

	gl_size(w, h)

	gl_quad = gluNewQuadric()
	gl_tess = gluNewTess()
	gluTessCallback(gl_tess, GLU_TESS_BEGIN, glBegin)
	gluTessCallback(gl_tess, GLU_TESS_VERTEX, glVertex3dv)
	gluTessCallback(gl_tess, GLU_TESS_END, glEnd)
#	gluTessCallback(gl_tess, GLU_TESS_COMBINE_DATA, (_GLUfuncptr)myCombine)   # this was causing crashes! dunno why

	depth = 32
	pixel_size = 4
	pixel_size_i = 4

	if use_vid:
		vid_init()

	col(fg_col)
	clear()

	gr_done = 0

	Paint()

gr_free()
	if gr_done_signal
		warn("gr_done_signal")
	.
	# XXX does nothing yet - maybe it should!

gr_sync()
	gr_flush()

gr_flush()
	gr_mingw_debug("gr_flush -> glFlush")
	glFlush()
	# does not actually sync on windows (yet)

def SXR(x) SX(x)+0.5
def SYR(x) SY(x)+0.5

# both of the following don't work, seems to work if I don't set GLU_TESS_COMBINE_DATA callback at all though

#myCombine(GLdouble coords[3], GLdouble *d[4], GLfloat w[4], GLdouble **dataOut, polygon *p)
#	# XXX this could be dodgy, maybe, if it causes a realloc of the array?  might not be expected?
#	#warning("polygons should be non-self-intersecting, but GL thinks otherwise!")
#	# see gluTessCallback(3) if ever need to do this properly
#	polygon_point(p, coords[0], coords[1])
#	*dataOut = p->points + (p->n_points-1)*3

#myCombine_new(GLdouble coords[3], GLdouble *d[4], GLfloat w[4], GLdouble **dataOut, polygon *p)
#	static GLdouble new[3]
#	#warning("polygons should be non-self-intersecting, but GL thinks otherwise!")
#	# see gluTessCallback(3) if ever need to do this properly
#	warn("myCombine")
#	new[0] = coords[0]
#	new[1] = coords[1]
#	new[2] = 0
#	*dataOut = new


gr_destroy()
	gluDeleteQuadric(gl_quad)
	gluDeleteTess(gl_tess)
	
	_win_destroy()

colour _colour

colour col(colour c)
	fg_col = c
#	gr_mingw_debug("col %08lx -> %f %f %f", c, pixn_r(c), pixn_g(c), pixn_b(c))
	glColor3f(pixn_r(c), pixn_g(c), pixn_b(c))  # XXX use an int func?
	return c

colour coln(char *name)
	use(name)
	warn("sorry, no named colours in GL version (yet)")
	return grey   # XXX FIXME

colour rgb(double red, double green, double blue)
	colour c = pixn_rgb_safe(red, green, blue)
#	gr_mingw_debug("rgb %f %f %f -> %08lx", red, green, blue, c)
	return col(c)

circle(double x, double y, double r)
	double r1 = sd(r)
	glPushMatrix()
	glTranslatef(sx(x), sy(y), 0)
	int steps = 2*pi*r1 / 4
	gluDisk(gl_quad, r1-1, r1, steps, 1)
	glPopMatrix()
	gr__change_hook()
	#char buf[1024] ; sprintf(buf, "%lf %lf %d %lf %lf", sx(x), sy(y), steps, r1-1, r1) ; MessageBox(NULL, buf, "circle", MB_OK | MB_ICONINFORMATION)
	# there should be a better way?

circle_fill(double x, double y, double r)
	double r1 = sd(r)
	glPushMatrix()
	glTranslatef(sx(x), sy(y), 0)
	int steps = 2*pi*r1 / 4
	gluDisk(gl_quad, 0, r1, steps, 1)
	glPopMatrix()
	#char buf[1024] ; sprintf(buf, "%lf %lf %d %lf %lf", sx(x), sy(y), steps, 0.0, r1) ; MessageBox(NULL, buf, "circle_fill", MB_OK | MB_ICONINFORMATION)
	gr__change_hook()

rect_fill(double x, double y, double w, double h)
	glRectd(SXR(x), SYR(y), SXR(x+w), SYR(y+h))
	gr__change_hook()

line(double x0, double y0, double x1, double y1)
	glBegin(GL_LINES)
	glVertex2d(SXR(x0), SYR(y0))
	glVertex2d(SXR(x1), SYR(y1))
	glEnd()
	update_last(x1, y1)
	gr__change_hook()

point(double x, double y)
	#char buf[1024] ; sprintf(buf, "%lf %lf", sx(x), sy(y)) ; MessageBox(NULL, buf, "point", MB_OK | MB_ICONINFORMATION)
	glBegin(GL_POINTS)
	glVertex2d(SXR(x), SYR(y))
	glEnd()
	gr__change_hook()

# polygons, outline and filled...  but how to do hollow polygons?  ah, who cares!
# we'll paint the lakes over the land...

# FIXME why are these polygons not implemented using vec? maybe I did this first?

struct polygon
	GLdouble *points
	int n_points
	int space
typedef struct polygon polygon

polygon_start(struct polygon *p, int n_points_estimate)
	p->points = Malloc(n_points_estimate * sizeof(GLdouble)*3)
	p->n_points = 0
	p->space = n_points_estimate

# should be `local' (static) but it's not working right,
# 1. brace doesn't insert void automatically if there's a `local'
# 2. brace_header extracts static / local functions too
_polygon_point(struct polygon *p, double x, double y)
	if p->n_points == p->space
		p->space = p->n_points * 2
		Realloc(p->points, p->space * sizeof(GLdouble)*3)
	GLdouble *point = p->points + p->n_points * 3
	point[0] = x
	point[1] = y
	point[2] = 0
	++p->n_points

polygon_point(struct polygon *p, double x, double y)
	_polygon_point(p, SXR(x), SYR(y))

polygon_draw(struct polygon *p)
	glBegin(GL_LINE_LOOP)
	GLdouble *point = p->points
	int i = p->n_points
	for ; i>0; --i
			glVertex2d(point[0], point[1])
		point += 3
	glEnd()
	gr__change_hook()

polygon_fill(struct polygon *p)
	# TODO should use instead: glBegin(GL_POLYGON)  ..  glEnd()
	gluTessBeginPolygon(gl_tess, p)
	gluTessBeginContour(gl_tess)
	int i = p->n_points
	GLdouble *point = p->points
	for ; i>0; --i
#		warn("poly fill %d", i)
		gluTessVertex(gl_tess, point, point)
		point += 3
	gluTessEndContour(gl_tess)
	gluTessEndPolygon(gl_tess)
#	warn("poly fill done")
	# makes sure the thing shows up if it's small
#	glBegin(GL_POINTS)
#	glVertex2d(p->points[0], p->points[1])
#	glEnd()
	gr__change_hook()

polygon_end(struct polygon *p)
	Free(p->points)

clear()
#	colour fg = fg_col
#	gol(bg_col)
#	gr_mingw_debug("clear %08lx -> %f %f %f", bg_col, pixn_r(bg_col), pixn_g(bg_col), pixn_b(bg_col))
	glClearColor(pixn_r(bg_col), pixn_g(bg_col), pixn_b(bg_col), 0)  # XXX use an int func?
	glClear(GL_COLOR_BUFFER_BIT)
#	col(fg)
	gr__change_hook()
	# TODO simplify this, no need to change with col()  ?
	# need to call paint also to update the actual window

# I have no font / text support in GL yet

gprint(cstr s)
	warn("gprint: %s", s)  # XXX FIXME sorry, no text in GL version (yet)
num font_height()
	warn("sorry, no text in GL version (yet)")
	return isd(10)   # XXX FIXME

paint_sync(int syncage)
	if vid:
		# TODO invert or something !@#!@#%!
		glDrawPixels(w, h, GL_BGRA, GL_UNSIGNED_BYTE, vid)
	SwapBuffers(hDC)
	if syncage
		glFlush()  # XXX do this instead of SwapBuffers again?
#	SwapBuffers(hDC)  # XXX XXX I don't know why, but apparently it's necessary to do this twice in order to get something to display!

	if paint_handle_events || veclen(gr_need_delay_callbacks)
		handle_events(0)

# here's the Windoze stuff:

^define WIN32_LEAN_AND_MEAN
export windows.h

HWND hWnd
HDC hDC
HGLRC hRC
MSG msg

#int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int iCmdShow)

_win_init()
	WNDCLASS wc
	DWORD dwExStyle
	DWORD dwStyle
	RECT rect
	HINSTANCE hInstance = GetModuleHandle(NULL)
	
	rect.left = 0
	rect.right = w
	rect.top = 0
	rect.bottom = h
	
	wc.style = CS_OWNDC
	wc.lpfnWndProc = WndProc
	wc.cbClsExtra = 0
	wc.cbWndExtra = 0
	wc.hInstance = hInstance
	wc.hIcon = LoadIcon(NULL, IDI_APPLICATION)
	wc.hCursor = LoadCursor(NULL, IDC_ARROW)
	wc.hbrBackground = NULL
	wc.lpszMenuName = NULL
	wc.lpszClassName = program
	RegisterClass(&wc)
	
	dwExStyle = WS_EX_APPWINDOW | WS_EX_WINDOWEDGE
	dwStyle = WS_OVERLAPPEDWINDOW | WS_VISIBLE
	
	AdjustWindowRectEx(&rect, dwStyle, FALSE, dwExStyle)
	
	#char buf[1024]
	#sprintf(buf, "Rect: %ld %ld %ld %ld\n", rect.left, rect.right, rect.top, rect.bottom)
	#MessageBox(NULL, buf, "Window Outside Rectangle", MB_OK | MB_ICONINFORMATION);
	hWnd = CreateWindowEx(dwExStyle, program, program, dwStyle | WS_CLIPSIBLINGS | WS_CLIPCHILDREN, 0, 0, rect.right-rect.left, rect.bottom-rect.top, NULL, NULL, hInstance, NULL)
	
	EnableOpenGL(hWnd, &hDC, &hRC)

int _win_destroy()
	DisableOpenGL(hWnd, hDC, hRC)
	DestroyWindow(hWnd)
	return msg.wParam

EnableOpenGL(HWND hWnd, HDC * hDC, HGLRC * hRC)
	PIXELFORMATDESCRIPTOR pfd
	int format
	
	*hDC = GetDC(hWnd)
	
	# set the pixel format for the DC
	ZeroMemory(&pfd, sizeof(pfd))
	pfd.nSize = sizeof(pfd)
	pfd.nVersion = 1
	pfd.dwFlags = PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER
	pfd.iPixelType = PFD_TYPE_RGBA
	pfd.cColorBits = 24  # was 16
	pfd.cDepthBits = 0
	#pfd.cColorBits = 24
	#pfd.cDepthBits = 16
	pfd.iLayerType = PFD_MAIN_PLANE
	format = ChoosePixelFormat(*hDC, &pfd)
	SetPixelFormat(*hDC, format, &pfd)
	
	*hRC = wglCreateContext(*hDC)
	wglMakeCurrent(*hDC, *hRC)

DisableOpenGL(HWND hWnd, HDC hDC, HGLRC hRC)
	wglMakeCurrent(NULL, NULL)
	wglDeleteContext(hRC)
	ReleaseDC(hWnd, hDC)

triangle(num x2, num y2)
	polygon p
	polygon_start(&p, 3)
	polygon_point(&p, lx2, ly2)
	polygon_point(&p, lx, ly)
	polygon_point(&p, x2, y2)
	polygon_fill(&p)
	polygon_end(&p)
	move2(lx, ly, x2, y2)
	# TODO make faster; don't use polygon ?

quadrilateral(num x2, num y2, num x3, num y3)
	polygon p
	polygon_start(&p, 4)
	polygon_point(&p, lx2, ly2)
	polygon_point(&p, lx, ly)
	polygon_point(&p, x2, y2)
	polygon_point(&p, x3, y3)
	polygon_fill(&p)
	polygon_end(&p)
	move2(x2, y2, x3, y3)
	# TODO make faster; don't use polygon ?

def with_pixel_type(macro)
	# assuming 24/32 bpp
	macro(uint32_t)

# FIXME only do this for pixel()
def pixel(vid, X, Y) (screen ? 0 : (vid_init(),0)), pixelq(vid, X, Y)

vid_init()
	if !screen
		use_vid = 1
		vid = Malloc(w*h*pixel_size_i)
		bzero(vid, w*h*pixel_size_i)
		  # XXX clears to black, not to background color
		screen = &struct__screen
		sprite_screen(screen)
		pix_clear(bg_col_init)

# XXX FIXME TODO for GL:

line_width(num width)
	_line_width = width
	int w = SD(width)
	use(w)
	# TODO

# XXX FIXME TODO for GL:

font(cstr name, int size)
	use(name, size)
def font(name) font(name, 14)   # XXX bogus / inconsistent

sprite_screen(sprite *s)
	s->width = w
	s->height = h
	s->stride = -w
	s->pixels = (pix_t *)pixel(vid) + w*(h-1)
	# this is because glDrawPixels draws stuff upside down
