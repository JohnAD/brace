// 2>/dev/null; [ ! -e pretty -o pretty.c -nt pretty ] && cc -s -Wall -Werror -I. -I/usr/X11R6/include -O2 -lXext -L/usr/X11R6/lib -lX11 -lm -opretty ./pretty.c ; exec ./pretty ; exit

#include <stdlib.h>
#include <errno.h>
#include <stdio.h>
#include <stdarg.h>
#include <math.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <signal.h>
#include <sys/wait.h>
#include <sched.h>
#include <pwd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/un.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <linux/soundcard.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <X11/extensions/XShm.h>
#include <sys/ipc.h>
#include <sys/shm.h>

struct dirbase;
struct buffer;

typedef struct dirbase dirbase;
typedef struct buffer buffer;

typedef double num;
typedef int boolean;
typedef char *cstr;
typedef long colour;

struct dirbase
{
	cstr dir;
	cstr base;
};

struct buffer
{
	char *start;
	char *end;
	char *space_end;
};

colour coln(char *name);
colour col(colour pixel);
int cstr_eq(cstr s1, cstr s2);
int cstr_ends_with(cstr s, cstr substr);
cstr Strdup(cstr s);
dirbase dirbasename(cstr path);
int Vprintf(const char *format, va_list ap);
int Sayf(const char *format, ...);
int Vsayf(const char *format, va_list ap);
void rsleep(num time);
num rtime(void);
void Gettimeofday(struct timeval *tv);
void seed(void);
num rmod(num r, num base);
num rdiv(num r, num base);
int iclamp(int x, int min, int max);
void main__init(int _argc, char *_argv[], char *_envp[]);
void error(const char *format, ...);
void warn(const char *format, ...);
void serror(const char *format, ...);
void failed(const char *funcname);
void error__assert(int should_be_true, const char *format, ...);
void *Malloc(size_t size);
void *Realloc(void *ptr, size_t size);
size_t buffer_get_space(buffer *b);
void buffer_init(buffer *b, size_t space);
void buffer_set_space(buffer *b, size_t space);
void buffer_set_size(buffer *b, size_t size);
void buffer_squeeze(buffer *b);
void buffer_cat_char(buffer *b, char c);
void buffer_grow(buffer *b, size_t delta_size);
char buffer_last_char(buffer *b);
cstr format(const char *format, ...);
cstr vformat(const char *format, va_list ap);
int Vsnprintf(char *buf, size_t size, const char *format, va_list ap);
int Vsprintf(buffer *b, const char *format, va_list ap);
void buffer_add_nul(buffer *b);
void Atexit(void (*function)(void));
void colours_init(void);
void font(cstr name, int size);
void gr_init(void);
void _paper(int width, int height, colour _bg_col, colour _fg_col);
void xfont(const char *font_name);
colour rgb(num red, num green, num blue);
void line_width(num width);
void paint(void);
void clear(void);
void event_loop(void);
void gr_deco(int _d);
void text_origin(num x, num y);
void gr__change_hook(void);
void gr_fast(void);
void autopaint(boolean ap);
void gr_delay(num delay);
void rainbow_init(void);
colour _rainbow(num a);
int main(int main__argc, char *main__argv[], char *main__envp[]);
void qtrig_init(void);

extern const num pi;
extern XFontStruct *_font;
extern num _line_width;
extern int _deco;
extern boolean _autopaint;
extern num _delay;
extern boolean gr_auto_event_loop;
extern boolean bm_enabled;

int argc;
int args;
char **argv;
char **envp;
char *program_full;
char *program;
char **arg;
colour black;
colour white;
colour red;
colour orange;
colour yellow;
colour green;
colour blue;
colour indigo;
colour violet;
colour purple;
colour magenta;
colour midnightblue;
colour brown;
colour beige;
colour grey;
colour darkgrey;
colour lightgrey;
colour cyan;
colour pink;
Display *display;
Window root_window;
Window window;
Visual *visual;
int depth;
Pixmap buf;
Colormap colormap;
GC gc;
XGCValues gcvalues;
XColor color;
int screen_number;
XEvent event;
int root_w;
int root_h;
int w;
int h;
int w_2;
int h_2;
num ox;
num oy;
num sc;
num text_origin_x;
num text_origin_y;
num text_wrap_sx;
colour bg_col;
colour fg_col;
num rb_red_angle;
num rb_green_angle;
num rb_blue_angle;
num rb_red_power;
num rb_green_power;
num rb_blue_power;
num bm_start;
num bm_end;
num _qsin[360];
num _qcos[360];
num _qatan[500+1];

const num pi = M_PI;
XFontStruct *_font = NULL;
num _line_width = 0;
int _deco = 1;
boolean _autopaint = 1;
num _delay = 0;
boolean gr_auto_event_loop = 1;
boolean bm_enabled = 1;

int cstr_eq(cstr s1, cstr s2)
{
	return strcmp(s1, s2) == 0;
}

int cstr_ends_with(cstr s, cstr substr)
{
	size_t s_len = strlen(s);
	size_t substr_len = strlen(substr);
	if(substr_len > s_len)
	{
		return 0;
	}
	cstr expect = s + s_len - substr_len;
	return cstr_eq(expect, substr);
}

cstr Strdup(cstr s)
{
	cstr rv = strdup(s);
	if(rv == NULL)
	{
		failed("strdup");
	}
	return rv;
}

dirbase dirbasename(cstr path)
{
	dirbase rv;
	typeof(strlen(path)) len = (strlen(path));
	if(len == 0)
	{
		rv.dir = ".";
		rv.base = ".";
		return rv;
	}
	if(((path[len-1]) == '/'))
	{
		while(len && ((path[len-1]) == '/'))
		{
			path[len-1] = '\0';
			--len;
		}
		if(path[0] == '\0')
		{
			rv.dir = "/";
		}
		else
		{
			rv.dir = path;
		}
		rv.base = ".";
		return rv;
	}
	typeof(path+len-2) slash = (path+len-2);
	while(1)
	{
		if(slash < path)
		{
			slash = NULL;
			break;
		}
		if(((*slash) == '/'))
		{
			break;
		}
		--slash;
	}
	if(slash)
	{
		*slash = '\0';
		if(slash == path)
		{
			rv.dir = "/";
		}
		else
		{
			rv.dir = path;
		}
		rv.base = slash+1;
	}
	else
	{
		rv.dir = ".";
		rv.base = path;
	}
	return rv;
}

int Vprintf(const char *format, va_list ap)
{
	int len = vprintf(format, ap);
	if(len < 0)
	{
		failed("vprintf");
	}
	return len;
}

int Sayf(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(Vsayf(format, ap)) rv = (Vsayf(format, ap));
	va_end(ap);
	return rv;
}

int Vsayf(const char *format, va_list ap)
{
	int len = Vprintf(format, ap);
	if(putc('\n', stdout) == EOF)
	{
		failed("putc");
	}
	return len;
}

void rsleep(num time)
{
	if(time <= 0)
	{
		return;
	}
	struct timespec delay;
	delay.tv_sec = (time_t)time;
	delay.tv_nsec = (long)((time - floor(time)) * 1e9);
	while(nanosleep(&delay, &delay) == -1)
	{
		if(errno != EINTR)
		{
			failed("nanosleep");
		}
	}
}

num rtime(void)
{
	struct timeval tv;
	Gettimeofday(&tv);
	return (num)tv.tv_sec + tv.tv_usec / 1000000.0;
}

void Gettimeofday(struct timeval *tv)
{
	if((gettimeofday(tv, NULL)) != 0)
	{
		failed("gettimeofday");
	}
}

void seed(void)
{
	int s = (int)((rmod(rtime()*1000, pow(2, 32)))) ^ (getpid()<<16);
	(srandom(s));
}

num rmod(num r, num base)
{
	int d = rdiv(r, base);
	return r - d * base;
}

num rdiv(num r, num base)
{
	return floor(r / base);
}

int iclamp(int x, int min, int max)
{
	return x < min ? min : x > max ? max : x;
}

void main__init(int _argc, char *_argv[], char *_envp[])
{
	argc = _argc;
	argv = _argv;
	envp = _envp;
	program_full = argv[0];
	typeof(dirbasename((Strdup(program_full)))) my__295_rv = (dirbasename((Strdup(program_full))));
	typeof(my__295_rv.dir) d = (my__295_rv.dir);
	typeof(my__295_rv.base) b = (my__295_rv.base);
	d=d;
	program = b;
	if(cstr_ends_with(program, ".exe"))
	{
		program[strlen(program)-4] = '\0';
	}
	if(program[0] == '.')
	{
		++program;
	}
	arg = argv+1;
	args = argc - 1;
	seed();
}

void error(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	vfprintf(stderr, format, ap);
	va_end(ap);
	fprintf(stderr, "\n");
	fflush(stderr);
	exit(1);
}

void warn(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	vfprintf(stderr, format, ap);
	va_end(ap);
	fprintf(stderr, "\n");
	fflush(stderr);
}

void serror(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	vfprintf(stderr, format, ap);
	va_end(ap);
	fprintf(stderr, ": ");
	perror(NULL);
	fflush(stderr);
	exit(1);
}

void failed(const char *funcname)
{
	serror("%s failed", funcname);
}

void error__assert(int should_be_true, const char *format, ...)
{
	if(!should_be_true)
	{
		va_list ap;
		va_start(ap, format);
		vfprintf(stderr, format, ap);
		va_end(ap);
		fprintf(stderr, "\n");
		fflush(stderr);
		exit(1);
	}
}

void *Malloc(size_t size)
{
	void *ptr = malloc(size);
	if(ptr == NULL)
	{
		failed("malloc");
	}
	return ptr;
}

void *Realloc(void *ptr, size_t size)
{
	if(size == 0)
	{
		size = 1;
	}
	ptr = realloc(ptr, size);
	if((ptr == NULL))
	{
		failed("realloc");
	}
	return ptr;
}

size_t buffer_get_space(buffer *b)
{
	return b->space_end - b->start;
}

void buffer_init(buffer *b, size_t space)
{
	if(space == 0)
	{
		space = 1;
	}
	b->start = (char *)Malloc(space);
	b->end = b->start;
	b->space_end = b->start + space;
}

void buffer_set_space(buffer *b, size_t space)
{
	size_t size = ((b->end)-(b->start));
	(error__assert((size <= space), "cannot set buffer space less than buffer size"));
	if(space == 0)
	{
		space = 1;
	}
	b->start = (char *)Realloc(b->start, space);
	b->end = b->start + size;
	b->space_end = b->start + space;
}

void buffer_set_size(buffer *b, size_t size)
{
	size_t space = buffer_get_space(b);
	if(size > space)
	{
		do
		{
			space *= 2;
		}
		while(size > space);
		buffer_set_space(b, space);
	}
	b->end = b->start + size;
}

void buffer_squeeze(buffer *b)
{
	buffer_set_space(b, ((b->end)-(b->start)));
}

void buffer_cat_char(buffer *b, char c)
{
	buffer_grow(b, 1);
	*(b->end - 1) = c;
}

void buffer_grow(buffer *b, size_t delta_size)
{
	buffer_set_size(b, ((b->end)-(b->start)) + delta_size);
}

char buffer_last_char(buffer *b)
{
	return b->start[((b->end)-(b->start))-1];
}

cstr format(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(vformat(format, ap)) rv = (vformat(format, ap));
	va_end(ap);
	return rv;
}

cstr vformat(const char *format, va_list ap)
{
	buffer *b;
	buffer struct__b;
	b = &struct__b;
	buffer_init(b, 4096);
	Vsprintf(b, format, ap);
	buffer_add_nul(b);
	buffer_squeeze(b);
	return (b->start);
}

int Vsnprintf(char *buf, size_t size, const char *format, va_list ap)
{
	typeof(vsnprintf(buf, size, format, ap)) rv = (vsnprintf(buf, size, format, ap));
	if(rv < 0)
	{
		failed("vsnprintf");
	}
	return rv;
}

int Vsprintf(buffer *b, const char *format, va_list ap)
{
	va_list ap1;
	va_copy(ap1, ap);
	int old_size = ((b->end)-(b->start));
	char *start = b->start + old_size;
	int size = buffer_get_space(b) - old_size;
	if(size == 0)
	{
		buffer_set_space(b, old_size+1);
		size = 1;
	}
	int len = Vsnprintf(start, size, format, ap);
	if(len < size)
	{
		buffer_grow(b, len);
	}
	else
	{
		buffer_set_size(b, old_size+len+1);
		start = b->start + old_size;
		size = buffer_get_space(b) - old_size;
		len = Vsnprintf(start, size, format, ap1);
		(error__assert((old_size+len == ((b->end)-(b->start))-1), "vsnprintf returned different sizes on same input!!"));
		buffer_set_size(b, old_size+len);
	}
	va_end(ap1);
	return len;
}

void buffer_add_nul(buffer *b)
{
	if(((b->end)-(b->start)) == 0 || buffer_last_char(b) != '\0')
	{
		buffer_cat_char(b, '\0');
	}
}

void Atexit(void (*function)(void))
{
	if(atexit(function) != 0)
	{
		failed("atexit");
	}
}

void colours_init(void)
{
	black = coln("black");
	white = coln("white");
	red = coln("red");
	orange = coln("orange");
	yellow = coln("yellow");
	green = coln("green");
	blue = coln("blue");
	indigo = coln("indigo");
	violet = coln("violet");
	purple = coln("purple");
	magenta = coln("magenta");
	midnightblue = coln("midnightblue");
	brown = coln("brown");
	beige = coln("beige");
	grey = coln("grey");
	darkgrey = coln("darkgrey");
	lightgrey = coln("lightgrey");
	cyan = coln("cyan");
	pink = coln("pink");
}

void font(cstr name, int size)
{
	typeof(format("-*-%s-r-normal--%d-*-100-100-p-*-iso8859-1", name, size)) xfontname = (format("-*-%s-r-normal--%d-*-100-100-p-*-iso8859-1", name, size));
	xfont(xfontname);
	(free(xfontname));
}

void gr_init(void)
{
	if(gr_auto_event_loop)
	{
		Atexit(event_loop);
	}
	rainbow_init();
	if((display = XOpenDisplay(NULL)) == NULL)
	{
		error("cannot open display");
	}
	screen_number = DefaultScreen(display);
	visual = DefaultVisual(display, screen_number);
	depth = DefaultDepth(display, screen_number);
	white = WhitePixel(display, screen_number);
	black = BlackPixel(display, screen_number);
	colormap = DefaultColormap(display, screen_number);
	gc = DefaultGC(display, screen_number);
	gcvalues.function = GXcopy;
	gcvalues.foreground = white;
	gcvalues.cap_style = CapNotLast;
	gcvalues.line_width = _line_width;
	XChangeGC(display, gc, GCFunction|GCForeground|GCCapStyle|GCLineWidth, &gcvalues);
	root_window = DefaultRootWindow(display);
	colours_init();
	font("helvetica-medium", 11);
	XWindowAttributes window_attributes;
	if(XGetWindowAttributes(display, root_window, &window_attributes))
	{
		root_w = window_attributes.width;
		root_h = window_attributes.height;
	}
}

void _paper(int width, int height, colour _bg_col, colour _fg_col)
{
	if(width)
	{
		w = width;
		h = height;
	}
	else
	{
		w = root_w;
		h = root_h;
	}
	bg_col = _bg_col;
	fg_col = _fg_col;
	w_2 = w/2;
	h_2 = h/2;
	ox = oy = 0;
	sc = 1;
	text_origin(-w_2, h_2);
	text_wrap_sx = width;
	unsigned long valuemask = 0;
	XSetWindowAttributes attributes;
	if(!_deco)
	{
		valuemask |= CWOverrideRedirect;
		attributes.override_redirect = True;
	}
	window = XCreateWindow(display, root_window, 0, 0, w, h, 0, CopyFromParent, InputOutput, CopyFromParent, valuemask, &attributes);
	buf = XCreatePixmap(display, window, w, h, XDefaultDepth(display, screen_number));
	XSelectInput(display, window, ExposureMask|ButtonPressMask|ButtonReleaseMask|ButtonMotionMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask);
	XMapWindow(display, window);
	clear();
	paint();
}

void xfont(const char *font_name)
{
	if((_font = XLoadQueryFont(display, font_name)) == NULL)
	{
		error("cannot load font %s", font_name);
	}
	gcvalues.font = _font->fid;
	XChangeGC(display, gc, GCFont, &gcvalues);
}

colour rgb(num red, num green, num blue)
{
	char name[8];
	int r, g, b;
	r = iclamp(red*256, 0, 255);
	g = iclamp(green*256, 0, 255);
	b = iclamp(blue*256, 0, 255);
	snprintf(name, sizeof(name), "#%02x%02x%02x", r, g, b);
	return coln(name);
}

colour col(colour pixel)
{
	gcvalues.foreground = pixel;
	XChangeGC(display, gc, GCForeground, &gcvalues);
	fg_col = pixel;
	return pixel;
}

colour coln(char *name)
{
	if(XAllocNamedColor(display, colormap, name, &color, &color))
	{
		return col(color.pixel);
	}
	return white;
}

void line_width(num width)
{
	_line_width = width;
	int w = ((int)width);
	gcvalues.line_width = w;
	XChangeGC(display, gc, GCLineWidth, &gcvalues);
}

void paint(void)
{
	XCopyArea(display, buf, window, gc, 0, 0, w, h, 0, 0);
	XFlush(display);
}

void clear(void)
{
	colour fg = fg_col;
	col(bg_col);
	XFillRectangle(display, buf, gc, 0, 0, w, h);
	col(fg);
	gr__change_hook();
}

void event_loop(void)
{
	while(1)
	{
		XNextEvent(display, &event);
		switch(event.type)
		{
		case Expose:	if(event.xexpose.count == 0)
			{
				paint();
			}
		}
	}
}

void gr_deco(int _d)
{
	_deco = _d;
}

void text_origin(num x, num y)
{
	text_origin_x = x;
	text_origin_y = y;
}

void gr__change_hook(void)
{
	if(_autopaint)
	{
		paint();
	}
	(rsleep(_delay));
}

void gr_fast(void)
{
	autopaint(0);
	gr_delay(0);
}

void autopaint(boolean ap)
{
	_autopaint = ap;
}

void gr_delay(num delay)
{
	_delay = delay;
}

void rainbow_init(void)
{
	rb_red_angle = ((-120) * pi / 180.0);
	rb_green_angle = 0;
	rb_blue_angle = (120 * pi / 180.0);
	rb_red_power = 1;
	rb_green_power = 0.9;
	rb_blue_power = 1;
}

colour _rainbow(num a)
{
	num r = rb_red_power * (cos(a-rb_red_angle)+1)/2;
	num g = rb_green_power * (cos(a-rb_green_angle)+1)/2;
	num b = rb_blue_power * (cos(a-rb_blue_angle)+1)/2;
	return rgb(r, g, b);
}

int main(int main__argc, char *main__argv[], char *main__envp[])
{
	main__init(main__argc, main__argv, main__envp);
	gr_fast();
	gr_deco(0);
	gr_init();
	_paper(0, 0, black, black);
	col(white);
	qtrig_init();
	colour rb[360];
	typeof(0) i = 0;
	typeof(360) my__1403_end = 360;
	for(; i<my__1403_end; ++i)
	{
		rb[i] = (_rainbow(i * pi / 180.0));
	}
	bm_enabled = 0;
	if(bm_enabled)
	{
		bm_start = rtime();
	}
	int ShmMajor, ShmMinor;
	Bool ShmPixmaps;
	Bool shm_ok = XShmQueryVersion(display, &ShmMajor, &ShmMinor, &ShmPixmaps);
	XImage *image;
	XShmSegmentInfo *shmseginfo;
	if(shm_ok)
	{
		shmseginfo = ((XShmSegmentInfo *)Malloc(sizeof(XShmSegmentInfo)));
		(bzero(shmseginfo, sizeof(*shmseginfo)));
		image = XShmCreateImage(display, visual, depth, ZPixmap, NULL, shmseginfo, w, h);
		shmseginfo->shmid = shmget(IPC_PRIVATE, image->bytes_per_line * image->height, IPC_CREAT|0777);
		if(shmseginfo->shmid<0)
		{
			failed("shmget");
		}
		shmseginfo->shmaddr = shmat(shmseginfo->shmid, NULL, 0);
		if(!shmseginfo->shmaddr)
		{
			failed("shmat");
		}
		shmseginfo->readOnly = False;
		image->data = shmseginfo->shmaddr;
		if(!XShmAttach(display, shmseginfo))
		{
			failed("XShmAttach");
		}
	}
	else
	{
		warn("XShm not working");
		image = XGetImage(display, buf, 0, 0, w, h, AllPlanes, ZPixmap);
	}
	if(image == NULL)
	{
		failed("XGetImage");
	}
	if(bm_enabled)
	{
		bm_end = rtime();
		Sayf("%s: %f", "got image", bm_end-bm_start);
	}
	int da = 0;
	int dr = 0;
	while(1)
	{
		long *px = ((long *)(image->data + image->bytes_per_line * 0 + sizeof(long)*0));
		da+=2;
		int y;
		for(y=h_2-1; y>=-h_2; --y)
		{
			int r2 = w_2*w_2+y*y;
			typeof(-w_2) x = (-w_2);
			typeof(w_2) my__1423_end = w_2;
			for(; x<my__1423_end; ++x)
			{
				int a;
				num s, atn;
				int my__1434_ang;
				int my__1443__i = ((r2/100.0+dr)*(360/360));
				if(my__1443__i >= 0)
				{
					my__1434_ang = my__1443__i%360;
				}
				else
				{
					my__1434_ang = 360-1 - (-1-my__1443__i)%360;
				}
				s = _qsin[my__1434_ang];
				num my__1459__x = x;
				num my__1459__y = y;
				if(my__1459__x == 0)
				{
					atn = my__1459__y >= 0 ? 90 : -90;
				}
				else
				{
					num my__1480__t = (my__1459__y/my__1459__x);
					if(my__1480__t > 0)
					{
						if(my__1480__t <= 1)
						{
							atn = _qatan[(int)(my__1480__t*500)];
						}
						else
						{
							atn = 90 - _qatan[(int)(500/my__1480__t)];
						}
					}
					else
					{
						if(my__1480__t >= -1)
						{
							atn = -_qatan[(int)(-500*my__1480__t)];
						}
						else
						{
							atn = _qatan[(int)(-500/my__1480__t)] - 90;
						}
					}
					if(my__1459__x < 0)
					{
						if(my__1459__y < 0)
						{
							atn -= 180;
						}
						else
						{
							atn += 180;
						}
					}
				}
				int my__1519__i = (atn+s*50+da);
				if(my__1519__i >= 0)
				{
					a = my__1519__i%360;
				}
				else
				{
					a = 360-1 - (-1-my__1519__i)%360;
				}
				*px++ = rb[a];
				r2 += 2*x+1;
			}
			px += image->bytes_per_line / sizeof(long) - w;
		}
		if(bm_enabled)
		{
			bm_end = rtime();
			Sayf("%s: %f", "calc done", bm_end-bm_start);
		}
		if(shm_ok)
		{
			XShmPutImage(display, buf, gc, image, 0, 0, 0, 0, w, h, False);
		}
		else
		{
			XPutImage(display, buf, gc, image, 0, 0, 0, 0, w, h);
		}
		if(bm_enabled)
		{
			bm_end = rtime();
			Sayf("%s: %f", "put image", bm_end-bm_start);
		}
		paint();
		if(bm_enabled)
		{
			bm_end = rtime();
			Sayf("%s: %f", "painted", bm_end-bm_start);
		}
		if(bm_enabled)
		{
			bm_start = rtime();
		}
	}
	XShmDetach(display, shmseginfo);
	if(image)
	{
		XDestroyImage(image);
	}
	shmdt(shmseginfo->shmaddr);
	shmctl(shmseginfo->shmid, IPC_RMID, NULL);
	free(shmseginfo);
	return 0;
}

void qtrig_init(void)
{
	typeof(0) i = 0;
	typeof(360) my__1538_end = 360;
	for(; i<my__1538_end; ++i)
	{
		num a = i*360.0/360;
		_qsin[i] = (sin(a * pi / 180.0));
		_qcos[i] = (cos(a * pi / 180.0));
	}
	typeof(0) j = 0;
	typeof(500+1) my__1559_end = (500+1);
	for(; j<my__1559_end; ++j)
	{
		_qatan[j] = ((atan(j/(num)500)) * 180.0 / pi);
	}
}

