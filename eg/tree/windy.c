#include </usr/include/math.h>
#include </usr/include/stdlib.h>
#include </usr/include/sys/types.h>
#include </usr/include/stdio.h>
#include </usr/include/sys/stat.h>
#include </usr/include/fcntl.h>
#include </usr/include/unistd.h>
#include </usr/include/dirent.h>
#include </usr/include/errno.h>
#include </usr/lib/gcc/i486-linux-gnu/4.3.2/include/stdarg.h>
#include </usr/include/string.h>
#include </usr/include/time.h>
#include </usr/include/sys/time.h>
#include </usr/include/X11/Xlib.h>
#include </usr/include/X11/Xutil.h>

struct str;
struct buffer;
struct polygon;

typedef struct str str;
typedef struct buffer buffer;
typedef struct polygon polygon;

typedef unsigned char byte;
typedef double num;
typedef int boolean;
typedef char *cstr;
typedef unsigned int count_t;
typedef void (*Thunk)(void);
typedef void (*handler_cstr)(cstr s);
typedef unsigned char uchar;
typedef struct stat stats;
typedef struct stat lstats;
typedef enum { if_dead_error, if_dead_null, if_dead_path, if_dead_warn=1<<31 } readlinks_if_dead;
typedef struct tm datetime;
typedef long colour;

struct str
{
	char *start;
	char *end;
};

struct buffer
{
	char *start;
	char *end;
	char *space_end;
};

struct polygon
{
	XPoint *points;
	int n_points;
	int capacity;
};

str new_str(char *start, char *end);
str str_dup(str s);
str str_of_size(size_t size);
char *str_copy(char *to, str from);
void str_free(str s);
cstr cstr_from_str(const str s);
str str_cat_2(str s1, str s2);
str str_cat_3(str s1, str s2, str s3);
str str_from_char(char c);
str str_from_cstr(cstr cs);
void str_dump(str s);
char *str_chr(str s, char c);
str str_str(str haystack, str needle);
cstr *str_str_start(str haystack, str needle);
void fprint_str(FILE *stream, str s);
void print_str(str s);
void fsay_str(FILE *stream, str s);
void say_str(str s);
void error(const char *format, ...);
void warn(const char *format, ...);
void serror(const char *format, ...);
void failed(const char *funcname);
void failed_2(const char *funcname, const char *errmsg);
void swarning(const char *format, ...);
void memdump(const char *from, const char *to);
void error__assert(int should_be_true, const char *format, ...);
void usage(char *syntax);
size_t buffer_get_space(buffer *b);
void buffer_init(buffer *b, size_t space);
void buffer_free(buffer *b);
void buffer_set_space(buffer *b, size_t space);
void buffer_set_size(buffer *b, size_t size);
void buffer_double(buffer *b);
void buffer_squeeze(buffer *b);
void buffer_cat_char(buffer *b, char c);
void buffer_cat_cstr(buffer *b, cstr s);
void buffer_cat_str(buffer *b, str s);
void buffer_grow(buffer *b, size_t delta_size);
void buffer_clear(buffer *b);
size_t buffer_get_free(buffer *b);
char buffer_last_char(buffer *b);
char buffer_first_char(buffer *b);
char buffer_get_char(buffer *b, int i);
void buffer_zero(buffer *b);
int Sprintf(buffer *b, const char *format, ...);
cstr format(const char *format, ...);
cstr vformat(const char *format, va_list ap);
int Vsnprintf(char *buf, size_t size, const char *format, va_list ap);
int Vsprintf(buffer *b, const char *format, va_list ap);
void buffer_add_nul(buffer *b);
void buffer_nul_terminate(buffer *b);
void buffer_dump(FILE *stream, buffer *b);
void buffer_dup(buffer *to, buffer *from);
cstr buffer_to_cstr(buffer *b);
int Open(const char *pathname, int flags);
void Close(int fd);
ssize_t Read(int fd, void *buf, size_t count);
ssize_t Write_some(int fd, const void *buf, size_t count);
void Write(int fd, const void *buf, size_t count);
void slurp_2(int fd, buffer *b);
buffer *slurp_1(int filedes);
void belch(int fd, buffer *b);
FILE *Fopen(const char *path, const char *mode);
void Fclose(FILE *fp);
char *Fgets(char *s, int size, FILE *stream);
int Freadline(buffer *b, FILE *stream);
int Readline(buffer *b);
int Printf(const char *format, ...);
int Vprintf(const char *format, va_list ap);
int Fprintf(FILE *stream, const char *format, ...);
int Vfprintf(FILE *stream, const char *format, va_list ap);
void Fflush(FILE *stream);
FILE *Fdopen(int filedes, const char *mode);
void Nl(FILE *stream);
void crnl(FILE *stream);
void Fputs(const char *s, FILE *stream);
void Puts(const char *s);
int Sayf(const char *format, ...);
int Vsayf(const char *format, va_list ap);
int Fsayf(FILE *stream, const char *format, ...);
int Vfsayf(FILE *stream, const char *format, va_list ap);
void Fsay(FILE *stream, const char *s);
char *Input(const char *s);
char *Inputf(const char *format, ...);
char *Vinputf(const char *format, va_list ap);
DIR *Opendir(const char *name);
struct dirent *Readdir(DIR *dir);
void Closedir(DIR *dir);
void Remove(const char *path);
int Temp(buffer *b, char *prefix, char *suffix);
int Tempdir(buffer *b, char *prefix, char *suffix);
int Tempfile(buffer *b, char *prefix, char *suffix, char *tmpdir, int dir, int mode);
char random_alphanum(void);
int Exists(const char *file_name);
int Stat(const char *file_name, struct stat *buf);
void Fstat(int filedes, struct stat *buf);
void cx(const char *path);
void cnotx(const char *path);
void chmod_add(const char *path, mode_t add_mode);
void chmod_sub(const char *path, mode_t sub_mode);
void stats_init(stats *s, const char *file_name);
void lstats_init(stats *s, const char *file_name);
int Lstat(const char *file_name, struct stat *buf);
FILE *Popen(const char *command, const char *type);
int Pclose(FILE *stream);
int Fgetc(FILE *stream);
void Fwrite(const void *ptr, size_t size, size_t n, FILE *s);
void Fwrite_str(FILE *stream, str s);
void Fputc(int c, FILE *stream);
void _Readlink(const char *path, buffer *b);
cstr Readlink(const char *path);
cstr _readlinks(cstr path, readlinks_if_dead if_dead);
void _Getcwd(buffer *b);
cstr Getcwd(void);
void Chdir(const char *path);
void say_cstr(cstr s);
void Rename(const char *oldpath, const char *newpath);
void Chmod(const char *path, mode_t mode);
void Symlink(const char *oldpath, const char *newpath);
void Link(const char *oldpath, const char *newpath);
void Pipe(int filedes[2]);
int Dup(int oldfd);
int Dup2(int oldfd, int newfd);
FILE *Freopen(const char *path, const char *mode, FILE *stream);
void print_range(char *start, char *end);
void fprint_range(FILE *stream, char *start, char *end);
void say_range(char *start, char *end);
void fsay_range(FILE *stream, char *start, char *end);
void stats_dump(stats *s);
mode_t mode(const char *file_name);
void cp(const char *from, const char *to, int mode);
void cp_fd(int in, int out);
void *Malloc(size_t size);
void *Realloc(void *ptr, size_t size);
void *Calloc(size_t nmemb, size_t size);
void *rc_malloc(size_t size);
count_t rc_use(void *obj);
count_t rc_done(void *obj);
void rc_free(void *obj);
void *rc_calloc(size_t nmemb, size_t size);
void hexdump(FILE *stream, char *b0, char *b1);
boolean printable(uchar c);
void *mem_mem(const void* haystack, size_t haystacklen, const void* needle, size_t needlelen);
void rsleep(num time);
num rtime(void);
void Gettimeofday(struct timeval *tv);
void Gmtime(double t, datetime *result);
void Localtime(double t, datetime *result);
int Mktime(datetime *t);
void Timef(buffer *b, const datetime *tm, const char *format);
cstr Timef_cstr(datetime *dt, const char *format);
void datetime_init(datetime *dt, int year, int month, int day,  int hour, int min, int sec);
num deg2rad(num a);
num rad2deg(num a);
int sgn(num x);
num nmin(num x, num y);
num nmax(num x, num y);
int imin(int x, int y);
int imax(int x, int y);
num notpot(num hypotenuse, num x);
int Randint(int max);
num Rand(void);
void seed(void);
int mod(int i, int base);
int Div(int i, int base);
num rmod(num r, num base);
num rdiv(num r, num base);
num dist(num x0, num y0, num x1, num y1);
num double_or_nothing(num factor);
void divmod(int i, int base, int *div, int *_mod);
void divmod_range(int i, int low, int high, int *div, int *_mod);
void rdivmod(num r, num base, num *div, num *_mod);
void rdivmod_range(num r, num low, num high, num *div, num *_mod);
num clamp(num x, num min, num max);
int iclamp(int x, int min, int max);
colour coln(char *name);
void colours_init(void);
void font(cstr name, int size);
void gr_init(void);
void _paper(int width, int height, colour _bg_col, colour _fg_col);
void xfont(const char *font_name);
colour rgb(num red, num green, num blue);
colour col(colour pixel);
void line_width(num width);
void rect_fill(num x, num y, num w, num h);
void line(num x0, num y0, num x1, num y1);
void point(num x, num y);
void circle(num x, num y, num r);
void circle_fill(num x, num y, num r);
void polygon_start(struct polygon *p, int n_points_estimate);
void _polygon_point(struct polygon *p, short x, short y);
void polygon_point(struct polygon *p, num x, num y);
void polygon_draw(struct polygon *p);
void polygon_fill(struct polygon *p);
void polygon_end(struct polygon *p);
void gprint(char *p);
num font_height(void);
void paint(void);
void clear(void);
void event_loop(void);
void triangle(num x2, num y2);
void quad(num x2, num y2, num x3, num y3);
void xflip(void);
void yflip(void);
void origin(num _ox, num _oy);
void zoom(num _sc);
num sx(num x);
num sy(num y);
num sd(num d);
num isx(num sx);
num isy(num sy);
num isd(num sd);
void move(num x, num y);
void move2(num x1, num y1, num x2, num y2);
void draw(num x, num y);
int gprintf(const char *format, ...);
int vgprintf(const char *format, va_list ap);
void gsay(char *p);
int gsayf(const char *format, ...);
int vgsayf(const char *format, va_list ap);
void gnl(void);
void text_origin(num x, num y);
void move_to_text_origin(void);
void bg(colour bg);
void gr__change_hook(void);
void gr_fast(void);
void autopaint(boolean ap);
void gr_delay(num delay);
void rainbow_init(void);
colour _rainbow(num a);
void random_colour(void);
colour _hsv(num hue, num sat, num val);
void tree1(int forks,  num x, num y, num r, num a,  num a0, num a1, num m0, num m1);
void branch(num x0, num y0, num x1, num y1, num w);
void leaf(num x, num y, num a, num r);
void main__init(int _argc, char *_argv[], char *_envp[]);
int main(int main__argc, char *main__argv[], char *main__envp[]);

extern str str_null;
extern cstr dt_format;
extern cstr dt_format_tz;
extern const num pi;
extern num tinynum;
extern colour black;
extern colour white;
extern colour red;
extern colour orange;
extern colour yellow;
extern colour green;
extern colour blue;
extern colour indigo;
extern colour violet;
extern colour purple;
extern colour magenta;
extern colour midnightblue;
extern colour brown;
extern colour beige;
extern colour grey;
extern colour darkgrey;
extern colour lightgrey;
extern colour cyan;
extern colour pink;
extern XFontStruct *_font;
extern num _line_width;
extern Display *display;
extern Window root;
extern Window window;
extern Pixmap buf;
extern Colormap colormap;
extern GC gc;
extern XGCValues gcvalues;
extern XColor color;
extern int screen_number;
extern XEvent event;
extern int _xflip;
extern int _yflip;
extern num lx;
extern num ly;
extern num lx2;
extern num ly2;
extern boolean _autopaint;
extern num _delay;
extern int text_at_col0;
extern num a_pixel;
extern boolean gr_auto_event_loop;
extern int w;
extern int h;
extern int w_2;
extern int h_2;
extern num ox;
extern num oy;
extern num sc;
extern num text_origin_x;
extern num text_origin_y;
extern num text_wrap_sx;
extern colour bg_col;
extern colour fg_col;
extern num rb_red_angle;
extern num rb_green_angle;
extern num rb_blue_angle;
extern num rb_red_power;
extern num rb_green_power;
extern num rb_blue_power;
extern boolean rb;
extern num wf;
extern colour branchcol;
extern int argc;
extern int args;
extern char **argv;
extern char **envp;
extern char *program_full;
extern char *program;
extern char **arg;

int main(int main__argc, char *main__argv[], char *main__envp[])
{
	main__init(main__argc, main__argv, main__envp);
	int forks = 6;
	num speed = 0.2;
	switch(args)
	{
	case 2:	speed = atof(arg[1]);
	case 1:	forks = atoi(arg[0]);
	case 0:	break;
	default:	usage("[forks [speed]]");
	}
	gr_init();
	_paper(640, 480, (coln("tan")), black);
	num a0 = 36, a1 = -43;
	num da0 = 0, da1 = 0;
	num drag = 0.995;
	num m0 = .77, m1 = .80;
	gr_fast();
	boolean limit = 0;
	while(1)
	{
		clear();
		rb = 1;
		wf = 1;
		tree1(forks, 0, (-200), 100, 90, a0, a1, m0, m1);
		paint();
		a0 += da0;
		a1 += da1;
		da0 += ((Rand()*(speed-(-speed)))+(-speed));
		da1 += ((Rand()*(speed-(-speed)))+(-speed));
		if(limit)
		{
			if(a0 < 10)
			{
				da0 += .3;
			}
			else if(a0 > 60)
			{
				da0 -= .3;
			}
			if(a1 < -60)
			{
				da1 += .3;
			}
			else if(a1 > -10)
			{
				da1 -= .3;
			}
			da0 *= drag;
			da1 *= drag;
		}
		(rsleep(0.02));
	}
	(event_loop());
	return 0;
}

