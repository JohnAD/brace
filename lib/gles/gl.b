export SDL/SDL_syswm.h
export EGL/egl.h
export GLES/gl.h

def gl_num GLfloat
def GL_NUM GL_FLOAT

def sdl_gl_mode SDL_SWSURFACE|SDL_FULLSCREEN
def must_be_fullscreen 1

EGLDisplay g_eglDisplay = 0
EGLConfig g_eglConfig = 0
EGLContext g_eglContext = 0
EGLSurface g_eglSurface = 0
Display *g_x11Display = NULL

def COLOURDEPTH_RED_SIZE 5
def COLOURDEPTH_GREEN_SIZE 6
def COLOURDEPTH_BLUE_SIZE 5
def COLOURDEPTH_DEPTH_SIZE 16

static const EGLint g_configAttribs[] =
#	EGL_RED_SIZE, COLOURDEPTH_RED_SIZE,
#	EGL_GREEN_SIZE, COLOURDEPTH_GREEN_SIZE,
#	EGL_BLUE_SIZE, COLOURDEPTH_BLUE_SIZE,
#	EGL_DEPTH_SIZE, COLOURDEPTH_DEPTH_SIZE,
	EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
#	EGL_RENDERABLE_TYPE, EGL_OPENGL_ES_BIT,
#	EGL_BIND_TO_TEXTURE_RGBA, EGL_TRUE,
	EGL_NONE

bit gles_init_ok = 0

gl_init()
	g_x11Display = XOpenDisplay(NULL)
	if !g_x11Display
		failed("XOpenDisplay")

	g_eglDisplay = eglGetDisplay((EGLNativeDisplayType)g_x11Display)
	if g_eglDisplay == EGL_NO_DISPLAY
		failed("eglGetDisplay")

	if !eglInitialize(g_eglDisplay, NULL, NULL)
		failed("eglInitialize")

	EGLint numConfigsOut = 0
	if eglChooseConfig(g_eglDisplay, g_configAttribs, &g_eglConfig, 1, &numConfigsOut) != EGL_TRUE || numConfigsOut == 0
		failed("eglChooseConfig")

	SDL_SysWMinfo sysInfo
	SDL_VERSION(&sysInfo.version)
	if SDL_GetWMInfo(&sysInfo) <= 0
		failed("SDL_GetWMInfo")

	g_eglSurface = eglCreateWindowSurface(g_eglDisplay, g_eglConfig, (EGLNativeWindowType)sysInfo.info.x11.window, 0)
	if g_eglSurface == EGL_NO_SURFACE
		failed("eglCreateWindowSurface")

#	eglBindAPI(EGL_OPENGL_ES_API)
	EGLint contextParams[] = { EGL_CONTEXT_CLIENT_VERSION, 1, EGL_NONE }
	g_eglContext = eglCreateContext(g_eglDisplay, g_eglConfig, EGL_NO_CONTEXT, contextParams)
	if g_eglContext == EGL_NO_CONTEXT
		failed("eglCreateContext")

	if eglMakeCurrent(g_eglDisplay, g_eglSurface, g_eglSurface, g_eglContext) == EGL_FALSE
		failed("eglMakeCurrent")

	gles_init_ok = 1

gl_final()
	if !gles_init_ok
		return
	eglMakeCurrent(g_eglDisplay, NULL, NULL, EGL_NO_CONTEXT)
	eglDestroySurface(g_eglDisplay, g_eglSurface)
	eglDestroyContext(g_eglDisplay, g_eglContext)
	g_eglSurface = 0
	g_eglContext = 0
	g_eglConfig = 0
	eglTerminate(g_eglDisplay)
	g_eglDisplay = 0
	XCloseDisplay(g_x11Display)
	g_x11Display = NULL

def glColor3f(r, g, b) glColor4f(r, g, b, 1)

def swap_buffers() eglSwapBuffers(g_eglDisplay, g_eglSurface)

def GL_BGRA GL_RGBA

gl_tex_rect(gl_num x0, gl_num y0, gl_num x1, gl_num y1, gl_num tx0, gl_num ty0, gl_num tx1, gl_num ty1)
	GLfloat v[8] = {x0,y0, x1,y0, x1,y1, x0,y1}
	GLfloat t[8] = {tx0,ty0, tx1,ty0, tx1,ty1, tx0,ty1}
	glVertexPointer(2, GL_FLOAT, 0, v)
	glTexCoordPointer(2, GL_FLOAT, 0, t)
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4)

gl_fill_rect(gl_num x0, gl_num y0, gl_num x1, gl_num y1)
	GLfloat v[8] = {x0,y0, x1,y0, x1,y1, x0,y1}
	glVertexPointer(2, GL_FLOAT, 0, v)
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4)

gl_fill_tri(gl_num x0, gl_num y0, gl_num x1, gl_num y1, gl_num x2, gl_num y2)
	GLfloat v[6] = {x0,y0, x1,y1, x2,y2}
	glVertexPointer(2, GL_FLOAT, 0, v)
	glDrawArrays(GL_TRIANGLES, 0, 3)
