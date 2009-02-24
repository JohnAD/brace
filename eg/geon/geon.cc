#include <stdio.h>
#include <sys/types.h>
#include <stdarg.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/XShm.h>
#include <math.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <dirent.h>
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
#include <algorithm>
#include <vector>
#include <map>

using namespace std;

enum region_type
{
	LAND,
	LAKE,
};

enum sector_side
{
	E, N, W, S
};

enum region_sector_containment
{
	REGION_CONTAINS_SECTOR,
	SECTOR_CONTAINS_REGION,
	REGION_OUTSIDE_SECTOR,
	REGION_CROSSES_SECTOR
};

struct polygon;
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
template<class S, class F> F for_each(S &s, F f);
template<class S1, class S2, class F> void mapp(S1 &s1, S2 &s2, F &f);
struct vec3;
struct angle3;
struct region;
struct clip_to_hemisphere_arc;
struct sector_id;
struct sector_bounds;
struct sector_side_pos;
struct clip_to_sector_arc;

typedef struct polygon polygon;
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
typedef struct vec3 vec3;
typedef struct angle3 angle3;
typedef struct region region;
typedef struct clip_to_hemisphere_arc clip_to_hemisphere_arc;
typedef struct sector_id sector_id;
typedef struct sector_bounds sector_bounds;
typedef struct sector_side_pos sector_side_pos;
typedef struct clip_to_sector_arc clip_to_sector_arc;

typedef unsigned char byte;
typedef double num;
typedef unsigned char boolean;
typedef char *cstr;
typedef unsigned int count_t;
typedef unsigned char uchar;
typedef struct timeval timeval;
typedef struct timespec timespec;
typedef long colour;
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
typedef vector<angle3> poly_angle3;
typedef vector<vec3> poly_vec3;
typedef map<num, clip_to_hemisphere_arc> in_angle_to_arc_t;

struct polygon
{
	XPoint *points;
	int n_points;
	int space;
};

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

template<class S, class F> F for_each(S &s, F f)
{
	return for_each(s.begin(), s.end(), f);
}

template<class S1, class S2, class F> void mapp(S1 &s1, S2 &s2, F &f)
{
	s2.clear();
	typename S1::const_iterator i = s1.begin();
	typename S1::const_iterator end = s1.end();
	for(; i!=end ; ++i)
	{
		typename S2::value_type i2;
		f(*i, i2);
		s2.push_back(i2);
	}
}

struct vec3
{
	num x, y, z;
	vec3() : x(0), y(0), z(0) {};
	vec3(num x, num y, num z) : x(x), y(y), z(z) {};
};

struct angle3
{
	num latitude, longitude;
	angle3() : latitude{(0) : longitude(0) {};
	angle3(num latitude, num longitude) : latitude(latitude), longitude(longitude) {};
};

struct region
{
	int id;
	region_type type;
	poly_angle3 points_a;
	poly_vec3 points_v;
};

struct clip_to_hemisphere_arc
{
	int from;
	int to;
	num to_angle;
};

struct sector_id
{
	int level, row, cell;
};

struct sector_bounds
{
	num west, east, south, north;
};

struct sector_side_pos
{
	sector_side side;
	num pos;
};

struct clip_to_sector_arc
{
	int from;
	int to;
	sector_side_pos from_side_pos, to_side_pos;
};

extern "C" colour coln(char *name);
extern "C" void colours_init(void);
extern "C" void font(cstr name, int size);
extern "C" void gr_init(void);
extern "C" void _paper(int width, int height, colour _bg_col, colour _fg_col);
extern "C" void gr_free(void);
extern "C" void xfont(const char *font_name);
extern "C" colour rgb(num red, num green, num blue);
extern "C" colour col(colour pixel);
extern "C" void line_width(num width);
extern "C" void rect_fill(num x, num y, num w, num h);
extern "C" void line(num x0, num y0, num x1, num y1);
extern "C" void point(num x, num y);
extern "C" void circle(num x, num y, num r);
extern "C" void circle_fill(num x, num y, num r);
extern "C" void polygon_start(struct polygon *p, int n_points_estimate);
extern "C" void _polygon_point(struct polygon *p, short x, short y);
extern "C" void polygon_point(struct polygon *p, num x, num y);
extern "C" void polygon_draw(struct polygon *p);
extern "C" void polygon_fill(struct polygon *p);
extern "C" void polygon_end(struct polygon *p);
extern "C" void gprint(char *p);
extern "C" num font_height(void);
extern "C" void paint(void);
extern "C" void Paint(void);
extern "C" void gr_sync(void);
extern "C" void clear(void);
extern "C" void event_loop(void);
extern "C" void triangle(num x2, num y2);
extern "C" void quad(num x2, num y2, num x3, num y3);
extern "C" void gr_deco(int _d);
extern "C" void xflip(void);
extern "C" void yflip(void);
extern "C" void origin(num _ox, num _oy);
extern "C" void zoom(num _sc);
extern "C" num isx(num sx);
extern "C" num isy(num sy);
extern "C" num isd(num sd);
extern "C" void move(num x, num y);
extern "C" void move2(num x1, num y1, num x2, num y2);
extern "C" void draw(num x, num y);
extern "C" void gprint_anchor(num xanc, num yanc);
extern "C" int gprintf(const char *format, ...);
extern "C" int vgprintf(const char *format, va_list ap);
extern "C" void gsay(char *p);
extern "C" int gsayf(const char *format, ...);
extern "C" int vgsayf(const char *format, va_list ap);
extern "C" void gnl(void);
extern "C" void text_origin(num x, num y);
extern "C" void move_to_text_origin(void);
extern "C" void bg(colour bg);
extern "C" void gr__change_hook(void);
extern "C" void gr_fast(void);
extern "C" void autopaint(boolean ap);
extern "C" void gr_delay(num delay);
extern "C" void rainbow_init(void);
extern "C" colour _rainbow(num a);
extern "C" void random_colour(void);
extern "C" colour _hsv(num hue, num sat, num val);
extern "C" str new_str(char *start, char *end);
extern "C" str str_dup(str s);
extern "C" str str_of_size(size_t size);
extern "C" char *str_copy(char *to, str from);
extern "C" void str_free(str s);
extern "C" cstr cstr_from_str(const str s);
extern "C" str str_cat_2(str s1, str s2);
extern "C" str str_cat_3(str s1, str s2, str s3);
extern "C" str str_from_char(char c);
extern "C" str str_from_cstr(cstr cs);
extern "C" void str_dump(str s);
extern "C" char *str_chr(str s, char c);
extern "C" str str_str(str haystack, str needle);
extern "C" cstr *str_str_start(str haystack, str needle);
extern "C" void fprint_str(FILE *stream, str s);
extern "C" void print_str(str s);
extern "C" void fsay_str(FILE *stream, str s);
extern "C" void say_str(str s);
extern "C" size_t buffer_get_space(buffer *b);
extern "C" void buffer_init(buffer *b, size_t space);
extern "C" void buffer_free(buffer *b);
extern "C" void buffer_set_space(buffer *b, size_t space);
extern "C" void buffer_set_size(buffer *b, size_t size);
extern "C" void buffer_double(buffer *b);
extern "C" void buffer_squeeze(buffer *b);
extern "C" void buffer_cat_char(buffer *b, char c);
extern "C" void buffer_cat_cstr(buffer *b, const char *s);
extern "C" void buffer_cat_str(buffer *b, str s);
extern "C" void buffer_cat_range(buffer *b, const char *start, const char *end);
extern "C" void buffer_grow(buffer *b, size_t delta_size);
extern "C" void buffer_clear(buffer *b);
extern "C" size_t buffer_get_free(buffer *b);
extern "C" char buffer_last_char(buffer *b);
extern "C" char buffer_first_char(buffer *b);
extern "C" char buffer_get_char(buffer *b, int i);
extern "C" void buffer_zero(buffer *b);
extern "C" int Sprintf(buffer *b, const char *format, ...);
extern "C" cstr format(const char *format, ...);
extern "C" cstr vformat(const char *format, va_list ap);
extern "C" int Vsnprintf(char *buf, size_t size, const char *format, va_list ap);
extern "C" int Vsprintf(buffer *b, const char *format, va_list ap);
extern "C" void buffer_add_nul(buffer *b);
extern "C" void buffer_nul_terminate(buffer *b);
extern "C" void buffer_strip_nul(buffer *b);
extern "C" void buffer_dump(FILE *stream, buffer *b);
extern "C" void buffer_dup(buffer *to, buffer *from);
extern "C" cstr buffer_to_cstr(buffer *b);
extern "C" void buffer_shift(buffer *b, size_t shift);
extern "C" void buffer_ensure_space(buffer *b, size_t space);
extern "C" void buffer_ensure_size(buffer *b, size_t size);
extern "C" void buffer_ensure_free(buffer *b, size_t free);
extern "C" void buffer_nl(buffer *b);
extern "C" void vec_init_el_size(vec *v, size_t element_size, size_t space);
extern "C" void vec_clear(vec *v);
extern "C" void vec_free(vec *v);
extern "C" void vec_space(vec *v, size_t space);
extern "C" void vec_size(vec *v, size_t size);
extern "C" void vec_double(vec *v);
extern "C" void vec_squeeze(vec *v);
extern "C" void *vec_element(vec *v, size_t index);
extern "C" void *vec_top(vec *v, size_t index);
extern "C" void *vec_push(vec *v);
extern "C" void vec_pop(vec *v);
extern "C" void vec_dup(vec *to, vec *from);
extern "C" void vec_ensure_size(vec *v, size_t size);
extern "C" void list_init(list *l);
extern "C" boolean list_is_empty(list *l);
extern "C" list *list_last(list *l);
extern "C" void list_dump(list *l);
extern "C" list *list_reverse(list *l);
extern "C" list *list_reverse_fast(list *l);
extern "C" void list_push(list **list_pp, list *new_node);
extern "C" void list_pop(list **list_pp);
extern "C" void list_free(list **l);
extern "C" void list_x_init(list_x *n, void *o);
extern "C" void cstr_dos_to_unix(cstr s);
extern "C" cstr cstr_unix_to_dos(cstr s);
extern "C" void cstr_chomp(cstr s);
extern "C" int cstr_eq(cstr s1, cstr s2);
extern "C" int cstr_is_empty(cstr s1);
extern "C" int cstr_ends_with(cstr s, cstr substr);
extern "C" cstr cstr_begins_with(cstr s, cstr substr);
extern "C" cstr cstr_from_buffer(buffer *b);
extern "C" cstr cstr_of_size(size_t n);
extern "C" cstr Strdup(cstr s);
extern "C" cstr cstr_chop_end(cstr c, cstr end);
extern "C" cstr cstr_chop_start(cstr c, cstr start);
extern "C" void void_cstr(cstr s);
extern "C" void split_cstr(vec *v, cstr s, char c);
extern "C" void hashtable_init(hashtable *ht, hash_func hash, eq_func eq, size_t size);
extern "C" list *alloc_buckets(size_t size);
extern "C" list *hashtable_lookup_ref(hashtable *ht, void *key);
extern "C" key_value *hashtable_lookup(hashtable *ht, void *key);
extern "C" key_value *hashtable_ref_lookup(list *l);
extern "C" void *hashtable_value(hashtable *ht, void *key);
extern "C" key_value *hashtable_add(hashtable *ht, void *key, void *value);
extern "C" void hashtable_ref_add(list *l, void *key, void *value);
extern "C" key_value hashtable_delete(hashtable *ht, void *key);
extern "C" void hashtable_delete_maybe(hashtable *ht, void *key);
extern "C" key_value hashtable_ref_delete(list *l);
extern "C" node_kv *hashtable_ref_node(list *l);
extern "C" boolean hashtable_ref_exists(list *l);
extern "C" key_value *hashtable_ref_key_value(list *l);
extern "C" list *which_bucket(hashtable *ht, void *key);
extern "C" size_t hashtable_sensible_size(size_t size);
extern "C" unsigned int cstr_hash(void *s);
extern "C" void hashtable_dump(hashtable *ht);
extern "C" key_value *hashtable_lookup_or_add_key(hashtable *ht, void *key, void *value_init);
extern "C" unsigned int int_hash(void *i_ptr);
extern "C" boolean int_eq(int *a, int *b);
extern "C" void hashtable_free(hashtable *ht);
extern "C" void circbuf_init(circbuf *b, size_t space);
extern "C" char *circbuf_get_pos(circbuf *b, int index);
extern "C" void circbuf_free(circbuf *b);
extern "C" void circbuf_set_space(circbuf *b, size_t space);
extern "C" void circbuf_set_size(circbuf *b, size_t size);
extern "C" void circbuf_grow(circbuf *b, size_t delta_size);
extern "C" void circbuf_shift(circbuf *b, size_t delta_size);
extern "C" void circbuf_double(circbuf *b);
extern "C" void circbuf_squeeze(circbuf *b);
extern "C" void _deq_init(deq *q, size_t element_size, size_t space);
extern "C" void deq_free(deq *q);
extern "C" void deq_space(deq *q, size_t space);
extern "C" void deq_size(deq *q, size_t size);
extern "C" void deq_double(deq *q);
extern "C" void deq_squeeze(deq *q);
extern "C" void *deq_element(deq *q, size_t index);
extern "C" void *deq_push(deq *q);
extern "C" void deq_pop(deq *q);
extern "C" void *deq_top(deq *q, size_t index);
extern "C" void *deq_unshift(deq *q);
extern "C" void deq_shift(deq *q);
extern "C" void *thunk_ignore(void *obj, void *common_arg, void *specific_arg);
extern "C" void *thunk_void(void *obj, void *common_arg, void *specific_arg);
extern "C" void *thunk_thunks(void *obj, void *common_arg, void *specific_arg);
extern "C" void *thunks_call(deq *q, void *specific_arg);
extern "C" void error(const char *format, ...);
extern "C" void serror(const char *format, ...);
extern "C" void warn(const char *format, ...);
extern "C" void failed(const char *funcname);
extern "C" void failed2(const char *funcname, const char *errmsg);
extern "C" void failed3(const char *funcname, const char *msg1, const char *msg2);
extern "C" void swarning(const char *format, ...);
extern "C" void memdump(const char *from, const char *to);
extern "C" void error__assert(int should_be_true, const char *format, ...);
extern "C" void usage(char *syntax);
extern "C" void error_init(void);
extern "C" err *error_add(cstr msg, int no, void *data);
extern "C" void Throw(cstr msg, int no, void *data);
extern "C" void throw_(err *e);
extern "C" void clear_errors(void);
extern "C" void warn_errors(void);
extern "C" void warn_errors_keep(void);
extern "C" void debug_errors(void);
extern "C" void debug_errors_keep(void);
extern "C" void fault_(char *file, int line, const char *format, ...);
extern "C" void add_error_message(int errnum, cstr message);
extern "C" cstr Strerror(int errnum);
extern "C" void Perror(const char *s);
extern "C" void *error_warn(void *obj, void *common_arg, void *er);
extern "C" void *error_ignore(void *obj, void *common_arg, void *er);
extern "C" int Socket(int domain, int type, int protocol);
extern "C" void Bind(int sockfd, struct sockaddr *my_addr, socklen_t addrlen);
extern "C" void Listen(int sockfd, int backlog);
extern "C" int Accept(int earfd, struct sockaddr *addr, socklen_t *addrlen);
extern "C" void Connect(int sockfd, const struct sockaddr *serv_addr, socklen_t addrlen);
extern "C" void Sockaddr_in(struct sockaddr *sockaddr, char *addr, int port);
extern "C" hostent *Gethostbyname(const char *name);
extern "C" cstr name_to_ip(const char *name);
extern "C" int Server_tcp(char *addr, int port);
extern "C" void Setsockopt(int s, int level, int optname, const void *optval, socklen_t optlen);
extern "C" int Client_tcp(char *addr, int port);
extern "C" cstr Hostname(void);
extern "C" ssize_t Send(int s, const void *buf, size_t len, int flags);
extern "C" ssize_t Recv(int s, void *buf, size_t len, int flags);
extern "C" ssize_t SendTo(int s, const void *buf, size_t len, int flags, const struct sockaddr *to, socklen_t tolen);
extern "C" ssize_t RecvFrom(int s, void *buf, size_t len, int flags, struct sockaddr *from, socklen_t *fromlen);
extern "C" void Shutdown(int s, int how);
extern "C" void Closesocket(int fd);
extern "C" void keepalive(int fd);
extern "C" int Server_unix_stream(char *addr);
extern "C" int Client_unix_stream(char *addr);
extern "C" void Sockaddr_unix(struct sockaddr *sockaddr, char *addr);
extern "C" int Open(const char *pathname, int flags, mode_t mode);
extern "C" void Close(int fd);
extern "C" ssize_t Read_some(int fd, void *buf, size_t count);
extern "C" ssize_t Read(int fd, void *buf, size_t count);
extern "C" ssize_t Write_some(int fd, const void *buf, size_t count);
extern "C" void Write(int fd, const void *buf, size_t count);
extern "C" void slurp_2(int fd, buffer *b);
extern "C" buffer *slurp_1(int filedes);
extern "C" void spurt(int fd, buffer *b);
extern "C" FILE *Fopen(const char *path, const char *mode);
extern "C" void Fclose(FILE *fp);
extern "C" char *Fgets(char *s, int size, FILE *stream);
extern "C" int Freadline(buffer *b, FILE *stream);
extern "C" int Readline(buffer *b);
extern "C" int Printf(const char *format, ...);
extern "C" int Vprintf(const char *format, va_list ap);
extern "C" int Fprintf(FILE *stream, const char *format, ...);
extern "C" int Vfprintf(FILE *stream, const char *format, va_list ap);
extern "C" void Fflush(FILE *stream);
extern "C" FILE *Fdopen(int filedes, const char *mode);
extern "C" void Nl(FILE *stream);
extern "C" void crnl(FILE *stream);
extern "C" void Puts(const char *s);
extern "C" void Fsay(FILE *stream, const char *s);
extern "C" void Fputs(const char *s, FILE *stream);
extern "C" int Sayf(const char *format, ...);
extern "C" int Vsayf(const char *format, va_list ap);
extern "C" int Fsayf(FILE *stream, const char *format, ...);
extern "C" int Vfsayf(FILE *stream, const char *format, va_list ap);
extern "C" char *Input(const char *prompt);
extern "C" char *Inputf(const char *format, ...);
extern "C" char *Vinputf(const char *format, va_list ap);
extern "C" char *Vfinputf(FILE *in, FILE *out, const char *format, va_list ap);
extern "C" char *Finput(FILE *in, FILE *out, const char *prompt);
extern "C" char *Finputf(FILE *in, FILE *out, const char *format, ...);
extern "C" char *Sinput(FILE *s, const char *prompt);
extern "C" char *Sinputf(FILE *s, const char *format, ...);
extern "C" DIR *Opendir(const char *name);
extern "C" dirent *Readdir(DIR *dir);
extern "C" void Closedir(DIR *dir);
extern "C" void Remove(const char *path);
extern "C" int Temp(buffer *b, char *prefix, char *suffix);
extern "C" int Tempdir(buffer *b, char *prefix, char *suffix);
extern "C" int Tempfile(buffer *b, char *prefix, char *suffix, char *tmpdir, int dir, int mode);
extern "C" char random_alphanum(void);
extern "C" int Exists(const char *file_name);
extern "C" int Stat(const char *file_name, struct stat *buf);
extern "C" int is_dir(const char *file_name);
extern "C" int is_real_dir(const char *file_name);
extern "C" void Fstat(int filedes, struct stat *buf);
extern "C" void cx(const char *path);
extern "C" void cnotx(const char *path);
extern "C" void chmod_add(const char *path, mode_t add_mode);
extern "C" void chmod_sub(const char *path, mode_t sub_mode);
extern "C" void stats_init(stats *s, const char *file_name);
extern "C" void lstats_init(stats *s, const char *file_name);
extern "C" int Lstat(const char *file_name, struct stat *buf);
extern "C" FILE *Popen(const char *command, const char *type);
extern "C" int Pclose(FILE *stream);
extern "C" int Fgetc(FILE *stream);
extern "C" void Fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
extern "C" size_t Fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
extern "C" void Fwrite_str(FILE *stream, str s);
extern "C" void Fputc(int c, FILE *stream);
extern "C" long Ftell(FILE *stream);
extern "C" off_t Lseek(int fd, off_t offset, int whence);
extern "C" void Truncate(const char *path, off_t length);
extern "C" void Ftruncate(int fd, off_t length);
extern "C" void _Readlink(const char *path, buffer *b);
extern "C" cstr Readlink(const char *path);
extern "C" cstr readlinks(cstr path, readlinks_if_dead if_dead);
extern "C" void _Getcwd(buffer *b);
extern "C" cstr Getcwd(void);
extern "C" void Chdir(const char *path);
extern "C" void Mkdir_if(const char *pathname, mode_t mode);
extern "C" void say_cstr(cstr s);
extern "C" void Rename(const char *oldpath, const char *newpath);
extern "C" void Chmod(const char *path, mode_t mode);
extern "C" void Chown(const char *path, uid_t uid, gid_t gid);
extern "C" void Lchown(const char *path, uid_t uid, gid_t gid);
extern "C" void Symlink(const char *oldpath, const char *newpath);
extern "C" void Link(const char *oldpath, const char *newpath);
extern "C" void Pipe(int filedes[2]);
extern "C" int Dup(int oldfd);
extern "C" int Dup2(int oldfd, int newfd);
extern "C" FILE *Freopen(const char *path, const char *mode, FILE *stream);
extern "C" void print_range(char *start, char *end);
extern "C" void fprint_range(FILE *stream, char *start, char *end);
extern "C" void say_range(char *start, char *end);
extern "C" void fsay_range(FILE *stream, char *start, char *end);
extern "C" void stats_dump(stats *s);
extern "C" mode_t mode(const char *file_name);
extern "C" void cp(const char *from, const char *to, int mode);
extern "C" void cp_fd(int in, int out);
extern "C" int Select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout);
extern "C" void fd_set_init(fd_set *o);
extern "C" cstr which(cstr file);
extern "C" int can_read(int fd);
extern "C" int can_write(int fd);
extern "C" int has_error(int fd);
extern "C" void Mkdirs(const char *pathname, mode_t mode);
extern "C" void Rmdirs(const char *pathname);
extern "C" int Poll(struct pollfd *fds, nfds_t nfds, int timeout);
extern "C" int Ppoll(struct pollfd *fds, nfds_t nfds, const struct timespec *timeout, const sigset_t *sigmask);
extern "C" void nonblock(int fd);
extern "C" int Fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len);
extern "C" void *Malloc(size_t size);
extern "C" void *_Realloc(void *ptr, size_t size);
extern "C" void *Calloc(size_t nmemb, size_t size);
extern "C" void *rc_malloc(size_t size);
extern "C" count_t rc_use(void *obj);
extern "C" count_t rc_done(void *obj);
extern "C" void rc_free(void *obj);
extern "C" void *rc_calloc(size_t nmemb, size_t size);
extern "C" void hexdump(FILE *stream, char *b0, char *b1);
extern "C" boolean printable(uchar c);
extern "C" void *mem_mem(const void* haystack, size_t haystacklen, const void* needle, size_t needlelen);
extern "C" int num_cmp(const void *a, const void *b);
extern "C" int int_cmp(const void *a, const void *b);
extern "C" void rsleep(num time);
extern "C" num rtime(void);
extern "C" void Gettimeofday(struct timeval *tv);
extern "C" void Gmtime(double t, datetime *result);
extern "C" void Localtime(double t, datetime *result);
extern "C" int Mktime(datetime *t);
extern "C" void Timef(buffer *b, const datetime *tm, const char *format);
extern "C" cstr Timef_cstr(datetime *dt, const char *format);
extern "C" void datetime_init(datetime *dt, int year, int month, int day,  int hour, int min, int sec);
extern "C" void sleep_step(long double step);
extern "C" long double asleep(long double dt, long double t);
extern "C" void rtime_to_timeval(num rtime, struct timeval *tv);
extern "C" void rtime_to_timespec(num rtime, struct timespec *ts);
extern "C" num timeval_to_rtime(struct timeval *tv);
extern "C" num timespec_to_rtime(struct timespec *ts);
extern "C" int sgn(num x);
extern "C" num nmin(num x, num y);
extern "C" num nmax(num x, num y);
extern "C" int imin(int x, int y);
extern "C" int imax(int x, int y);
extern "C" num notpot(num hypotenuse, num x);
extern "C" void seed(void);
extern "C" int mod(int i, int base);
extern "C" int Div(int i, int base);
extern "C" num rmod(num r, num base);
extern "C" num dist(num x0, num y0, num x1, num y1);
extern "C" num double_or_nothing(num factor);
extern "C" void divmod(int i, int base, int *div, int *_mod);
extern "C" void divmod_range(int i, int low, int high, int *div, int *_mod);
extern "C" void rdivmod(num r, num base, num *div, num *_mod);
extern "C" void rdivmod_range(num r, num low, num high, num *div, num *_mod);
extern "C" num clamp(num x, num min, num max);
extern "C" int iclamp(int x, int min, int max);
extern "C" num spow(num b, num e);
extern "C" colour black;
extern "C" colour white;
extern "C" colour red;
extern "C" colour orange;
extern "C" colour yellow;
extern "C" colour green;
extern "C" colour blue;
extern "C" colour indigo;
extern "C" colour violet;
extern "C" colour purple;
extern "C" colour magenta;
extern "C" colour midnightblue;
extern "C" colour brown;
extern "C" colour beige;
extern "C" colour grey;
extern "C" colour darkgrey;
extern "C" colour lightgrey;
extern "C" colour cyan;
extern "C" colour pink;
extern "C" XFontStruct *_font;
extern "C" XShmSegmentInfo *shmseginfo;
extern "C" num _line_width;
extern "C" Display *display;
extern "C" Window root_window;
extern "C" Window window;
extern "C" Visual *visual;
extern "C" XVisualInfo *visual_info;
extern "C" int depth;
extern "C" num pixel_size;
extern "C" Pixmap buf;
extern "C" Colormap colormap;
extern "C" GC gc;
extern "C" XGCValues gcvalues;
extern "C" XColor color;
extern "C" int screen_number;
extern "C" XEvent event;
extern "C" int _xflip;
extern "C" int _yflip;
extern "C" int _deco;
extern "C" num lx;
extern "C" num ly;
extern "C" num lx2;
extern "C" num ly2;
extern "C" boolean _autopaint;
extern "C" num _delay;
extern "C" int text_at_col0;
extern "C" char *vid;
extern "C" num a_pixel;
extern "C" boolean gr_auto_event_loop;
extern "C" num _xanc;
extern "C" num _yanc;
extern "C" int root_w;
extern "C" int root_h;
extern "C" int w;
extern "C" int h;
extern "C" int w_2;
extern "C" int h_2;
extern "C" num ox;
extern "C" num oy;
extern "C" num sc;
extern "C" num text_origin_x;
extern "C" num text_origin_y;
extern "C" num text_wrap_sx;
extern "C" colour bg_col;
extern "C" colour fg_col;
extern "C" num rb_red_angle;
extern "C" num rb_green_angle;
extern "C" num rb_blue_angle;
extern "C" num rb_red_power;
extern "C" num rb_green_power;
extern "C" num rb_blue_power;
extern "C" colour rb[360];
extern "C" str str_null;
extern "C" thunk _thunk_null;
extern "C" thunk *thunk_null;
extern "C" thunk _thunk_error_warn;
extern "C" thunk *thunk_error_warn;
extern "C" thunk _thunk_error_ignore;
extern "C" thunk *thunk_error_ignore;
extern "C" vec *error_handlers;
extern "C" vec *errors;
extern "C" hashtable *extra_error_messages;
extern "C" char hostname__[256];
extern "C" int h_errno;
extern "C" fd_set *tmp_fd_set;
extern "C" cstr dt_format;
extern "C" cstr dt_format_tz;
extern "C" long double sleep_step_last;
extern "C" boolean sleep_step_debug;
extern "C" long double asleep_small;
extern "C" num bm_start;
extern "C" boolean bm_enabled;
extern "C" const double pi;
extern "C" const double e;

void angle3_to_vec3(const angle3 &a, vec3 &v);
num vec3_length(const vec3 &v);
void vec3_to_angle3(const vec3 &v, angle3 &a);
void x_y_rot(num &x, num &y, num a);
void vec3_rot_z(vec3 &v, num a);
void vec3_rot_x(vec3 &v, num a);
void vec3_rot_y(vec3 &v, num a);
void viewpoint_transform(vec3 &v);
void poly_angle3_to_poly_vec3(const poly_angle3 &poly_a, poly_vec3 &poly_v);
void poly_vec3_viewpoint_transform(poly_vec3 &poly_v);
void load_and_convert_regions(const char *datafile);
inline void null_function(...);
void dump_angle3(const angle3 &a);
void poly_vec3_vp_clip_and_draw(const poly_vec3 &poly);
void poly_vec3_vp_clip_and_fill(poly_vec3 poly);
void add_poly_arc_to_polygon(polygon &render_poly, const poly_vec3 &arc, int from, int to);
void add_circle_arc_to_polygon(polygon &render_poly, num from_angle, num to_angle);
num angle_of_cross_point(vec3 &v0, vec3 &v1);
num calc_max_da(void);
void load_colour(FILE *f, colour &c);
void load_palette(const char *palfile);
void poly_vec3_draw(const poly_vec3 &poly);
void draw_to_vec3(const vec3 &v);
void poly_vec3_vp_and_draw(const poly_vec3 &poly);
void draw_to_vec3_vp(vec3 v);
void poly_vec3_vp_and_fill(const poly_vec3 &poly);
polygon *vec3_polygon_accumulator(polygon *p, vec3 v);
void poly_angle3_draw(const poly_angle3 &poly_a);
void plot_point(vec3 p);
void plot_point_angle3(angle3 a3);
void draw_points(poly_vec3 &points);
void load_points(const char *pointfile);
void calc_sector_bounds(const sector_id &id, sector_bounds &b);
int sector_rows(int level);
int sector_rows_eq_to_pole(int level);
num sector_row_height(int level);
num sector_width(int level, int row);
int sectors_in_row(int level, int row);
void which_sector(const angle3 &a, sector_id &s);
bool point_in_sector(const angle3 &p, const sector_bounds &b);
void clip_region_to_sector(const poly_angle3 &poly, const sector_bounds &b, region_sector_containment &containment, vector<clip_to_sector_arc> &arcs);
void exits_sector_where(const sector_bounds &b, const angle3 &a0, const angle3 &a1, sector_side_pos &pos);
void enters_sector_where(const sector_bounds &b, const angle3 &a0, const angle3 &a1, sector_side_pos &pos);
void draw_clipped_arcs(poly_vec3 &poly, vector<clip_to_sector_arc> &clipped_arcs);
void draw_sector_grid(int level);
void draw_parallel(num latitude);
void draw_parallel_arc(num latitude, num ew0, num ew1);
void draw_meridian(num longitude);
void draw_meridian_arc(num longitude, num ns0, num ns1);
num calc_dotted_line_da(void);
void draw_great_circle(void);
void draw_great_circle_arc(void);
void draw_sector_bounds(sector_bounds &b);
int main(int argc, char **argv);
void fill_region(region &r);

extern num latitude;
extern num longitude;
extern num spin;
extern num r;
extern num zm;
extern vector<region> regions;
extern num acceptable_deviation_from_arc_pixels;
extern colour col_space;
extern colour col_sea;
extern colour col_land;
extern colour col_lake;
extern colour col_point;
extern colour col_focus;
extern colour col_grid;
extern poly_angle3 points;
extern poly_vec3 points_v;
extern int pixels_per_dot;
extern int window_width;
extern int window_height;
extern int focus_region;

num window_radius;

int window_width = 600;
int window_height = 600;
int focus_region = -1;

int main(int argc, char **argv)
{
	num delta_latitude, delta_longitude, delta_spin, dfac_zoom;
	num delay = 0;
	int level, row, cell;
	if(argc != 14)
	{
		error("syntax: geon ns ew rot zoom dns dew drot fzoom delay focus_region level row cell");
	}
	latitude = ((atof(argv[1])) * pi / 180.0);
	longitude = ((atof(argv[2])) * pi / 180.0);
	spin = ((atof(argv[3])) * pi / 180.0);
	zm = atof(argv[4]);
	delta_latitude = ((atof(argv[5])) * pi / 180.0);
	delta_longitude = ((atof(argv[6])) * pi / 180.0);
	delta_spin = ((atof(argv[7])) * pi / 180.0);
	dfac_zoom = atof(argv[8]);
	delay = atof(argv[9]);
	focus_region = atoi(argv[10]);
	level = atoi(argv[11]);
	row = atoi(argv[12]);
	cell = atoi(argv[13]);
	load_and_convert_regions("data/regions");
	load_points("data/points");
	gr_init();
	_paper(window_width, window_height, white, black);
	gr_fast();
	window_radius = hypot(window_width/2, window_height/2);
	load_palette("data/palette");
	zoom(r*zm);
	bool display_focus = focus_region >= 0 && (unsigned int)focus_region < regions.size();
	if(display_focus)
	{
		latitude = regions[focus_region].points_a[0].latitude;
		longitude = regions[focus_region].points_a[0].longitude;
	}
	sector_id focus_sector_id = { level, row, cell };
	sector_bounds focus_sector_bounds;
	bool display_focus_sector = level >= 0 && cell >= 0;
	region_sector_containment containment;
	vector<clip_to_sector_arc> clipped_arcs;
	if(display_focus_sector)
	{
		calc_sector_bounds(focus_sector_id, focus_sector_bounds);
		clip_region_to_sector(regions[0].points_a, focus_sector_bounds, containment, clipped_arcs);
		latitude = (focus_sector_bounds.south + focus_sector_bounds.north) / 2;
		longitude = (focus_sector_bounds.west + focus_sector_bounds.east) / 2;
	}
	while(1)
	{
		num pixel = 1/(r*zm);
		if(r*zm < window_radius + 10*pixel)
		{
			bg(col_space);
			clear();
			col(col_sea);
			(circle_fill(0, 0, (1-pixel)));
		}
		else
		{
			bg(col_sea);
			clear();
		}
		for_each(regions, fill_region);
		if(display_focus)
		{
			col(col_focus);
		}
		if(level >= 0)
		{
			col(col_grid);
			draw_sector_grid(level);
		}
		col(col_point);
		draw_points(points_v);
		if(display_focus_sector)
		{
			draw_sector_bounds(focus_sector_bounds);
			draw_clipped_arcs(regions[focus_region].points_v, clipped_arcs);
		}
		paint();
		if(delay < 0)
		{
			break;
		}
		rsleep(delay);
		latitude += delta_latitude;
		longitude += delta_longitude;
		spin += delta_spin;
		zm *= dfac_zoom;
		zoom(r*zm);
	}
	event_loop();
	return 0;
}

void fill_region(region &r)
{
	if(r.type == LAND)
	{
		col(col_land);
	}
	else if(r.type == LAKE)
	{
		col(col_lake);
	}
	else
	{
		error("unknown region type %d", (int)r.type);
	}
	poly_vec3_vp_clip_and_fill(r.points_v);
}

