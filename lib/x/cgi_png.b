use cgi
use io process env stdc gr time cstr util alloc
export types

# This HACK requires a vnc server, uses Setenv, etc.
# It's a demo, has bugs,  not suitable for serious use.
# TODO locking

def SH_QUIET "exec 2>/dev/null; "

cstr cgi_png_display = ":99.0"
cstr cgi_png_display1

def cgi_png() cgi_png(1024, 1024)
def cgi_png(w, h) cgi_png(w, h, 1)

cgi_png(int w, int h, num scale)
	char *p = strchr(cgi_png_display, '.')
	if !p
		error("cgi_png_display %s is invalid, should be like :99.0", cgi_png_display)
	cgi_png_display1 = strndup(cgi_png_display, p-cgi_png_display)
	cgi_png_scale = scale
	cgi_content_type("image/png")
#	Say("Content-Type: text/plain\r")

	Putenv(format("DISPLAY=%s", cgi_png_display))
#	Setenv("PATH", "/home/sam/all/brace/exe:/usr/lib/ccache/bin:/home/share/aliases:/home/share/hacks:/home/share/abbrev:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/opt/bin:/opt/blackdown-jre-1.4.1/bin:/usr/games:/home/share/lib/sh:/home/sam/all/darcs-utils")
	cstr user = whoami()
	Setenv("USER", user)
	Putenv(format("HOME=/home/%s", user))
#	Setenv("HOME", format("/home/%s", user))

	Systemf(SH_QUIET "tightvncserver -kill %s; tightvncserver %s -geometry %dx%d -depth 16 ; xsetroot -solid black", cgi_png_display1, cgi_png_display1, w, h)
	# FIXME set resolution based on paper size!

	gr_fast()
	gr_auto_event_loop = 0

	Atexit(cgi_png_done)


num cgi_png_scale

cgi_png_done()
	paint()
	if cgi_png_scale == 1
		dump_png()
	 else
	 	dump_png(cgi_png_scale)

	Systemf(SH_QUIET "tightvncserver -kill %s", cgi_png_display1)
#	_exit()  ??

def dump_png()
	dump_png_1()

dump_png_1()
	Systemf(SH_QUIET "xwd -id %ld | xwdtopnm | pnmcrop -black | pnmtopng", window)

dump_png(num scale)
	Systemf(SH_QUIET "xwd -id %ld | xwdtopnm | pnmcrop -black | pnmscale %f | pnmtopng", window, scale)

