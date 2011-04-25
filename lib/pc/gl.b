export SDL_opengl.h
#use GL/glx.h
#use GL/glxext.h

def gl_num GLdouble
def GL_NUM GL_DOUBLE

def sdl_gl_mode SDL_OPENGL
def must_be_fullscreen 0

gl_init()
	.
#glXSwapIntervalSGI(1)
def gl_final()
	.
def swap_buffers() SDL_GL_SwapBuffers()
def glOrthof glOrtho

gl_tex_rect(gl_num x0, gl_num y0, gl_num x1, gl_num y1, gl_num tx0, gl_num ty0, gl_num tx1, gl_num ty1)
	glBegin(GL_QUADS)
	glTexCoord2f(tx0, ty0)
	glVertex2f(x0, y0)
	glTexCoord2f(tx1, ty0)
	glVertex2f(x1, y0)
	glTexCoord2f(tx1, ty1)
	glVertex2f(x1, y1)
	glTexCoord2f(tx0, ty1)
	glVertex2f(x0, y1)
	glEnd()

gl_fill_rect(gl_num x0, gl_num y0, gl_num x1, gl_num y1)
	glBegin(GL_QUADS)
	glVertex2f(x0, y0)
	glVertex2f(x1, y0)
	glVertex2f(x1, y1)
	glVertex2f(x0, y1)
	glEnd()

gl_fill_tri(gl_num x0, gl_num y0, gl_num x1, gl_num y1, gl_num x2, gl_num y2)
	glBegin(GL_TRIANGLES)
	glVertex2f(x0, y0)
	glVertex2f(x1, y1)
	glVertex2f(x2, y2)
	glEnd()
