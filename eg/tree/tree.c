#include <math.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/types.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <dirent.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>
#include <setjmp.h>
#include <ctype.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/un.h>
#include <sys/select.h>
#include <poll.h>
#include <time.h>
#include <sys/time.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/XShm.h>

struct str;
struct buffer;
struct vec;
struct list;
struct list_x;
struct hashtable;
struct key_value;
struct node_kv;
struct circbuf;
struct deq;
struct thunk;
struct err;
struct error_handler;
struct polygon;

typedef struct str str;
typedef struct buffer buffer;
typedef struct vec vec;
typedef struct list list;
typedef struct list_x list_x;
typedef struct hashtable hashtable;
typedef struct key_value key_value;
typedef struct node_kv node_kv;
typedef struct circbuf circbuf;
typedef struct deq deq;
typedef struct thunk thunk;
typedef struct err err;
typedef struct error_handler error_handler;
typedef struct polygon polygon;

typedef unsigned char byte;
typedef double num;
typedef unsigned char boolean;
typedef char *cstr;
typedef unsigned int count_t;
typedef unsigned char uchar;
typedef struct timeval timeval;
typedef struct timespec timespec;
typedef unsigned int (*hash_func)(void *key);
typedef boolean (*eq_func)(void *k1, void *k2);
typedef void *(*thunk_func)(void *obj, void *common_arg, void *specific_arg);
typedef struct hostent hostent;
typedef int SOCKET;
typedef struct dirent dirent;
typedef struct stat stats;
typedef struct stat lstats;
typedef enum { if_dead_error, if_dead_null, if_dead_path, if_dead_warn=1<<31 } readlinks_if_dead;
typedef struct pollfd pollfd;
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

struct vec
{
	buffer b;
	size_t element_size;
	size_t space;
	size_t size;
};

struct list
{
	list *next;
};

struct list_x
{
	list *next;
	void *o;
};

struct hashtable
{
	list *buckets;
	size_t size;
	hash_func hash;
	eq_func eq;
};

struct key_value
{
	void *key;
	void *value;
};

struct node_kv
{
	list l;
	key_value kv;
};

struct circbuf
{
	size_t size;
	size_t space;
	size_t start;
	char *data;
};

struct deq
{
	circbuf b;
	size_t element_size;
	size_t space;
	size_t size;
	size_t start;
};

struct thunk
{
	thunk_func func;
	void *obj;
	void *common_arg;
};

struct err
{
	cstr msg;
	int no;
	void *data;
};

struct error_handler
{
	sigjmp_buf *jump;
	thunk handler;
	int err;
};

struct polygon
{
	XPoint *points;
	int n_points;
	int space;
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
size_t buffer_get_space(buffer *b);
void buffer_init(buffer *b, size_t space);
void buffer_free(buffer *b);
void buffer_set_space(buffer *b, size_t space);
void buffer_set_size(buffer *b, size_t size);
void buffer_double(buffer *b);
void buffer_squeeze(buffer *b);
void buffer_cat_char(buffer *b, char c);
void buffer_cat_cstr(buffer *b, const char *s);
void buffer_cat_str(buffer *b, str s);
void buffer_cat_range(buffer *b, const char *start, const char *end);
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
void buffer_strip_nul(buffer *b);
void buffer_dump(FILE *stream, buffer *b);
void buffer_dup(buffer *to, buffer *from);
cstr buffer_to_cstr(buffer *b);
void buffer_shift(buffer *b, size_t shift);
void buffer_ensure_space(buffer *b, size_t space);
void buffer_ensure_size(buffer *b, size_t size);
void buffer_ensure_free(buffer *b, size_t free);
void buffer_nl(buffer *b);
void vec_init_el_size(vec *v, size_t element_size, size_t space);
void vec_clear(vec *v);
void vec_free(vec *v);
void vec_space(vec *v, size_t space);
void vec_size(vec *v, size_t size);
void vec_double(vec *v);
void vec_squeeze(vec *v);
void *vec_element(vec *v, size_t index);
void *vec_top(vec *v, size_t index);
void *vec_push(vec *v);
void vec_pop(vec *v);
void vec_dup(vec *to, vec *from);
void vec_ensure_size(vec *v, size_t size);
void list_init(list *l);
boolean list_is_empty(list *l);
list *list_last(list *l);
void list_dump(list *l);
list *list_reverse(list *l);
list *list_reverse_fast(list *l);
void list_push(list **list_pp, list *new_node);
void list_pop(list **list_pp);
void list_free(list **l);
void list_x_init(list_x *n, void *o);
void cstr_dos_to_unix(cstr s);
cstr cstr_unix_to_dos(cstr s);
void cstr_chomp(cstr s);
int cstr_eq(cstr s1, cstr s2);
int cstr_is_empty(cstr s1);
int cstr_ends_with(cstr s, cstr substr);
cstr cstr_begins_with(cstr s, cstr substr);
cstr cstr_from_buffer(buffer *b);
cstr cstr_of_size(size_t n);
cstr Strdup(cstr s);
cstr cstr_chop_end(cstr c, cstr end);
cstr cstr_chop_start(cstr c, cstr start);
void void_cstr(cstr s);
void split_cstr(vec *v, cstr s, char c);
void hashtable_init(hashtable *ht, hash_func hash, eq_func eq, size_t size);
list *alloc_buckets(size_t size);
list *hashtable_lookup_ref(hashtable *ht, void *key);
key_value *hashtable_lookup(hashtable *ht, void *key);
key_value *hashtable_ref_lookup(list *l);
void *hashtable_value(hashtable *ht, void *key);
key_value *hashtable_add(hashtable *ht, void *key, void *value);
void hashtable_ref_add(list *l, void *key, void *value);
key_value hashtable_delete(hashtable *ht, void *key);
void hashtable_delete_maybe(hashtable *ht, void *key);
key_value hashtable_ref_delete(list *l);
node_kv *hashtable_ref_node(list *l);
boolean hashtable_ref_exists(list *l);
key_value *hashtable_ref_key_value(list *l);
list *which_bucket(hashtable *ht, void *key);
size_t hashtable_sensible_size(size_t size);
unsigned int cstr_hash(void *s);
void hashtable_dump(hashtable *ht);
key_value *hashtable_lookup_or_add_key(hashtable *ht, void *key, void *value_init);
unsigned int int_hash(void *i_ptr);
boolean int_eq(int *a, int *b);
void hashtable_free(hashtable *ht);
void circbuf_init(circbuf *b, size_t space);
char *circbuf_get_pos(circbuf *b, int index);
void circbuf_free(circbuf *b);
void circbuf_set_space(circbuf *b, size_t space);
void circbuf_set_size(circbuf *b, size_t size);
void circbuf_grow(circbuf *b, size_t delta_size);
void circbuf_shift(circbuf *b, size_t delta_size);
void circbuf_double(circbuf *b);
void circbuf_squeeze(circbuf *b);
void _deq_init(deq *q, size_t element_size, size_t space);
void deq_free(deq *q);
void deq_space(deq *q, size_t space);
void deq_size(deq *q, size_t size);
void deq_double(deq *q);
void deq_squeeze(deq *q);
void *deq_element(deq *q, size_t index);
void *deq_push(deq *q);
void deq_pop(deq *q);
void *deq_top(deq *q, size_t index);
void *deq_unshift(deq *q);
void deq_shift(deq *q);
void *thunk_ignore(void *obj, void *common_arg, void *specific_arg);
void *thunk_void(void *obj, void *common_arg, void *specific_arg);
void *thunk_thunks(void *obj, void *common_arg, void *specific_arg);
void *thunks_call(deq *q, void *specific_arg);
void error(const char *format, ...);
void serror(const char *format, ...);
void warn(const char *format, ...);
void failed(const char *funcname);
void failed2(const char *funcname, const char *errmsg);
void failed3(const char *funcname, const char *msg1, const char *msg2);
void swarning(const char *format, ...);
void memdump(const char *from, const char *to);
void error__assert(int should_be_true, const char *format, ...);
void usage(char *syntax);
void error_init(void);
err *error_add(cstr msg, int no, void *data);
void Throw(cstr msg, int no, void *data);
void throw_(err *e);
void clear_errors(void);
void warn_errors(void);
void warn_errors_keep(void);
void debug_errors(void);
void debug_errors_keep(void);
void fault_(char *file, int line, const char *format, ...);
void add_error_message(int errnum, cstr message);
cstr Strerror(int errnum);
void Perror(const char *s);
void *error_warn(void *obj, void *common_arg, void *er);
void *error_ignore(void *obj, void *common_arg, void *er);
int Socket(int domain, int type, int protocol);
void Bind(int sockfd, struct sockaddr *my_addr, socklen_t addrlen);
void Listen(int sockfd, int backlog);
int Accept(int earfd, struct sockaddr *addr, socklen_t *addrlen);
void Connect(int sockfd, const struct sockaddr *serv_addr, socklen_t addrlen);
void Sockaddr_in(struct sockaddr *sockaddr, char *addr, int port);
hostent *Gethostbyname(const char *name);
cstr name_to_ip(const char *name);
int Server_tcp(char *addr, int port);
void Setsockopt(int s, int level, int optname, const void *optval, socklen_t optlen);
int Client_tcp(char *addr, int port);
cstr Hostname(void);
ssize_t Send(int s, const void *buf, size_t len, int flags);
ssize_t Recv(int s, void *buf, size_t len, int flags);
ssize_t SendTo(int s, const void *buf, size_t len, int flags, const struct sockaddr *to, socklen_t tolen);
ssize_t RecvFrom(int s, void *buf, size_t len, int flags, struct sockaddr *from, socklen_t *fromlen);
void Shutdown(int s, int how);
void Closesocket(int fd);
void keepalive(int fd);
int Server_unix_stream(char *addr);
int Client_unix_stream(char *addr);
void Sockaddr_unix(struct sockaddr *sockaddr, char *addr);
int Open(const char *pathname, int flags, mode_t mode);
void Close(int fd);
ssize_t Read_some(int fd, void *buf, size_t count);
ssize_t Read(int fd, void *buf, size_t count);
ssize_t Write_some(int fd, const void *buf, size_t count);
void Write(int fd, const void *buf, size_t count);
void slurp_2(int fd, buffer *b);
buffer *slurp_1(int filedes);
void spurt(int fd, buffer *b);
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
void Puts(const char *s);
void Fsay(FILE *stream, const char *s);
void Fputs(const char *s, FILE *stream);
int Sayf(const char *format, ...);
int Vsayf(const char *format, va_list ap);
int Fsayf(FILE *stream, const char *format, ...);
int Vfsayf(FILE *stream, const char *format, va_list ap);
char *Input(const char *prompt);
char *Inputf(const char *format, ...);
char *Vinputf(const char *format, va_list ap);
char *Vfinputf(FILE *in, FILE *out, const char *format, va_list ap);
char *Finput(FILE *in, FILE *out, const char *prompt);
char *Finputf(FILE *in, FILE *out, const char *format, ...);
char *Sinput(FILE *s, const char *prompt);
char *Sinputf(FILE *s, const char *format, ...);
DIR *Opendir(const char *name);
dirent *Readdir(DIR *dir);
void Closedir(DIR *dir);
void Remove(const char *path);
int Temp(buffer *b, char *prefix, char *suffix);
int Tempdir(buffer *b, char *prefix, char *suffix);
int Tempfile(buffer *b, char *prefix, char *suffix, char *tmpdir, int dir, int mode);
char random_alphanum(void);
int Exists(const char *file_name);
int Stat(const char *file_name, struct stat *buf);
int is_dir(const char *file_name);
int is_real_dir(const char *file_name);
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
void Fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
size_t Fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
void Fwrite_str(FILE *stream, str s);
void Fputc(int c, FILE *stream);
long Ftell(FILE *stream);
off_t Lseek(int fd, off_t offset, int whence);
void Truncate(const char *path, off_t length);
void Ftruncate(int fd, off_t length);
void _Readlink(const char *path, buffer *b);
cstr Readlink(const char *path);
cstr readlinks(cstr path, readlinks_if_dead if_dead);
void _Getcwd(buffer *b);
cstr Getcwd(void);
void Chdir(const char *path);
void Mkdir_if(const char *pathname, mode_t mode);
void say_cstr(cstr s);
void Rename(const char *oldpath, const char *newpath);
void Chmod(const char *path, mode_t mode);
void Chown(const char *path, uid_t uid, gid_t gid);
void Lchown(const char *path, uid_t uid, gid_t gid);
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
int Select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout);
void fd_set_init(fd_set *o);
cstr which(cstr file);
int can_read(int fd);
int can_write(int fd);
int has_error(int fd);
void Mkdirs(const char *pathname, mode_t mode);
void Rmdirs(const char *pathname);
int Poll(struct pollfd *fds, nfds_t nfds, int timeout);
int Ppoll(struct pollfd *fds, nfds_t nfds, const struct timespec *timeout, const sigset_t *sigmask);
void nonblock(int fd);
int Fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len);
void *Malloc(size_t size);
void *_Realloc(void *ptr, size_t size);
void *Calloc(size_t nmemb, size_t size);
void *rc_malloc(size_t size);
count_t rc_use(void *obj);
count_t rc_done(void *obj);
void rc_free(void *obj);
void *rc_calloc(size_t nmemb, size_t size);
void hexdump(FILE *stream, char *b0, char *b1);
boolean printable(uchar c);
void *mem_mem(const void* haystack, size_t haystacklen, const void* needle, size_t needlelen);
int num_cmp(const void *a, const void *b);
int int_cmp(const void *a, const void *b);
void rsleep(num time);
num rtime(void);
void Gettimeofday(struct timeval *tv);
void Gmtime(double t, datetime *result);
void Localtime(double t, datetime *result);
int Mktime(datetime *t);
void Timef(buffer *b, const datetime *tm, const char *format);
cstr Timef_cstr(datetime *dt, const char *format);
void datetime_init(datetime *dt, int year, int month, int day,  int hour, int min, int sec);
void sleep_step(long double step);
long double asleep(long double dt, long double t);
void rtime_to_timeval(num rtime, struct timeval *tv);
void rtime_to_timespec(num rtime, struct timespec *ts);
num timeval_to_rtime(struct timeval *tv);
num timespec_to_rtime(struct timespec *ts);
int sgn(num x);
num nmin(num x, num y);
num nmax(num x, num y);
int imin(int x, int y);
int imax(int x, int y);
num notpot(num hypotenuse, num x);
void seed(void);
int mod(int i, int base);
int Div(int i, int base);
num rmod(num r, num base);
num dist(num x0, num y0, num x1, num y1);
num double_or_nothing(num factor);
void divmod(int i, int base, int *div, int *_mod);
void divmod_range(int i, int low, int high, int *div, int *_mod);
void rdivmod(num r, num base, num *div, num *_mod);
void rdivmod_range(num r, num low, num high, num *div, num *_mod);
num clamp(num x, num min, num max);
int iclamp(int x, int min, int max);
num spow(num b, num e);
colour coln(char *name);
void colours_init(void);
void font(cstr name, int size);
void gr_init(void);
void _paper(int width, int height, colour _bg_col, colour _fg_col);
void gr_free(void);
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
void Paint(void);
void gr_sync(void);
void clear(void);
void event_loop(void);
void triangle(num x2, num y2);
void quad(num x2, num y2, num x3, num y3);
void gr_deco(int _d);
void xflip(void);
void yflip(void);
void origin(num _ox, num _oy);
void zoom(num _sc);
num isx(num sx);
num isy(num sy);
num isd(num sd);
void move(num x, num y);
void move2(num x1, num y1, num x2, num y2);
void draw(num x, num y);
void gprint_anchor(num xanc, num yanc);
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

extern str str_null;
extern thunk _thunk_null;
extern thunk *thunk_null;
extern thunk _thunk_error_warn;
extern thunk *thunk_error_warn;
extern thunk _thunk_error_ignore;
extern thunk *thunk_error_ignore;
extern vec *error_handlers;
extern vec *errors;
extern hashtable *extra_error_messages;
extern char hostname__[256];
extern int h_errno;
extern fd_set *tmp_fd_set;
extern cstr dt_format;
extern cstr dt_format_tz;
extern long double sleep_step_last;
extern boolean sleep_step_debug;
extern long double asleep_small;
extern num bm_start;
extern boolean bm_enabled;
extern const double pi;
extern const double e;
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
extern XShmSegmentInfo *shmseginfo;
extern num _line_width;
extern Display *display;
extern Window root_window;
extern Window window;
extern Visual *visual;
extern XVisualInfo *visual_info;
extern int depth;
extern num pixel_size;
extern Pixmap buf;
extern Colormap colormap;
extern GC gc;
extern XGCValues gcvalues;
extern XColor color;
extern int screen_number;
extern XEvent event;
extern int _xflip;
extern int _yflip;
extern int _deco;
extern num lx;
extern num ly;
extern num lx2;
extern num ly2;
extern boolean _autopaint;
extern num _delay;
extern int text_at_col0;
extern char *vid;
extern num a_pixel;
extern boolean gr_auto_event_loop;
extern num _xanc;
extern num _yanc;
extern int root_w;
extern int root_h;
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
extern colour rb[360];

boolean use_rb;
num wf;
colour branchcol;

void tree1(int forks,  num x, num y, num r, num a,  num a0, num a1, num m0, num m1)
{
	typeof((cos(a * pi / 180.0))*r + x) x1 = (cos(a * pi / 180.0))*r + x;
	typeof((sin(a * pi / 180.0))*r + y) y1 = (sin(a * pi / 180.0))*r + y;
	branch(x, y, x1, y1, r/6);
	if(forks == 0)
	{
		leaf(x1, y1, a, r/6);
	}
	else
	{
		tree1(forks-1, x1, y1, r*m0, a+a0, a0, a1, m0, m1);
		tree1(forks-1, x1, y1, r*m1, a+a1, a0, a1, m0, m1);
	}
}

void branch(num x0, num y0, num x1, num y1, num w)
{
	w *= wf;
	if(use_rb)
	{
		(_rainbow((x0/2) * pi / 180.0));
	}
	else
	{
		col(branchcol);
	}
	(line_width(w));
	line(x0, y0, x1, y1);
	(circle_fill(x1, y1, (w/2*.8)));
	(circle_fill(x0, y0, (w/2*1.1)));
}

void leaf(num x, num y, num a, num r)
{
	(a=a);
	r *= wf;
	if(use_rb)
	{
		(_rainbow((x/2) * pi / 180.0));
	}
	else
	{
		(col(black));
	}
	(circle_fill(x, y, r));
}

