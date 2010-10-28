#include <png.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdint.h>
#include <limits.h>
#include <float.h>
#include <stdio.h>
#include <errno.h>
#include <setjmp.h>
#include <stdarg.h>
#include <unistd.h>
#include <signal.h>
#include <pwd.h>
#include <grp.h>
#include <sched.h>
#include <sys/wait.h>
#include <sys/utsname.h>
#include <shadow.h>
#include <ctype.h>
#include <time.h>
#include <sys/time.h>
#include <locale.h>
#include <math.h>
#include <complex.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/un.h>
#include <sys/sendfile.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <utime.h>
#include <sys/select.h>
#include <poll.h>
#include <sys/ioctl.h>
#include <sys/epoll.h>
#include <sys/mman.h>
#include <strings.h>
#include <linux/soundcard.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/XShm.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <termios.h>

struct str;
union any;
struct buffer;
struct circbuf;
struct deq;
struct thunk;
struct list;
struct list_x;
struct hashtable;
struct err;
struct error_handler;
struct User;
struct vec;
struct ropev;
union rope;
struct rope_p;
struct cons;
struct dirbase;
struct pointi1;
struct pointi2;
struct pointi3;
struct pointn1;
struct pointn2;
struct pointn3;
struct proc;
struct timeout;
struct vstream;
struct key_value;
struct cstr2cstr;
struct long2cstr;
struct cstr2long;
struct long2long;
struct node_kv;
struct io_epoll;
struct scheduler;
struct shuttle;
struct sock;
struct shuttle_buffer;
struct shuttle_sock_p;
struct coro;
struct opts;
struct opt;
struct type__element;
struct type__size;
struct type;
struct type__void;
struct type__int;
struct type__float;
struct type__point;
struct type__array;
struct type__struct_union;
struct type__func;
struct type__def;
struct range;
struct audio;
struct sprite;
struct sprite_loop;
struct polygon;
struct gr_event;
struct controller;
struct gr_event_callback;
struct turtle_pos;

typedef struct str str;
typedef union any any;
typedef struct buffer buffer;
typedef struct circbuf circbuf;
typedef struct deq deq;
typedef struct thunk thunk;
typedef struct list list;
typedef struct list_x list_x;
typedef struct hashtable hashtable;
typedef struct err err;
typedef struct error_handler error_handler;
typedef struct User User;
typedef struct vec vec;
typedef struct ropev ropev;
typedef union rope rope;
typedef struct rope_p rope_p;
typedef struct cons cons;
typedef struct dirbase dirbase;
typedef struct pointi1 pointi1;
typedef struct pointi2 pointi2;
typedef struct pointi3 pointi3;
typedef struct pointn1 pointn1;
typedef struct pointn2 pointn2;
typedef struct pointn3 pointn3;
typedef struct proc proc;
typedef struct timeout timeout;
typedef struct vstream vstream;
typedef struct key_value key_value;
typedef struct cstr2cstr cstr2cstr;
typedef struct long2cstr long2cstr;
typedef struct cstr2long cstr2long;
typedef struct long2long long2long;
typedef struct node_kv node_kv;
typedef struct io_epoll io_epoll;
typedef struct scheduler scheduler;
typedef struct shuttle shuttle;
typedef struct sock sock;
typedef struct shuttle_buffer shuttle_buffer;
typedef struct shuttle_sock_p shuttle_sock_p;
typedef struct coro coro;
typedef struct opts opts;
typedef struct opt opt;
typedef struct type__element type__element;
typedef struct type__size type__size;
typedef struct type type;
typedef struct type__void type__void;
typedef struct type__int type__int;
typedef struct type__float type__float;
typedef struct type__point type__point;
typedef struct type__array type__array;
typedef struct type__struct_union type__struct_union;
typedef struct type__func type__func;
typedef struct type__def type__def;
typedef struct range range;
typedef struct audio audio;
typedef struct sprite sprite;
typedef struct sprite_loop sprite_loop;
typedef struct polygon polygon;
typedef struct gr_event gr_event;
typedef struct controller controller;
typedef struct gr_event_callback gr_event_callback;
typedef struct turtle_pos turtle_pos;

typedef uint8_t byte;
typedef double num;
typedef unsigned char boolean;
typedef char *cstr;
typedef unsigned int count_t;
typedef unsigned short ushort;
typedef unsigned char uchar;
typedef unsigned long ulong;
typedef unsigned int uint;
typedef signed char schar;
typedef long vlong;
typedef struct timeval timeval;
typedef struct timespec timespec;
typedef struct tm datetime;
typedef void free_t(void *);
typedef long long long_long;
typedef long double long_double;
typedef signed int signed_int;
typedef signed short signed_short;
typedef signed char signed_char;
typedef signed long signed_long;
typedef signed long long signed_long_long;
typedef unsigned int unsigned_int;
typedef unsigned short unsigned_short;
typedef unsigned char unsigned_char;
typedef unsigned long unsigned_long;
typedef unsigned long long unsigned_long_long;
typedef void *ptr;
typedef unsigned int flag;
typedef void *thunk_func(void *obj, void *common_arg, void *specific_arg);
typedef unsigned long hash_func(void *key);
typedef boolean eq_func(void *k1, void *k2);
typedef enum { OE_CONT, OE_ERRCODE, OE_ERROR, OE_WARN=1<<31 } opt_err;
typedef void (*sighandler_t)(int);
typedef struct sched_param sched_param;
typedef struct passwd passwd;
typedef struct spwd spwd;
typedef struct group group;
typedef struct itimerval itimerval;
typedef double complex cmplx;
typedef int (*proc_func)(proc *p);
typedef proc *proc_p;
typedef vec priq;
typedef priq timeouts;
typedef timeout *timeout_p;
typedef struct sockaddr sockaddr;
typedef struct sockaddr_in sockaddr_in;
typedef struct sockaddr_un sockaddr_un;
typedef struct in_addr in_addr;
typedef struct hostent hostent;
typedef int SOCKET;
typedef void (*vs_putc_t)(int c, vstream *vs);
typedef int (*vs_getc_t)(vstream *vs);
typedef int (*vs_printf_t)(vstream *vs, const char *format, va_list ap);
typedef char *(*vs_gets_t)(char *s, int size, vstream *vs);
typedef void (*vs_write_t)(const void *ptr, size_t size, size_t nmemb, vstream *vs);
typedef size_t (*vs_read_t)(void *ptr, size_t size, size_t nmemb, vstream *vs);
typedef void (*vs_flush_t)(vstream *vs);
typedef void (*vs_close_t)(vstream *vs);
typedef void (*vs_shutdown_t)(vstream *vs, int how);
typedef struct dirent dirent;
typedef struct stat stats;
typedef struct stat lstats;
typedef struct stat Stats;
typedef struct stat Lstats;
typedef enum { FT_REG=1, FT_DIR=2, FT_CHR=3, FT_BLK=4, FT_FIFO=5, FT_SOCK=6, FT_EXISTS=8, FT_FILE=16, FT_LINK=32, FT_TYPE_MASK=7 } filetype_t;
typedef struct pollfd pollfd;
typedef struct epoll_event epoll_event;
typedef int (*cmp_t)(const void *, const void *);
typedef sock *sock_p;
typedef listener_try listener_tcp;
typedef listener_try listener_unix;
typedef void noret;
typedef void (*coro_func)(coro *caller);
typedef enum { HTTP_GET, HTTP_HEAD, HTTP_POST, HTTP_PUT, HTTP_DELETE, HTTP_INVALID } http__method;
typedef enum { TYPE_VOID, TYPE_INT, TYPE_FLOAT, TYPE_POINT, TYPE_ARRAY, TYPE_STRUCT, TYPE_UNION, TYPE_FUNC, TYPE_DEF } type_t;
typedef enum { SIGNED_NORMAL, SIGNED_SIGNED, SIGNED_UNSIGNED=-1 } signed_t;
typedef float sample;
typedef double sample2;
typedef vec sound;
typedef vec dsp_buffer;
typedef num (*wave_f)(num t);
typedef unsigned long colour;
typedef uint32_t pix_t;
typedef int gr__x_error_handler(Display *, XErrorEvent *);
typedef struct termios termios;

struct str
{
	char *start;
	char *end;
};

union any
{
	void *p;
	char *cs;
	char c;
	short s;
	int i;
	long l;
	long long ll;
	float f;
	double d;
	long double ld;
	size_t z;
	off_t o;
};

struct buffer
{
	char *start;
	char *end;
	char *space_end;
};

struct circbuf
{
	ssize_t size;
	ssize_t space;
	ssize_t start;
	char *data;
};

struct deq
{
	circbuf b;
	ssize_t element_size;
	ssize_t space;
	ssize_t size;
	ssize_t start;
};

struct thunk
{
	thunk_func *func;
	void *obj;
	void *common_arg;
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
	hash_func *hash;
	eq_func *eq;
};

struct err
{
	cstr msg;
	int no;
	void *data;
};

struct error_handler
{
	jmp_buf *jump;
	thunk handler;
	int err;
};

struct User
{
	char *pw_name;
	char *pw_passwd;
	uid_t pw_uid;
	gid_t pw_gid;
	char *pw_gecos;
	char *pw_dir;
	char *pw_shell;
	long n_groups;
	char **groups;
	gid_t *gids;
	long n_members;
	char **members;
	uid_t *mids;
};

struct vec
{
	buffer b;
	ssize_t element_size;
	ssize_t space;
	ssize_t size;
};

struct ropev
{
	rope *end;
	rope *start;
};

union rope
{
	str s;
	ropev v;
};

struct rope_p
{
	vec stack;
	uchar ref_type;
	uchar where;
};

struct cons
{
	void *head;
	void *tail;
};

struct dirbase
{
	cstr dir;
	cstr base;
};

struct pointi1
{
	int x[1];
};

struct pointi2
{
	int x[2];
};

struct pointi3
{
	int x[3];
};

struct pointn1
{
	num x[1];
};

struct pointn2
{
	num x[2];
};

struct pointn3
{
	num x[3];
};

struct proc
{
	proc_func f;
	int pc;
};

struct timeout
{
	num time;
	thunk handler;
	int i;
};

struct vstream
{
	vs_putc_t putc;
	vs_getc_t getc;
	vs_printf_t printf;
	vs_gets_t gets;
	vs_write_t write;
	vs_read_t read;
	vs_flush_t flush;
	vs_close_t close;
	vs_shutdown_t shutdown;
	void *data;
};

struct key_value
{
	void *k;
	void *v;
};

struct cstr2cstr
{
	cstr k;
	cstr v;
};

struct long2cstr
{
	long k;
	cstr v;
};

struct cstr2long
{
	cstr k;
	long v;
};

struct long2long
{
	long k;
	long v;
};

struct node_kv
{
	list l;
	key_value kv;
};

struct io_epoll
{
	int epfd;
	int max_fd_plus_1;
	int count;
	vec *events;
};

struct scheduler
{
	int exit;
	deq q;
	io_epoll io;
	vec readers;
	vec writers;
	num now;
	timeouts tos;
	hashtable child_wait;
	hashtable child_status;
	int step;
	int n_children;
	int got_sigchld;
};

struct shuttle
{
	proc *current;
	proc *other;
	enum { ACTIVE, WAITING, GONE } other_state;
};

struct sock
{
	int fd;
	sockaddr *sa;
	socklen_t len;
};

struct shuttle_buffer
{
	shuttle sh;
	buffer d;
};

struct shuttle_sock_p
{
	shuttle sh;
	sock_p d;
};

struct coro
{
	coro *next;
	coro *prev;
	jmp_buf j;
};

struct opts
{
	vec v;
	hashtable h;
};

struct opt
{
	cstr name;
	cstr *arg;
};

struct type__element
{
	type *type;
	cstr name;
	long offset;
};

struct type__size
{
	int size;
	int var_size;
};

struct type
{
	type_t type;
	cstr name;
	long size;
};

struct type__void
{
	type t;
};

struct type__int
{
	type t;
	signed_t sign;
};

struct type__float
{
	type t;
};

struct type__point
{
	type t;
	type *ref;
};

struct type__array
{
	type t;
	int dims;
	type *ref;
	int n[];
};

struct type__struct_union
{
	type t;
	long n;
	type__element e[];
};

struct type__func
{
	type t;
	int n;
	type *ret;
	type *arg[];
};

struct type__def
{
	type t;
	type *ref;
};

struct range
{
	sample min, max;
};

struct audio
{
	int channels;
	int bits_per_sample;
	long sample_rate;
	size_t n_samples;
	sound *sound;
};

struct sprite
{
	pix_t *pixels;
	long width;
	long height;
	long stride;
};

struct sprite_loop
{
	sprite *spr;
	pix_t *px;
	pix_t *end;
	pix_t *endrow;
	long d;
};

struct polygon
{
	XPoint *points;
	int n_points;
	int space;
};

struct gr_event
{
	int type;
	int which;
	int x, y;
	int state;
	long time;
};

struct controller
{
	thunk keyboard;
	thunk mouse;
};

struct gr_event_callback
{
	thunk t;
	gr_event e;
	num time;
};

struct turtle_pos
{
	num lx, ly;
	num lx2, ly2;
	num turtle_a;
};

noret new_coro_2(coro_func f, coro *caller);
colour coln(char *name);
colour col(colour pixel);
thunk (*key_handlers)[2];
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
char buffer_last_char(buffer *b);
boolean buffer_ends_with_char(buffer *b, char c);
boolean buffer_ends_with(buffer *b, cstr s);
char buffer_first_char(buffer *b);
char buffer_get_char(buffer *b, size_t i);
void buffer_zero(buffer *b);
int Sprintf(buffer *b, const char *format, ...);
cstr format(const char *format, ...);
cstr vformat(const char *format, va_list ap);
cstr fformat(const char *format, ...);
cstr vfformat(const char *format, va_list ap);
int Vsnprintf(char *buf, size_t size, const char *format, va_list ap);
int Vsprintf(buffer *b, const char *format, va_list ap);
char *buffer_add_nul(buffer *b);
char *buffer_nul_terminate(buffer *b);
void buffer_strip_nul(buffer *b);
void buffer_dump(FILE *stream, buffer *b);
buffer *buffer_dup_0(buffer *from);
buffer *buffer_dup(buffer *to, buffer *from);
cstr buffer_to_cstr(buffer *b);
void buffer_from_cstr(buffer *b, cstr s, size_t len);
buffer *buffer_from_cstr_1(cstr s);
void buffer_shift(buffer *b, size_t shift);
void buffer_ensure_space(buffer *b, size_t space);
void buffer_ensure_size(buffer *b, ssize_t size);
void buffer_ensure_free(buffer *b, ssize_t free);
void buffer_nl(buffer *b);
void buf_splice(buffer *b, size_t i, size_t cut, char *in, size_t ins);
buffer *Subbuf(buffer *b, size_t i, size_t n, size_t extra);
buffer *subbuf(buffer *sub, buffer *b, size_t i, size_t n);
void buf_dup_guts(buffer *b, size_t extra);
void buffer_cat_chars(buffer *b, char c, size_t n);
void buffer_cat_int(buffer *b, int i);
void buffer_cat_long(buffer *b, long i);
void buffer_clone(buffer *out, buffer *in);
void circbuf_init(circbuf *b, ssize_t space);
char *circbuf_get_pos(circbuf *b, int index);
void circbuf_free(circbuf *b);
void circbuf_set_space(circbuf *b, ssize_t space);
void circbuf_ensure_space(circbuf *b, ssize_t space);
void circbuf_ensure_size(circbuf *b, ssize_t size);
void circbuf_ensure_free(circbuf *b, ssize_t free);
void circbuf_set_size(circbuf *b, ssize_t size);
void circbuf_grow(circbuf *b, ssize_t delta_size);
void circbuf_shift(circbuf *b, ssize_t delta_size);
void circbuf_unshift(circbuf *b, ssize_t delta_size);
void circbuf_double(circbuf *b);
void circbuf_squeeze(circbuf *b);
void circbuf_clear(circbuf *b);
void buffer_to_circbuf(circbuf *cb, buffer *b);
void circbuf_cat_char(circbuf *b, char c);
void circbuf_cat_cstr(circbuf *b, const char *s);
void circbuf_cat_str(circbuf *b, str s);
void circbuf_cat_range(circbuf *b, const char *start, const char *end);
char circbuf_first_char(circbuf *b);
char circbuf_last_char(circbuf *b);
char circbuf_get_char(circbuf *b, ssize_t i);
int Vsprintf_cb(circbuf *b, const char *format, va_list ap);
void circbuf_add_nul(circbuf *b);
void circbuf_to_buffer(buffer *b, circbuf *cb);
void circbuf_tidy(circbuf *b);
cstr circbuf_to_cstr(circbuf *b);
char *circbuf_nul_terminate(circbuf *b);
ssize_t cbindex_not_len(circbuf *b, char *p);
ssize_t cbindex_not_0(circbuf *b, char *p);
void circbuf_from_cstr(circbuf *b, cstr s, ssize_t len);
void circbuf_dump(FILE *stream, circbuf *b);
void circbuf_copy_out(circbuf *b, void *dest, ssize_t i, ssize_t n);
void circbuf_cat_cb_range(circbuf *b, circbuf *from, ssize_t i, ssize_t n);
void circbuf_copy_in(circbuf *b, ssize_t i, void *from, ssize_t n);
void _deq_init(deq *q, ssize_t element_size, ssize_t space);
void deq_free(deq *q);
void deq_space(deq *q, ssize_t space);
void deq_size(deq *q, ssize_t size);
void deq_clear(deq *q);
void deq_double(deq *q);
void deq_squeeze(deq *q);
void *deq_element(deq *q, ssize_t index);
void *deq_push(deq *q);
void deq_pop(deq *q);
void *deq_top(deq *q, ssize_t index);
void *deq_unshift(deq *q);
void deq_shift(deq *q);
void deq_grow(deq *q, ssize_t delta_size);
void deq_cat_range(deq *q, void *start, void *end);
void deq_recalc_from_cb(deq *q);
void deq_shifts(deq *q, ssize_t n);
void deq_unshifts(deq *q, ssize_t n);
void deq_copy_out(deq *q, void *dest, ssize_t i, ssize_t n);
void deq_cat_deq_range(deq *q, deq *from, ssize_t i, ssize_t n);
void deq_cat_deq(deq *q, deq *from);
void deq_copy_in(deq *q, ssize_t i, void *from, ssize_t n);
void vec_to_deq(deq *q, vec *v);
void deq_to_vec(vec *v, deq *q);
void deq_tidy(deq *q);
void data_to_deq(deq *q, void *data, ssize_t size, ssize_t element_size);
void deq_to_data(deq *q, void **data, ssize_t *size);
ssize_t deqt_pre(deq *t, deq *q, ssize_t offset);
ssize_t deqt_post(deq *t, ssize_t oldsize);
void deqts_shift(deq *q, ssize_t *offsets, ssize_t n);
ssize_t deqts_min_offset(ssize_t *offsets, ssize_t n);
void deqts_shift_offsets(ssize_t *offsets, ssize_t n, ssize_t min_offset);
void *thunk_ignore(void *obj, void *common_arg, void *specific_arg);
void *thunk_void(void *obj, void *common_arg, void *specific_arg);
void *thunk_thunks(void *obj, void *common_arg, void *specific_arg);
void *thunks_call(deq *q, void *specific_arg);
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
void hashtable_init(hashtable *ht, hash_func *hash, eq_func *eq, size_t size);
list *alloc_buckets(size_t size);
list *hashtable_lookup_ref(hashtable *ht, void *key);
key_value *hashtable_lookup(hashtable *ht, void *key);
key_value *hashtable_ref_lookup(list *l);
void *hashtable_value(hashtable *ht, void *key);
void *hashtable_value_or_null(hashtable *ht, void *key);
void *hashtable_value_or(hashtable *ht, void *key, void *def);
key_value *hashtable_add(hashtable *ht, void *key, void *value);
void hashtable_ref_add(list *l, void *key, void *value);
key_value *hashtable_add_maybe(hashtable *ht, void *key, void *value);
boolean hashtable_ref_add_maybe(list *l, void *key, void *value);
key_value hashtable_delete(hashtable *ht, void *key);
void hashtable_delete_maybe(hashtable *ht, void *key);
key_value hashtable_ref_delete(list *l);
node_kv *hashtable_ref_node(list *l);
boolean hashtable_ref_exists(list *l);
key_value *hashtable_ref_key_value(list *l);
list *which_bucket(hashtable *ht, void *key);
size_t hashtable_sensible_size(size_t size);
unsigned long cstr_hash(void *s);
void hashtable_dump(hashtable *ht);
key_value *hashtable_lookup_or_add_key(hashtable *ht, void *key, void *value_init);
key_value *hashtable_lookup_or_die(hashtable *ht, void *key);
unsigned long int_hash(void *i_ptr);
boolean int_eq(void *a, void *b);
void hashtable_free(hashtable *ht, free_t *free_key, free_t *free_value);
void hashtable_clear(hashtable *ht, free_t *free_key, free_t *free_value);
vec *mget(hashtable *ht, void *key);
void mput(hashtable *ht, void *key, void *value);
void *mget1(hashtable *ht, void *key);
ssize_t mgetc(hashtable *ht, void *key);
void *mget1st(hashtable *ht, void *key);
void *mgetlast(hashtable *ht, void *key);
void kv_cstr_to_hashtable(hashtable *ht, cstr kv[][2]);
void table_cstr_to_hashtable(hashtable *ht, void *table, long width, long ki, long vi);
ssize_t hashtable_already(hashtable *ht, void *key);
unsigned long vos_hash(void *s);
boolean vos_eq(void *_v1, void *_v2);
void keys(vec *out, hashtable *ht);
void values(vec *out, hashtable *ht);
void sort_keys(vec *out, hashtable *ht);
void error(const char *format, ...);
void verror(const char *format, va_list ap);
void serror(const char *format, ...);
void vserror(const char *format, va_list ap);
void warn(const char *format, ...);
void vwarn(const char *format, va_list ap);
void failed(const char *funcname);
void failed2(const char *funcname, const char *errmsg);
void failed3(const char *funcname, const char *msg1, const char *msg2);
void warn_failed(const char *funcname);
void swarning(const char *format, ...);
void vswarning(const char *format, va_list ap);
void memdump(const char *from, const char *to);
void fsay_usage_(FILE *s, cstr *usage);
void error_init(void);
err *error_add(cstr msg, int no, void *data);
void Throw(cstr msg, int no, void *data);
void throw_(err *e);
void die_errors(int status);
void clear_errors(void);
void warn_errors(void);
void warn_errors_keep(void);
void debug_errors(void);
void debug_errors_keep(void);
void fault_(char *file, int line, const char *format, ...);
void vfault_(char *file, int line, const char *format, va_list ap);
void add_error_message(int errnum, cstr message);
cstr Strerror(int errnum);
void Perror(const char *s);
void *error_warn(void *obj, void *common_arg, void *er);
void *error_ignore(void *obj, void *common_arg, void *er);
any opt_err_do(opt_err opt, any value, any errcode, char *format, ...);
any vopt_err_do(opt_err opt, any value, any errcode, char *format, va_list ap);
void Debug(cstr format, ...);
void vDebug(cstr format, va_list ap);
void Debug_errors(void);
void Atexit(void (*function)(void));
void Exit(int status);
void Execv(const char *path, char *const argv[]);
void Execvp(const char *file, char *const argv[]);
void Execve(const char *filename, char *const argv[], char *const envp[]);
static void exec_argv_do_init(void);
void Execl(const char *path, ...);
void Vexecl(const char *path, va_list ap);
void Execlp(const char *file, ...);
void Vexeclp(const char *file, va_list ap);
void Execle(const char *path, ...);
void Vexecle(const char *path, va_list ap);
void sh_quote(const char *from, buffer *to);
void cmd_quote(const char *from, buffer *to);
int System(const char *s);
int Systemf(const char *format, ...);
void SYSTEM(const char *s);
void SYSTEMF(const char *format, ...);
void VSYSTEMF(const char *format, va_list ap);
int Vsystemf(const char *format, va_list ap);
sighandler_t Signal(int signum, sighandler_t handler);
int Systema_q(boolean quote, const char *filename, char *const argv[]);
void system_quote_check_uq(boolean quote, const char *s, buffer *b);
int Systemv_q(boolean quote, const char *filename, char *const argv[]);
int Systeml__q(boolean quote, const char *filename, ...);
int Systeml_(const char *filename, ...);
int Systemlu_(const char *filename, ...);
int Vsysteml_q(boolean quote, const char *filename, va_list ap);
cstr cmd(cstr c);
sighandler_t Sigact(int signum, sighandler_t handler, int sa_flags);
void call_sighandler(sighandler_t h, int sig);
void Raise(int sig);
void catch_signal_null(int sig);
int fix_exit_status(int status);
void hold_term_open(void);
void Uname(struct utsname *buf);
void uq_init(void);
cstr uq(const char *s);
boolean is_uq(const char *s);
void uq_clean(void);
void q_init(void);
cstr q(const char *s);
void q_clean(void);
cstr qq(cstr s);
cstr x(cstr command);
void sh_unquote(cstr s);
char *sh_unquote_full(cstr s);
pid_t Fork(void);
pid_t Waitpid(pid_t pid, int *status, int options);
int Child_wait(pid_t pid);
pid_t Child_done(void);
pid_t Waitpid_intr(pid_t pid, int *status, int options);
void Sched_setscheduler(pid_t pid, int policy, const sched_param *p);
void set_priority(pid_t pid, int priority);
cstr whoami(void);
int auth(User *u, cstr pass);
int auth_pw(passwd *pw, cstr pass);
void Setgroups(size_t size, const gid_t *list);
hashtable *load_users(void);
User *passwd_to_user(passwd *p);
void user_free(User *u);
struct passwd *Getpwent(void);
struct passwd *Getpwnam(const char *name);
struct passwd *Getpwuid(uid_t uid);
struct group *Getgrent(void);
struct spwd *Getspent(void);
struct spwd *Getspnam(const char *name);
void Setuid(uid_t uid);
void Setgid(gid_t gid);
void Seteuid(uid_t euid);
void Setegid(gid_t egid);
void Setreuid(uid_t ruid, uid_t euid);
void Setregid(gid_t rgid, gid_t egid);
sighandler_t sigact(int signum, sighandler_t handler, int sa_flags);
void Sigprocmask(int how, const sigset_t *set, sigset_t *oldset);
sigset_t Sig_defer(int signum);
sigset_t Sig_pass(int signum);
sigset_t Sig_mask(int signum, int defer);
sigset_t Sig_setmask(sigset_t *set);
sigset_t Sig_getmask(void);
void Sigsuspend(const sigset_t *mask);
int Sigwait(const sigset_t *mask);
void Nice(int inc);
void Sched_yield(void);
void exit_exec_failed(void);
void Sigdfl_all(void);
int Getgrouplist(const char *user, gid_t group, vec *groups);
void vec_init_el_size(vec *v, ssize_t element_size, ssize_t space);
void vec_clear(vec *v);
void vec_free(vec *v);
void vec_Free(vec *v);
void vec_space(vec *v, ssize_t space);
void vec_size(vec *v, ssize_t size);
void vec_double(vec *v);
void vec_squeeze(vec *v);
void *vec_element(vec *v, ssize_t index);
void *vec_top(vec *v, ssize_t index);
void *vec_push(vec *v);
void vec_pop(vec *v);
void vec_grow(vec *v, ssize_t delta_size);
void vec_grow_squeeze(vec *v, ssize_t delta_size);
vec *vec_dup_0(vec *from);
vec *vec_dup(vec *to, vec *from);
void vec_ensure_size(vec *v, ssize_t size);
void *vec_to_array(vec *v);
void array_to_vec(vec *v, void *a);
void vec_splice(vec *v, ssize_t i, ssize_t cut, void *in, ssize_t ins);
vec *Subvec(vec *v, ssize_t i, ssize_t n, ssize_t extra);
vec *subvec(vec *sub, vec *v, ssize_t i, ssize_t n);
void vec_recalc_from_buffer(vec *v);
void vec_recalc_buffer(vec *v);
void vec_append_vec(vec *v0, vec *v1);
void vov_free(vec *v);
void vov_free_maybe_null(vec *v);
vec *vec1(void *e);
void cstr_dos_to_unix(cstr s);
cstr cstr_unix_to_dos(cstr s);
cstr cstr_chomp(cstr s);
boolean cstr_eq(void *s1, void *s2);
boolean cstr_case_eq(void *s1, void *s2);
boolean cstr_is_empty(cstr s1);
boolean cstr_ends_with(cstr s, cstr substr);
boolean cstr_case_ends_with(cstr s, cstr substr);
cstr cstr_begins_with(cstr s, cstr substr);
cstr cstr_case_begins_with(cstr s, cstr substr);
cstr cstr_from_buffer(buffer *b);
cstr cstr_of_size(size_t n);
cstr cstr_chop_end(cstr c, cstr end);
cstr cstr_chop_start(cstr c, cstr start);
void void_cstr(cstr s);
void splitv(vec *v, cstr s, char c);
void splitv1(vec *v, cstr s, char c);
void splitv_dup(vec *v, const char *_s, char c);
cstr *split(cstr s, char c);
cstr *splitn(cstr s, char c, int n);
void splitvn(vec *v, cstr s, char c, int n);
void splitvn1(vec *v, cstr s, char c, int n);
cstr *split_dup(const char *s, char c);
cstr join(char sep, cstr *s);
cstr joinv(char sep, vec *v);
cstr joins(cstr sep, cstr *s);
cstr joinsv(cstr sep, vec *v);
char *Strstr(const char *haystack, const char *needle);
char *Strcasestr(const char *haystack, const char *needle);
char *Strchr(const char *s, int c);
char *Strrchr(const char *s, int c);
cstr cstr_tolower(cstr s);
cstr cstr_toupper(cstr s);
boolean is_blank(cstr l);
cstr cstr_begins_with_word(cstr s, cstr substr);
void cstr_chop(cstr s, long n);
cstr cstr_begins_with_sym(cstr s, cstr substr);
char *cstr_not_chr(cstr s, char c);
cstr make_name(cstr s);
size_t Strlcpy(char *dst, char *src, size_t size);
size_t Strlcat(char *dst, char *src, size_t size);
long int Strtol(const char *nptr, char **endptr, int base);
long long int Strtoll(const char *nptr, char **endptr, int base);
double Strtod(const char *nptr, char **endptr);
float Strtof(const char *nptr, char **endptr);
long int STRTOL(const char *nptr, int base);
long long int STRTOLL(const char *nptr, int base);
double STRTOD(const char *nptr);
float STRTOF(const char *nptr);
size_t strlcpy(char *dst, const char *src, size_t size);
size_t strlcat(char *dst, const char *src, size_t size);
size_t rope_get_size(rope r);
ropev ropev_ref(rope *start, rope *end);
ropev ropev_of_size(int size);
size_t ropev_get_size(ropev v);
str str_from_rope(rope r);
cstr cstr_from_rope(rope r);
char *rope_flatten(char *to, rope r);
char *ropev_flatten(char *to, ropev v);
rope rope_cat_2(rope r1, rope r2);
rope rope_cat_3(rope r1, rope r2, rope r3);
rope rope_cat_n(size_t n, ...);
rope vrope_cat_n(size_t n, va_list ap);
void rope_dump(rope r, int indent);
void ropev_dump(ropev v, int indent);
void rope_p_init(rope_p *rp, size_t space);
void rope_p_free(rope_p *rp);
rope_p rope_start(rope r);
rope_p rope_end(rope r);
boolean rope_p_is_a_rope(rope_p *rp);
boolean rope_p_is_a_char(rope_p *rp);
void rope_p_enter(rope_p *rp);
boolean rope_p_at_top(rope_p *rp);
void rope_p_leave(rope_p *rp);
void rope_p_next(rope_p *rp);
void rope_p_dup(rope_p *to, rope_p *from);
void fprint_rope(FILE *stream, rope r);
void print_rope(rope r);
void fsay_rope(FILE *stream, rope r);
void say_rope(rope r);
void sym_init(void);
cstr sym(cstr s);
cstr sym_this(cstr s);
cstr path_cat(cstr a, cstr b);
dirbase dirbasename(cstr path);
cstr dir_name(cstr path);
cstr base_name(cstr path);
cstr path_relative_to(cstr path, cstr origin);
cstr path_tidy(cstr path);
cstr path_under(cstr parent, cstr child);
cstr path_under_maybe(cstr parent, cstr child);
boolean path_hidden(cstr p);
boolean path_hidden_normal(cstr p);
boolean path_has_component(cstr path, cstr component);
cstr path_to_abs(cstr path, cstr cwd);
cstr which(cstr file);
cstr Which(cstr file);
void PATH_prepend(cstr dir);
void PATH_append(cstr dir);
void PATH_rm(cstr dir);
boolean path_is_abs(cstr path);
void Rsleep(num time);
num rsleep(num time);
num rtime(void);
void Gettimeofday(struct timeval *tv);
void Gmtime(double t, datetime *result);
void Localtime(double t, datetime *result);
int Mktime(datetime *t);
void Timef(buffer *b, const datetime *tm, const char *format);
cstr Timef_cstr(datetime *dt, const char *format);
void datetime_init(datetime *dt, int year, int month, int day,  int hour, int min, int sec);
void csleep(long double step, boolean sync, boolean use_asleep, boolean rush);
long double asleep(long double dt, long double t);
void rtime_to_timeval(num rtime, struct timeval *tv);
void rtime_to_timespec(num rtime, struct timespec *ts);
num timeval_to_rtime(const struct timeval *tv);
num timespec_to_rtime(const struct timespec *ts);
int rtime_to_ms(num rtime);
num ms_to_rtime(int ms);
int delay_to_ms(num delay);
struct timespec *delay_to_timespec(num delay, struct timespec *p);
struct timeval *delay_to_timeval(num delay, struct timeval *p);
void date_rfc1123_init(void);
char *date_rfc1123(time_t t);
void lsleep_init(void);
void lsleep(num dt);
void Getitimer(int which, struct itimerval *value);
void Setitimer(int which, const struct itimerval *value, struct itimerval *ovalue);
void Ualarm(num dt);
int sgn(num x);
num nmin(num x, num y);
num nmax(num x, num y);
int imin(int x, int y);
long lmin(long x, long y);
int imax(int x, int y);
long lmax(long x, long y);
num notpot(num hypotenuse, num x);
long Randi(long min, long max);
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
long lclamp(long x, long min, long max);
num spow(num b, num e);
num rand_normal(void);
num blend(num i, num x0, num x1);
char *Getenv(const char *name, char *_default);
boolean is_env(const char *name);
void Putenv(char *string);
void Setenv(const char *name, const char *value, int overwrite);
void dump_env(void);
void load_config(cstr file);
void Clearenv(void);
void Unsetenv(const char *name);
int clear_env(void);
cstr homedir(void);
void find_vec(cstr root, vec *v);
void find_vec_all(cstr root, vec *v);
void find_vec_files(cstr root, vec *v);
cmplx cis(num ang);
void fft(cmplx *in, cmplx *out, int log2_n);
void proc_init(proc *p, proc_func f);
int resume(proc *p);
void proc_dump(proc *p);
void timeout_init(timeout *timeout, num time, thunk_func *func, void *obj, void *common_arg);
void timeout_init_thunk(timeout *timeout, num time, thunk *handler);
void timeouts_add(timeouts *q, timeout *o);
void timeouts_rm(timeouts *q, timeout *o);
timeout *timeouts_next(timeouts *q);
void timeouts_shift(timeouts *q);
void timeouts_call(timeouts *timeouts, num time);
num timeouts_delay(timeouts *timeouts, num time);
void timeouts_delay_tv(timeouts *timeouts, num time, timeval **tv);
void timeouts_delay_ts(timeouts *timeouts, num time, timespec **ts);
int timeouts_delay_ms(timeouts *timeouts, num time);
int Socket(int domain, int type, int protocol);
void Bind(int sockfd, struct sockaddr *my_addr, socklen_t addrlen);
void Listen(int sockfd, int backlog);
int Accept(int earfd, struct sockaddr *addr, socklen_t *addrlen);
void Connect(int sockfd, const struct sockaddr *serv_addr, socklen_t addrlen);
void Sockaddr_in(struct sockaddr_in *sa, char *addr, int port);
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
void keepalive(int fd, int keepalive);
void nodelay(int fd, int nodelay);
void reuseaddr(int fd, int reuseaddr);
void Getsockopt(int s, int level, int optname, void *optval, socklen_t *optlen);
int Getsockerr(int fd);
ssize_t Sendfile(int out_fd, int in_fd, off_t *offset, size_t count);
int Server_unix_stream(char *addr);
int Client_unix_stream(char *addr);
void Sockaddr_unix(struct sockaddr_un *sa, char *addr);
void cork(int fd, int cork);
void vstream_init_stdio(vstream *vs, FILE *s);
void vs_putc_stdio(int c, vstream *vs);
int vs_getc_stdio(vstream *vs);
int vs_printf_stdio(vstream *vs, const char *format, va_list ap);
char *vs_gets_stdio(char *s, int size, vstream *vs);
void vs_write_stdio(const void *ptr, size_t size, size_t nmemb, vstream *vs);
size_t vs_read_stdio(void *ptr, size_t size, size_t nmemb, vstream *vs);
void vs_flush_stdio(vstream *vs);
void vs_close_stdio(vstream *vs);
void vs_shutdown_stdio(vstream *vs, int how);
void vstreams_init(void);
void vstream_init_buffer(vstream *vs, buffer *b);
void vs_putc_buffer(int c, vstream *vs);
int vs_getc_buffer(vstream *vs);
int vs_printf_buffer(vstream *vs, const char *format, va_list ap);
char *vs_gets_buffer(char *s, int size, vstream *vs);
void vs_write_buffer(const void *ptr, size_t size, size_t nmemb, vstream *vs);
size_t vs_read_buffer(void *ptr, size_t size, size_t nmemb, vstream *vs);
void vs_flush_buffer(vstream *vs);
void vs_close_buffer(vstream *vs);
void vs_shutdown_buffer(vstream *vs, int how);
void vs_putc(int c);
int vs_getc(void);
int vs_printf(const char *format, va_list ap);
char *vs_gets(char *s, int size);
void vs_write(const void *ptr, size_t size, size_t nmemb);
size_t vs_read(void *ptr, size_t size, size_t nmemb);
void vs_flush(void);
void vs_close(void);
void vs_shutdown(int how);
int pf(const char *format, ...);
int vs_sayf(const char *format, va_list ap);
int sf(const char *format, ...);
int print(const char *s);
int say(const char *s);
int rl(buffer *b);
cstr rl_0(void);
vec *read_ints(cstr file);
vec *read_nums(cstr file);
vec *read_cstrs(cstr file);
void vstream_init_circbuf(vstream *vs, circbuf *b);
void vs_putc_circbuf(int c, vstream *vs);
int vs_getc_circbuf(vstream *vs);
int vs_printf_circbuf(vstream *vs, const char *format, va_list ap);
char *vs_gets_circbuf(char *s, int size, vstream *vs);
void vs_write_circbuf(const void *ptr, size_t size, size_t nmemb, vstream *vs);
size_t vs_read_circbuf(void *ptr, size_t size, size_t nmemb, vstream *vs);
void vs_flush_circbuf(vstream *vs);
void vs_close_circbuf(vstream *vs);
void vs_shutdown_circbuf(vstream *vs, int how);
void discard(size_t n);
void vcp(void);
int Open(const char *pathname, int flags, mode_t mode);
void Close(int fd);
ssize_t Read_some(int fd, void *buf, size_t count);
ssize_t Read(int fd, void *buf, size_t count);
ssize_t Write_some(int fd, const void *buf, size_t count);
void Write(int fd, const void *buf, size_t count);
void slurp_2(int fd, buffer *b);
buffer *slurp_1(int filedes);
void spurt(int fd, buffer *b);
void fslurp_2(FILE *s, buffer *b);
buffer *fslurp_1(FILE *s);
void fspurt(FILE *s, buffer *b);
FILE *Fopen(const char *path, const char *mode);
void Fclose(FILE *fp);
char *Fgets(char *s, int size, FILE *stream);
int Freadline(buffer *b, FILE *stream);
int Readline(buffer *b);
cstr Freadline_1(FILE *stream);
int Printf(const char *format, ...);
int Vprintf(const char *format, va_list ap);
int Fprintf(FILE *stream, const char *format, ...);
int Vfprintf(FILE *stream, const char *format, va_list ap);
void Fflush(FILE *stream);
FILE *Fdopen(int filedes, const char *mode);
void Nl(FILE *stream);
void crlf(FILE *stream);
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
vec *Ls(const char *name, int all);
vec *ls(const char *name, boolean all);
vec *ls_(const char *name, boolean all, vec *v);
vec *slurp_lines_0(void);
vec *slurp_lines(vec *lines);
void Remove(const char *path);
int Temp(buffer *b, char *prefix, char *suffix);
int Tempdir(buffer *b, char *prefix, char *suffix);
int Tempfile(buffer *b, char *prefix, char *suffix, char *tmpdir, int dir, int mode);
char random_alphanum(void);
int exists(const char *file_name);
int lexists(const char *file_name);
off_t file_size(const char *file_name);
off_t fd_size(int fd);
int Stat(const char *file_name, struct stat *buf);
int is_file(const char *file_name);
int is_dir(const char *file_name);
int is_symlink(const char *file_name);
int is_real_dir(const char *file_name);
void Fstat(int filedes, struct stat *buf);
void cx(const char *path);
void cnotx(const char *path);
void chmod_add(const char *path, mode_t add_mode);
void chmod_sub(const char *path, mode_t sub_mode);
void Stats_init(stats *s, const char *file_name);
void Lstats_init(stats *s, const char *file_name);
void stats_init(stats *s, const char *file_name);
void lstats_init(stats *s, const char *file_name);
int Lstat(const char *file_name, struct stat *buf);
FILE *Popen(const char *command, const char *type);
int Pclose(FILE *stream);
int Fgetc(FILE *stream);
void Fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
size_t Fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
size_t Fread_all(void *ptr, size_t size, size_t nmemb, FILE *stream);
void Fwrite_str(FILE *stream, str s);
void Fwrite_buffer(FILE *stream, buffer *b);
size_t Fread_buffer(FILE *stream, buffer *b);
void Fputc(int c, FILE *stream);
void Fseek(FILE *stream, long offset, int whence);
long Ftell(FILE *stream);
off_t Lseek(int fd, off_t offset, int whence);
void Truncate(const char *path, off_t length);
void Ftruncate(int fd, off_t length);
int io__readlink2(const char *path, buffer *b);
void _Readlink(const char *path, buffer *b);
cstr Readlink(const char *path);
cstr io__readlink1(const char *path);
cstr readlinks(cstr path, opt_err if_dead);
void _Getcwd(buffer *b);
cstr Getcwd(void);
void Chdir(const char *path);
void Mkdir(const char *pathname, mode_t mode);
void Mkdir_if(const char *pathname, mode_t mode);
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
void stats_dump(Stats *s);
mode_t mode(const char *file_name);
void cp(const char *from, const char *to, int mode);
off_t cp_fd_chunked(int in, int out);
off_t cp_fd_unbuf(int in, int out);
void fcp(FILE *in, FILE *out);
int Select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, num timeout);
void fd_set_init(fd_set *o);
int can_read(int fd, num timeout);
int can_write(int fd, num timeout);
int has_error(int fd, num timeout);
void Mkdirs(const char *pathname, mode_t mode);
void Mkdirs_cwd(const char *pathname, mode_t mode, cstr basedir);
void Rmdir(const char *pathname);
void Rmdirs(const char *pathname);
boolean newer(const char *file1, const char *file2);
void lnsa(cstr from, cstr to, cstr cwd);
void Cp(cstr from, cstr to, Lstats *sf);
void CP(cstr from, cstr to, Lstats *sf);
void cp_attrs(cstr from, cstr to);
void cp_mode(Stats *sf, cstr to);
void Utime(const char *filename, const struct utimbuf *times);
void cp_times(Lstats *sf, cstr to);
void cp_atime(Lstats *sf, cstr to, Lstats *st);
void cp_mtime(Lstats *sf, cstr to, Lstats *st);
void Setvbuf(FILE *stream, char *buf, int mode, size_t size);
ssize_t Readv(int fd, const struct iovec *iov, int iovcnt);
ssize_t Writev(int fd, const struct iovec *iov, int iovcnt);
int file_cmp(cstr fa, cstr fb);
void create_hole(cstr file, off_t size);
void insert_hole(cstr file, off_t offset, off_t size);
int Fileno(FILE *stream);
void fprint_vec_cstr(FILE *s, cstr h, vec *v);
cstr read_lines(vec *lines, cstr in_file);
void write_lines(vec *lines, cstr out_file);
void dump_lines(vec *lines);
void warn_lines(vec *lines, cstr msg);
void Fspurt(cstr file, cstr content);
cstr Fslurp(cstr file);
cstr dotfile(cstr f);
cstr scan_cstr(cstr *a, cstr l);
cstr scan_int(int *a, cstr l);
cstr scan_short(short *a, cstr l);
cstr scan_char(char *a, cstr l);
cstr scan_long(long *a, cstr l);
cstr scan_long_long(long long *a, cstr l);
cstr scan_num(num *a, cstr l);
cstr scan_double(double *a, cstr l);
cstr scan_float(float *a, cstr l);
cstr scan_long_double(long double *a, cstr l);
cstr scan_skip(cstr l);
cstr is_scan_space(cstr s);
void do_delay(num t);
void kv_io_init(void);
int Fgetline(buffer *b, FILE *stream);
int Getline(buffer *b);
filetype_t file_type(const char *file_name);
mode_t stat_ft(const char *file_name);
mode_t lstat_ft(const char *file_name);
int Pselect(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, num timeout, const sigset_t *sigmask);
int Poll(struct pollfd *fds, nfds_t nfds, num timeout);
int fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len);
int Fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len);
int Fcntl_getfd(int fd);
void Fcntl_setfd(int fd, long arg);
int Fcntl_getfl(int fd);
void Fcntl_setfl(int fd, long arg);
void cloexec(int fd);
void cloexec_off(int fd);
void Chown(const char *path, uid_t uid, gid_t gid);
void Lchown(const char *path, uid_t uid, gid_t gid);
void cp_attrs_st(Lstats *sf, cstr to);
void cp_owner(Lstats *sf, cstr to);
void Socketpair(int d, int type, int protocol, int sv[2]);
void nonblock_fcntl(int fd, int nb);
void nonblock_ioctl(int fd, int nb);
int Epoll_create(int size);
void Epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
int Epoll_wait(int epfd, struct epoll_event *events, int maxevents, num timeout);
int Epoll_pwait(int epfd, struct epoll_event *events, int maxevents, num timeout, const sigset_t *sigmask);
void *normal_Malloc(size_t size);
void *normal_Realloc(void *ptr, size_t size);
void *normal_Calloc(size_t nmemb, size_t size);
cstr normal_Strdup(const char *s);
char *normal_Strndup(const char *s, size_t n);
void *rc_malloc(size_t size);
count_t rc_use(void *obj);
count_t rc_done(void *obj);
void rc_free(void *obj);
void *rc_calloc(size_t nmemb, size_t size);
void memlog_stderr(void);
void memlog_file(cstr file);
void *memlog_Malloc(size_t size, char *file, int line);
void memlog_Free(void *ptr, char *file, int line);
void *memlog_Realloc(void *ptr, size_t size, char *file, int line);
void *memlog_Calloc(size_t nmemb, size_t size, char *file, int line);
cstr memlog_Strdup(const char *s, char *file, int line);
cstr memlog_Strndup(const char *s, size_t n, char *file, int line);
void *tofree(void *obj);
void free_all(vec *v);
void *Mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);
int Munmap(void *addr, size_t length);
void hexdump(FILE *stream, char *b0, char *b1);
boolean printable(uchar c);
void *Id_func(void *x);
void *mem_mem(const void* haystack, size_t haystacklen, const void* needle, size_t needlelen);
int num_cmp(const void *a, const void *b);
int int_cmp(const void *a, const void *b);
int long_cmp(const void *a, const void *b);
int off_t_cmp(const void *a, const void *b);
size_t arylen(void *_p);
vec *sort_vec(vec *v, cmp_t cmp);
int cstr_cmp(const void *_a, const void *_b);
int cstrp_cmp_null(const void *_a, const void *_b);
void comm(vec *merge_v, vec *comm_v, vec *va, vec *vb, cmp_t cmp, free_t *freer);
void comm_dump_cstr(vec *merge_v, vec *comm_v);
void *memdup(const void *src, size_t n, size_t extra);
void cstr_set_add(vec *set, cstr s);
unsigned int bit_reverse(unsigned int x);
boolean version_ge(cstr v0, cstr v1);
cstr hashbang(cstr file);
void *dflt(void *p, void *dflt);
void remove_null(vec *v);
void *orp(void *a, void *b);
int ori(int a, int b);
cstr nul_to(char *a, char *b, char replacement);
void uniq_vos(vec *v);
void uniq_vovos(vec *v);
boolean isword(char c);
cstr lookup_cstr(cstr2cstr *ix, cstr key, cstr default_val);
cstr Lookup_cstr(cstr2cstr *ix, cstr key);
void io_epoll_init(io_epoll *io);
int io_epoll_wait(io_epoll *io, num delay, sigset_t *sigmask);
int io_epoll_add(io_epoll *io, int fd, boolean et);
void io_epoll_rm(io_epoll *io, int fd);
void scheduler_init(scheduler *sched);
void scheduler_free(scheduler *sched);
void start_f(proc *p);
void run(void);
void step(void);
int scheduler_add_fd(scheduler *sched, int fd, int et);
void fd_has_error(int fd);
void set_reader(int fd, proc *p);
void set_writer(int fd, proc *p);
void clr_reader(int fd);
void clr_writer(int fd);
int sched_child_exited(pid_t pid);
void set_waitchild(pid_t pid, proc *p);
void have_child(pid_t pid, proc *p);
void drop_child(pid_t pid, proc *p);
void clr_waitchild(pid_t pid);
void sched_sigchld_handler(int signum);
num sched_get_time(void);
void sched_forget_time(void);
void sched_set_time(void);
boolean sched_sig_child_exited(sigset_t *oldsigmask);
boolean sched_sig_child_exited_2(sigset_t *oldsigmask);
void shuttle_init(shuttle *sh, proc *p1, proc *p2);
boolean pull_f(shuttle *s, proc *p);
void push_f(shuttle *s, proc *p);
void sock_init(sock *s, socklen_t socklen);
void sock_free(sock *s);
in_addr sock_in_addr(sock *s);
uint16_t sock_in_port(sock *s);
void listener_tcp_init(listener_try *p, cstr listen_addr, int listen_port);
proc listener_sel(int listen_fd, socklen_t socklen);
proc listener_try(int listen_fd, socklen_t socklen);
proc write_sock(void);
proc reader_sel(int fd, size_t block_size);
proc writer_sel(int fd);
proc reader_try(int fd, size_t block_size, boolean sel_first);
proc writer_try(int fd, boolean sel_first);
proc cat(off_t len);
void debug_io_count(void);
void listener_unix_init(listener_try *p, cstr addr);
void coro_init(void);
int yield_val_2(coro *c, int val);
int yield_val(coro **c, int val);
int ccoro_yield(coro **c);
noret new_coro_3(coro_func f, coro *caller);
coro *new_coro(coro_func f);
void main__init(int _argc, char *_argv[]);
void opts_init(opts *O, size_t opts_hash_size);
opts *get_options(cstr options[][3]);
void dump_options(opts *O);
void help_(cstr version, cstr description, cstr *usage, cstr options[][3]);
cstr darcs_root(void);
cstr _darcs_path(cstr path, cstr root, cstr cwd);
cstr darcs_exists(cstr darcs_path);
void html_split(boolean split_entities);
void html_join(void);
void tagn(cstr name, ...);
void vtag(cstr name, va_list ap);
void _html_encode(buffer *b, cstr v);
cstr html_encode(cstr v);
void _html_decode(buffer *b, cstr v);
cstr html_decode(cstr v);
cstr html2text(cstr html);
void url_decode(cstr q);
cstr url_encode(cstr q);
cstr get_host_from_url(cstr url);
cstr get_path_from_url(cstr url);
void http_fake_browser(boolean f);
cstr http(cstr method, cstr url, buffer *req_headers, buffer *req_data, buffer *rsp_headers, buffer *rsp_data);
cstr http_get_1(cstr url);
cstr http_get(cstr url, buffer *rsp_data);
cstr http_head_1(cstr url);
cstr http_head(cstr url, buffer *rsp_headers);
cstr http_post_1(cstr url, cstr req_data);
cstr http_post(cstr url, cstr _req_data, buffer *rsp_data);
void base64_decode_buffers(buffer *i, buffer *o);
void base64_decode(void);
http__method http_which_method(cstr method);
void hunk(cstr in_file, cstr out_dir, int avg_hunk_size, int max_hunk_size, int sum_window_size);
void cgi_html(void);
void cgi_content_type(cstr type);
void cgi_text(void);
void cgi_init(void);
void cgi_query_load(cstr data);
cstr cgi(cstr key, cstr _default);
cstr cgi_required(cstr key);
void cgi_errors_to_browser(void);
void *cgi_error_to_browser(void *obj, void *common_arg, void *specific_arg);
void qmath_init(void);
void mimetypes_init(void);
void load_mimetypes_vio(void);
cstr mimetype(cstr ext);
cstr Mimetype(cstr ext);
void meta_init(void);
void type_add(type *t);
type *type_get(cstr name);
void read_structs(vec *v, type__struct_union *t);
void write_structs(vec *v, type__struct_union *t);
int read_struct(void *s, type__struct_union *t, opt_err unknown_key);
boolean write_struct(void *s, type__struct_union *t, opt_err unknown_type);
range check_range(sample *s0, sample *s1);
boolean range_ok(sample *s0, sample *s1);
void sound_print(sample *s0, sample *s1);
void normalize(sample *s0, sample *s1, boolean softer);
void amplify(sample *s0, sample *s1, num factor);
void clip(sample *s0, sample *s1);
void add_noise(sample *s0, sample *s1, num vol);
void sound_init(sound *s, ssize_t size);
void sound_clear(sound *s);
void mix_range(sample *up, sample *a0, sample *a1);
void sound_same_size(sound *s1, sound *s2);
void sound_grow(sound *s, ssize_t size);
void mix(sound *up, sound *add);
void mix_to_new(sample *out, sample *a0, sample *a1, sample *b0, sample *b1);
void sound_set_rate(int r);
void audio_init(audio *a);
void audio_init_2(audio *a, int channels, int n_samples);
void load_wav(audio *a);
void dsp_play_sound(sample *i, sample *e);
void dsp_init(void);
void dsp_play(char *b0, char *b1);
void dsp_sync(void);
void dsp_buffer_init(dsp_buffer *b, size_t size);
void dsp_buffer_print(dsp_buffer *b);
size_t dsp_sample_size(void);
void dsp_encode(sample *in0, sample *in1, short *out);
void dur(num d);
void vol(num v);
void freq(num f);
void relfreq(num rf);
void pitch(num p);
void note(void);
void envelope(num attack, num release);
void vibrato(num power, num freq);
void tremolo(num dpitch, num freq);
void tremolof(num power, num freq);
void wavegen(float *from, float *to);
num puretone(num t);
num sawtooth(num t);
void chordf(int n, num f[]);
void rfChord(int n, num relfreq[]);
void chord(int n, num pitch[]);
void chord2f(num a0, num a1);
void rfChord2(num a0, num a1);
void chord2(num a0, num a1);
void chord3f(num a0, num a1, num a2);
void rfChord3(num a0, num a1, num a2);
void chord3(num a0, num a1, num a2);
void chord4f(num a0, num a1, num a2, num a3);
void rfChord4(num a0, num a1, num a2, num a3);
void chord4(num a0, num a1, num a2, num a3);
void note_1_in_bits(num freq);
void key_note_freq(num freq);
void key_note(num pitch);
num pitch2freq(num pitch);
num freq2pitch(num freq);
num pitch2relfreq(num pitch);
num relfreq2pitch(num freq);
num relfreq2freq(num relfreq);
num freq2relfreq(num relfreq);
void harmony(int p);
num harmony2relfreq(int p);
num harmony2freq(int p);
void colours_init(void);
void sprite_init(sprite *s, long width, long height);
void sprite_clear(sprite *s, pix_t c);
void sprite_clip(sprite *target, sprite *source, sprite *target_full, sprite *source_full, long x, long y);
void sprite_blit(sprite *to, sprite *from);
void sprite_blit_transl(sprite *to, sprite *from);
void sprite_blit_transp(sprite *to, sprite *from);
void sprite_gradient(sprite *s, colour c00, colour c10, colour c01, colour c11);
void sprite_gradient_angle(sprite *s, colour _c00, colour _c10, colour _c01, colour _c11, num angle);
num grad_value(num x, num y, num v00, num v10, num v01, num v11);
void sprite_translucent(sprite *s, num a);
void sprite_circle(sprite *s);
void sprite_circle_aa(sprite *s);
sprite *sprite_load_png(sprite *s, cstr filename);
sprite *sprite_load_png_stream(sprite *s, FILE *in);
pix_t sprite_at(sprite *s, long x, long y);
pix_t colour_to_pix(colour c);
void sprite_loop_init(sprite_loop *l, sprite *spr);
void gr_deco(int _d);
void gr_fullscreen(void);
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
void Clear(colour c);
void pix_clear(colour c);
void gr__change_hook(void);
void paint(void);
void Paint(void);
void gr_fast(void);
void autopaint(boolean ap);
void gr_delay(num delay);
void rainbow_init(void);
colour _rainbow(num a);
void random_colour(void);
colour _hsv(num hue, num sat, num val);
void curve(num x, num y);
colour colour_rand(void);
void gr_at_exit(void);
void gr_cleanup_sig_handler(int sig);
void gr_cleanup_catch_signals(void);
void font(cstr name, int size);
void gr_init(void);
void _paper(int width, int height, colour _bg_col, colour _fg_col);
int gr__mitshm_fault_h(Display *d, XErrorEvent *e);
void gr_free(void);
void free_shmseg(void);
void xfont(const char *font_name);
colour rgb(num red, num green, num blue);
void line_width(num width);
void rect(num x, num y, num w, num h);
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
num text_width(char *p);
void gprint(char *p);
num font_height(void);
void paint_sync(int syncage);
void gr_sync(void);
void gr_flush(void);
void clear(void);
void triangle(num x2, num y2);
void quadrilateral(num x2, num y2, num x3, num y3);
void dump_img(cstr type, cstr file, num scale);
void gr_do_delay(num dt);
void *gr_do_delay_handler(void *obj, void *a0, void *event);
void vid_init(void);
void sprite_screen(sprite *s);
void control_init(void);
void control_default(void);
void control_ignore(void);
void event_handler_init(void);
void event_loop(void);
int handle_events(boolean wait_for_event);
boolean handle_event_maybe(boolean wait_for_event);
int gr_call_need_delay_callbacks(void);
int gr_getc(void);
void *gr_getc_handler(void *obj, void *a0, void *event);
void key_handlers_init(void);
void key_handlers_default(void);
void key_handlers_ignore(void);
void *quit(void *obj, void *a0, void *event);
int keystr_ix(cstr keystr);
int keysym_ix(KeySym keysym);
int key_event_type_ix(int event_type);
void *key_handler_main(void *obj, void *a0, void *event);
cstr event_key_string(gr_event *e);
void key_event_debug(cstr format, gr_event *e);
cstr key_string(int keycode, boolean shift);
void mouse_handlers_init(void);
void mouse_handlers_default(void);
void mouse_handlers_ignore(void);
int mouse_event_type_ix(int event_type);
void *mouse_handler_main(void *obj, void *a0, void *event);
cstr event_type_name(int type);
int events_queued(boolean wait_for_event);
void handle_event(void);
boolean gr_key_avoid_auto_repeat_press(gr_event *e);
boolean gr_key_avoid_auto_repeat_release(gr_event *e, boolean is_callback);
void configure_notify(void);
void north(num d);
void east(num d);
void south(num d);
void west(num d);
void turtle_go(num dx, num dy);
void forward(num d);
void back(num d);
turtle_pos get_pos(void);
void set_pos(turtle_pos p);
void raw(void);
void cooked(void);
void noecho(void);
void echo(void);
void key_init(void);
void key_final(void);
int key(void);
void cont_handler(int signum);
void int_handler(int signum);
cstr Input_passwd(cstr prompt);
void cgi_png(int w, int h, num scale);
void cgi_png_done(void);

extern char **environ;
extern str str_null;
extern thunk _thunk_null;
extern thunk *thunk_null;
extern key_value kv_null;
extern boolean debugging;
extern boolean abort_on_error;
extern boolean die;
extern int exit__error;
extern int exit__fault;
extern int throw_faults;
extern thunk _thunk_error_warn;
extern thunk *thunk_error_warn;
extern thunk _thunk_error_ignore;
extern thunk *thunk_error_ignore;
extern boolean is_verbose;
extern int exit__execfailed;
extern int status__execfailed;
extern boolean process__forked;
extern boolean process__fork_fflush;
extern boolean process__exit_fflush;
extern boolean exec__warn_fail;
static int exec_argv_init;
extern boolean system_verbose;
extern vec *uq_vec;
extern vec *q_vec;
extern int sig_execfailed;
extern uid_t uid_root;
extern int myuid;
extern int mygid;
extern int passwd_n_buckets;
extern int rope_p_char;
extern int rope_p_rope;
extern int rope_p_start;
extern int rope_p_end;
extern int rope_p_on;
extern size_t syms_n_buckets;
extern hashtable *syms;
extern int nonmingw_path;
extern cstr dt_format;
extern cstr dt_format_tz;
extern boolean sleep_debug;
extern long double csleep_last;
extern num bm_start;
extern num bm_end;
extern boolean bm_enabled;
extern boolean lsleep_inited;
extern long double asleep_small;
extern const num pi;
extern const num e;
extern char *env__required;
extern int listen_backlog;
extern char hostname__[256];
extern size_t block_size;
extern fd_set *tmp_fd_set;
extern buffer *Cp_symlink;
extern cstr print_space;
extern cstr scan_space;
extern int memlog_on;
static FILE *memlog;
extern vec *tofree_vec;
extern int io_epoll_size;
extern int io_epoll_maxevents;
extern epoll_event io_epoll_rm__event;
extern num sched_delay;
extern int sched_busy;
extern int sched__children_n_buckets;
extern scheduler *sched;
extern int max_line_length;
extern int coro_init_done;
extern coro *coro_top;
extern coro *current_coro;
extern boolean args_literal;
extern boolean args_list;
extern int unix_main;
extern const boolean mingw;
extern cstr tag__no_value;
extern cstr html_entity[];
extern char html_entity_char[];
extern boolean _http_fake_browser;
extern boolean http_debug;
extern const char *base64_encode_map;
extern char *base64_decode_map;
extern int cgi__sent_headers;
extern unsigned int rand_v;
extern cstr mimetypes_file;
extern size_t mimetypes_n_buckets;
extern hashtable *mimetypes;
extern type__size type__sizes[];
extern type__int t_ints[];
extern type__float t_floats[];
extern type__void t_voids[];
extern type__point t_points[];
extern type__def t_defs[];
extern hashtable *type_ix;
extern int sound_rate;
extern num sound_dt;
extern int dsp_rate;
extern int bits_per_sample;
extern int dsp_channels;
extern num dsp_buf_initial_duration;
extern int bytes_per_sample;
extern char *dsp_outfile;
extern int use_dsp;
extern dsp_buffer *dsp_buf;
extern wave_f music_wave;
extern num ref_freq;
extern num key_freq;
extern num _vol;
extern num _dur;
extern num _freq;
extern num _rf;
extern num _p;
extern num _attack;
extern num _release;
extern num vibrato_power;
extern num vibrato_freq;
extern num tremolo_power;
extern num tremolo_freq;
extern num _harmony[12];
extern pix_t pix_transp;
extern Display *display;
extern int _xflip;
extern int _yflip;
extern sprite *screen;
extern boolean fullscreen;
extern boolean _deco;
extern num lx;
extern num ly;
extern num lx2;
extern num ly2;
extern boolean _autopaint;
extern num _delay;
extern boolean paint_handle_events;
extern int text_at_col0;
extern char *vid;
extern num a_pixel;
extern boolean gr_done;
extern boolean gr_exiting;
extern int gr_done_signal;
extern int use_vid;
extern num _line_width;
extern num _xanc;
extern num _yanc;
extern num gprint_tab_width;
extern boolean curve_at_start;
extern Window window;
extern XVisualInfo *visual_info;
extern XFontStruct *_font;
extern XShmSegmentInfo *shmseginfo;
extern Pixmap gr_buf;
extern XImage *gr_buf_image;
extern boolean fullscreen_grab_keyboard;
extern boolean gr_alloced;
extern boolean gr_key_ignore_release;
extern boolean gr_key_auto_repeat;
extern controller *control;
extern num gr_need_delay_callbacks_sleep;
extern vec *gr_need_delay_callbacks;
extern cstr quit_key[];
extern int gr_key_last_release_key;
extern int gr_key_last_release_time;
extern num gr_key_last_release_time_real;
extern long2cstr event_type_names[];
extern num turtle_a;
extern num turtle_pendown;
extern int key_raw;
extern int key_noecho;
extern cstr cgi_png_display;

vec *error_handlers;
vec *errors;
hashtable *extra_error_messages;
static vec exec_argv;
int wait__status;
vec struct__uq_vec;
vec struct__q_vec;
int linux_process;
hashtable syms__struct;
int linux_net;
vstream struct__in;
vstream *in;
vstream struct__out;
vstream *out;
vstream struct__er;
vstream *er;
list *cache__ref;
pid_t waitchild__pid;
int waitchild__status;
coro main_coro;
coro_func new_coro_f;
jmp_buf alloc_ret;
coro yielder;
int argc;
int args;
char **argv;
char *program_full;
char *program_real;
char *program;
char *program_dir;
char **arg;
char *main_dir;
hashtable _cgi_query_hash;
hashtable *cgi_query_hash;
num *_qsin;
num *_qcos;
num *_qatan;
int dsp_fd;
dsp_buffer struct__dsp_buf;
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
int root_w;
int root_h;
int w;
int h;
int w_2;
int h_2;
num ox;
num oy;
num sc;
int depth;
num pixel_size;
int pixel_size_i;
num text_origin_x;
num text_origin_y;
num text_wrap_sx;
colour bg_col;
colour fg_col;
sighandler_t gr_cleanup_prev_handler[64+1];
colour bg_col_init;
num rb_red_angle;
num rb_green_angle;
num rb_blue_angle;
num rb_red_power;
num rb_green_power;
num rb_blue_power;
colour rb[360];
Window root_window;
Visual *visual;
Colormap colormap;
GC gc;
XGCValues gcvalues;
XColor color;
int screen_number;
Atom wm_protocols;
Atom wm_delete;
int x11_fd;
int shm_major;
int shm_minor;
int shm_version;
Bool shm_pixmaps;
boolean gr_do_delay_done;
controller control_null;
controller control_normal;
int gr_getc_char;
int key_first;
int key_last;
char *key_down;
thunk key_handler_default;
thunk mouse_handlers[(3-1+1)][3];
thunk mouse_handler_default;
XEvent x_event;
termios term;
termios term_orig;
cstr cgi_png_display1;
num cgi_png_scale;
buffer _Cp_symlink;
scheduler struct__sched;
hashtable struct__mimetypes;
hashtable struct__type_ix;
sprite struct__screen;
vec struct__gr_need_delay_callbacks;

str str_null = { NULL, NULL };
thunk _thunk_null = { NULL, NULL, NULL };
thunk *thunk_null = &_thunk_null;
key_value kv_null = { ((void*)(intptr_t)(-1)), ((void*)(intptr_t)(-1)) };
boolean debugging = 0;
boolean abort_on_error = 0;
boolean die = 0;
int exit__error = 125;
int exit__fault = 124;
int throw_faults = 0;
thunk _thunk_error_warn = { error_warn, NULL, NULL };
thunk *thunk_error_warn = &_thunk_error_warn;
thunk _thunk_error_ignore = { error_ignore, NULL, NULL };
thunk *thunk_error_ignore = &_thunk_error_ignore;
boolean is_verbose = 0;
int exit__execfailed = 127;
int status__execfailed = 512 + 127;
boolean process__forked = 0;
boolean process__fork_fflush = 1;
boolean process__exit_fflush = 1;
boolean exec__warn_fail = 1;
static int exec_argv_init = 0;
boolean system_verbose = 0;
vec *uq_vec = NULL;
vec *q_vec = NULL;
int sig_execfailed = SIGUSR2;
uid_t uid_root = 0;
int myuid = -1;
int mygid = -1;
int passwd_n_buckets = 1009;
int rope_p_char = 0;
int rope_p_rope = 1;
int rope_p_start = 0;
int rope_p_end = 1;
int rope_p_on = 2;
size_t syms_n_buckets = 1021;
hashtable *syms = NULL;
int nonmingw_path = 1;
cstr dt_format = "%F %T";
cstr dt_format_tz = "%F %T %z";
boolean sleep_debug = 0;
long double csleep_last = 0;
num bm_start = 0;
num bm_end = 0;
boolean bm_enabled = 1;
boolean lsleep_inited = 0;
long double asleep_small = 0.03;
const num pi = M_PI;
const num e = M_E;
char *env__required = (char *)-1;
int listen_backlog = SOMAXCONN;
char hostname__[256] = "";
size_t block_size = 1024;
fd_set *tmp_fd_set = NULL;
buffer *Cp_symlink = NULL;
cstr print_space = " ";
cstr scan_space = NULL;
int memlog_on = 0;
static FILE *memlog = NULL;
vec *tofree_vec = NULL;
int io_epoll_size = 1024;
int io_epoll_maxevents = 1024;
epoll_event io_epoll_rm__event = { 0, { .u64 = 0 } };
num sched_delay = 0;
int sched_busy = 16;
int sched__children_n_buckets = 1009;
scheduler *sched = &struct__sched;
int max_line_length = 0;
int coro_init_done = 0;
coro *coro_top = &main_coro;
coro *current_coro = &main_coro;
boolean args_literal = 0;
boolean args_list = 0;
int unix_main = 1;
const boolean mingw = 0;
cstr tag__no_value = (cstr)-1;
cstr html_entity[] = { "&nbsp;", "&amp;", "&quot;", "&lt;", "&gt;", NULL };
char html_entity_char[] = { ' ', '&', '"', '<', '>', '\0' };
boolean _http_fake_browser = 0;
boolean http_debug = 0;
const char *base64_encode_map = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
char *base64_decode_map = NULL;
int cgi__sent_headers = 0;
unsigned int rand_v = 1;
cstr mimetypes_file = "/etc/mime.types";
size_t mimetypes_n_buckets = 1009;
hashtable *mimetypes = NULL;
type__size type__sizes[] =
{
	{ sizeof(type__void), 0 },
	{ sizeof(type__int), 0 },
	{ sizeof(type__float), 0 },
	{ sizeof(type__point), 0 },
	{ sizeof(type__array), sizeof(int) },
	{ sizeof(type__struct_union), sizeof(type__element) },
	{ sizeof(type__struct_union), sizeof(type__element) },
	{ sizeof(type__func), sizeof(type *) },
	{ sizeof(type__def), 0 }
};
type__int t_ints[] =
{
	{ { TYPE_INT, "int", sizeof(int) }, SIGNED_NORMAL },
	{ { TYPE_INT, "char", sizeof(char) }, SIGNED_NORMAL },
	{ { TYPE_INT, "short", sizeof(short) }, SIGNED_NORMAL },
	{ { TYPE_INT, "long", sizeof(long) }, SIGNED_NORMAL },
	{ { TYPE_INT, "long long", sizeof(long long) }, SIGNED_NORMAL },
	{ { TYPE_INT, "signed int", sizeof(signed int) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed char", sizeof(signed char) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed short", sizeof(signed short) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed long", sizeof(signed long) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed long long", sizeof(signed long long) }, SIGNED_SIGNED },
	{ { TYPE_INT, "unsigned int", sizeof(unsigned int) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned char", sizeof(unsigned char) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned short", sizeof(unsigned short) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned long", sizeof(unsigned long) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned long long", sizeof(unsigned long long) }, SIGNED_UNSIGNED }
};
type__float t_floats[] =
{
	{ { TYPE_FLOAT, "float", sizeof(float) } },
	{ { TYPE_FLOAT, "double", sizeof(double) } },
	{ { TYPE_FLOAT, "long double", sizeof(long double) } }
};
type__void t_voids[] =
{
	{ { TYPE_VOID, "void", 0 } }
};
type__point t_points[] =
{
	{ { TYPE_POINT, "char *", sizeof(char *) }, &(t_ints + 1)->t },
	{ { TYPE_POINT, "void *", sizeof(void *) }, &(t_voids + 0)->t }
};
type__def t_defs[] =
{
	{ { TYPE_DEF, "cstr", sizeof(cstr) }, &(t_points + 0)->t }
};
hashtable *type_ix = &struct__type_ix;
int sound_rate = 0;
num sound_dt = 0;
int dsp_rate = 44100;
int bits_per_sample = 16;
int dsp_channels = 1;
num dsp_buf_initial_duration = 1;
int bytes_per_sample = 2;
char *dsp_outfile = "/dev/dsp";
int use_dsp = 1;
dsp_buffer *dsp_buf = &struct__dsp_buf;
wave_f music_wave = puretone;
num ref_freq = 440.0;
num key_freq = 440.0;
num _vol = 0.5;
num _dur = 0.25;
num _freq = 440;
num _rf = 1;
num _p = 0;
num _attack = 0.05;
num _release = 0.1;
num vibrato_power = 1;
num vibrato_freq = 4;
num tremolo_power = 1;
num tremolo_freq = 4;
num _harmony[12] =
{
	3.0/4, 4.0/5, 5.0/6, 8.0/9, 15.0/16,
	1, 16.0/15, 9.0/8, 6.0/5, 5.0/4, 4.0/3,
	45.0/32
};
pix_t pix_transp = ((pix_t)255<<24 | ((pix_t)0<<16 | (pix_t)0<<8 | (pix_t)0));
Display *display = NULL;
int _xflip = 0;
int _yflip = 0;
sprite *screen = NULL;
boolean fullscreen = 0;
boolean _deco = 1;
num lx = 0;
num ly = 0;
num lx2 = 0;
num ly2 = 0;
boolean _autopaint = 0;
num _delay = 0;
boolean paint_handle_events = 1;
int text_at_col0 = 1;
char *vid = NULL;
num a_pixel = 1;
boolean gr_done = 1;
boolean gr_exiting = 0;
int gr_done_signal = 0;
int use_vid = 0;
num _line_width = 0;
num _xanc = -1;
num _yanc = 1;
num gprint_tab_width = 2;
boolean curve_at_start = 1;
Window window = 0;
XVisualInfo *visual_info = NULL;
XFontStruct *_font = NULL;
XShmSegmentInfo *shmseginfo = NULL;
Pixmap gr_buf = 0;
XImage *gr_buf_image = NULL;
boolean fullscreen_grab_keyboard = 1;
boolean gr_alloced = 0;
boolean gr_key_ignore_release = 0;
boolean gr_key_auto_repeat = 0;
controller *control = &control_normal;
num gr_need_delay_callbacks_sleep = 0.001;
vec *gr_need_delay_callbacks = &struct__gr_need_delay_callbacks;
cstr quit_key[] = {"Q", "Escape", NULL};
int gr_key_last_release_key = -1;
int gr_key_last_release_time = -1;
num gr_key_last_release_time_real = -1;
long2cstr event_type_names[] =
{
	{ KeyPress, "KeyPress" },
	{ KeyRelease, "KeyRelease" },
	{ ButtonPress, "ButtonPress" },
	{ ButtonRelease, "ButtonRelease" },
	{ MotionNotify, "MotionNotify" },
	{ EnterNotify, "EnterNotify" },
	{ LeaveNotify, "LeaveNotify" },
	{ FocusIn, "FocusIn" },
	{ FocusOut, "FocusOut" },
	{ KeymapNotify, "KeymapNotify" },
	{ Expose, "Expose" },
	{ GraphicsExpose, "GraphicsExpose" },
	{ NoExpose, "NoExpose" },
	{ VisibilityNotify, "VisibilityNotify" },
	{ CreateNotify, "CreateNotify" },
	{ DestroyNotify, "DestroyNotify" },
	{ UnmapNotify, "UnmapNotify" },
	{ MapNotify, "MapNotify" },
	{ MapRequest, "MapRequest" },
	{ ReparentNotify, "ReparentNotify" },
	{ ConfigureNotify, "ConfigureNotify" },
	{ ConfigureRequest, "ConfigureRequest" },
	{ GravityNotify, "GravityNotify" },
	{ ResizeRequest, "ResizeRequest" },
	{ CirculateNotify, "CirculateNotify" },
	{ CirculateRequest, "CirculateRequest" },
	{ PropertyNotify, "PropertyNotify" },
	{ SelectionClear, "SelectionClear" },
	{ SelectionRequest, "SelectionRequest" },
	{ SelectionNotify, "SelectionNotify" },
	{ ColormapNotify, "ColormapNotify" },
	{ ClientMessage, "ClientMessage" },
	{ MappingNotify, "MappingNotify" },
};
num turtle_a = 0;
num turtle_pendown = 1;
int key_raw = 0;
int key_noecho = 0;
cstr cgi_png_display = ":99.0";

str new_str(char *start, char *end)
{
	str s = {start, end};
	return s;
}

str str_dup(str s)
{
	size_t size = (s.end - s.start);
	typeof(str_of_size(size)) ret = str_of_size(size);
	str_copy(ret.start, s);
	return ret;
}

str str_of_size(size_t size)
{
	str ret;
	ret.start = (normal_Malloc(size));
	ret.end = ret.start + size;
	return ret;
}

char *str_copy(char *to, str from)
{
	size_t size = (from.end - from.start);
	memmove(to, from.start, size);
	return to+size;
}

void str_free(str s)
{
	((free(s.start)), (s.start) = NULL);
}

cstr cstr_from_str(const str s)
{
	int size = (s.end - s.start);
	typeof(cstr_of_size(size)) cs = cstr_of_size(size);
	strlcpy(cs, s.start, size+1);
	return cs;
}

str str_cat_2(str s1, str s2)
{
	size_t s1_size = (s1.end - s1.start);
	size_t s2_size = (s2.end - s2.start);
	typeof(str_of_size(s1_size + s2_size)) ret = str_of_size(s1_size + s2_size);
	str_copy(ret.start, s1);
	str_copy(ret.start + s1_size, s2);
	return ret;
}

str str_cat_3(str s1, str s2, str s3)
{
	size_t s1_size = (s1.end - s1.start);
	size_t s2_size = (s2.end - s2.start);
	size_t s3_size = (s3.end - s3.start);
	typeof(str_of_size(s1_size + s2_size + s3_size)) ret = str_of_size(s1_size + s2_size + s3_size);
	str_copy(ret.start, s1);
	str_copy(ret.start + s1_size, s2);
	str_copy(ret.start + s1_size + s2_size, s3);
	return ret;
}

str str_from_char(char c)
{
	typeof(str_of_size(1)) ret = str_of_size(1);
	*ret.start = c;
	return ret;
}

str str_from_cstr(cstr cs)
{
	return new_str(cs, (cs+strlen(cs)));
}

void str_dump(str s)
{
	memdump(s.start, s.end);
}

char *str_chr(str s, char c)
{
	return memchr(s.start, c, (s.end - s.start));
}

str str_str(str haystack, str needle)
{
	str rv;
	rv.start = mem_mem(haystack.start, (haystack.end - haystack.start),  needle.start, (needle.end - needle.start));
	if(rv.start == NULL)
	{
		return str_null;
	}
	rv.end = rv.start + (needle.end - needle.start);
	return rv;
}

cstr *str_str_start(str haystack, str needle)
{
	return mem_mem(haystack.start, (haystack.end - haystack.start),  needle.start, (needle.end - needle.start));
}

void fprint_str(FILE *stream, str s)
{
	fprint_range(stream, (s.start), (s.end));
}

void print_str(str s)
{
	fprint_str(stdout, s);
}

void fsay_str(FILE *stream, str s)
{
	fprint_str(stream, s);
	if(0)
	{
		
	}
	else if(putc('\n', stream) == EOF)
	{
		failed("putc");
	}
}

void say_str(str s)
{
	fsay_str(stdout, s);
}

void buffer_init(buffer *b, size_t space)
{
	if(space == 0)
	{
		space = 1;
	}
	b->start = (char *)(normal_Malloc(space));
	b->end = b->start;
	b->space_end = b->start + space;
}

void buffer_free(buffer *b)
{
	((free(b->start)), (b->start) = NULL);
}

void buffer_set_space(buffer *b, size_t space)
{
	size_t size = ((ssize_t)((b->end)-(b->start)));
	if(1 && !((size <= space)))
	{
		fault_(__FILE__, __LINE__, "cannot set buffer space less than buffer size");
	}
	if(space == 0)
	{
		space = 1;
	}
	((b->start) = normal_Realloc((b->start), space));
	b->end = b->start + size;
	b->space_end = b->start + space;
}

void buffer_set_size(buffer *b, size_t size)
{
	buffer_ensure_space(b, size);
	b->end = b->start + size;
}

void buffer_double(buffer *b)
{
	buffer_set_space(b, 2 * ((ssize_t)(b->space_end - b->start)));
}

void buffer_squeeze(buffer *b)
{
	buffer_set_space(b, ((ssize_t)((b->end)-(b->start))));
}

void buffer_cat_char(buffer *b, char c)
{
	buffer_grow(b, 1);
	*(b->end - 1) = c;
}

void buffer_cat_cstr(buffer *b, const char *s)
{
	int l = strlen(s);
	buffer_grow(b, l);
	memcpy(b->end - l, s, l);
}

void buffer_cat_str(buffer *b, str s)
{
	int l = (s.end - s.start);
	buffer_grow(b, l);
	str_copy(b->end - l, s);
}

void buffer_cat_range(buffer *b, const char *start, const char *end)
{
	int l = end - start;
	buffer_grow(b, l);
	memmove(b->end - l, start, l);
}

void buffer_grow(buffer *b, size_t delta_size)
{
	buffer_set_size(b, ((ssize_t)((b->end)-(b->start))) + delta_size);
}

void buffer_clear(buffer *b)
{
	b->end = b->start;
}

char buffer_last_char(buffer *b)
{
	ssize_t l = ((ssize_t)((b->end)-(b->start)));
	if(!l)
	{
		return '\0';
	}
	return b->start[l-1];
}

boolean buffer_ends_with_char(buffer *b, char c)
{
	return ((ssize_t)((b->end)-(b->start))) && buffer_last_char(b) == c;
}

boolean buffer_ends_with(buffer *b, cstr s)
{
	ssize_t len = strlen(s);
	return ((ssize_t)((b->end)-(b->start))) >= len && !strncmp(b->end-len, s, len);
}

char buffer_first_char(buffer *b)
{
	return b->start[0];
}

char buffer_get_char(buffer *b, size_t i)
{
	return b->start[i];
}

void buffer_zero(buffer *b)
{
	memset((b->start), 0, ((ssize_t)((b->end)-(b->start))));
}

int Sprintf(buffer *b, const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(Vsprintf(b, format, ap)) rv = Vsprintf(b, format, ap);
	va_end(ap);
	return rv;
}

cstr format(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(vformat(format, ap)) rv = vformat(format, ap);
	va_end(ap);
	return rv;
}

cstr vformat(const char *format, va_list ap)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 4096);
	Vsprintf(b, format, ap);
	buffer_add_nul(b);
	buffer_squeeze(b);
	return (b->start);
}

cstr fformat(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(vformat(format, ap)) rv = vformat(format, ap);
	va_end(ap);
	return rv;
}

cstr vfformat(const char *format, va_list ap)
{
	return tofree(vformat(format, ap));
}

int Vsnprintf(char *buf, size_t size, const char *format, va_list ap)
{
	typeof(vsnprintf(buf, size, format, ap)) rv = vsnprintf(buf, size, format, ap);
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
	ssize_t old_size = ((ssize_t)((b->end)-(b->start)));
	char *start = b->start + old_size;
	ssize_t space = ((ssize_t)(b->space_end - b->start)) - old_size;
	if(space == 0)
	{
		buffer_ensure_space(b, old_size+1);
		start = b->start + old_size;
		space = ((ssize_t)(b->space_end - b->start)) - old_size;
	}
	ssize_t len = Vsnprintf(start, space, format, ap);
	if(len < space)
	{
		buffer_grow(b, len);
	}
	else
	{
		buffer_set_size(b, old_size+len+1);
		start = b->start + old_size;
		space = ((ssize_t)(b->space_end - b->start)) - old_size;
		len = Vsnprintf(start, space, format, ap1);
		if(1 && !((old_size+len == ((ssize_t)((b->end)-(b->start)))-1)))
		{
			fault_(__FILE__, __LINE__, "vsnprintf returned different sizes on same input!!");
		}
		buffer_set_size(b, old_size+len);
	}
	va_end(ap1);
	return len;
}

char *buffer_add_nul(buffer *b)
{
	buffer_cat_char(b, '\0');
	return ((b->start));
}

char *buffer_nul_terminate(buffer *b)
{
	buffer_cat_char(b, '\0');
	buffer_grow(b, -1);
	return ((b->start));
}

void buffer_strip_nul(buffer *b)
{
	if(((ssize_t)((b->end)-(b->start))) && buffer_last_char(b) == '\0')
	{
		buffer_grow(b, -1);
	}
}

void buffer_dump(FILE *stream, buffer *b)
{
	Fprintf(stream, "buffer: %08x %08x %08x (%d):\n", b->start, b->end, b->space_end, b->end - b->start);
	hexdump(stream, b->start, b->end);
}

buffer *buffer_dup_0(buffer *from)
{
	return buffer_dup((((buffer *)(normal_Malloc(1 * sizeof(buffer))))), from);
}

buffer *buffer_dup(buffer *to, buffer *from)
{
	buffer_init(to, ((ssize_t)(from->space_end - from->start)));
	int size = ((ssize_t)((from->end)-(from->start)));
	memcpy(to->start, from->start, size);
	to->end = to->start + size;
	return to;
}

cstr buffer_to_cstr(buffer *b)
{
	buffer_add_nul(b);
	buffer_squeeze(b);
	return (b->start);
}

void buffer_from_cstr(buffer *b, cstr s, size_t len)
{
	b->start = s;
	b->end = s + len;
	b->space_end = b->end + 1;
}

buffer *buffer_from_cstr_1(cstr s)
{
	size_t len = strlen(s);
	buffer *b;
	b = (((buffer *)(normal_Malloc(1 * sizeof(buffer)))));
	buffer_init(b, len+1);
	buffer_from_cstr(b, s, len);
	return b;
}

void buffer_shift(buffer *b, size_t shift)
{
	char *start = (b->start);
	size_t size = ((ssize_t)((b->end)-(b->start)));
	if(size != shift)
	{
		memmove(start, start+shift, size-shift);
	}
	buffer_grow(b, -shift);
}

void buffer_ensure_space(buffer *b, size_t space)
{
	size_t ospace = ((ssize_t)(b->space_end - b->start));
	if(space > ospace)
	{
		do
		{
			ospace *= 2;
		}
		while(space > ospace);
		buffer_set_space(b, ospace);
	}
}

void buffer_ensure_size(buffer *b, ssize_t size)
{
	if(((ssize_t)((b->end)-(b->start))) < size)
	{
		buffer_set_size(b, size);
	}
}

void buffer_ensure_free(buffer *b, ssize_t free)
{
	while(((ssize_t)(b->space_end - b->end)) < free)
	{
		buffer_double(b);
	}
}

void buffer_nl(buffer *b)
{
	buffer_cat_char(b, '\n');
}

void buf_splice(buffer *b, size_t i, size_t cut, char *in, size_t ins)
{
	ssize_t in_i = -1;
	if(in+ins < ((b->start)) || in >= ((b->end)) eif (in >= (((b->start))) && in < (((b->end)))))
	{
		in_i = in - ((b->start));
	}
	else
	{
		fault_(__FILE__, __LINE__, "buf_splice: input overlaps the start or end of the buffer");
	}
	size_t oldlen = (((ssize_t)((b->end)-(b->start))));
	buffer_grow(b, ins-cut);
	if(in_i >= 0)
	{
		in = ((b->start)) + in_i;
	}
	size_t endcut = i+cut;
	size_t endins = i+ins;
	if(in && ins <= cut)
	{
		memmove((b->start+i), in, ins);
	}
	size_t tail = oldlen-endcut;
	memmove((b->start+endins), (b->start+endcut), tail);
	if(in && ins > cut)
	{
		size_t hard = 0;
		if(in_i >= 0)
		{
			hard = in+ins - (b->start+endcut);
			if(hard > 0)
			{
				memcpy((b->start+(endins-hard)), (b->start+endins), hard);
			}
		}
		memmove((b->start+i), in, ins-hard);
	}
}

buffer *Subbuf(buffer *b, size_t i, size_t n, size_t extra)
{
	buffer *sub = (((buffer *)(normal_Malloc(1 * sizeof(buffer)))));
	subbuf(sub, b, i, n);
	buf_dup_guts(sub, extra);
	return sub;
}

buffer *subbuf(buffer *sub, buffer *b, size_t i, size_t n)
{
	sub->start = (b->start+i);
	sub->space_end = sub->end = (b->start+(i+n));
	return sub;
}

void buf_dup_guts(buffer *b, size_t extra)
{
	size_t n = (((ssize_t)((b->end)-(b->start))));
	b->start = memdup(b->start, n, extra);
	b->end = b->start + n;
	b->space_end = b->end + extra;
}

void buffer_cat_chars(buffer *b, char c, size_t n)
{
	buffer_grow(b, n);
	char *p = ((b->end)) - n;
	memset(p, c, n);
}

void buffer_cat_int(buffer *b, int i)
{
	Sprintf(b, "%d", i);
}

void buffer_cat_long(buffer *b, long i)
{
	Sprintf(b, "%ld", i);
}

void buffer_clone(buffer *out, buffer *in)
{
	out->start = in->start;
	out->end = in->end;
	out->space_end = in->space_end;
}

void circbuf_init(circbuf *b, ssize_t space)
{
	b->space = space ? space : 1;
	b->data = (normal_Malloc(b->space));
	b->size = 0;
	b->start = 0;
}

char *circbuf_get_pos(circbuf *b, int index)
{
	char *pos = b->data + b->start + index;
	if(b->start + index >= b->space)
	{
		pos -= b->space;
	}
	return pos;
}

void circbuf_free(circbuf *b)
{
	((free(b->data)), (b->data) = NULL);
}

void circbuf_set_space(circbuf *b, ssize_t space)
{
	space = space ? space : 1;
	char *new_data = (normal_Malloc(space));
	ssize_t max_first_part = b->space - b->start;
	ssize_t second_part = b->size - max_first_part;
	if(second_part <= 0)
	{
		memcpy(new_data, b->data+b->start, b->size);
	}
	else
	{
		memcpy(new_data, b->data+b->start, max_first_part);
		memcpy(new_data+max_first_part, b->data, second_part);
	}
	((free(b->data)), (b->data) = NULL);
	b->data = new_data;
	b->space = space;
	b->start = 0;
}

void circbuf_ensure_space(circbuf *b, ssize_t space)
{
	ssize_t ospace = (b->space);
	if(space > ospace)
	{
		do
		{
			ospace *= 2;
		}
		while(space > ospace);
		circbuf_set_space(b, ospace);
	}
}

void circbuf_ensure_size(circbuf *b, ssize_t size)
{
	if((b->size) < size)
	{
		circbuf_set_size(b, size);
	}
}

void circbuf_ensure_free(circbuf *b, ssize_t free)
{
	while(((b->space) - (b->size)) < free)
	{
		circbuf_double(b);
	}
}

void circbuf_set_size(circbuf *b, ssize_t size)
{
	ssize_t space = b->space;
	while(size > space)
	{
		space *= 2;
		circbuf_set_space(b, space);
	}
	b->size = size;
}

void circbuf_grow(circbuf *b, ssize_t delta_size)
{
	circbuf_set_size(b, (b->size) + delta_size);
}

void circbuf_shift(circbuf *b, ssize_t delta_size)
{
	b->start += delta_size;
	if(b->start >= b->space)
	{
		b->start -= b->space;
	}
	b->size -= delta_size;
}

void circbuf_unshift(circbuf *b, ssize_t delta_size)
{
	circbuf_ensure_free(b, delta_size);
	b->start -= delta_size;
	if(b->start < 0)
	{
		b->start += b->space;
	}
	b->size += delta_size;
}

void circbuf_double(circbuf *b)
{
	circbuf_set_space(b, b->space * 2);
}

void circbuf_squeeze(circbuf *b)
{
	circbuf_set_space(b, b->size);
}

void circbuf_clear(circbuf *b)
{
	b->size = 0;
	b->start = 0;
}

void buffer_to_circbuf(circbuf *cb, buffer *b)
{
	cb->space = ((ssize_t)(b->space_end - b->start));
	cb->data = ((b->start));
	cb->size = (((ssize_t)((b->end)-(b->start))));
	cb->start = 0;
}

void circbuf_cat_char(circbuf *b, char c)
{
	circbuf_grow(b, 1);
	*(circbuf_get_pos(b, (((b->size))-1))) = c;
}

void circbuf_cat_cstr(circbuf *b, const char *s)
{
	ssize_t l = strlen(s);
	circbuf_cat_range(b, s, s+l);
}

void circbuf_cat_str(circbuf *b, str s)
{
	circbuf_cat_range(b, s.start, s.end);
}

void circbuf_cat_range(circbuf *b, const char *start, const char *end)
{
	ssize_t l = end - start;
	circbuf_grow(b, l);
	char *space_end = (b->data + b->space);
	char *i = (circbuf_get_pos(b, ((b->size) - l)));
	ssize_t l1 = space_end - i;
	boolean onestep = l <= l1;
	if(onestep)
	{
		l1 = l;
	}
	memcpy(i, start, l1);
	if(!onestep)
	{
		memcpy(b->data, start+l1, l - l1);
	}
}

char circbuf_first_char(circbuf *b)
{
	return *(circbuf_get_pos(b, 0));
}

char circbuf_last_char(circbuf *b)
{
	return *(circbuf_get_pos(b, (((b->size))-1)));
}

char circbuf_get_char(circbuf *b, ssize_t i)
{
	return *(circbuf_get_pos(b, i));
}

int Vsprintf_cb(circbuf *b, const char *format, va_list ap)
{
	va_list ap1;
	va_copy(ap1, ap);
	ssize_t old_size = (b->size);
	char *start = ((circbuf_get_pos(b, b->size)));
	ssize_t free = ((b->space) - (b->size));
	ssize_t free_1 = ((b->size >= b->space - b->start) ? b->space - b->size : b->space - b->start - b->size);
	if(free_1 == 0)
	{
		circbuf_ensure_space(b, old_size+1);
		start = ((circbuf_get_pos(b, b->size)));
		free = ((b->space) - (b->size));
		free_1 = ((b->size >= b->space - b->start) ? b->space - b->size : b->space - b->start - b->size);
	}
	ssize_t len = Vsnprintf(start, free_1, format, ap);
	if(len < free_1)
	{
		circbuf_grow(b, len);
	}
	else if(len < free)
	{
		char tmp[len+1];
		ssize_t len1 = Vsnprintf(tmp, len+1, format, ap1);
		if(1 && !((len == len1)))
		{
			fault_(__FILE__, __LINE__, "vsnprintf returned different sizes on same input!!");
		}
		circbuf_cat_range(b, tmp, tmp+len+1);
		circbuf_grow(b, -1);
	}
	else
	{
		circbuf_ensure_space(b, old_size+len+1);
		start = ((circbuf_get_pos(b, b->size)));
		free_1 = ((b->size >= b->space - b->start) ? b->space - b->size : b->space - b->start - b->size);
		if(1 && !((free_1 >= len+1)))
		{
			fault_(__FILE__, __LINE__, "Vsprintf_cb: circbuf_ensure_space did not work properly");
		}
		ssize_t len1 = Vsnprintf(start, free_1, format, ap1);
		if(1 && !((len == len1)))
		{
			fault_(__FILE__, __LINE__, "vsnprintf returned different sizes on same input!!");
		}
		circbuf_grow(b, len);
	}
	va_end(ap1);
	return len;
}

void circbuf_add_nul(circbuf *b)
{
	if((b->size) == 0 || circbuf_last_char(b) != '\0')
	{
		circbuf_cat_char(b, '\0');
	}
}

void circbuf_to_buffer(buffer *b, circbuf *cb)
{
	circbuf_tidy(cb);
	b->start = cb->data;
	b->end = b->start + cb->size;
	b->space_end = b->start + cb->space;
}

void circbuf_tidy(circbuf *b)
{
	if(b->start == 0)
	{
		return;
	}
	ssize_t l1 = ((b->size >= b->space - b->start) ? b->space - b->start : b->size);
	ssize_t l2 = ((b->size >= b->space - b->start) ? b->start + b->size - b->space : 0);
	if(l1 <= l2)
	{
		char tmp[l1];
		memcpy(tmp, ((b->data + b->start)), l1);
		if(l2)
		{
			memmove(b->data + l1, b->data, l2);
		}
		memcpy(b->data, tmp, l1);
	}
	else
	{
		char tmp[l2];
		memcpy(tmp, b->data, l2);
		memmove(b->data, ((b->data + b->start)), l1);
		memcpy(b->data + l1, tmp, l2);
	}
	b->start = 0;
}

cstr circbuf_to_cstr(circbuf *b)
{
	if(!((b->space) - (b->size)))
	{
		circbuf_grow(b, 1);
		if(1 && !((b->start == 0)))
		{
			fault_(__FILE__, __LINE__, "circbuf_grow did not work properly");
		}
	}
	else
	{
		circbuf_tidy(b);
	}
	circbuf_add_nul(b);
	circbuf_squeeze(b);
	return ((b->data + b->start));
}

char *circbuf_nul_terminate(circbuf *b)
{
	if((b->size >= b->space - b->start) || (b->size) == 0 || circbuf_last_char(b) != '\0')
	{
		circbuf_to_cstr(b);
	}
	circbuf_grow(b, -1);
	return ((b->data + b->start));
}

ssize_t cbindex_not_len(circbuf *b, char *p)
{
	ssize_t i = p - ((b->data + b->start));
	if(i < 0)
	{
		i += (b->space);
	}
	return i;
}

ssize_t cbindex_not_0(circbuf *b, char *p)
{
	ssize_t i = p - ((b->data + b->start));
	if(i <= 0)
	{
		i += (b->space);
	}
	return i;
}

void circbuf_from_cstr(circbuf *b, cstr s, ssize_t len)
{
	b->data = s;
	b->size = len;
	b->space = len + 1;
	b->start = 0;
}

void circbuf_dump(FILE *stream, circbuf *b)
{
	Fprintf(stream, "circbuf: %08x %08x %08x %08x:\n", b->data, b->size, b->space, b->start);
	hexdump(stream, b->data, b->data + b->space);
}

void circbuf_copy_out(circbuf *b, void *dest, ssize_t i, ssize_t n)
{
	i += b->start;
	if(i >= b->space)
	{
		i -= b->space;
	}
	ssize_t n0 = lmin(n, b->space - i);
	ssize_t n1 = n - n0;
	memcpy(dest, b->data + i, n0);
	if(n1)
	{
		memcpy((char*)dest + n0, b->data, n1);
	}
}

void circbuf_cat_cb_range(circbuf *b, circbuf *from, ssize_t i, ssize_t n)
{
	ssize_t to = (b->size);
	circbuf_grow(b, n);
	ssize_t l1 = ((from->size >= from->space - from->start) ? from->space - from->start : from->size);
	if(i < l1)
	{
		ssize_t n1 = l1 - i;
		if(n1 > n)
		{
			n1 = n;
		}
		circbuf_copy_in(b, to, (circbuf_get_pos(from, i)), n1);
		n -= n1;
		if(n)
		{
			to += n1;
			circbuf_copy_in(b, to, from->data, n);
		}
	}
	else
	{
		circbuf_copy_in(b, to, (circbuf_get_pos(from, i)), n);
	}
}

void circbuf_copy_in(circbuf *b, ssize_t i, void *from, ssize_t n)
{
	char *p = (circbuf_get_pos(b, i));
	ssize_t l0 = (b->data + b->space) - p;
	ssize_t l1 = n - l0;
	if(n < l0)
	{
		l0 = n;
	}
	memcpy(p, from, l0);
	if(l1 > 0)
	{
		memcpy(b->data, (char *)from+l0, l1);
	}
}

void _deq_init(deq *q, ssize_t element_size, ssize_t space)
{
	q->space = space ? space : 1;
	circbuf_init(&q->b, q->space * element_size);
	q->element_size = element_size;
	q->size = 0;
	q->start = 0;
}

void deq_free(deq *q)
{
	circbuf_free(&q->b);
}

void deq_space(deq *q, ssize_t space)
{
	q->space = space ? space : 1;
	circbuf_set_space(&q->b, q->space * q->element_size);
	if(q->b.start == 0)
	{
		q->start = 0;
	}
}

void deq_size(deq *q, ssize_t size)
{
	ssize_t cap = q->space;
	if(size > cap)
	{
		do
		{
			cap *= 2;
		}
		while(size > cap);
		deq_space(q, cap);
	}
	q->size = size;
	q->b.size = size * q->element_size;
}

void deq_clear(deq *q)
{
	circbuf_clear(&q->b);
	q->start = q->size = 0;
}

void deq_double(deq *q)
{
	deq_space(q, q->space * 2);
}

void deq_squeeze(deq *q)
{
	deq_space(q, q->size);
}

void *deq_element(deq *q, ssize_t index)
{
	index += q->start;
	if(index >= q->space)
	{
		index -= q->space;
	}
	return q->b.data + index * q->element_size;
}

void *deq_push(deq *q)
{
	if(q->size == q->space)
	{
		deq_double(q);
	}
	++q->size;
	q->b.size += q->element_size;
	return deq_element(q, q->size-1);
}

void deq_pop(deq *q)
{
	--q->size;
	q->b.size -= q->element_size;
}

void *deq_top(deq *q, ssize_t index)
{
	return deq_element(q, q->size -1 - index);
}

void *deq_unshift(deq *q)
{
	if(q->size == q->space)
	{
		deq_double(q);
	}
	++q->size;
	q->b.size += q->element_size;
	if(q->start > 0)
	{
		--q->start;
		q->b.start -= q->element_size;
	}
	else
	{
		q->start = q->space - 1;
		q->b.start = q->b.space - q->element_size;
	}
	return deq_element(q, 0);
}

void deq_shift(deq *q)
{
	--q->size;
	if(q->size == 0)
	{
		deq_clear(q);
		return;
	}
	q->b.size -= q->element_size;
	++q->start;
	q->b.start += q->element_size;
	if(q->start >= q->space)
	{
		q->start -= q->space;
		q->b.start -= q->b.space;
	}
}

void deq_grow(deq *q, ssize_t delta_size)
{
	(deq_size(q, (((q->size)) + delta_size)));
}

void deq_cat_range(deq *q, void *start, void *end)
{
	ssize_t old_space = q->b.space;
	circbuf_cat_range(&q->b, start, end);
	if(q->b.space != old_space)
	{
		deq_recalc_from_cb(q);
	}
	else
	{
		q->size = q->b.size / q->element_size;
	}
}

void deq_recalc_from_cb(deq *q)
{
	q->start = q->b.start / q->element_size;
	q->space = q->b.space / q->element_size;
	q->size = q->b.size / q->element_size;
}

void deq_shifts(deq *q, ssize_t n)
{
	q->size -= n;
	if(q->size == 0)
	{
		deq_clear(q);
	}
	else
	{
		circbuf_shift(&q->b, q->element_size * n);
		q->start += n;
		if(q->start >= q->space)
		{
			q->start -= q->space;
		}
	}
}

void deq_unshifts(deq *q, ssize_t n)
{
	q->size += n;
	circbuf_unshift(&q->b, q->element_size * n);
	q->start -= n;
	if(q->start < 0)
	{
		q->start += q->space;
	}
}

void deq_copy_out(deq *q, void *dest, ssize_t i, ssize_t n)
{
	ssize_t es = q->element_size;
	circbuf_copy_out(&q->b, dest, i*es, n*es);
}

void deq_cat_deq_range(deq *q, deq *from, ssize_t i, ssize_t n)
{
	ssize_t old_space = q->b.space;
	ssize_t es = q->element_size;
	circbuf_cat_cb_range(&q->b, &from->b, i*es, n*es);
	if(q->b.space != old_space)
	{
		deq_recalc_from_cb(q);
	}
	else
	{
		q->size += n;
	}
}

void deq_cat_deq(deq *q, deq *from)
{
	deq_cat_deq_range(q, from, 0, ((from->size)));
}

void deq_copy_in(deq *q, ssize_t i, void *from, ssize_t n)
{
	ssize_t es = q->element_size;
	circbuf_copy_in(&q->b, i*es, from, n*es);
}

void vec_to_deq(deq *q, vec *v)
{
	q->element_size = v->element_size;
	buffer_to_circbuf(&q->b, &v->b);
	deq_recalc_from_cb(q);
}

void deq_to_vec(vec *v, deq *q)
{
	v->element_size = q->element_size;
	circbuf_to_buffer(&v->b, &q->b);
	deq_recalc_from_cb(q);
	vec_recalc_from_buffer(v);
}

void deq_tidy(deq *q)
{
	circbuf_tidy(&q->b);
	deq_recalc_from_cb(q);
}

void data_to_deq(deq *q, void *data, ssize_t size, ssize_t element_size)
{
	q->element_size = element_size;
	q->size = q->space = size;
	q->start = 0;
	q->b.size = q->b.space = size * element_size;
	q->b.start = 0;
	q->b.data = data;
}

void deq_to_data(deq *q, void **data, ssize_t *size)
{
	deq_tidy(q);
	*data = (deq_element(q, 0));
	*size = ((q->size));
}

ssize_t deqt_pre(deq *t, deq *q, ssize_t offset)
{
	*t = *q;
	deq_shifts(t, offset);
	return ((t->size));
}

ssize_t deqt_post(deq *t, ssize_t oldsize)
{
	ssize_t offset = oldsize - ((t->size));
	return offset;
}

void deqts_shift(deq *q, ssize_t *offsets, ssize_t n)
{
	ssize_t min_offset = deqts_min_offset(offsets, n);
	deqts_shift_offsets(offsets, n, min_offset);
	deq_shifts(q, min_offset);
}

ssize_t deqts_min_offset(ssize_t *offsets, ssize_t n)
{
	ssize_t min_offset = *offsets;
	typeof((offsets+n)) (skip(1, `my__308_)end) = (offsets+n);
	typeof((offsets+1)) (skip(1, `my__313_)v1) = (offsets+1);
	for(; (skip(1, `my__318_)v1)<(skip(1, `my__320_)end); ++(skip(1, `my__322_)v1))
	{
		typeof((skip(1, `my__324_)v1)) i = (skip(1, `my__324_)v1);
		if(*i < min_offset)
		{
			min_offset = *i;
		}
	}
	return min_offset;
}

void deqts_shift_offsets(ssize_t *offsets, ssize_t n, ssize_t min_offset)
{
	typeof((offsets+n)) (skip(1, `my__330_)end) = (offsets+n);
	typeof(offsets) (skip(1, `my__335_)v1) = offsets;
	for(; (skip(1, `my__340_)v1)<(skip(1, `my__342_)end); ++(skip(1, `my__344_)v1))
	{
		typeof((skip(1, `my__346_)v1)) i = (skip(1, `my__346_)v1);
		*i -= min_offset;
	}
}

void *thunk_ignore(void *obj, void *common_arg, void *specific_arg)
{
	(void)obj;
	(void)common_arg;
	(void)specific_arg;
	return (((void*)(intptr_t)1));
}

void *thunk_void(void *obj, void *common_arg, void *specific_arg)
{
	(void)obj;
	(void)common_arg;
	(void)specific_arg;
	return (((void*)(intptr_t)0));
}

void *thunk_thunks(void *obj, void *common_arg, void *specific_arg)
{
	(void)common_arg;
	return thunks_call((deq*)obj, specific_arg);
}

void *thunks_call(deq *q, void *specific_arg)
{
	deq *(skip(1, `my__363_)q1) = q;
	thunk *i = (deq_element(((skip(1, `my__365_)q1)), 0));
	thunk *(skip(1, `my__368_)end) = (deq_element(((skip(1, `my__370_)q1)), ((skip(1, `my__370_)q1))->size));
	thunk *(skip(1, `my__373_)wrap) = ((void *)(((skip(1, `my__375_)q1))->b.data + ((skip(1, `my__375_)q1))->b.space));
	thunk *(skip(1, `my__378_)origin) = ((void *)(((skip(1, `my__380_)q1))->b.data));
	if((((skip(1, `my__383_)q1))->size))
	{
		(skip(1, `my__386_)st);
	}
	for(; i != (skip(1, `my__388_)end) ; ++i, i = i == (skip(1, `my__390_)wrap) ? (skip(1, `my__392_)origin) : i) {}
}
void (skip(1, `my__394_)st)		.
{
	{
		void *handled = ((*i->func)(i->obj, i->common_arg, specific_arg));
		if(handled)
		{
			return handled;
		}
	}
	return (((void*)(intptr_t)0));
}

void list_init(list *l)
{
	l->next = NULL;
}

boolean list_is_empty(list *l)
{
	return l->next == NULL;
}

list *list_last(list *l)
{
	while(l->next != NULL)
	{
		l = l->next;
	}
	return l;
}

void list_dump(list *l)
{
	while(1)
	{
		if(l == NULL)
		{
			Puts("NULL");
			break;
		}
		else
		{
			Sayf("%010p ", l);
			l = (l->next);
		}
	}
}

list *list_reverse(list *l)
{
	list *prev = NULL;
	while(l != NULL)
	{
		list *next = l->next;
		l->next = prev;
		prev = l;
		l = next;
	}
	return prev;
}

list *list_reverse_fast(list *l)
{
	list *prev = NULL;
	while(1)
	{
		if(l == NULL)
		{
			return prev;
		}
		list *next = l->next;
		l->next = prev;
		if(next == NULL)
		{
			return l;
		}
		prev = next->next;
		next->next = l;
		if(prev == NULL)
		{
			return next;
		}
		l = prev->next;
		prev->next = next;
	}
}

void list_push(list **list_pp, list *new_node)
{
	typeof(*list_pp) next = *list_pp;
	*list_pp = new_node;
	*(&new_node->next) = next;
}

void list_pop(list **list_pp)
{
	*list_pp = (*list_pp)->next;
}

void list_free(list **l)
{
	typeof(l) ((skip(1, `my__410_)link1)) = l;
	while(*((skip(1, `my__410_)link1)))
	{
		typeof(((skip(1, `my__410_)link1))) ((skip(1, `my__408_)link0)) = ((skip(1, `my__410_)link1));
		typeof(*((skip(1, `my__408_)link0))) i = *((skip(1, `my__408_)link0));
		((skip(1, `my__410_)link1)) = (&i->next);
		
		((free(i)), i = NULL);
	}
}

void list_x_init(list_x *n, void *o)
{
	n->o = o;
}

void hashtable_init(hashtable *ht, hash_func *hash, eq_func *eq, size_t size)
{
	ht->size = hashtable_sensible_size(size);
	ht->buckets = alloc_buckets(ht->size);
	ht->hash = hash;
	ht->eq = eq;
}

list *alloc_buckets(size_t size)
{
	list *buckets = ((list *)(normal_Malloc(size * sizeof(list))));
	list *end = buckets + size;
	list *i;
	for(i = buckets ; i != end ; ++i)
	{
		list_init(i);
	}
	return buckets;
}

list *hashtable_lookup_ref(hashtable *ht, void *key)
{
	list *bucket = which_bucket(ht, key);
	eq_func *eq = ht->eq;
	while(1)
	{
		node_kv *node = (node_kv *)bucket->next;
		if(node == NULL || (*eq)(key, node->kv.k))
		{
			return bucket;
		}
		bucket = (list *)node;
	}
}

key_value *hashtable_lookup(hashtable *ht, void *key)
{
	list *l = hashtable_lookup_ref(ht, key);
	if(l->next == NULL)
	{
		return NULL;
	}
	else
	{
		return hashtable_ref_lookup(l);
	}
}

key_value *hashtable_ref_lookup(list *l)
{
	node_kv *node = (node_kv *)l->next;
	return (key_value *)&node->kv;
}

void *hashtable_value(hashtable *ht, void *key)
{
	key_value *kv = hashtable_lookup(ht, key);
	if(kv == NULL)
	{
		error("hashtable_value: key does not exist");
		return NULL;
	}
	else
	{
		return kv->v;
	}
}

void *hashtable_value_or_null(hashtable *ht, void *key)
{
	return hashtable_value_or(ht, key, NULL);
}

void *hashtable_value_or(hashtable *ht, void *key, void *def)
{
	key_value *kv = hashtable_lookup(ht, key);
	if(kv == NULL)
	{
		return def;
	}
	else
	{
		return kv->v;
	}
}

key_value *hashtable_add(hashtable *ht, void *key, void *value)
{
	list *l = hashtable_lookup_ref(ht, key);
	hashtable_ref_add(l, key, value);
	return hashtable_ref_key_value(l);
}

void hashtable_ref_add(list *l, void *key, void *value)
{
	if(!hashtable_ref_add_maybe(l, key, value))
	{
		error("hashtable_ref_add: key already exists");
	}
}

key_value *hashtable_add_maybe(hashtable *ht, void *key, void *value)
{
	list *l = hashtable_lookup_ref(ht, key);
	if(hashtable_ref_add_maybe(l, key, value))
	{
		return hashtable_ref_key_value(l);
	}
	else
	{
		return NULL;
	}
}

boolean hashtable_ref_add_maybe(list *l, void *key, void *value)
{
	if(l->next != NULL)
	{
		return 0;
	}
	node_kv *node = (((node_kv *)(normal_Malloc(1 * sizeof(node_kv)))));
	node->kv.k = key;
	node->kv.v = value;
	typeof(*((&l->next))) next = *((&l->next));
	*((&l->next)) = ((list *)node);
	*(&((list *)node)->next) = next;
	return 1;
}

key_value hashtable_delete(hashtable *ht, void *key)
{
	list *l = hashtable_lookup_ref(ht, key);
	return hashtable_ref_delete(l);
}

void hashtable_delete_maybe(hashtable *ht, void *key)
{
	list *l = hashtable_lookup_ref(ht, key);
	if(hashtable_ref_exists(l))
	{
		hashtable_ref_delete(l);
	}
}

key_value hashtable_ref_delete(list *l)
{
	key_value ret;
	if(hashtable_ref_exists(l))
	{
		node_kv *node = hashtable_ref_node(l);
		*((&l->next)) = (*((&l->next)))->next;
		ret = node->kv;
		((free(node)), node = NULL);
	}
	else
	{
		ret = kv_null;
	}
	return ret;
}

node_kv *hashtable_ref_node(list *l)
{
	node_kv *node = (node_kv *)l->next;
	if(1 && !((node != NULL)))
	{
		fault_(__FILE__, __LINE__, "hashtable_ref_node: node not found");
	}
	return node;
}

boolean hashtable_ref_exists(list *l)
{
	return l->next != NULL;
}

key_value *hashtable_ref_key_value(list *l)
{
	node_kv *node = hashtable_ref_node(l);
	return &node->kv;
}

list *which_bucket(hashtable *ht, void *key)
{
	unsigned int hash = (*ht->hash)(key);
	unsigned int i = hash % ht->size;
	return ht->buckets + i;
}

size_t hashtable_sensible_size(size_t size)
{
	if(size == 0)
	{
		size = 1;
	}
	return size;
}

unsigned long cstr_hash(void *s)
{
	unsigned long rv = 0;
	typeof(((((char *)s)+strlen((char *)s)))) (skip(1, `my__452_)end) = ((((char *)s)+strlen((char *)s)));
	typeof(((char *)s)) (skip(1, `my__457_)v1) = ((char *)s);
	for(; (skip(1, `my__462_)v1)<(skip(1, `my__464_)end); ++(skip(1, `my__466_)v1))
	{
		typeof((skip(1, `my__468_)v1)) i = (skip(1, `my__468_)v1);
		rv *= 101;
		rv += *i;
	}
	return rv;
}

void hashtable_dump(hashtable *ht)
{
	uint i;
	for(i=0; i<ht->size; ++i)
	{
		list *bucket = &ht->buckets[i];
		list *l = bucket;
		while(1)
		{
			Printf("%010p ", l);
			l = l->next;
			if(l == NULL)
			{
				break;
			}
		}
		if(0)
		{
			
		}
		else if(putc('\n', stdout) == EOF)
		{
			failed("putc");
		}
	}
	if(0)
	{
		
	}
	else if(putc('\n', stdout) == EOF)
	{
		failed("putc");
	}
}

key_value *hashtable_lookup_or_add_key(hashtable *ht, void *key, void *value_init)
{
	list *ref = hashtable_lookup_ref(ht, key);
	if(ref->next == NULL)
	{
		hashtable_ref_add(ref, key, value_init);
	}
	return hashtable_ref_lookup(ref);
}

key_value *hashtable_lookup_or_die(hashtable *ht, void *key)
{
	list *ref = hashtable_lookup_ref(ht, key);
	if(ref->next == NULL)
	{
		error("%s failed", "hashtable_lookup_or_die");
	}
	return hashtable_ref_lookup(ref);
}

unsigned long int_hash(void *i_ptr)
{
	long i = ((intptr_t)i_ptr);
	char s[64];
	size_t size = snprintf(s, sizeof(s), "%ld", i);
	if(size >= sizeof(s))
	{
		failed("int_hash");
	}
	return cstr_hash(s);
}

boolean int_eq(void *a, void *b)
{
	return ((intptr_t)a) == ((intptr_t)b);
}

void hashtable_free(hashtable *ht, free_t *free_key, free_t *free_value)
{
	hashtable_clear(ht, free_key, free_value);
	((free(ht->buckets)), (ht->buckets) = NULL);
}

void hashtable_clear(hashtable *ht, free_t *free_key, free_t *free_value)
{
	list *bucket = ht->buckets;
	list *end = bucket + ht->size;
	for(; bucket != end; ++bucket)
	{
		list *item = bucket->next;
		while(item)
		{
			list *next = item->next;
			node_kv *node = (node_kv *)item;
			if(free_key)
			{
				free_key(node->kv.k);
			}
			if(free_value)
			{
				free_value(node->kv.v);
			}
			((free(node)), node = NULL);
			item = next;
		}
	}
}

vec *mget(hashtable *ht, void *key)
{
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL);
	vec *v = kv->v;
	return v;
}

void mput(hashtable *ht, void *key, void *value)
{
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL);
	vec *v = kv->v;
	if(v == NULL)
	{
		kv->v = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
		vec_init_el_size(kv->v, sizeof(void*), (1));
		v = kv->v;
	}
	*(void**)vec_push(v) = value;
}

void *mget1(hashtable *ht, void *key)
{
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL);
	vec *v = kv->v;
	if(v && ((v->size)) == 1)
	{
		return *(void**)((vec_element(v, 0)));
	}
	else
	{
		return NULL;
	}
}

ssize_t mgetc(hashtable *ht, void *key)
{
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL);
	vec *v = kv->v;
	return v ? ((v->size)) : 0;
}

void *mget1st(hashtable *ht, void *key)
{
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL);
	vec *v = kv->v;
	if(v && ((v->size)))
	{
		return *(void**)((vec_element(v, 0)));
	}
	else
	{
		return NULL;
	}
}

void *mgetlast(hashtable *ht, void *key)
{
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL);
	vec *v = kv->v;
	if(v && ((v->size)))
	{
		return *(void**)(vec_top(v, 0));
	}
	else
	{
		return NULL;
	}
}

void kv_cstr_to_hashtable(hashtable *ht, cstr kv[][2])
{
	table_cstr_to_hashtable(ht, kv, 2, 0, 1);
}

void table_cstr_to_hashtable(hashtable *ht, void *table, long width, long ki, long vi)
{
	cstr *i = table;
	for(; *i ; i += width)
	{
		(hashtable_add(ht, ((void*)(intptr_t)(i[ki])), ((void*)(intptr_t)(i[vi]))));
	}
}

ssize_t hashtable_already(hashtable *ht, void *key)
{
	if(1 && !(sizeof(ssize_t) <= sizeof(void*)))
	{
		warn("sizeof(ssize_t) %zu is bigger than sizeof(void *) %zu", (sizeof(ssize_t)), (sizeof(void*)));
	}
	ssize_t count, count1;
	key_value *x = (hashtable_lookup_or_add_key(ht, ((void*)(intptr_t)key), ((void*)(intptr_t)(((void*)(intptr_t)0)))));
	count = (ssize_t)((intptr_t)(x->v));
	count1 = count + 1;
	if(!count1)
	{
		count1 = 1;
	}
	x->v = ((void*)(intptr_t)count1);
	return count;
}

unsigned long vos_hash(void *s)
{
	unsigned long rv = 0;
	vec *(skip(1, `my__525_)v1) = (vec*)s;
	cstr *(skip(1, `my__527_)end) = ((vec_element(((skip(1, `my__529_)v1)), ((skip(1, `my__529_)v1))->size)));
	cstr *(skip(1, `my__533_)i1) = ((vec_element(((skip(1, `my__535_)v1)), 0)));
	for(; (skip(1, `my__539_)i1)!=(skip(1, `my__541_)end) ; ++(skip(1, `my__543_)i1))
	{
		typeof((skip(1, `my__545_)i1)) i = (skip(1, `my__545_)i1);
		
		cstr l = *i;
		rv *= 101;
		typeof(((l+strlen(l)))) (skip(1, `my__554_)end) = ((l+strlen(l)));
		typeof(l) (skip(1, `my__559_)v1) = l;
		for(; (skip(1, `my__564_)v1)<(skip(1, `my__566_)end); ++(skip(1, `my__568_)v1))
		{
			typeof((skip(1, `my__570_)v1)) j = (skip(1, `my__570_)v1);
			rv *= 101;
			rv += *j;
		}
	}
	return rv;
}

boolean vos_eq(void *_v1, void *_v2)
{
	vec *v1 = _v1, *v2 = _v2;
	if(((v1->size)) != ((v2->size)))
	{
		return 0;
	}
	cstr *p2 = ((vec_element(v2, 0)));
	vec *(skip(1, `my__583_)v1) = v1;
	cstr *(skip(1, `my__585_)end) = ((vec_element(((skip(1, `my__587_)v1)), ((skip(1, `my__587_)v1))->size)));
	cstr *(skip(1, `my__591_)i1) = ((vec_element(((skip(1, `my__593_)v1)), 0)));
	for(; (skip(1, `my__597_)i1)!=(skip(1, `my__599_)end) ; ++(skip(1, `my__601_)i1))
	{
		typeof((skip(1, `my__603_)i1)) p1 = (skip(1, `my__603_)i1);
		
		if(!cstr_eq(*p1, *p2))
		{
			return 0;
		}
		++p2;
	}
	return 1;
}

void keys(vec *out, hashtable *ht)
{
	void *k, *v;
	list *((skip(1, `my__614_)bucket)) = ht->buckets;
	list *((skip(1, `my__616_)end)) = ((skip(1, `my__614_)bucket)) + ht->size;
	list *(((skip(1, `my__611_)ref))) = ((skip(1, `my__614_)bucket));
	list *((skip(1, `my__618_)next));
	for(; ; (((skip(1, `my__611_)ref))) = ((skip(1, `my__618_)next)))
	{
		while(((skip(1, `my__614_)bucket)) != ((skip(1, `my__616_)end)) && (((skip(1, `my__611_)ref)))->next == NULL)
		{
			++((skip(1, `my__614_)bucket));
			(((skip(1, `my__611_)ref))) = ((skip(1, `my__614_)bucket));
		}
		if(((skip(1, `my__614_)bucket)) == ((skip(1, `my__616_)end)))
		{
			break;
		}
		node_kv *n = (node_kv *)(((skip(1, `my__611_)ref)))->next;
		key_value *(((skip(1, `my__609_)kv))) = &n->kv;
		k = (typeof(k))(((skip(1, `my__609_)kv)))->k;
		v = (typeof(v))(((skip(1, `my__609_)kv)))->v;
		((skip(1, `my__618_)next)) = (((skip(1, `my__611_)ref)))->next;
		*(typeof(k) *)vec_push(out) = k;
	}
}

void values(vec *out, hashtable *ht)
{
	void *k, *v;
	list *((skip(1, `my__628_)bucket)) = ht->buckets;
	list *((skip(1, `my__630_)end)) = ((skip(1, `my__628_)bucket)) + ht->size;
	list *(((skip(1, `my__625_)ref))) = ((skip(1, `my__628_)bucket));
	list *((skip(1, `my__632_)next));
	for(; ; (((skip(1, `my__625_)ref))) = ((skip(1, `my__632_)next)))
	{
		while(((skip(1, `my__628_)bucket)) != ((skip(1, `my__630_)end)) && (((skip(1, `my__625_)ref)))->next == NULL)
		{
			++((skip(1, `my__628_)bucket));
			(((skip(1, `my__625_)ref))) = ((skip(1, `my__628_)bucket));
		}
		if(((skip(1, `my__628_)bucket)) == ((skip(1, `my__630_)end)))
		{
			break;
		}
		node_kv *n = (node_kv *)(((skip(1, `my__625_)ref)))->next;
		key_value *(((skip(1, `my__623_)kv))) = &n->kv;
		k = (typeof(k))(((skip(1, `my__623_)kv)))->k;
		v = (typeof(v))(((skip(1, `my__623_)kv)))->v;
		((skip(1, `my__632_)next)) = (((skip(1, `my__625_)ref)))->next;
		*(typeof(v) *)vec_push(out) = v;
	}
}

void sort_keys(vec *out, hashtable *ht)
{
	keys(out, ht);
	((sort_vec(out, cstr_cmp)));
}

void error(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	verror(format, ap);
	va_end(ap);
}

void verror(const char *format, va_list ap)
{
	buffer struct__b;
	buffer *b = &struct__b;
	(buffer_init(b, 128));
	Vsprintf(b, format, ap);
	buffer_add_nul(b);
	buffer_squeeze(b);
	Throw((b->start), 0, NULL);
}

void serror(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	vserror(format, ap);
	va_end(ap);
}

void vserror(const char *format, va_list ap)
{
	int no = errno;
	buffer struct__b;
	buffer *b = &struct__b;
	(buffer_init(b, 128));
	Vsprintf(b, format, ap);
	Sprintf(b, ": %s", Strerror(no));
	buffer_add_nul(b);
	buffer_squeeze(b);
	Throw((b->start), no, NULL);
}

void warn(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	vwarn(format, ap);
	va_end(ap);
}

void vwarn(const char *format, va_list ap)
{
	size_t (skip(1, `my__654_)len) = strlen(format);
	char format1[(skip(1, `my__656_)len)+2];
	char *(skip(1, `my__658_)e) = format1 + (skip(1, `my__660_)len);
	strcpy(format1, format);
	*(skip(1, `my__662_)e) = '\n';
	(skip(1, `my__664_)e)[1] = '\0';
	fflush(stdout);
	vfprintf(stderr, format1, ap);
	if(mingw)
	{
		fflush(stderr);
	}
}

void failed(const char *funcname)
{
	serror("%s failed", funcname);
}

void failed2(const char *funcname, const char *errmsg)
{
	serror("%s failed: %s", funcname, errmsg);
}

void failed3(const char *funcname, const char *msg1, const char *msg2)
{
	serror("%s failed: %s, %s", funcname, msg1, msg2);
}

void warn_failed(const char *funcname)
{
	swarning("%s failed", funcname);
}

void swarning(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	vswarning(format, ap);
	va_end(ap);
}

void vswarning(const char *format, va_list ap)
{
	fflush(stdout);
	Vfprintf(stderr, format, ap);
	fprintf(stderr, ": ");
	Perror(NULL);
	if(mingw)
	{
		fflush(stderr);
	}
}

void memdump(const char *from, const char *to)
{
	Fflush(stdout);
	while(from != to)
	{
		Fprintf(stderr, "%02x ", (const unsigned char)*from);
		++from;
	}
	Fprintf(stderr, "\n");
	if(mingw)
	{
		Fflush(stderr);
	}
}

void fsay_usage_(FILE *s, cstr *usage)
{
	typeof(usage) i = usage;
	typeof(1) (skip(1, `my__670_)first) = 1;
	for(; *i; ++i)
	{
		if((skip(1, `my__675_)first))
		{
			Fsayf(s, "usage: %s %s", program, *i);
			(skip(1, `my__677_)first) = 0;
		}
		else
		{
			Fsayf(s, "       %s %s", program, *i);
		}
	}
}

void error_init(void)
{
	error_handlers = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
	vec_init_el_size(error_handlers, sizeof(error_handler), (16));
	errors = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
	vec_init_el_size(errors, sizeof(err), (16));
	extra_error_messages = (((hashtable *)(normal_Malloc(1 * sizeof(hashtable)))));
	hashtable_init(extra_error_messages, int_hash, int_eq, 101);
	if(*((Getenv("DEBUG", ""))))
	{
		abort_on_error = 1;
	}
}

err *error_add(cstr msg, int no, void *data)
{
	err *e = vec_push(errors);
	e->msg = msg;
	e->no = no;
	e->data = data;
	return e;
}

void Throw(cstr msg, int no, void *data)
{
	throw_(error_add(msg, no, data));
}

void throw_(err *e)
{
	if((!error_handlers->size))
	{
		die_errors(exit__error);
	}
	error_handler *h = (vec_top(error_handlers, 0));
	if(((&h->handler)->func != NULL))
	{
		if(((*(&h->handler)->func)((&h->handler)->obj, (&h->handler)->common_arg, e)))
		{
			h->jump = NULL;
		}
	}
	if(h->jump)
	{
		vec_pop(error_handlers);
		longjmp(*h->jump, 1);
	}
}

void die_errors(int status)
{
	warn_errors();
	if(abort_on_error)
	{
		abort();
	}
	die = 1;
	Exit(status);
}

void clear_errors(void)
{
	vec *(skip(1, `my__709_)v1) = errors;
	err *(skip(1, `my__711_)end) = ((vec_element(((skip(1, `my__713_)v1)), ((skip(1, `my__713_)v1))->size)));
	err *(skip(1, `my__717_)i1) = ((vec_element(((skip(1, `my__719_)v1)), 0)));
	for(; (skip(1, `my__723_)i1)!=(skip(1, `my__725_)end) ; ++(skip(1, `my__727_)i1))
	{
		typeof((skip(1, `my__729_)i1)) e = (skip(1, `my__729_)i1);
		
		((free(e->msg)), (e->msg) = NULL);
		((free(e->data)), (e->data) = NULL);
	}
	vec_size(errors, 0);
}

void warn_errors(void)
{
	warn_errors_keep();
	clear_errors();
}

void warn_errors_keep(void)
{
	vec *(skip(1, `my__742_)v1) = errors;
	err *(skip(1, `my__744_)end) = ((vec_element(((skip(1, `my__746_)v1)), ((skip(1, `my__746_)v1))->size)));
	err *(skip(1, `my__750_)i1) = ((vec_element(((skip(1, `my__752_)v1)), 0)));
	for(; (skip(1, `my__756_)i1)!=(skip(1, `my__758_)end) ; ++(skip(1, `my__760_)i1))
	{
		typeof((skip(1, `my__762_)i1)) e = (skip(1, `my__762_)i1);
		
		warn("%s", e->msg);
	}
}

void debug_errors(void)
{
	debug_errors_keep();
	clear_errors();
}

void debug_errors_keep(void)
{
	vec *(skip(1, `my__768_)v1) = errors;
	err *(skip(1, `my__770_)end) = ((vec_element(((skip(1, `my__772_)v1)), ((skip(1, `my__772_)v1))->size)));
	err *(skip(1, `my__776_)i1) = ((vec_element(((skip(1, `my__778_)v1)), 0)));
	for(; (skip(1, `my__782_)i1)!=(skip(1, `my__784_)end) ; ++(skip(1, `my__786_)i1))
	{
		typeof((skip(1, `my__788_)i1)) e = (skip(1, `my__788_)i1);
		
		(void)e;
		
	}
}

void fault_(char *file, int line, const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	vfault_(file, line, format, ap);
	va_end(ap);
}

void vfault_(char *file, int line, const char *format, va_list ap)
{
	file = ((path_under_maybe(main_dir, path_tidy(((normal_Strdup(file)))))));
	buffer struct__b;
	buffer *b = &struct__b;
	(buffer_init(b, 128));
	Sprintf(b, "%s:%d: ", file, line);
	Vsprintf(b, format, ap);
	buffer_add_nul(b);
	buffer_squeeze(b);
	if(throw_faults)
	{
		Throw(((b->start)), 0, NULL);
	}
	else
	{
		error_add(((b->start)), 0, NULL);
		die_errors(exit__fault);
	}
}

void add_error_message(int errnum, cstr message)
{
	hashtable_add(extra_error_messages, ((void*)(intptr_t)errnum), message);
}

cstr Strerror(int errnum)
{
	key_value *kv = hashtable_lookup(extra_error_messages, ((void*)(intptr_t)errnum));
	if(kv == NULL)
	{
		return strerror(errnum);
	}
	else
	{
		return kv->v;
	}
}

void Perror(const char *s)
{
	cstr msg = Strerror(errno);
	if(s)
	{
		warn("%s: %s", s, msg);
	}
	else
	{
		warn("%s", msg);
	}
}

void *error_warn(void *obj, void *common_arg, void *er)
{
	(void)obj;
	(void)common_arg;
	fflush(stdout);
	fprintf(stderr, "%s\n", ((err*)er)->msg);
	if(mingw)
	{
		fflush(stderr);
	}
	vec_pop(errors);
	return (((void*)(intptr_t)1));
}

void *error_ignore(void *obj, void *common_arg, void *er)
{
	(void)obj;
	(void)common_arg;
	(void)er;
	vec_pop(errors);
	return (((void*)(intptr_t)1));
}

any opt_err_do(opt_err opt, any value, any errcode, char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(vopt_err_do(opt, value, errcode, format, ap)) rv = vopt_err_do(opt, value, errcode, format, ap);
	va_end(ap);
	return rv;
}

any vopt_err_do(opt_err opt, any value, any errcode, char *format, va_list ap)
{
	if(opt & OE_WARN || opt == OE_ERROR)
	{
		opt &= ~OE_WARN;
		if(opt == OE_ERROR)
		{
			verror(format, ap);
		}
		else
		{
			vwarn(format, ap);
		}
	}
	switch(opt)
	{
	case OE_CONT:	return value;
		break;
	case OE_ERRCODE:	return errcode;
		break;
	default:	failed2("vopt_err_do", "unknown opt_err option");
	}
	return errcode;
}

void Debug(cstr format, ...)
{
	va_list ap;
	va_start(ap, format);
	vDebug(format, ap);
	va_end(ap);
}

void vDebug(cstr format, va_list ap)
{
	if(debugging)
	{
		vwarn(format, ap);
	}
}

void Debug_errors(void)
{
	if(debugging)
	{
		warn_errors();
	}
	else
	{
		clear_errors();
	}
}

void Atexit(void (*function)(void))
{
	if(atexit(function) != 0)
	{
		failed("atexit");
	}
}

void Exit(int status)
{
	if(process__forked)
	{
		if(process__exit_fflush)
		{
			Fflush(NULL);
		}
		_Exit(status);
	}
	exit(status);
}

void Execv(const char *path, char *const argv[])
{
	execv(path, argv);
	if(exec__warn_fail)
	{
		warn_failed("execv");
	}
	exit_exec_failed();
}

void Execvp(const char *file, char *const argv[])
{
	execvp(file, argv);
	if(exec__warn_fail)
	{
		warn_failed("execvp");
	}
	exit_exec_failed();
}

void Execve(const char *filename, char *const argv[], char *const envp[])
{
	execve(filename, argv, envp);
	if(exec__warn_fail)
	{
		warn_failed("execve");
	}
	exit_exec_failed();
}

static void exec_argv_do_init(void)
{
	vec_init_el_size(&exec_argv, sizeof(cstr), (10));
	exec_argv_init = 1;
}

void Execl(const char *path, ...)
{
	va_list ap;
	va_start(ap, path);
	Vexecl(path, ap);
	va_end(ap);
}

void Vexecl(const char *path, va_list ap)
{
	if(!exec_argv_init)
	{
		exec_argv_do_init();
	}
	vec_clear(&exec_argv);
	while(1)
	{
		char *arg = va_arg(ap, char *);
		if(arg == NULL)
		{
			break;
		}
		*(char **)vec_push(&exec_argv) = arg;
	}
	Execv(path, (char *const *)vec_to_array(&exec_argv));
}

void Execlp(const char *file, ...)
{
	va_list ap;
	va_start(ap, file);
	Vexeclp(file, ap);
	va_end(ap);
}

void Vexeclp(const char *file, va_list ap)
{
	if(!exec_argv_init)
	{
		exec_argv_do_init();
	}
	vec_clear(&exec_argv);
	while(1)
	{
		char *arg = va_arg(ap, char *);
		if(arg == NULL)
		{
			break;
		}
		*(char **)vec_push(&exec_argv) = arg;
	}
	Execvp(file, (char *const *)vec_to_array(&exec_argv));
}

void Execle(const char *path, ...)
{
	va_list ap;
	va_start(ap, path);
	Vexecle(path, ap);
	va_end(ap);
}

void Vexecle(const char *path, va_list ap)
{
	if(!exec_argv_init)
	{
		exec_argv_do_init();
	}
	vec_clear(&exec_argv);
	while(1)
	{
		char *arg = va_arg(ap, char *);
		if(arg == NULL)
		{
			break;
		}
		*(char **)vec_push(&exec_argv) = arg;
	}
	char *const *envp = va_arg(ap, char *const *);
	Execve(path, (char *const *)vec_to_array(&exec_argv), envp);
}

void sh_quote(const char *from, buffer *to)
{
	char c;
	int i = ((ssize_t)((to->end)-(to->start)));
	while(1)
	{
		c = *from;
		if(c == '\0')
		{
			break;
		}
		if((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || strchr("-_./", c) != NULL)
		{
			buffer_set_size(to, i+1);
			to->start[i] = c;
			++i;
		}
		else if(c == '\n')
		{
			buffer_set_size(to, i+3);
			to->start[i] = '"';
			to->start[i+1] = c;
			to->start[i+2] = '"';
			i += 3;
		}
		else
		{
			buffer_set_size(to, i+2);
			to->start[i] = '\\';
			to->start[i+1] = c;
			i += 2;
		}
		++from;
	}
	buffer_nul_terminate(to);
}

void cmd_quote(const char *from, buffer *to)
{
	typeof(strchr(from, ' ') != NULL) quote = strchr(from, ' ') != NULL;
	if(quote)
	{
		buffer_cat_char(to, '"');
	}
	buffer_cat_cstr(to, (cstr)from);
	if(quote)
	{
		buffer_cat_char(to, '"');
	}
	buffer_nul_terminate(to);
}

int System(const char *s)
{
	if(system_verbose)
	{
		warn(s);
	}
	int status = system(s);
	if(status == -1)
	{
		failed("system");
	}
	if(WIFEXITED(status))
	{
		return WEXITSTATUS(status);
	}
	return -1;
}

int Systemf(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(Vsystemf(format, ap)) rv = Vsystemf(format, ap);
	va_end(ap);
	return rv;
}

void SYSTEM(const char *s)
{
	if(System(s))
	{
		failed2("system", s);
	}
}

void SYSTEMF(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	VSYSTEMF(format, ap);
	va_end(ap);
}

void VSYSTEMF(const char *format, va_list ap)
{
	int rv = Vsystemf(format, ap);
	if(rv)
	{
		failed("system");
	}
}

int Vsystemf(const char *format, va_list ap)
{
	static buffer b;
	static int init = 0;
	if(!init)
	{
		buffer_init(&b, 32);
		init = 1;
	}
	buffer_clear(&b);
	Vsprintf(&b, format, ap);
	return System(b.start);
}

sighandler_t Signal(int signum, sighandler_t handler)
{
	sighandler_t rv = signal(signum, handler);
	if(rv == SIG_ERR)
	{
		failed("signal");
	}
	return rv;
}

int Systema_q(boolean quote, const char *filename, char *const argv[])
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 256);
	system_quote_check_uq(quote, filename, b);
	while (*argv) {
	{
		buffer_cat_char(b, ' ');
		system_quote_check_uq(quote, *argv, b);
		++argv;
	}
	}
	cstr command = buffer_to_cstr(b);
	typeof(System(command)) rv = System(command);
	buffer_free(b);
	uq_clean();
	return rv;
}

void system_quote_check_uq(boolean quote, const char *s, buffer *b)
{
	if(quote && !is_uq(s))
	{
		sh_quote(s, b);
	}
	else
	{
		buffer_cat_cstr(b, s);
	}
}

int Systemv_q(boolean quote, const char *filename, char *const argv[])
{
	return Systema_q(quote, filename, argv+1);
}

int Systeml__q(boolean quote, const char *filename, ...)
{
	va_list ap;
	va_start(ap, filename);
	typeof(Vsysteml_q(quote, filename, ap)) rv = Vsysteml_q(quote, filename, ap);
	va_end(ap);
	return rv;
}

int Systeml_(const char *filename, ...)
{
	va_list ap;
	va_start(ap, filename);
	typeof((Vsysteml_q(1, filename, ap))) rv = (Vsysteml_q(1, filename, ap));
	va_end(ap);
	return rv;
}

int Systemlu_(const char *filename, ...)
{
	va_list ap;
	va_start(ap, filename);
	typeof((Vsysteml_q(0, filename, ap))) rv = (Vsysteml_q(0, filename, ap));
	va_end(ap);
	return rv;
}

int Vsysteml_q(boolean quote, const char *filename, va_list ap)
{
	if(!exec_argv_init)
	{
		exec_argv_do_init();
	}
	vec_clear(&exec_argv);
	*(const char **)vec_push(&exec_argv) = filename;
	while(1)
	{
		char *arg = va_arg(ap, char *);
		if(arg == NULL)
		{
			break;
		}
		*(char **)vec_push(&exec_argv) = arg;
	}
	return Systemv_q(quote, filename, (char *const *)vec_to_array(&exec_argv));
}

cstr cmd(cstr c)
{
	FILE *f = Popen(c, "r");
	cstr rv = buffer_to_cstr(fslurp_1(f));
	Pclose(f);
	return rv;
}

sighandler_t Sigact(int signum, sighandler_t handler, int sa_flags)
{
	sighandler_t rv = sigact(signum, handler, sa_flags);
	if(rv == SIG_ERR)
	{
		failed("sigact");
	}
	return rv;
}

void call_sighandler(sighandler_t h, int sig)
{
	if(h == SIG_DFL)
	{
		(Sigact(sig, SIG_DFL, 0));
		kill(getpid(), sig);
	}
	else if(h != SIG_IGN)
	{
		h(sig);
	}
}

void Raise(int sig)
{
	if(raise(sig))
	{
		failed("raise");
	}
}

void catch_signal_null(int sig)
{
	(void)sig;
}

int fix_exit_status(int status)
{
	if(WIFEXITED(status))
	{
		status = WEXITSTATUS(status);
		if(!sig_execfailed && status == exit__execfailed)
		{
			status = status__execfailed;
		}
	}
	else if(WIFSIGNALED(status))
	{
		status = 256 + 128 + WTERMSIG(status);
		if(sig_execfailed && status == 256 + 128 + sig_execfailed)
		{
			status = status__execfailed;
		}
	}
	else
	{
		fault_(__FILE__, __LINE__, "unknown exit status %d - perhaps child stop/cont.\nSet your SIGCHLD handler with Sigact or Sigintr to avoid this.", status);
	}
	return status;
}

void hold_term_open(void)
{
	warn("\ndone, press enter to close the terminal");
	buffer struct__b;
	buffer *b = &struct__b;
	(buffer_init(b, 128));
	Freadline(b, stdin);
}

void Uname(struct utsname *buf)
{
	if(!uname(buf))
	{
		failed("uname");
	}
}

void uq_init(void)
{
	uq_vec = &struct__uq_vec;
	vec_init_el_size(uq_vec, sizeof(cstr), (16));
}

cstr uq(const char *s)
{
	if(!uq_vec)
	{
		uq_init();
	}
	char *s1 = (normal_Strdup(s));
	*(typeof(s1) *)vec_push(uq_vec) = s1;
	return s1;
}

boolean is_uq(const char *s)
{
	if(uq_vec)
	{
		vec *(skip(1, `my__881_)v1) = uq_vec;
		cstr *(skip(1, `my__883_)end) = ((vec_element(((skip(1, `my__885_)v1)), ((skip(1, `my__885_)v1))->size)));
		cstr *(skip(1, `my__889_)i1) = ((vec_element(((skip(1, `my__891_)v1)), 0)));
		for(; (skip(1, `my__895_)i1)!=(skip(1, `my__897_)end) ; ++(skip(1, `my__899_)i1))
		{
			typeof((skip(1, `my__901_)i1)) i = (skip(1, `my__901_)i1);
			
			if(*i == s)
			{
				return 1;
			}
		}
	}
	return 0;
}

void uq_clean(void)
{
	if(uq_vec)
	{
		vec *(skip(1, `my__907_)v1) = uq_vec;
		cstr *(skip(1, `my__909_)end) = ((vec_element(((skip(1, `my__911_)v1)), ((skip(1, `my__911_)v1))->size)));
		cstr *(skip(1, `my__915_)i1) = ((vec_element(((skip(1, `my__917_)v1)), 0)));
		for(; (skip(1, `my__921_)i1)!=(skip(1, `my__923_)end) ; ++(skip(1, `my__925_)i1))
		{
			typeof((skip(1, `my__927_)i1)) i = (skip(1, `my__927_)i1);
			
			((free(*i)), (*i) = NULL);
		}
		vec_clear(uq_vec);
	}
}

void q_init(void)
{
	q_vec = &struct__q_vec;
	vec_init_el_size(q_vec, sizeof(cstr), (16));
}

cstr q(const char *s)
{
	if(!q_vec)
	{
		q_init();
	}
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 128);
	sh_quote(s, b);
	cstr q = buffer_to_cstr(b);
	*(typeof(q) *)vec_push(q_vec) = q;
	return q;
}

void q_clean(void)
{
	if(q_vec)
	{
		vec *(skip(1, `my__943_)v1) = q_vec;
		cstr *(skip(1, `my__945_)end) = ((vec_element(((skip(1, `my__947_)v1)), ((skip(1, `my__947_)v1))->size)));
		cstr *(skip(1, `my__951_)i1) = ((vec_element(((skip(1, `my__953_)v1)), 0)));
		for(; (skip(1, `my__957_)i1)!=(skip(1, `my__959_)end) ; ++(skip(1, `my__961_)i1))
		{
			typeof((skip(1, `my__963_)i1)) i = (skip(1, `my__963_)i1);
			
			((free(*i)), (*i) = NULL);
		}
		vec_clear(q_vec);
	}
}

cstr qq(cstr s)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, PATH_MAX);
	buffer_cat_char(b, '"');
	sh_quote(s, b);
	buffer_cat_char(b, '"');
	return buffer_to_cstr(b);
}

cstr x(cstr command)
{
	FILE *s = Popen(command, "r");
	cstr rv = buffer_to_cstr(fslurp_1(s));
	Pclose(s);
	return rv;
}

void sh_unquote(cstr s)
{
	char *o = s;
	while(*s)
	{
		if(*s == '\\')
		{
			++s;
		}
		*o++ = *s++;
	}
	*o = '\0';
}

char *sh_unquote_full(cstr s)
{
	char *o = s;
	while(*s)
	{
		if(*s == '\'')
		{
			while(*s != '\'')
			{
				*o++ = *s++;
			}
			++s;
		}
		else if(*s == '\"')
		{
			while(*s != '\"')
			{
				if(*s == '\\')
				{
					++s;
				}
				*o++ = *s++;
			}
			++s;
		}
		else if(isspace((unsigned char)*s))
		{
			*o++ = '\0';
			++s;
		}
		else
		{
			if(*s == '\\')
			{
				++s;
			}
			*o++ = *s++;
		}
	}
	*o = '\0';
	return o;
}

pid_t Fork(void)
{
	if(process__fork_fflush)
	{
		Fflush(NULL);
	}
	pid_t pid = fork();
	if(pid == -1)
	{
		failed("fork");
	}
	else if(pid == 0)
	{
		process__forked = 1;
	}
	return pid;
}

pid_t Waitpid(pid_t pid, int *status, int options)
{
	pid_t r_pid;
	while(1)
	{
		r_pid = waitpid(pid, status, options);
		if(r_pid == -1)
		{
			if(errno != EINTR)
			{
				failed("waitpid");
			}
		}
		else
		{
			return r_pid;
		}
	}
}

int Child_wait(pid_t pid)
{
	Waitpid(pid, &wait__status, 0);
	wait__status = fix_exit_status(wait__status);
	return wait__status;
}

pid_t Child_done(void)
{
	pid_t pid = Waitpid(-1, &wait__status, WNOHANG);
	if(pid)
	{
		wait__status = fix_exit_status(wait__status);
	}
	return pid;
}

pid_t Waitpid_intr(pid_t pid, int *status, int options)
{
	pid_t r_pid = waitpid(pid, status, options);
	if(r_pid == -1 && errno != EINTR)
	{
		failed("waitpid");
	}
	return r_pid;
}

void Sched_setscheduler(pid_t pid, int policy, const sched_param *p)
{
	if(sched_setscheduler(pid, policy, p) == -1)
	{
		failed("sched_setscheduler");
	}
}

void set_priority(pid_t pid, int priority)
{
	sched_param struct__param;
	sched_param *param = &struct__param;
	(bzero(param, sizeof(*param)));
	param->sched_priority = priority;
	Sched_setscheduler(pid, SCHED_FIFO, param);
}

cstr whoami(void)
{
	return (normal_Strdup(Getpwuid(geteuid())->pw_name));
}

int auth(User *u, cstr pass)
{
	return auth_pw((passwd *)u, pass);
}

int auth_pw(passwd *pw, cstr pass)
{
	char *x = pw->pw_passwd;
	char salt[64];
	char *dollar = strrchr(x, '$');
	if(!dollar)
	{
		return 0;
	}
	int l = dollar - x;
	if(1 && !((l < (int)sizeof(salt))))
	{
		fault_(__FILE__, __LINE__, "auth: salt too long");
	}
	strlcpy(salt, x, l+1);
	salt[l] = '\0';
	return cstr_eq(x, crypt(pass, salt)) && !cstr_eq(pw->pw_shell, "/bin/false");
}

void Setgroups(size_t size, const gid_t *list)
{
	if(setgroups(size, list))
	{
		failed("setgroups");
	}
}

hashtable *load_users(void)
{
	sym_init();
	hashtable *ht;
	ht = (((hashtable *)(normal_Malloc(1 * sizeof(hashtable)))));
	hashtable_init(ht, cstr_hash, cstr_eq, passwd_n_buckets);
	passwd *p;
	while((p = Getpwent()))
	{
		User *u = passwd_to_user(p);
		(hashtable_add(ht, ((void*)(intptr_t)(u->pw_name)), ((void*)(intptr_t)u)));
	}
	spwd *s;
	while((s = getspent()))
	{
		User *u = (hashtable_value_or_null(ht, ((void*)(intptr_t)(s->sp_namp))));
		if(s->sp_pwdp)
		{
			((free(u->pw_passwd)), (u->pw_passwd) = NULL);
			u->pw_passwd = (normal_Strdup(s->sp_pwdp));
		}
	}
	endspent();
	group *g;
	while((g = Getgrent()))
	{
		User *u = (hashtable_value_or_null(ht, ((void*)(intptr_t)(g->gr_name))));
		if(!u)
		{
			continue;
		}
		char **p = g->gr_mem;
		while(*p)
		{
			++u->n_members;
			++p;
		}
		u->members = ((char * *)(normal_Malloc((u->n_members) * sizeof(char *))));
		u->mids = ((uid_t *)(normal_Malloc((u->n_members) * sizeof(uid_t))));
		char **member = u->members;
		gid_t *mid = u->mids;
		p = g->gr_mem;
		while(*p)
		{
			User *m = (hashtable_value_or_null(ht, ((void*)(intptr_t)(*p))));
			++m->n_groups;
			*member++ = sym(*p);
			*mid++ = m->pw_uid;
			++p;
		}
	}
	endgrent();
	setpwent();
	while((p = Getpwent()))
	{
		User *u = (hashtable_value_or_null(ht, ((void*)(intptr_t)(p->pw_name))));
		u->groups = ((char * *)(normal_Malloc((u->n_groups) * sizeof(char *))));
		u->gids = ((gid_t *)(normal_Malloc((u->n_groups) * sizeof(gid_t))));
		u->n_groups = 0;
	}
	setpwent();
	while((p = Getpwent()))
	{
		User *u = (hashtable_value_or_null(ht, ((void*)(intptr_t)(p->pw_name))));
		int i = 0;
		for(; i<u->n_members ; ++i)
		{
			User *m = (hashtable_value_or_null(ht, ((void*)(intptr_t)(u->members[i]))));
			m->groups[m->n_groups] = u->pw_name;
			m->gids[m->n_groups] = u->pw_gid;
			++m->n_groups;
		}
	}
	endpwent();
	return ht;
}

User *passwd_to_user(passwd *p)
{
	User *u = (((User *)(normal_Malloc(1 * sizeof(User)))));
	*(passwd*)u = *p;
	u->pw_name = sym(p->pw_name);
	u->pw_passwd = (normal_Strdup(p->pw_passwd));
	u->pw_gecos = (normal_Strdup(p->pw_gecos));
	u->pw_dir = (normal_Strdup(p->pw_dir));
	u->pw_shell = sym(p->pw_shell);
	u->n_groups = 0;
	u->groups = NULL;
	u->gids = NULL;
	u->n_members = 0;
	u->members = NULL;
	u->mids = NULL;
	return u;
}

void user_free(User *u)
{
	((free(u->pw_passwd)), (u->pw_passwd) = NULL);
	((free(u->pw_gecos)), (u->pw_gecos) = NULL);
	((free(u->pw_dir)), (u->pw_dir) = NULL);
	((free(u->members)), (u->members) = NULL);
	((free(u->mids)), (u->mids) = NULL);
	((free(u)), u = NULL);
}

struct passwd *Getpwent(void)
{
	struct passwd *rv;
	errno = 0;
	rv = getpwent();
	if(!rv && errno)
	{
		failed("getpwent");
	}
	return rv;
}

struct passwd *Getpwnam(const char *name)
{
	struct passwd *rv;
	errno = 0;
	rv = getpwnam(name);
	if(!rv && errno)
	{
		failed("getpwnam");
	}
	return rv;
}

struct passwd *Getpwuid(uid_t uid)
{
	struct passwd *rv;
	errno = 0;
	rv = getpwuid(uid);
	if(!rv && errno)
	{
		failed("getpwuid");
	}
	return rv;
}

struct group *Getgrent(void)
{
	struct group *rv;
	errno = 0;
	rv = getgrent();
	if(!rv && errno)
	{
		failed("getgrent");
	}
	return rv;
}

struct spwd *Getspent(void)
{
	struct spwd *rv;
	errno = 0;
	rv = getspent();
	if(!rv && errno)
	{
		failed("getspent");
	}
	return rv;
}

struct spwd *Getspnam(const char *name)
{
	struct spwd *rv;
	errno = 0;
	rv = getspnam(name);
	if(!rv && errno)
	{
		failed("getspnam");
	}
	return rv;
}

void Setuid(uid_t uid)
{
	if(setuid(uid))
	{
		failed("setuid");
	}
}

void Setgid(gid_t gid)
{
	if(setgid(gid))
	{
		failed("setgid");
	}
}

void Seteuid(uid_t euid)
{
	if(seteuid(euid))
	{
		failed("seteuid");
	}
}

void Setegid(gid_t egid)
{
	if(setegid(egid))
	{
		failed("setegid");
	}
}

void Setreuid(uid_t ruid, uid_t euid)
{
	if(setreuid(ruid, euid))
	{
		failed("setreuid");
	}
}

void Setregid(gid_t rgid, gid_t egid)
{
	if(setregid(rgid, egid))
	{
		failed("setregid");
	}
}

sighandler_t sigact(int signum, sighandler_t handler, int sa_flags)
{
	struct sigaction act, oldact;
	act.sa_handler = handler;
	sigemptyset(&act.sa_mask);
	act.sa_flags = sa_flags;
	if(sigaction(signum, &act, &oldact) < 0)
	{
		return SIG_ERR;
	}
	return oldact.sa_handler;
}

void Sigprocmask(int how, const sigset_t *set, sigset_t *oldset)
{
	if(sigprocmask(how, set, oldset))
	{
		failed("sigprocmask");
	}
}

sigset_t Sig_defer(int signum)
{
	return Sig_mask(signum, 1);
}

sigset_t Sig_pass(int signum)
{
	return Sig_mask(signum, 0);
}

sigset_t Sig_mask(int signum, int defer)
{
	sigset_t set;
	sigset_t oldset;
	sigemptyset(&set);
	sigaddset(&set, signum);
	Sigprocmask(defer ? SIG_BLOCK : SIG_UNBLOCK, &set, &oldset);
	return oldset;
}

sigset_t Sig_setmask(sigset_t *set)
{
	sigset_t oldset;
	Sigprocmask(SIG_SETMASK, set, &oldset);
	return oldset;
}

sigset_t Sig_getmask(void)
{
	sigset_t oldset;
	Sigprocmask(SIG_SETMASK, NULL, &oldset);
	return oldset;
}

void Sigsuspend(const sigset_t *mask)
{
	if(sigsuspend(mask) < 0 && errno != EINTR)
	{
		failed("sigsuspend");
	}
}

int Sigwait(const sigset_t *mask)
{
	int sig;
	sigwait(mask, &sig);
	return sig;
}

void Nice(int inc)
{
	errno = 0;
	if(nice(inc) == -1 && errno)
	{
		failed("nice");
	}
}

void Sched_yield(void)
{
	if(sched_yield() < 0)
	{
		failed("sched_yield");
	}
}

void exit_exec_failed(void)
{
	if(sig_execfailed)
	{
		(Sigact(sig_execfailed, SIG_DFL, 0));
		Sig_pass(sig_execfailed);
		Raise(sig_execfailed);
	}
	Exit(exit__execfailed);
}

void Sigdfl_all(void)
{
	typeof((SIGRTMAX+1)) (skip(1, `my__1056_)end) = (SIGRTMAX+1);
	typeof(1) (skip(1, `my__1061_)v1) = 1;
	for(; (skip(1, `my__1066_)v1)<(skip(1, `my__1068_)end); ++(skip(1, `my__1070_)v1))
	{
		typeof((skip(1, `my__1072_)v1)) i = (skip(1, `my__1072_)v1);
		if((i == SIGKILL || i == SIGSTOP) || (i>=32 && i<SIGRTMIN))
		{
			continue;
		}
		(sigact(i, SIG_DFL, 0));
	}
}

int Getgrouplist(const char *user, gid_t group, vec *groups)
{
	int ngroups = ((groups->size));
	int rv;
	int count = 0;
	do
	{
		rv = getgrouplist(user, group, (gid_t*)((vec_element(groups, 0))), &ngroups);
		vec_size(groups, ngroups);
	}
	while(rv < 0 && !count++);
	if(rv < 0)
	{
		failed("getgrouplist");
	}
	return ngroups;
}

void vec_init_el_size(vec *v, ssize_t element_size, ssize_t space)
{
	v->space = space ? space : 1;
	buffer_init(&v->b, v->space * element_size);
	v->element_size = element_size;
	v->size = 0;
}

void vec_clear(vec *v)
{
	buffer_clear(&v->b);
	v->size = 0;
}

void vec_free(vec *v)
{
	buffer_free(&v->b);
}

void vec_Free(vec *v)
{
	vec *(skip(1, `my__1085_)v1) = v;
	void* *(skip(1, `my__1087_)end) = ((vec_element(((skip(1, `my__1089_)v1)), ((skip(1, `my__1089_)v1))->size)));
	void* *(skip(1, `my__1093_)i1) = ((vec_element(((skip(1, `my__1095_)v1)), 0)));
	for(; (skip(1, `my__1099_)i1)!=(skip(1, `my__1101_)end) ; ++(skip(1, `my__1103_)i1))
	{
		typeof((skip(1, `my__1105_)i1)) i = (skip(1, `my__1105_)i1);
		
		((free(*i)), (*i) = NULL);
	}
	vec_free(v);
}

void vec_space(vec *v, ssize_t space)
{
	v->space = space ? space : 1;
	buffer_set_space(&v->b, v->space * v->element_size);
}

void vec_size(vec *v, ssize_t size)
{
	ssize_t cap = v->space;
	if(size > cap)
	{
		do
		{
			cap *= 2;
		}
		while(size > cap);
		vec_space(v, cap);
	}
	v->size = size;
	buffer_set_size(&v->b, size * v->element_size);
}

void vec_double(vec *v)
{
	vec_space(v, v->space * 2);
}

void vec_squeeze(vec *v)
{
	vec_space(v, v->size);
}

void *vec_element(vec *v, ssize_t index)
{
	return v->b.start + index * v->element_size;
}

void *vec_top(vec *v, ssize_t index)
{
	return vec_element(v, v->size - 1 - index);
}

void *vec_push(vec *v)
{
	if(v->size == v->space)
	{
		vec_double(v);
	}
	++v->size;
	buffer_grow(&v->b, v->element_size);
	return vec_element(v, v->size-1);
}

void vec_pop(vec *v)
{
	--v->size;
	buffer_grow(&v->b, - v->element_size);
}

void vec_grow(vec *v, ssize_t delta_size)
{
	vec_size(v, ((v->size)) + delta_size);
}

void vec_grow_squeeze(vec *v, ssize_t delta_size)
{
	ssize_t size = ((v->size)) + delta_size;
	vec_space(v, size);
	vec_size(v, size);
}

vec *vec_dup_0(vec *from)
{
	return vec_dup((((vec *)(normal_Malloc(1 * sizeof(vec))))), from);
}

vec *vec_dup(vec *to, vec *from)
{
	buffer_dup(&to->b, &from->b);
	to->element_size = from->element_size;
	to->space = from->space;
	to->size = from->size;
	return to;
}

void vec_ensure_size(vec *v, ssize_t size)
{
	if((v->size) < size)
	{
		vec_size(v, size);
	}
}

void *vec_to_array(vec *v)
{
	*(typeof(NULL) *)vec_push(v) = NULL;
	vec_squeeze(v);
	vec_pop(v);
	return (vec_element(v, 0));
}

void array_to_vec(vec *v, void *a)
{
	v->b.start = a;
	v->element_size = sizeof(void*);
	v->size = arylen(a);
	v->space = v->size + 1;
	vec_recalc_buffer(v);
}

void vec_splice(vec *v, ssize_t i, ssize_t cut, void *in, ssize_t ins)
{
	ssize_t e = (v->element_size);
	buf_splice(&v->b, i*e, cut*e, in, ins*e);
	v->size += ins - cut;
	v->space = ((ssize_t)((&v->b)->space_end - (&v->b)->start)) / e;
}

vec *Subvec(vec *v, ssize_t i, ssize_t n, ssize_t extra)
{
	vec *sub = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
	subvec(sub, v, i, n);
	buf_dup_guts(&sub->b, extra * (sub->element_size));
	sub->space += extra;
	return sub;
}

vec *subvec(vec *sub, vec *v, ssize_t i, ssize_t n)
{
	ssize_t e = (v->element_size);
	subbuf(&sub->b, &v->b, i*e, n*e);
	sub->element_size = e;
	sub->space = sub->size = n;
	return sub;
}

void vec_recalc_from_buffer(vec *v)
{
	v->space = ((ssize_t)((&v->b)->space_end - (&v->b)->start)) / v->element_size;
	v->size = ((ssize_t)(((&v->b)->end)-((&v->b)->start))) / v->element_size;
}

void vec_recalc_buffer(vec *v)
{
	v->b.end = v->b.start + v->element_size * v->size;
	v->b.space_end = v->b.start + v->element_size * v->space;
}

void vec_append_vec(vec *v0, vec *v1)
{
	((vec_splice(v0, (((v0->size))), 0, ((((vec_element(v1, 0))))), ((((v1->size)))))));
}

void vov_free(vec *v)
{
	vec *(skip(1, `my__1154_)v1) = v;
	vec* *(skip(1, `my__1156_)end) = ((vec_element(((skip(1, `my__1158_)v1)), ((skip(1, `my__1158_)v1))->size)));
	vec* *(skip(1, `my__1162_)i1) = ((vec_element(((skip(1, `my__1164_)v1)), 0)));
	for(; (skip(1, `my__1168_)i1)!=(skip(1, `my__1170_)end) ; ++(skip(1, `my__1172_)i1))
	{
		typeof((skip(1, `my__1174_)i1)) i = (skip(1, `my__1174_)i1);
		
		vec_free(*i);
	}
}

void vov_free_maybe_null(vec *v)
{
	vec *(skip(1, `my__1180_)v1) = v;
	vec* *(skip(1, `my__1182_)end) = ((vec_element(((skip(1, `my__1184_)v1)), ((skip(1, `my__1184_)v1))->size)));
	vec* *(skip(1, `my__1188_)i1) = ((vec_element(((skip(1, `my__1190_)v1)), 0)));
	for(; (skip(1, `my__1194_)i1)!=(skip(1, `my__1196_)end) ; ++(skip(1, `my__1198_)i1))
	{
		typeof((skip(1, `my__1200_)i1)) i = (skip(1, `my__1200_)i1);
		
		if(*i)
		{
			vec_free(*i);
		}
	}
}

vec *vec1(void *e)
{
	vec *v;
	v = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
	vec_init_el_size(v, sizeof(void*), (1));
	*(typeof(e) *)vec_push(v) = e;
	return v;
}

void cstr_dos_to_unix(cstr s)
{
	cstr p1, p2;
	for(p1=p2=s; *p1 != '\0'; ++p1)
	{
		if(*p1 != '\r')
		{
			*p2 = *p1;
			++p2;
		}
	}
	*p2 = '\0';
}

cstr cstr_unix_to_dos(cstr s)
{
	cstr p1;
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, strlen(s)*1.5);
	for(p1=s; *p1 != 0; ++p1)
	{
		if(*p1 == '\n')
		{
			buffer_cat_char(b, '\r');
			buffer_cat_char(b, '\n');
		}
		else
		{
			buffer_cat_char(b, *p1);
		}
	}
	return buffer_to_cstr(b);
}

cstr cstr_chomp(cstr s)
{
	char *p = s;
	while(*p)
	{
		if(((*p) == '\n' || (*p) == '\r'))
		{
			*p = '\0';
			break;
		}
		p++;
	}
	return s;
}

boolean cstr_eq(void *s1, void *s2)
{
	return strcmp(s1, s2) == 0;
}

boolean cstr_case_eq(void *s1, void *s2)
{
	return strcasecmp(s1, s2) == 0;
}

boolean cstr_is_empty(cstr s1)
{
	return *s1 == '\0';
}

boolean cstr_ends_with(cstr s, cstr substr)
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

boolean cstr_case_ends_with(cstr s, cstr substr)
{
	size_t s_len = strlen(s);
	size_t substr_len = strlen(substr);
	if(substr_len > s_len)
	{
		return 0;
	}
	cstr expect = s + s_len - substr_len;
	return cstr_case_eq(expect, substr);
}

cstr cstr_begins_with(cstr s, cstr substr)
{
	while(1)
	{
		if(*substr == '\0')
		{
			return (cstr)s;
		}
		if(*substr != *s)
		{
			return NULL;
		}
		++s;
		++substr;
	}
}

cstr cstr_case_begins_with(cstr s, cstr substr)
{
	while(1)
	{
		if(*substr == '\0')
		{
			return (cstr)s;
		}
		if(tolower((unsigned char)*substr) != tolower((unsigned char)*s))
		{
			return NULL;
		}
		++s;
		++substr;
	}
}

cstr cstr_from_buffer(buffer *b)
{
	buffer_nul_terminate(b);
	return b->start;
}

cstr cstr_of_size(size_t n)
{
	cstr cs = (normal_Malloc(n + 1));
	cs[n] = '\0';
	return cs;
}

cstr cstr_chop_end(cstr c, cstr end)
{
	(c = normal_Realloc(c, (end - c)));
	return c;
}

cstr cstr_chop_start(cstr c, cstr start)
{
	int len = strlen(start);
	memmove(c, start, len);
	c[len] = '\0';
	return c;
}

void void_cstr(cstr s)
{
	((free(s)), s = NULL);
}

void splitv(vec *v, cstr s, char c)
{
	if(*s)
	{
		splitv1(v, s, c);
	}
}

void splitv1(vec *v, cstr s, char c)
{
	*(typeof(s) *)vec_push(v) = s;
	char *i;
	for(i=s; *i != '\0'; ++i)
	{
		
		if(*i == c)
		{
			*i = '\0';
			*(typeof(i+1) *)vec_push(v) = (i+1);
		}
	}
}

void splitv_dup(vec *v, const char *_s, char c)
{
	char *s = (char *)_s;
	char *i;
	for(i=s; *i != '\0'; ++i)
	{
		
		if(*i == c)
		{
			cstr x = (normal_Strndup(s, (i-s)));
			*(typeof(x) *)vec_push(v) = x;
			s = i+1;
		}
	}
	if(i >= s)
	{
		*(typeof((normal_Strdup(s))) *)vec_push(v) = ((normal_Strdup(s)));
	}
}

cstr *split(cstr s, char c)
{
	vec struct__v;
	vec *v = &struct__v;
	vec_init_el_size(v, sizeof(cstr), (16));
	splitv(v, s, c);
	return vec_to_array(v);
}

cstr *splitn(cstr s, char c, int n)
{
	vec struct__v;
	vec *v = &struct__v;
	vec_init_el_size(v, sizeof(cstr), (16));
	splitvn(v, s, c, n);
	return vec_to_array(v);
}

void splitvn(vec *v, cstr s, char c, int n)
{
	if(*s)
	{
		splitvn1(v, s, c, n);
	}
}

void splitvn1(vec *v, cstr s, char c, int n)
{
	*(typeof(s) *)vec_push(v) = s;
	if(--n)
	{
		char *i;
		for(i=s; *i != '\0'; ++i)
		{
			
			if(*i == c)
			{
				*i = '\0';
				*(typeof(i+1) *)vec_push(v) = (i+1);
				if(--n == 0)
				{
					break;
				}
			}
		}
	}
}

cstr *split_dup(const char *s, char c)
{
	vec struct__v;
	vec *v = &struct__v;
	vec_init_el_size(v, sizeof(cstr), (16));
	splitv_dup(v, s, c);
	return vec_to_array(v);
}

cstr join(char sep, cstr *s)
{
	char sep_cstr[2] = { sep, '\0' };
	return joins(sep_cstr, s);
}

cstr joinv(char sep, vec *v)
{
	return join(sep, vec_to_array(v));
}

cstr joins(cstr sep, cstr *s)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 256);
	if(*s)
	{
		while(1)
		{
			buffer_cat_cstr(b, *s);
			++s;
			if(!*s)
			{
				break;
			}
			buffer_cat_cstr(b, sep);
		}
	}
	return buffer_to_cstr(b);
}

cstr joinsv(cstr sep, vec *v)
{
	return joins(sep, vec_to_array(v));
}

char *Strstr(const char *haystack, const char *needle)
{
	char *rv = strstr(haystack, needle);
	if(!rv)
	{
		error("%s failed", "strstr");
	}
	return rv;
}

char *Strcasestr(const char *haystack, const char *needle)
{
	char *rv = strcasestr(haystack, needle);
	if(!rv)
	{
		error("%s failed", "strcasestr");
	}
	return rv;
}

char *Strchr(const char *s, int c)
{
	char *rv = strchr(s, c);
	if(!rv)
	{
		error("%s failed", "strchr");
	}
	return rv;
}

char *Strrchr(const char *s, int c)
{
	char *rv = strrchr(s, c);
	if(!rv)
	{
		error("%s failed", "strrchr");
	}
	return rv;
}

cstr cstr_tolower(cstr s)
{
	char *i;
	for(i=s; *i != '\0'; ++i)
	{
		
		*i = tolower((unsigned char)*i);
	}
	return s;
}

cstr cstr_toupper(cstr s)
{
	char *i;
	for(i=s; *i != '\0'; ++i)
	{
		
		*i = toupper((unsigned char)*i);
	}
	return s;
}

boolean is_blank(cstr l)
{
	return l[strspn(l, " \t")] == '\0';
}

cstr cstr_begins_with_word(cstr s, cstr substr)
{
	cstr rv = cstr_begins_with(s, substr);
	if(rv)
	{
		if(*rv == ' ')
		{
			return rv+1;
		}
		else if(*rv == '\0')
		{
			return rv;
		}
	}
	return NULL;
}

void cstr_chop(cstr s, long n)
{
	s[strlen(s)-n] = '\0';
}

cstr cstr_begins_with_sym(cstr s, cstr substr)
{
	cstr rv = cstr_begins_with(s, substr);
	if(rv && !isword(*rv))
	{
		return rv;
	}
	return NULL;
}

char *cstr_not_chr(cstr s, char c)
{
	while(*s == c)
	{
		++s;
	}
	return s;
}

cstr make_name(cstr s)
{
	char *i;
	for(i=s; *i != '\0'; ++i)
	{
		
		if(!isword(*i))
		{
			*i = '_';
		}
	}
	return s;
}

size_t Strlcpy(char *dst, char *src, size_t size)
{
	size_t rv;
	rv = strlcpy(dst, src, size);
	if(rv >= size)
	{
		failed2("strlcpy", "dst buffer too small");
	}
	return rv;
}

size_t Strlcat(char *dst, char *src, size_t size)
{
	size_t rv;
	rv = strlcpy(dst, src, size);
	if(rv >= size)
	{
		failed2("strlcpy", "dst buffer too small");
	}
	return rv;
}

long int Strtol(const char *nptr, char **endptr, int base)
{
	errno = 0;
	long int rv = strtol(nptr, endptr, base);
	if(errno)
	{
		failed2("strtol", nptr);
	}
	return rv;
}

long long int Strtoll(const char *nptr, char **endptr, int base)
{
	errno = 0;
	long long int rv = strtoll(nptr, endptr, base);
	if(errno)
	{
		failed2("strtoll", nptr);
	}
	return rv;
}

double Strtod(const char *nptr, char **endptr)
{
	errno = 0;
	double rv = strtod(nptr, endptr);
	if(errno)
	{
		failed2("strtod", nptr);
	}
	return rv;
}

float Strtof(const char *nptr, char **endptr)
{
	errno = 0;
	float rv = strtof(nptr, endptr);
	if(errno)
	{
		failed2("strtof", nptr);
	}
	return rv;
}

long int STRTOL(const char *nptr, int base)
{
	char *endptr;
	errno = 0;
	long int rv = strtol(nptr, &endptr, base);
	if(errno || *endptr)
	{
		warn("strtol failed? %s %ld %p %p %p %d", nptr, rv, nptr, nptr+strlen(nptr), endptr, *endptr);
		failed2("strtol", nptr);
	}
	return rv;
}

long long int STRTOLL(const char *nptr, int base)
{
	char *endptr;
	errno = 0;
	long long int rv = strtoll(nptr, &endptr, base);
	if(errno || *endptr)
	{
		failed2("strtoll", nptr);
	}
	return rv;
}

double STRTOD(const char *nptr)
{
	char *endptr;
	errno = 0;
	double rv = strtod(nptr, &endptr);
	if(errno || *endptr)
	{
		failed2("strtod", nptr);
	}
	return rv;
}

float STRTOF(const char *nptr)
{
	char *endptr;
	errno = 0;
	float rv = strtof(nptr, &endptr);
	if(errno || *endptr)
	{
		failed2("strtof", nptr);
	}
	return rv;
}

size_t strlcpy(char *dst, const char *src, size_t size)
{
	if(size == 0)
	{
		return strlen(src);
	}
	const char *src0 = src;
	do
	{
		if((*dst++ = *src++) == 0)
		{
			break;
		}
	}
	while(--size);
	if(src[-1])
	{
		dst[-1] = '\0';
		while(*src++)
		{
			
		}
	}
	return src - src0 - 1;
}

size_t strlcat(char *dst, const char *src, size_t size)
{
	if(size == 0)
	{
		return strlen(dst)+strlen(src);
	}
	char *dst0 = dst;
	while(*dst && size--)
	{
		++dst;
	}
	return (dst-dst0) + strlcpy(dst, src, size);
}

size_t rope_get_size(rope r)
{
	if((r.s.start <= r.s.end))
	{
		return ((r.s).end - (r.s).start);
	}
	else
	{
		return ropev_get_size(r.v);
	}
}

ropev ropev_ref(rope *start, rope *end)
{
	ropev v = { end, start };
	return v;
}

ropev ropev_of_size(int size)
{
	ropev v;
	v.start = ((rope *)(normal_Malloc(size * sizeof(rope))));
	v.end = v.start + size;
	return v;
}

size_t ropev_get_size(ropev v)
{
	size_t size = 0;
	typeof(((rope *)v.end)) (skip(1, `my__1279_)end) = ((rope *)v.end);
	typeof(((rope *)v.start)) (skip(1, `my__1284_)v1) = ((rope *)v.start);
	for(; (skip(1, `my__1289_)v1)<(skip(1, `my__1291_)end); ++(skip(1, `my__1293_)v1))
	{
		typeof((skip(1, `my__1295_)v1)) i = (skip(1, `my__1295_)v1);
		size += rope_get_size(*i);
	}
	return size;
}

str str_from_rope(rope r)
{
	typeof(str_of_size(rope_get_size(r))) s = str_of_size(rope_get_size(r));
	rope_flatten(s.start, r);
	return s;
}

cstr cstr_from_rope(rope r)
{
	cstr cs = cstr_of_size(rope_get_size(r) + 1);
	rope_flatten(cs, r);
	return cs;
}

char *rope_flatten(char *to, rope r)
{
	if((r.s.start == r.s.end))
	{
		return to;
	}
	else if((r.s.start <= r.s.end))
	{
		return str_copy(to, r.s);
	}
	else
	{
		return ropev_flatten(to, r.v);
	}
}

char *ropev_flatten(char *to, ropev v)
{
	typeof(((rope *)v.end)) (skip(1, `my__1307_)end) = ((rope *)v.end);
	typeof(((rope *)v.start)) (skip(1, `my__1312_)v1) = ((rope *)v.start);
	for(; (skip(1, `my__1317_)v1)<(skip(1, `my__1319_)end); ++(skip(1, `my__1321_)v1))
	{
		typeof((skip(1, `my__1323_)v1)) i = (skip(1, `my__1323_)v1);
		to = rope_flatten(to, *i);
	}
	return to;
}

rope rope_cat_2(rope r1, rope r2)
{
	typeof(ropev_of_size(2)) v = ropev_of_size(2);
	rope *p = v.start;
	*p++ = r1;
	*p = r2;
	return (*(rope *)&v);
}

rope rope_cat_3(rope r1, rope r2, rope r3)
{
	typeof(ropev_of_size(3)) v = ropev_of_size(3);
	rope *p = v.start;
	*p++ = r1;
	*p++ = r2;
	*p = r3;
	return (*(rope *)&v);
}

rope rope_cat_n(size_t n, ...)
{
	va_list ap;
	va_start(ap, n);
	typeof(vrope_cat_n(n, ap)) rv = vrope_cat_n(n, ap);
	va_end(ap);
	return rv;
}

rope vrope_cat_n(size_t n, va_list ap)
{
	typeof(ropev_of_size(n)) v = ropev_of_size(n);
	typeof(((rope *)v.end)) (skip(1, `my__1345_)end) = ((rope *)v.end);
	typeof(((rope *)v.start)) (skip(1, `my__1350_)v1) = ((rope *)v.start);
	for(; (skip(1, `my__1355_)v1)<(skip(1, `my__1357_)end); ++(skip(1, `my__1359_)v1))
	{
		typeof((skip(1, `my__1361_)v1)) i = (skip(1, `my__1361_)v1);
		*i = va_arg(ap, rope);
	}
	return (*(rope *)&v);
}

void rope_dump(rope r, int indent)
{
	typeof(indent) (skip(1, `my__1372_)end) = indent;
	typeof(0) (skip(1, `my__1377_)v1) = 0;
	for(; (skip(1, `my__1382_)v1)<(skip(1, `my__1384_)end); ++(skip(1, `my__1386_)v1))
	{
		typeof((skip(1, `my__1388_)v1)) ((skip(1, `my__1369_)i)) = (skip(1, `my__1388_)v1);
		(void)((skip(1, `my__1393_)i));
		if(0)
		{
			
		}
		else if(putc('\t', stderr) == EOF)
		{
			failed("putc");
		}
	}
	if((r.s.start == r.s.end))
	{
		warn("empty");
	}
	else if((r.s.start <= r.s.end))
	{
		cstr s = (cstr_from_str(r.s));
		warn("str >%s<", s);
		((free(s)), s = NULL);
	}
	else
	{
		warn("ropev: %d", ropev_get_size(r.v));
		ropev_dump(r.v, indent+1);
	}
}

void ropev_dump(ropev v, int indent)
{
	typeof(((rope *)v.end)) (skip(1, `my__1407_)end) = ((rope *)v.end);
	typeof(((rope *)v.start)) (skip(1, `my__1412_)v1) = ((rope *)v.start);
	for(; (skip(1, `my__1417_)v1)<(skip(1, `my__1419_)end); ++(skip(1, `my__1421_)v1))
	{
		typeof((skip(1, `my__1423_)v1)) i = (skip(1, `my__1423_)v1);
		rope_dump(*i, indent);
	}
}

void rope_p_init(rope_p *rp, size_t space)
{
	vec_init_el_size(&rp->stack, sizeof(void *), (space));
}

void rope_p_free(rope_p *rp)
{
	vec_free(&rp->stack);
}

rope_p rope_start(rope r)
{
	rope_p struct__rp;
	rope_p *rp = &struct__rp;
	(rope_p_init(rp, 1));
	*(typeof(r) *)vec_push(&rp->stack) = r;
	rp->ref_type = rope_p_rope;
	rp->where = rope_p_start;
	return *rp;
}

rope_p rope_end(rope r)
{
	rope_p struct__rp;
	rope_p *rp = &struct__rp;
	(rope_p_init(rp, 1));
	*(typeof(r) *)vec_push(&rp->stack) = r;
	rp->ref_type = rope_p_rope;
	rp->where = rope_p_end;
	return *rp;
}

boolean rope_p_is_a_rope(rope_p *rp)
{
	return rp->ref_type == rope_p_rope;
}

boolean rope_p_is_a_char(rope_p *rp)
{
	return rp->ref_type == rope_p_char;
}

void rope_p_enter(rope_p *rp)
{
	if(1 && !((rope_p_is_a_rope(rp))))
	{
		fault_(__FILE__, __LINE__, "rope_p: cannot enter, already at char level");
	}
	rope p = *(rope *)(vec_top((&rp->stack), 0));
	if(1 && !((!(p.s.start == p.s.end))))
	{
		fault_(__FILE__, __LINE__, "rope_p: cannot enter, rope is empty");
	}
	if(1 && !((!(p.s.end == NULL))))
	{
		fault_(__FILE__, __LINE__, "rope_p: cannot enter, rope is null (it shouldn't be!)");
	}
	if(1 && !((rp->where != rope_p_on)))
	{
		fault_(__FILE__, __LINE__, "rope_p: cannot enter, where == on");
	}
	if((p.s.start <= p.s.end))
	{
		if(rp->where == rope_p_start)
		{
			*(typeof(p.s.start) *)vec_push(&rp->stack) = (p.s.start);
		}
		else
		{
			*(typeof(p.s.end) *)vec_push(&rp->stack) = (p.s.end);
			rp->where = rope_p_start;
		}
		rp->ref_type = rope_p_char;
	}
	else
	{
		if(rp->where == rope_p_start)
		{
			*(typeof(p.v.start) *)vec_push(&rp->stack) = (p.v.start);
		}
		else
		{
			*(typeof(p.v.end) *)vec_push(&rp->stack) = (p.v.end);
		}
	}
}

boolean rope_p_at_top(rope_p *rp)
{
	return ((&rp->stack)->size) == 1;
}

void rope_p_leave(rope_p *rp)
{
	if(1 && !((!rope_p_at_top(rp))))
	{
		fault_(__FILE__, __LINE__, "rope_p: cannot leave, already at top level");
	}
	vec_pop(&rp->stack);
}

void rope_p_next(rope_p *rp)
{
	(void)rp;
}

void rope_p_dup(rope_p *to, rope_p *from)
{
	vec_dup(&to->stack, &from->stack);
	to->ref_type = from->ref_type;
	to->where = from->where;
}

void fprint_rope(FILE *stream, rope r)
{
	deq struct__(skip(1, `my__1475_)q);
	deq *(skip(1, `my__1475_)q) = &struct__(skip(1, `my__1475_)q);
	(_deq_init(((skip(1, `my__1475_)q)), sizeof(rope), (1)));
	*(typeof(r) *)deq_push((skip(1, `my__1482_)q)) = r;
	rope (skip(1, `my__1485_)r);
	while((((skip(1, `my__1487_)q))->size))
	{
		typeof(((typeof(&(skip(1, `my__1492_)r)))(((deq_element(((skip(1, `my__1490_)q)), 0)))))) (skip(1, `my__1495_)p) = ((typeof(&(skip(1, `my__1492_)r)))(((deq_element(((skip(1, `my__1490_)q)), 0)))));
		(skip(1, `my__1492_)r) = *(skip(1, `my__1504_)p);
		deq_shift((skip(1, `my__1490_)q));
		if((((skip(1, `my__1506_)r)).s.start == ((skip(1, `my__1506_)r)).s.end))
		{
			continue;
		}
		else if((((skip(1, `my__1509_)r)).v.start <= ((skip(1, `my__1509_)r)).v.end))
		{
			typeof(((rope *)(skip(1, `my__1512_)r).v.end)) (skip(1, `my__1516_)end) = ((rope *)(skip(1, `my__1512_)r).v.end);
			typeof(((rope *)(skip(1, `my__1512_)r).v.start)) (skip(1, `my__1521_)v1) = ((rope *)(skip(1, `my__1512_)r).v.start);
			for(; (skip(1, `my__1526_)v1)<(skip(1, `my__1528_)end); ++(skip(1, `my__1530_)v1))
			{
				typeof((skip(1, `my__1532_)v1)) i = (skip(1, `my__1532_)v1);
				*(typeof(i) *)deq_push((skip(1, `my__1537_)q)) = i;
			}
			continue;
		}
		typeof((skip(1, `my__1540_)r).s) s = (skip(1, `my__1540_)r).s;
		fprint_str(stream, s);
	}
}

void print_rope(rope r)
{
	fprint_rope(stdout, r);
}

void fsay_rope(FILE *stream, rope r)
{
	fprint_rope(stream, r);
	if(0)
	{
		
	}
	else if(putc('\n', stream) == EOF)
	{
		failed("putc");
	}
}

void say_rope(rope r)
{
	fsay_rope(stdout, r);
}

void sym_init(void)
{
	if(!syms)
	{
		syms = &syms__struct;
		hashtable_init(syms, cstr_hash, cstr_eq, syms_n_buckets);
	}
}

cstr sym(cstr s)
{
	if(!syms)
	{
		sym_init();
	}
	list *ref = hashtable_lookup_ref(syms, s);
	if(hashtable_ref_exists(ref))
	{
		key_value *kv = hashtable_ref_key_value(ref);
		return (cstr)kv->k;
	}
	cstr s1 = ((normal_Strdup(s)));
	hashtable_add(syms, s1, NULL);
	return s1;
}

cstr sym_this(cstr s)
{
	if(!syms)
	{
		sym_init();
	}
	list *ref = hashtable_lookup_ref(syms, s);
	if(hashtable_ref_exists(ref))
	{
		key_value *kv = hashtable_ref_key_value(ref);
		((free(s)), s = NULL);
		return (cstr)kv->k;
	}
	hashtable_add(syms, s, NULL);
	return s;
}

cstr path_cat(cstr a, cstr b)
{
	if(cstr_ends_with(a, "/"))
	{
		if(*b)
		{
			return (format("%s%s", a, b));
		}
		else
		{
			return (normal_Strndup(a, (strlen(a)-1)));
		}
	}
	if(cstr_eq(a, "/"))
	{
		return (format("%s%s%s", "", "/", b));
	}
	return (format("%s%s%s", a, "/", b));
}

dirbase dirbasename(cstr path)
{
	dirbase rv;
	typeof(strlen(path)) len = strlen(path);
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
	typeof(path+len-2) slash = path+len-2;
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

cstr dir_name(cstr path)
{
	typeof(dirbasename(path)) rv = dirbasename(path);
	return rv.dir;
}

cstr base_name(cstr path)
{
	typeof(dirbasename(path)) rv = dirbasename(path);
	return rv.base;
}

cstr path_relative_to(cstr path, cstr origin)
{
	if(cstr_begins_with(path, "/"))
	{
		return path;
	}
	origin = (normal_Strdup(origin));
	typeof(dir_name(origin)) dir = dir_name(origin);
	typeof(format("%s" "/" "%s", dir, path)) _path = format("%s" "/" "%s", dir, path);
	((free(origin)), origin = NULL);
	((free(path)), path = NULL);
	return _path;
}

cstr path_tidy(cstr path)
{
	typeof(path) i = path;
	typeof(path) o = path;
	boolean o_uppable = 0;
	boolean abs = 0;
	if(*i == '\0')
	{
		error("path_tidy: empty path not valid");
	}
	if(((*i) == '/'))
	{
		*o++ = '/';
		i++;
		abs = 1;
	}
	while(1)
	{
		if(1 && !(((i == path || ((i[-1]) == '/')) && (o == path || ((o[-1]) == '/')))))
		{
			fault_(__FILE__, __LINE__, "borked in path_tidy");
		}
		if(((*i) == '/'))
		{
			++i;
		}
		else if(i[0] == '.' && (((i[1]) == '/') || (i[1]) == '\0'))
		{
			i += 2;
		}
		else
		{
			boolean dotdot = i[0] == '.' && i[1] == '.' && (((i[2]) == '/') || (i[2]) == '\0');
			if(dotdot && o_uppable)
			{
				i += 3;
				--o_uppable;
				do
				{
					--o;
				}
				while(!(o == path || ((o[-1]) == '/')));
			}
			else if(dotdot && abs)
			{
				i += 3;
			}
			else
			{
				if(1 && !((!dotdot || (dotdot && !abs && !o_uppable))))
				{
					fault_(__FILE__, __LINE__, "borked in path_tidy 2");
				}
				if(!dotdot)
				{
					++o_uppable;
				}
				do
				{
					*o++ = *i++;
				}
				while(!((((i[-1]) == '/') || (i[-1]) == '\0')));
			}
		}
		if(i[-1] == '\0')
		{
			break;
		}
		else if(o != path)
		{
			o[-1] = '/';
		}
	}
	if((o-path > 1 && ((o[-1]) == '/')) ||  (o-path > 0 && o[-1] == '\0'))
	{
		--o;
	}
	if(o == path)
	{
		*o++ = '.';
	}
	*o = '\0';
	(path = normal_Realloc(path, (o - path + 1)));
	return path;
}

cstr path_under(cstr parent, cstr child)
{
	cstr e = cstr_begins_with(child, parent);
	if(e)
	{
		if(((*e) == '/'))
		{
			cstr_chop_start(child, e+1);
			(child = normal_Realloc(child, ((strlen(child))+1)));
			return child;
		}
		else if(*e == '\0')
		{
			((free(child)), child = NULL);
			return (normal_Strdup("."));
		}
	}
	return NULL;
}

cstr path_under_maybe(cstr parent, cstr child)
{
	cstr rv = path_under(parent, child);
	if(rv == NULL)
	{
		rv = child;
	}
	return rv;
}

boolean path_hidden(cstr p)
{
	if(p[0] == '.' && p[1] == '\0')
	{
		return 0;
	}
	while(*p != '\0')
	{
		if(((*p) == '/'))
		{
			++p;
		}
		else if(*p == '.')
		{
			if(((p[1]) == '/'))
			{
				p += 2;
			}
			else if(p[1] == '.' && ((p[2]) == '/'))
			{
				p += 3;
			}
			else
			{
				return 1;
			}
		}
		else
		{
			while(!((*p) == '/'))
			{
				if(*p == '\0')
				{
					return 0;
				}
				++p;
			}
		}
	}
	return 0;
}

boolean path_hidden_normal(cstr p)
{
	return path_hidden(p) && !(p[1] == '\0' || (p[1] == '.' && p[2] == '\0'));
}

boolean path_has_component(cstr path, cstr component)
{
	typeof(format("/" "%s" "/", component)) c0 = format("/" "%s" "/", component);
	typeof(format("/" "%s", component)) c1 = format("/" "%s", component);
	typeof(format("%s" "/", component)) c2 = format("%s" "/", component);
	boolean has = strstr(path, c0) || cstr_ends_with(path, c1) || cstr_begins_with(path, c2) || cstr_eq(path, component);
	((free(c0)), c0 = NULL);
	((free(c1)), c1 = NULL);
	((free(c2)), c2 = NULL);
	return has;
}

cstr path_to_abs(cstr path, cstr cwd)
{
	if(path_is_abs(path))
	{
		return path;
	}
	else
	{
		if(!cwd)
		{
			cwd = Getcwd();
		}
		cstr path1 = path_tidy(path_cat(cwd, path));
		((free(path)), path = NULL);
		return path1;
	}
}

cstr which(cstr file)
{
	cstr PATH = (normal_Strdup((Getenv("PATH", ""))));
	vec struct__v;
	vec *v = &struct__v;
	vec_init_el_size(v, sizeof(cstr), (32));
	splitv(v, PATH, ':');
	cstr path = NULL;
	vec *(skip(1, `my__1682_)v1) = v;
	cstr *(skip(1, `my__1684_)end) = ((vec_element(((skip(1, `my__1686_)v1)), ((skip(1, `my__1686_)v1))->size)));
	cstr *(skip(1, `my__1690_)i1) = ((vec_element(((skip(1, `my__1692_)v1)), 0)));
	for(; (skip(1, `my__1696_)i1)!=(skip(1, `my__1698_)end) ; ++(skip(1, `my__1700_)i1))
	{
		typeof((skip(1, `my__1702_)i1)) dir = (skip(1, `my__1702_)i1);
		
		path = path_cat(*dir, file);
		if(exists(path))
		{
			break;
		}
		((free(path)), path = NULL);
	}
	vec_free(v);
	((free(PATH)), PATH = NULL);
	return path;
}

cstr Which(cstr file)
{
	cstr path = which(file);
	if(!path)
	{
		failed2("which", file);
	}
	return path;
}

void PATH_prepend(cstr dir)
{
	PATH_rm(dir);
	cstr new_PATH = format("%s%c%s", dir, ':', (Getenv("PATH", "")));
	Setenv("PATH", new_PATH, 1);
	((free(new_PATH)), new_PATH = NULL);
}

void PATH_append(cstr dir)
{
	PATH_rm(dir);
	cstr new_PATH = format("%s%c%s", (Getenv("PATH", "")), ':', dir);
	Setenv("PATH", new_PATH, 1);
	((free(new_PATH)), new_PATH = NULL);
}

void PATH_rm(cstr dir)
{
	cstr PATH = (normal_Strdup((Getenv("PATH", ""))));
	vec struct__v;
	vec *v = &struct__v;
	vec_init_el_size(v, sizeof(cstr), (32));
	splitv(v, PATH, ':');
	ssize_t c = ((v->size));
	cstr *((skip(1, `my__1738_)o)) = ((vec_element(v, 0)));
	vec *(skip(1, `my__1744_)v1) = v;
	cstr *(skip(1, `my__1746_)end) = ((vec_element(((skip(1, `my__1748_)v1)), ((skip(1, `my__1748_)v1))->size)));
	cstr *(skip(1, `my__1752_)i1) = ((vec_element(((skip(1, `my__1754_)v1)), 0)));
	for(; (skip(1, `my__1758_)i1)!=(skip(1, `my__1760_)end) ; ++(skip(1, `my__1762_)i1))
	{
		typeof((skip(1, `my__1764_)i1)) i = (skip(1, `my__1764_)i1);
		
		if(((!cstr_eq(*i, dir))))
		{
			*((skip(1, `my__1738_)o))++ = *i;
		}
		else
		{
			
		}
	}
	vec_size(v, ((skip(1, `my__1738_)o))-(cstr *)((vec_element(v, 0))));
	if(((v->size)) != c)
	{
		cstr new_PATH = joinv(':', v);
		Setenv("PATH", new_PATH, 1);
		((free(new_PATH)), new_PATH = NULL);
	}
	((free(PATH)), PATH = NULL);
}

boolean path_is_abs(cstr path)
{
	return ((path[0]) == '/');
}

void Rsleep(num time)
{
	while(1)
	{
		time = rsleep(time);
		if(time == 0)
		{
			break;
		}
		if(time == -1)
		{
			failed("nanosleep");
		}
	}
}

num rsleep(num time)
{
	if(time <= 0)
	{
		return 0;
	}
	struct timespec delay;
	rtime_to_timespec(time, &delay);
	if(nanosleep(&delay, &delay) == -1)
	{
		if(errno == EINTR)
		{
			return timespec_to_rtime(&delay);
		}
		return -1;
	}
	return 0;
}

num rtime(void)
{
	struct timeval tv;
	Gettimeofday(&tv);
	return timeval_to_rtime(&tv);
}

void Gettimeofday(struct timeval *tv)
{
	if((gettimeofday(tv, NULL)) != 0)
	{
		failed("gettimeofday");
	}
}

void Gmtime(double t, datetime *result)
{
	time_t t1 = (time_t)t;
	if(gmtime_r(&t1, result) == NULL)
	{
		failed("gmtime_r");
	}
}

void Localtime(double t, datetime *result)
{
	time_t t1 = (time_t)t;
	if(localtime_r(&t1, result) == NULL)
	{
		failed("localtime_r");
	}
}

int Mktime(datetime *t)
{
	int rv = mktime(t);
	if(rv == -1)
	{
		failed("mktime");
	}
	return rv;
}

void Timef(buffer *b, const datetime *tm, const char *format)
{
	int len;
	while(1)
	{
		b->start[0] = 'x';
		len = strftime(b->end, ((ssize_t)(b->space_end - b->end)), format, tm);
		if(len != 0 || b->start[0] == '\0')
		{
			break;
		}
		buffer_double(b);
	}
	buffer_set_size(b, len + 1);
}

cstr Timef_cstr(datetime *dt, const char *format)
{
	buffer struct__b;
	buffer *b = &struct__b;
	(buffer_init(b, 128));
	Timef(b, dt, format);
	return (b->start);
}

void datetime_init(datetime *dt, int year, int month, int day,  int hour, int min, int sec)
{
	dt->tm_year = year - 1900;
	dt->tm_mon = month - 1;
	dt->tm_mday = day;
	dt->tm_hour = hour;
	dt->tm_min = min;
	dt->tm_sec = sec;
}

void csleep(long double step, boolean sync, boolean use_asleep, boolean rush)
{
	long double t = rtime();
	long double to_sleep;
	if(!csleep_last)
	{
		if(sync)
		{
			long double t1 = (floor(t / step))*step+step;
			to_sleep = t1 - t;
			if(use_asleep)
			{
				asleep(to_sleep, t);
			}
			else
			{
				Rsleep(to_sleep);
			}
			csleep_last = t1;
		}
		else
		{
			if(use_asleep)
			{
				asleep(step, t);
			}
			else
			{
				Rsleep(step);
			}
			csleep_last = t + step;
		}
	}
	else
	{
		long double dt = t - csleep_last;
		long double to_sleep = step - dt;
		if(to_sleep > 0)
		{
			if(use_asleep)
			{
				asleep(to_sleep, t);
			}
			else
			{
				Rsleep(to_sleep);
			}
			csleep_last += step;
		}
		else
		{
			if(sleep_debug)
			{
				warn("sleep_step running late");
			}
			if(sync)
			{
				csleep_last += ((floor(dt / step))+1)*step;
				to_sleep = csleep_last - t;
				if(use_asleep)
				{
					asleep(to_sleep, t);
				}
				else
				{
					Rsleep(to_sleep);
				}
			}
			else if(!rush)
			{
				csleep_last = t;
			}
		}
	}
	if(sleep_debug)
	{
		warn("%f %Lf", rtime(), csleep_last);
	}
}

long double asleep(long double dt, long double t)
{
	if(dt <= 0.0)
	{
		return t;
	}
	t += dt;
	if(dt <= asleep_small)
	{
		long double t1;
		while((t1=rtime()) < t)
		{
			
		}
		return t1;
	}
	else
	{
		lsleep(dt-asleep_small);
		long double t2 = rtime();
		long double dt2 = t - t2;
		if(dt2 > 0)
		{
			return asleep(dt2, t2);
		}
		else if(dt < 0)
		{
			asleep_small *= 2;
			if(sleep_debug)
			{
				warn("asleep: slept too long, doubling asleep_small to %f", asleep_small);
			}
		}
		return t2;
	}
}

void rtime_to_timeval(num rtime, struct timeval *tv)
{
	tv->tv_sec = (long)rtime;
	tv->tv_usec = (long)((rtime - tv->tv_sec) * 1e6);
}

void rtime_to_timespec(num rtime, struct timespec *ts)
{
	ts->tv_sec = (long)rtime;
	ts->tv_nsec = (long)((rtime - ts->tv_sec) * 1e9);
}

num timeval_to_rtime(const struct timeval *tv)
{
	return (num)tv->tv_sec + tv->tv_usec / 1e6;
}

num timespec_to_rtime(const struct timespec *ts)
{
	return (num)ts->tv_sec + ts->tv_nsec / 1e9;
}

int rtime_to_ms(num rtime)
{
	return (int)(rtime * 1000);
}

num ms_to_rtime(int ms)
{
	return ms / 1000.0;
}

int delay_to_ms(num delay)
{
	if(delay == (-1e100))
	{
		return -1;
	}
	else
	{
		return rtime_to_ms(delay);
	}
}

struct timespec *delay_to_timespec(num delay, struct timespec *p)
{
	if(delay == (-1e100))
	{
		return NULL;
	}
	else
	{
		rtime_to_timespec(delay, p);
		return p;
	}
}

struct timeval *delay_to_timeval(num delay, struct timeval *p)
{
	if(delay == (-1e100))
	{
		return NULL;
	}
	else
	{
		rtime_to_timeval(delay, p);
		return p;
	}
}

void date_rfc1123_init(void)
{
	setlocale(LC_TIME, "POSIX");
	Putenv("TZ=GMT");
	tzset();
}

char *date_rfc1123(time_t t)
{
	static char date[32];
	static char maxdate[32];
	static time_t maxtime = -1;
	if(t == maxtime)
	{
		return maxdate;
	}
	char *d = date;
	if(t > maxtime)
	{
		maxtime = t;
		d = maxdate;
	}
	strftime(d, sizeof(date), "%a, %d %b %Y %H:%M:%S GMT", gmtime(&t));
	return d;
}

void lsleep_init(void)
{
	(Sigact(SIGALRM, catch_signal_null, SA_RESTART|(SIGALRM == SIGCHLD ? SA_NOCLDSTOP : 0)));
	lsleep_inited = 1;
}

void lsleep(num dt)
{
	if(!lsleep_inited)
	{
		lsleep_init();
	}
	Ualarm(dt);
	rsleep(dt+1);
}

void Getitimer(int which, struct itimerval *value)
{
	if(getitimer(which, value))
	{
		failed("getitimer");
	}
}

void Setitimer(int which, const struct itimerval *value, struct itimerval *ovalue)
{
	if(setitimer(which, value, ovalue))
	{
		failed("setitimer");
	}
}

void Ualarm(num dt)
{
	itimerval v;
	rtime_to_timeval(dt, &v.it_value);
	v.it_interval.tv_sec = v.it_interval.tv_usec = 0;
	Setitimer(ITIMER_REAL, &v, NULL);
}

int sgn(num x)
{
	if(x < 0)
	{
		return -1;
	}
	if(x > 0)
	{
		return 1;
	}
	return 0;
}

num nmin(num x, num y)
{
	if(x < y)
	{
		return x;
	}
	return y;
}

num nmax(num x, num y)
{
	if(x > y)
	{
		return x;
	}
	return y;
}

int imin(int x, int y)
{
	if(x < y)
	{
		return x;
	}
	return y;
}

long lmin(long x, long y)
{
	if(x < y)
	{
		return x;
	}
	return y;
}

int imax(int x, int y)
{
	if(x > y)
	{
		return x;
	}
	return y;
}

long lmax(long x, long y)
{
	if(x > y)
	{
		return x;
	}
	return y;
}

num notpot(num hypotenuse, num x)
{
	return sqrt((hypotenuse*hypotenuse) - (x*x));
}

long Randi(long min, long max)
{
	return random() / ((1U<<31) / (max - min)) + min;
}

void seed(void)
{
	int s = (int)((rmod(rtime()*1000, pow(2, 32)))) ^ (getpid()<<16);
	(srandom(s));
}

int mod(int i, int base)
{
	if(i < 0)
	{
		return base - 1 - (-1 - i) % base;
	}
	else
	{
		return i % base;
	}
}

int Div(int i, int base)
{
	if(i>=0)
	{
		return i/base;
	}
	return -((-i-1)/base + 1);
}

num rmod(num r, num base)
{
	int d = (floor(r / base));
	return r - d * base;
}

num dist(num x0, num y0, num x1, num y1)
{
	return hypot(x1-x0, y1-y0);
}

num double_or_nothing(num factor)
{
	return pow(2, floor(log(factor)/log(2)+.5));
}

void divmod(int i, int base, int *div, int *_mod)
{
	*div = Div(i, base);
	*_mod = mod(i, base);
}

void divmod_range(int i, int low, int high, int *div, int *_mod)
{
	i -= low;
	divmod(i, high-low, div, _mod);
	*_mod += low;
}

void rdivmod(num r, num base, num *div, num *_mod)
{
	*div = (floor(r / base));
	*_mod = rmod(r, base);
}

void rdivmod_range(num r, num low, num high, num *div, num *_mod)
{
	r -= low;
	rdivmod(r, high-low, div, _mod);
	r += low;
}

num clamp(num x, num min, num max)
{
	return x < min ? min : x > max ? max : x;
}

int iclamp(int x, int min, int max)
{
	return x < min ? min : x > max ? max : x;
}

long lclamp(long x, long min, long max)
{
	return x < min ? min : x > max ? max : x;
}

num spow(num b, num e)
{
	if(b >= 0)
	{
		return pow(b, e);
	}
	else
	{
		return -pow(-b, e);
	}
}

num rand_normal(void)
{
	num U = ((num)((long double)((long long int)random()*(((1UL<<31)))+random())/((unsigned long long int)(((1UL<<31)))*(((1UL<<31))))));
	num V = ((num)((long double)((long long int)random()*(((1UL<<31)))+random())/((unsigned long long int)(((1UL<<31)))*(((1UL<<31))))));
	num X = sqrt(-2 * log(U)) * cos(2*pi*V);
	return X;
}

num blend(num i, num x0, num x1)
{
	return (x1-x0)*i + x0;
}

char *Getenv(const char *name, char *_default)
{
	char *value = getenv(name);
	if(value == NULL)
	{
		if(_default == env__required)
		{
			error("missing required env arg: %s\n", name);
		}
		value = _default;
	}
	return value;
}

boolean is_env(const char *name)
{
	return *Getenv(name, "");
}

void Putenv(char *string)
{
	if(putenv(string) != 0)
	{
		failed("putenv");
	}
}

void Setenv(const char *name, const char *value, int overwrite)
{
	if(setenv(name, value, overwrite))
	{
		failed("setenv");
	}
}

void dump_env(void)
{
	typeof(environ) (skip(1, `my__1828_)p) = environ;
	for(; (skip(1, `my__1833_)p) && *(skip(1, `my__1835_)p); ++(skip(1, `my__1837_)p))
	{
		typeof(*(skip(1, `my__1839_)p)) e = *(skip(1, `my__1839_)p);
		Sayf("%s", e);
	}
}

void load_config(cstr file)
{
	FILE *(skip(1, `my__1845_)s) = (Fopen(file, "rb"));
	vstream *(skip(1, `my__1848_)old_in) = in;
	vstream struct__(skip(1, `my__1850_)vs);
	vstream *(skip(1, `my__1850_)vs) = &struct__(skip(1, `my__1850_)vs);
	vstream_init_stdio(((skip(1, `my__1850_)vs)), ((skip(1, `my__1852_)s)));
	int ((skip(1, `my__1858_)p)) = 0;
}
void ((skip(1, `my__1858_)p))	if ((skip(1, `my__1858_)p)) == 1
{
	{
		++((skip(1, `my__1858_)p));
		
		Fclose(skip(1, `my__1861_)s);
		in = (skip(1, `my__1863_)old_in);
	}
	for(; ((skip(1, `my__1865_)p)) < 2 ; ++((skip(1, `my__1865_)p)))
	{
		if(((skip(1, `my__1865_)p)) == 1)
		{
			goto ((skip(1, `my__1865_)p));
		}
		
		in = (skip(1, `my__1868_)vs);
		
		char *l;
		buffer struct__(skip(1, `my__1872_)b);
		buffer *(skip(1, `my__1872_)b) = &struct__(skip(1, `my__1872_)b);
		(buffer_init(((skip(1, `my__1872_)b)), 128));
		while(1)
		{
			buffer_clear(skip(1, `my__1878_)b);
			if(rl(skip(1, `my__1882_)b))
			{
				break;
			}
			l = (((skip(1, `my__1884_)b))->start);
			if(((*l) == '#' || (*l) == '\0'))
			{
				continue;
			}
			cstr key = (normal_Strdup(l));
			cstr val = strchr(key, '=');
			if(val)
			{
				*val++ = '\0';
			}
			else
			{
				val = "1";
			}
			if(!is_env(key))
			{
				if(*val == '"')
				{
					*val++ = '\0';
				}
				cstr lastq = strchr(val, '"');
				if(lastq)
				{
					*lastq = '\0';
				}
				Setenv(key, val, 1);
			}
		}
	}
}

void Clearenv(void)
{
	if(clearenv() != 0)
	{
		failed("clearenv");
	}
}

void Unsetenv(const char *name)
{
	unsetenv(name);
}

int clear_env(void)
{
	buffer struct__k;
	buffer *k = &struct__k;
	buffer_init(k, 256);
	while(*environ)
	{
		char *equals = strchr(*environ, '=');
		buffer_clear(k);
		if(!equals)
		{
			buffer_cat_cstr(k, *environ);
		}
		else
		{
			buffer_cat_str(k, new_str(*environ, equals));
		}
		Puts((k->start));
	}
	buffer_free(k);
	return 0;
}

cstr homedir(void)
{
	return Getenv("HOME", "/");
}

void find_vec(cstr root, vec *v)
{
	deq struct__((skip(1, `my__1900_)q));
	deq *((skip(1, `my__1900_)q)) = &struct__((skip(1, `my__1900_)q));
	(_deq_init((((skip(1, `my__1900_)q))), sizeof(cstr), (1)));
	*(typeof(root) *)deq_push(((skip(1, `my__1900_)q))) = root;
	cstr f;
	while((((((skip(1, `my__1909_)q))))->size))
	{
		typeof(((typeof(&f))(((deq_element((((((skip(1, `my__1909_)q))))), 0)))))) (skip(1, `my__1916_)p) = ((typeof(&f))(((deq_element((((((skip(1, `my__1909_)q))))), 0)))));
		f = *(skip(1, `my__1925_)p);
		deq_shift(((((skip(1, `my__1909_)q)))));
		lstats struct__s;
		lstats *s = &struct__s;
		lstats_init(s, f);
		if(!((s->st_mode)))
		{
			warn("find: can't stat: %s", f);
			continue;
		}
		
		if(path_hidden(f))
		{
			continue;
		}
		if(S_ISDIR(s->st_mode))
		{
			vec struct__(skip(1, `my__1934_)v);
			vec *(skip(1, `my__1934_)v) = &struct__(skip(1, `my__1934_)v);
			vec_init_el_size((skip(1, `my__1934_)v), sizeof(cstr), (1));
			typeof(opendir(f)) (skip(1, `my__1941_)dir) = opendir(f);
			if(!(skip(1, `my__1946_)dir))
			{
				warn("find: can't opendir %s", f);
			}
			else
			{
				while(1)
				{
					typeof(Readdir(skip(1, `my__1950_)dir)) (skip(1, `my__1948_)ent) = Readdir(skip(1, `my__1950_)dir);
					if((skip(1, `my__1955_)ent) == NULL)
					{
						break;
					}
					cstr (skip(1, `my__1957_)new_f) = (skip(1, `my__1959_)ent)->d_name;
					if(!(cstr_eq((skip(1, `my__1961_)new_f), ".") || cstr_eq((skip(1, `my__1963_)new_f), "..")))
					{
						(skip(1, `my__1966_)new_f) = path_cat(f, (skip(1, `my__1970_)new_f));
						*(typeof((skip(1, `my__1974_)new_f)) *)vec_push((skip(1, `my__1972_)v)) = ((skip(1, `my__1974_)new_f));
					}
				}
				Closedir(skip(1, `my__1977_)dir);
				while((((skip(1, `my__1979_)v))->size))
				{
					cstr (skip(1, `my__1982_)new_f);
					typeof(((typeof(&(skip(1, `my__1986_)new_f)))((vec_top(((skip(1, `my__1984_)v)), 0))))) (skip(1, `my__1989_)p) = ((typeof(&(skip(1, `my__1986_)new_f)))((vec_top(((skip(1, `my__1984_)v)), 0))));
					(skip(1, `my__1986_)new_f) = *(skip(1, `my__1997_)p);
					vec_pop((skip(1, `my__1984_)v));
					*(typeof(&((skip(1, `my__1999_)new_f))))deq_unshift((((((skip(1, `my__1909_)q)))))) = ((skip(1, `my__1999_)new_f));
				}
			}
		}
		
		
		
		*(typeof(f) *)vec_push(v) = f;
	}
}

void find_vec_all(cstr root, vec *v)
{
	deq struct__((skip(1, `my__2005_)q));
	deq *((skip(1, `my__2005_)q)) = &struct__((skip(1, `my__2005_)q));
	(_deq_init((((skip(1, `my__2005_)q))), sizeof(cstr), (1)));
	*(typeof(root) *)deq_push(((skip(1, `my__2005_)q))) = root;
	cstr f;
	while(((((skip(1, `my__2014_)q)))->size))
	{
		typeof(((typeof(&f))(((deq_element(((((skip(1, `my__2014_)q)))), 0)))))) (skip(1, `my__2020_)p) = ((typeof(&f))(((deq_element(((((skip(1, `my__2014_)q)))), 0)))));
		f = *(skip(1, `my__2029_)p);
		deq_shift((((skip(1, `my__2014_)q))));
		lstats struct__s;
		lstats *s = &struct__s;
		lstats_init(s, f);
		if(!((s->st_mode)))
		{
			warn("find: can't stat: %s", f);
			continue;
		}
		
		if(S_ISDIR(s->st_mode))
		{
			vec struct__(skip(1, `my__2037_)v);
			vec *(skip(1, `my__2037_)v) = &struct__(skip(1, `my__2037_)v);
			vec_init_el_size((skip(1, `my__2037_)v), sizeof(cstr), (1));
			typeof(opendir(f)) (skip(1, `my__2044_)dir) = opendir(f);
			if(!(skip(1, `my__2049_)dir))
			{
				warn("find: can't opendir %s", f);
			}
			else
			{
				while(1)
				{
					typeof(Readdir(skip(1, `my__2053_)dir)) (skip(1, `my__2051_)ent) = Readdir(skip(1, `my__2053_)dir);
					if((skip(1, `my__2058_)ent) == NULL)
					{
						break;
					}
					cstr (skip(1, `my__2060_)new_f) = (skip(1, `my__2062_)ent)->d_name;
					if(!(cstr_eq((skip(1, `my__2064_)new_f), ".") || cstr_eq((skip(1, `my__2066_)new_f), "..")))
					{
						(skip(1, `my__2069_)new_f) = path_cat(f, (skip(1, `my__2073_)new_f));
						*(typeof((skip(1, `my__2077_)new_f)) *)vec_push((skip(1, `my__2075_)v)) = ((skip(1, `my__2077_)new_f));
					}
				}
				Closedir(skip(1, `my__2080_)dir);
				while((((skip(1, `my__2082_)v))->size))
				{
					cstr (skip(1, `my__2085_)new_f);
					typeof(((typeof(&(skip(1, `my__2089_)new_f)))((vec_top(((skip(1, `my__2087_)v)), 0))))) (skip(1, `my__2092_)p) = ((typeof(&(skip(1, `my__2089_)new_f)))((vec_top(((skip(1, `my__2087_)v)), 0))));
					(skip(1, `my__2089_)new_f) = *(skip(1, `my__2100_)p);
					vec_pop((skip(1, `my__2087_)v));
					*(typeof(&((skip(1, `my__2102_)new_f))))deq_unshift(((((skip(1, `my__2014_)q))))) = ((skip(1, `my__2102_)new_f));
				}
			}
		}
		
		
		*(typeof(f) *)vec_push(v) = f;
	}
}

void find_vec_files(cstr root, vec *v)
{
	deq struct__((skip(1, `my__2108_)q));
	deq *((skip(1, `my__2108_)q)) = &struct__((skip(1, `my__2108_)q));
	(_deq_init((((skip(1, `my__2108_)q))), sizeof(cstr), (1)));
	*(typeof(root) *)deq_push(((skip(1, `my__2108_)q))) = root;
	cstr f;
	while((((((skip(1, `my__2117_)q))))->size))
	{
		typeof(((typeof(&f))(((deq_element((((((skip(1, `my__2117_)q))))), 0)))))) (skip(1, `my__2124_)p) = ((typeof(&f))(((deq_element((((((skip(1, `my__2117_)q))))), 0)))));
		f = *(skip(1, `my__2133_)p);
		deq_shift(((((skip(1, `my__2117_)q)))));
		lstats struct__s;
		lstats *s = &struct__s;
		lstats_init(s, f);
		if(!((s->st_mode)))
		{
			warn("find: can't stat: %s", f);
			continue;
		}
		
		if(path_hidden(f))
		{
			continue;
		}
		if(S_ISDIR(s->st_mode))
		{
			vec struct__(skip(1, `my__2142_)v);
			vec *(skip(1, `my__2142_)v) = &struct__(skip(1, `my__2142_)v);
			vec_init_el_size((skip(1, `my__2142_)v), sizeof(cstr), (1));
			typeof(opendir(f)) (skip(1, `my__2149_)dir) = opendir(f);
			if(!(skip(1, `my__2154_)dir))
			{
				warn("find: can't opendir %s", f);
			}
			else
			{
				while(1)
				{
					typeof(Readdir(skip(1, `my__2158_)dir)) (skip(1, `my__2156_)ent) = Readdir(skip(1, `my__2158_)dir);
					if((skip(1, `my__2163_)ent) == NULL)
					{
						break;
					}
					cstr (skip(1, `my__2165_)new_f) = (skip(1, `my__2167_)ent)->d_name;
					if(!(cstr_eq((skip(1, `my__2169_)new_f), ".") || cstr_eq((skip(1, `my__2171_)new_f), "..")))
					{
						(skip(1, `my__2174_)new_f) = path_cat(f, (skip(1, `my__2178_)new_f));
						*(typeof((skip(1, `my__2182_)new_f)) *)vec_push((skip(1, `my__2180_)v)) = ((skip(1, `my__2182_)new_f));
					}
				}
				Closedir(skip(1, `my__2185_)dir);
				while((((skip(1, `my__2187_)v))->size))
				{
					cstr (skip(1, `my__2190_)new_f);
					typeof(((typeof(&(skip(1, `my__2194_)new_f)))((vec_top(((skip(1, `my__2192_)v)), 0))))) (skip(1, `my__2197_)p) = ((typeof(&(skip(1, `my__2194_)new_f)))((vec_top(((skip(1, `my__2192_)v)), 0))));
					(skip(1, `my__2194_)new_f) = *(skip(1, `my__2205_)p);
					vec_pop((skip(1, `my__2192_)v));
					*(typeof(&((skip(1, `my__2207_)new_f))))deq_unshift((((((skip(1, `my__2117_)q)))))) = ((skip(1, `my__2207_)new_f));
				}
			}
		}
		
		if(S_ISDIR(s->st_mode))
		{
			continue;
		}
		
		
		*(typeof(f) *)vec_push(v) = f;
	}
}

cmplx cis(num ang)
{
	return cos(ang)+sin(ang)*I;
}

void fft(cmplx *in, cmplx *out, int log2_n)
{
	int n = 1 << log2_n;
	typeof(n) (skip(1, `my__2213_)end) = n;
	typeof(0) (skip(1, `my__2218_)v1) = 0;
	for(; (skip(1, `my__2223_)v1)<(skip(1, `my__2225_)end); ++(skip(1, `my__2227_)v1))
	{
		typeof((skip(1, `my__2229_)v1)) i = (skip(1, `my__2229_)v1);
		out[bit_reverse(i)] = in[i];
	}
	typeof((log2_n+1)) (skip(1, `my__2235_)end) = (log2_n+1);
	typeof(1) (skip(1, `my__2240_)v1) = 1;
	for(; (skip(1, `my__2245_)v1)<(skip(1, `my__2247_)end); ++(skip(1, `my__2249_)v1))
	{
		typeof((skip(1, `my__2251_)v1)) s = (skip(1, `my__2251_)v1);
		int m = 1 << s;
		cmplx w = 1;
		cmplx wm = cis(2*pi/m);
		typeof((m/2)) (skip(1, `my__2257_)end) = (m/2);
		typeof(0) (skip(1, `my__2262_)v1) = 0;
		for(; (skip(1, `my__2267_)v1)<(skip(1, `my__2269_)end); ++(skip(1, `my__2271_)v1))
		{
			typeof((skip(1, `my__2273_)v1)) j = (skip(1, `my__2273_)v1);
			typeof(n) (skip(1, `my__2279_)end) = n;
			typeof(m) (skip(1, `my__2284_)st) = m;
			typeof(j) (skip(1, `my__2289_)v1) = j;
			for(; (skip(1, `my__2294_)v1)<(skip(1, `my__2296_)end); (skip(1, `my__2298_)v1)+=(skip(1, `my__2300_)st))
			{
				typeof((skip(1, `my__2302_)v1)) k = (skip(1, `my__2302_)v1);
				cmplx t = w * out[k + m/2];
				cmplx u = out[k];
				out[k] = u + t;
				out[k + m/2] = u - t;
			}
			w = w * wm;
		}
	}
}

void proc_init(proc *p, proc_func f)
{
	p->f = f;
	p->pc = 1;
}

int resume(proc *p)
{
	
	int rv;
	if(p->pc == -1)
	{
		rv = 0;
	}
	else
	{
		rv = (*p->f)(p);
	}
	
	if(rv)
	{
		p->pc = rv;
	}
	return rv;
}

void proc_dump(proc *p)
{
	Fprintf(stderr, "%010p(%010p %d) ", p, p->f, p->pc);
}

void timeout_init(timeout *timeout, num time, thunk_func *func, void *obj, void *common_arg)
{
	thunk struct__th;
	thunk *th = &struct__th;
	th->func = func;
	th->obj = obj;
	th->common_arg = common_arg;
	timeout_init_thunk(timeout, time, th);
}

void timeout_init_thunk(timeout *timeout, num time, thunk *handler)
{
	timeout->time = time;
	timeout->handler = *handler;
}

void timeouts_add(timeouts *q, timeout *o)
{
	vec_push(q);
	int i = ((q->size))-1;
	for(; i>0 && ((*(timeout_p*)(((&o))))->time - (*(timeout_p*)((vec_element(q, (((i-1)/2))))))->time) < 0 ; i = ((i-1)/2))
	{
		int (skip(1, `my__2327_)old_i) = (((i-1)/2));
		*(timeout_p *)vec_element(q, i) = *(timeout_p *)vec_element(q, (((((i-1)/2)))));
		if(i != ((skip(1, `my__2329_)old_i)))
		{
			(*(timeout_p*)vec_element(q, i))->i = i;
		}
	}
	*(timeout_p *)(vec_element(q, i)) = *((&o));
	o->i = i;
}

void timeouts_rm(timeouts *q, timeout *o)
{
	if(o->i >= 0)
	{
		int (skip(1, `my__2336_)last_i) = ((q->size)) - 1;
		int ((skip(1, `my__2351_)j)) = (((o->i)));
		int ((skip(1, `my__2343_)size)) = ((q->size));
		int ((skip(1, `my__2345_)c1)), ((skip(1, `my__2347_)c2));
		void *((skip(1, `my__2349_)last)) = (vec_element(q, (((skip(1, `my__2343_)size))-1)));
		while(1)
		{
			((skip(1, `my__2345_)c1)) = (((skip(1, `my__2351_)j))*2+1);
			((skip(1, `my__2347_)c2)) = ((skip(1, `my__2345_)c1))+1;
			if(((skip(1, `my__2347_)c2)) >= ((skip(1, `my__2343_)size)))
			{
				break;
			}
			if(((*(timeout_p*)((vec_element(q, (((skip(1, `my__2347_)c2)))))))->time - (*(timeout_p*)((vec_element(q, (((skip(1, `my__2345_)c1)))))))->time) < 0)
			{
				((skip(1, `my__2345_)c1)) = ((skip(1, `my__2347_)c2));
			}
			if(((*(timeout_p*)((vec_element(q, (((skip(1, `my__2345_)c1)))))))->time - (*(timeout_p*)(((skip(1, `my__2349_)last))))->time) >= 0)
			{
				break;
			}
			int (skip(1, `my__2364_)old_i) = (((skip(1, `my__2345_)c1)));
			*(timeout_p *)vec_element(q, (((((skip(1, `my__2351_)j)))))) = *(timeout_p *)vec_element(q, (((((skip(1, `my__2345_)c1))))));
			if(((((skip(1, `my__2351_)j)))) != ((skip(1, `my__2366_)old_i)))
			{
				(*(timeout_p*)vec_element(q, (((((skip(1, `my__2351_)j)))))))->i = (((((skip(1, `my__2351_)j)))));
			}
			((skip(1, `my__2351_)j)) = ((skip(1, `my__2345_)c1));
		}
		if(((skip(1, `my__2351_)j)) != ((skip(1, `my__2343_)size))-1)
		{
			*(timeout_p *)vec_element(q, ((((skip(1, `my__2351_)j))))) = *(timeout_p *)vec_element(q, ((((skip(1, `my__2343_)size))-1)));
			if((((skip(1, `my__2351_)j))) != ((((skip(1, `my__2340_)last_i)))))
			{
				(*(timeout_p*)vec_element(q, ((((skip(1, `my__2351_)j))))))->i = ((((skip(1, `my__2351_)j))));
			}
		}
		vec_pop(q);
		o->i = -1;
	}
}

timeout *timeouts_next(timeouts *q)
{
	return *(timeout_p*)((vec_element(q, 0)));
}

void timeouts_shift(timeouts *q)
{
	int (skip(1, `my__2379_)last_i) = ((q->size)) - 1;
	int ((skip(1, `my__2394_)j)) = 0;
	int ((skip(1, `my__2386_)size)) = ((q->size));
	int ((skip(1, `my__2388_)c1)), ((skip(1, `my__2390_)c2));
	void *((skip(1, `my__2392_)last)) = (vec_element(q, (((skip(1, `my__2386_)size))-1)));
	while(1)
	{
		((skip(1, `my__2388_)c1)) = (((skip(1, `my__2394_)j))*2+1);
		((skip(1, `my__2390_)c2)) = ((skip(1, `my__2388_)c1))+1;
		if(((skip(1, `my__2390_)c2)) >= ((skip(1, `my__2386_)size)))
		{
			break;
		}
		if(((*(timeout_p*)((vec_element(q, (((skip(1, `my__2390_)c2)))))))->time - (*(timeout_p*)((vec_element(q, (((skip(1, `my__2388_)c1)))))))->time) < 0)
		{
			((skip(1, `my__2388_)c1)) = ((skip(1, `my__2390_)c2));
		}
		if(((*(timeout_p*)((vec_element(q, (((skip(1, `my__2388_)c1)))))))->time - (*(timeout_p*)(((skip(1, `my__2392_)last))))->time) >= 0)
		{
			break;
		}
		int (skip(1, `my__2407_)old_i) = (((skip(1, `my__2388_)c1)));
		*(timeout_p *)vec_element(q, (((((skip(1, `my__2394_)j)))))) = *(timeout_p *)vec_element(q, (((((skip(1, `my__2388_)c1))))));
		if(((((skip(1, `my__2394_)j)))) != ((skip(1, `my__2409_)old_i)))
		{
			
		}
		((skip(1, `my__2394_)j)) = ((skip(1, `my__2388_)c1));
	}
	if(((skip(1, `my__2394_)j)) != ((skip(1, `my__2386_)size))-1)
	{
		*(timeout_p *)vec_element(q, ((((skip(1, `my__2394_)j))))) = *(timeout_p *)vec_element(q, ((((skip(1, `my__2386_)size))-1)));
		if((((skip(1, `my__2394_)j))) != ((((skip(1, `my__2383_)last_i)))))
		{
			
		}
	}
	vec_pop(q);
}

void timeouts_call(timeouts *timeouts, num time)
{
	while(!((((timeouts->size)) == 0)))
	{
		timeout *timeout_next = timeouts_next(timeouts);
		if(timeout_next->time > time)
		{
			break;
		}
		timeout *(skip(1, `my__2424_)next) = timeouts_next(timeouts);
		((((*((&((skip(1, `my__2426_)next))->handler))->func)(((&((skip(1, `my__2426_)next))->handler))->obj, ((&((skip(1, `my__2426_)next))->handler))->common_arg, NULL))));
		if(!((((timeouts->size)) == 0)) && timeouts_next(timeouts) == (skip(1, `my__2436_)next))
		{
			timeouts_shift(timeouts);
		}
	}
}

num timeouts_delay(timeouts *timeouts, num time)
{
	if(((((timeouts->size)) == 0)))
	{
		return -1;
	}
	else
	{
		timeout *next = timeouts_next(timeouts);
		num delay = next->time - time;
		if(delay < 0)
		{
			delay = 0;
		}
		return delay;
	}
}

void timeouts_delay_tv(timeouts *timeouts, num time, timeval **tv)
{
	num d = timeouts_delay(timeouts, time);
	if(d < 0)
	{
		*tv = NULL;
	}
	else
	{
		rtime_to_timeval(d, *tv);
	}
}

void timeouts_delay_ts(timeouts *timeouts, num time, timespec **ts)
{
	num d = timeouts_delay(timeouts, time);
	if(d < 0)
	{
		*ts = NULL;
	}
	else
	{
		rtime_to_timespec(d, *ts);
	}
}

int timeouts_delay_ms(timeouts *timeouts, num time)
{
	num d = timeouts_delay(timeouts, time);
	if(d < 0)
	{
		return -1;
	}
	else
	{
		return (int)d*1000;
	}
}

int Socket(int domain, int type, int protocol)
{
	int fd = socket(domain, type, protocol);
	if(fd == -1)
	{
		
		failed("socket");
	}
	
	return fd;
}

void Bind(int sockfd, struct sockaddr *my_addr, socklen_t addrlen)
{
	if(bind(sockfd, my_addr, addrlen) != 0)
	{
		
		failed("bind");
	}
}

void Listen(int sockfd, int backlog)
{
	if(listen(sockfd, backlog) != 0)
	{
		
		failed("listen");
	}
}

int Accept(int earfd, struct sockaddr *addr, socklen_t *addrlen)
{
	int sockfd = accept(earfd, addr, addrlen);
	if(sockfd == -1)
	{
		
		failed("accept");
	}
	
	return sockfd;
}

void Connect(int sockfd, const struct sockaddr *serv_addr, socklen_t addrlen)
{
	if(connect(sockfd, serv_addr, addrlen) != 0)
	{
		
		failed("connect");
	}
}

void Sockaddr_in(struct sockaddr_in *sa, char *addr, int port)
{
	sa->sin_family = AF_INET;
	sa->sin_port = htons(port);
	if(inet_aton(addr, &sa->sin_addr) == 0)
	{
		error("Invalid IP address `%s'.\n", addr);
	}
	memset(&sa->sin_zero, 0, 8);
}

hostent *Gethostbyname(const char *name)
{
	typeof(gethostbyname(name)) rv = gethostbyname(name);
	if(rv == NULL)
	{
		errno = h_errno;
		failed("gethostbyname");
	}
	return rv;
}

cstr name_to_ip(const char *name)
{
	struct in_addr addr;
	if(inet_aton(name, &addr))
	{
		return (char*)name;
	}
	typeof(Gethostbyname(name)) he = Gethostbyname(name);
	if(he->h_addrtype != AF_INET)
	{
		error("name_to_ip: does not support ip6 yet");
	}
	return inet_ntoa(*(struct in_addr *)(he->h_addr_list[0]));
}

int Server_tcp(char *addr, int port)
{
	addr = name_to_ip(addr);
	int ear = Socket(PF_INET, SOCK_STREAM, 0);
	(reuseaddr(ear, 1));
	struct sockaddr_in sa;
	Sockaddr_in(&sa, addr, port);
	Bind(ear, (sockaddr *)&sa, sizeof(sockaddr_in));
	(Listen(ear, listen_backlog));
	return ear;
}

void Setsockopt(int s, int level, int optname, const void *optval, socklen_t optlen)
{
	if(setsockopt(s, level, optname, optval, optlen))
	{
		
		failed("setsockopt");
	}
}

int Client_tcp(char *addr, int port)
{
	addr = name_to_ip(addr);
	int sock = Socket(PF_INET, SOCK_STREAM, 0);
	struct sockaddr_in sa;
	Sockaddr_in(&sa, addr, port);
	Connect(sock, (sockaddr *)&sa, sizeof(sockaddr));
	return sock;
}

cstr Hostname(void)
{
	if(hostname__[0] == '\0')
	{
		if(gethostname(hostname__, 256) != 0)
		{
			
			failed("gethostname");
		}
		hostname__[256-1] = '\0';
	}
	return hostname__;
}

ssize_t Send(int s, const void *buf, size_t len, int flags)
{
	ssize_t rv = send(s, buf, len, flags);
	if(rv == -1)
	{
		
		if(errno == EAGAIN)
		{
			rv = 0;
		}
		else
		{
			failed("send");
		}
	}
	return rv;
}

ssize_t Recv(int s, void *buf, size_t len, int flags)
{
	errno = 0;
	ssize_t rv = recv(s, buf, len, flags);
	if(rv == -1)
	{
		
		if(errno == EAGAIN)
		{
			rv = 0;
		}
		else
		{
			failed("recv");
		}
	}
	return rv;
}

ssize_t SendTo(int s, const void *buf, size_t len, int flags, const struct sockaddr *to, socklen_t tolen)
{
	ssize_t rv = sendto(s, buf, len, flags, to, tolen);
	if(rv == -1)
	{
		
		if(errno == EAGAIN)
		{
			rv = 0;
		}
		else
		{
			failed("sendto");
		}
	}
	return rv;
}

ssize_t RecvFrom(int s, void *buf, size_t len, int flags, struct sockaddr *from, socklen_t *fromlen)
{
	errno = 0;
	ssize_t rv = recvfrom(s, buf, len, flags, from, fromlen);
	if(rv == -1)
	{
		
		if(errno == EAGAIN)
		{
			rv = 0;
		}
		else
		{
			failed("recvfrom");
		}
	}
	return rv;
}

void Shutdown(int s, int how)
{
	int rv = shutdown(s, how);
	if(rv == -1)
	{
		
		failed("shutdown");
	}
}

void Closesocket(int fd)
{
	if((close(fd)) != 0)
	{
		failed("closesocket");
	}
}

void keepalive(int fd, int keepalive)
{
	Setsockopt(fd, SOL_SOCKET, SO_KEEPALIVE, &keepalive, sizeof(keepalive));
}

void nodelay(int fd, int nodelay)
{
	Setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, &nodelay, sizeof(nodelay));
}

void reuseaddr(int fd, int reuseaddr)
{
	Setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &reuseaddr, sizeof(reuseaddr));
}

void Getsockopt(int s, int level, int optname, void *optval, socklen_t *optlen)
{
	if(getsockopt(s, level, optname, optval, optlen))
	{
		
		failed("getsockopt");
	}
}

int Getsockerr(int fd)
{
	int err;
	socklen_t size = sizeof(err);
	Getsockopt(fd, SOL_SOCKET, SO_ERROR, &err, &size);
	return err;
}

ssize_t Sendfile(int out_fd, int in_fd, off_t *offset, size_t count)
{
	ssize_t rv = sendfile(out_fd, in_fd, offset, count);
	if(rv == -1)
	{
		if(errno == EAGAIN)
		{
			rv = 0;
		}
		else
		{
			failed("sendfile");
		}
	}
	return rv;
}

int Server_unix_stream(char *addr)
{
	int ear = Socket(PF_UNIX, SOCK_STREAM, 0);
	struct sockaddr_un sa;
	Sockaddr_unix(&sa, addr);
	Bind(ear, (sockaddr *)&sa, sizeof(sockaddr_un));
	Listen(ear, 20);
	return ear;
}

int Client_unix_stream(char *addr)
{
	int sock = Socket(PF_UNIX, SOCK_STREAM, 0);
	struct sockaddr_un sa;
	Sockaddr_unix(&sa, addr);
	Connect(sock, (sockaddr *)&sa, sizeof(sockaddr));
	return sock;
}

void Sockaddr_unix(struct sockaddr_un *sa, char *addr)
{
	sa->sun_family = AF_UNIX;
	if(strlen(addr) > 108-1)
	{
		error("pathname to unix socket too long: %s", addr);
	}
	strcpy(sa->sun_path, addr);
}

void cork(int fd, int cork)
{
	Setsockopt(fd, IPPROTO_TCP, TCP_CORK, &cork, sizeof(cork));
}

void vstream_init_stdio(vstream *vs, FILE *s)
{
	vs->putc = vs_putc_stdio;
	vs->getc = vs_getc_stdio;
	vs->printf = vs_printf_stdio;
	vs->gets = vs_gets_stdio;
	vs->write = vs_write_stdio;
	vs->read = vs_read_stdio;
	vs->flush = vs_flush_stdio;
	vs->close = vs_close_stdio;
	vs->shutdown = vs_shutdown_stdio;
	vs->data = s;
}

void vs_putc_stdio(int c, vstream *vs)
{
	Fputc(c, vs->data);
}

int vs_getc_stdio(vstream *vs)
{
	return Fgetc(vs->data);
}

int vs_printf_stdio(vstream *vs, const char *format, va_list ap)
{
	return Vfprintf(vs->data, format, ap);
}

char *vs_gets_stdio(char *s, int size, vstream *vs)
{
	return Fgets(s, size, vs->data);
}

void vs_write_stdio(const void *ptr, size_t size, size_t nmemb, vstream *vs)
{
	Fwrite(ptr, size, nmemb, vs->data);
}

size_t vs_read_stdio(void *ptr, size_t size, size_t nmemb, vstream *vs)
{
	return Fread(ptr, size, nmemb, vs->data);
}

void vs_flush_stdio(vstream *vs)
{
	Fflush(vs->data);
}

void vs_close_stdio(vstream *vs)
{
	Fclose(vs->data);
}

void vs_shutdown_stdio(vstream *vs, int how)
{
	Shutdown(fileno((FILE*)vs->data), how);
}

void vstreams_init(void)
{
	in = &struct__in;
	out = &struct__out;
	er = &struct__er;
	vstream_init_stdio(in, stdin);
	vstream_init_stdio(out, stdout);
	vstream_init_stdio(er, stderr);
}

void vstream_init_buffer(vstream *vs, buffer *b)
{
	vs->putc = vs_putc_buffer;
	vs->getc = vs_getc_buffer;
	vs->printf = vs_printf_buffer;
	vs->gets = vs_gets_buffer;
	vs->write = vs_write_buffer;
	vs->read = vs_read_buffer;
	vs->flush = vs_flush_buffer;
	vs->close = vs_close_buffer;
	vs->shutdown = vs_shutdown_buffer;
	vs->data = b;
}

void vs_putc_buffer(int c, vstream *vs)
{
	buffer *b = vs->data;
	buffer_cat_char(b, c);
}

int vs_getc_buffer(vstream *vs)
{
	buffer *b = vs->data;
	if(((ssize_t)((b->end)-(b->start))))
	{
		int c = buffer_first_char(b);
		buffer_shift(b, 1);
		return c;
	}
	else
	{
		return EOF;
	}
}

int vs_printf_buffer(vstream *vs, const char *format, va_list ap)
{
	buffer *b = vs->data;
	return Vsprintf(b, format, ap);
}

char *vs_gets_buffer(char *s, int size, vstream *vs)
{
	buffer *b = vs->data;
	char *c = (b->start);
	char *e = (b->end);
	if(c == e || *c == 0)
	{
		return NULL;
	}
	char *o = s;
	if(e > c+size-1)
	{
		e = c+size-1;
	}
	while(c < e)
	{
		if(((*c) == '\0' || (*c) == '\n'))
		{
			c++;
			break;
		}
		*o++ = *c++;
	}
	*o++ = '\0';
	buffer_shift(b, c-(b->start));
	return s;
}

void vs_write_buffer(const void *ptr, size_t size, size_t nmemb, vstream *vs)
{
	buffer *b = vs->data;
	size_t l = size * nmemb;
	buffer_cat_range(b, ptr, ((const char *)ptr)+l);
}

size_t vs_read_buffer(void *ptr, size_t size, size_t nmemb, vstream *vs)
{
	buffer *b = vs->data;
	ssize_t l = size * nmemb;
	if(l > ((ssize_t)((b->end)-(b->start))))
	{
		l = ((ssize_t)((b->end)-(b->start)));
	}
	memmove(ptr, (b->start), l);
	buffer_shift(b, l);
	return nmemb;
}

void vs_flush_buffer(vstream *vs)
{
	buffer *b = vs->data;
	buffer_nul_terminate(b);
}

void vs_close_buffer(vstream *vs)
{
	buffer *b = vs->data;
	buffer_to_cstr(b);
}

void vs_shutdown_buffer(vstream *vs, int how)
{
	if((how == SHUT_WR || how == SHUT_RDWR))
	{
		vs_close_buffer(vs);
	}
}

void vs_putc(int c)
{
	(*out->putc)(c, out);
}

int vs_getc(void)
{
	return (*in->getc)(in);
}

int vs_printf(const char *format, va_list ap)
{
	return (*out->printf)(out, format, ap);
}

char *vs_gets(char *s, int size)
{
	return (*in->gets)(s, size, in);
}

void vs_write(const void *ptr, size_t size, size_t nmemb)
{
	(*out->write)(ptr, size, nmemb, out);
}

size_t vs_read(void *ptr, size_t size, size_t nmemb)
{
	return (*in->read)(ptr, size, nmemb, in);
}

void vs_flush(void)
{
	(*out->flush)(out);
}

void vs_close(void)
{
	(*out->close)(out);
	(*in->close)(in);
}

void vs_shutdown(int how)
{
	if((how == SHUT_WR || how == SHUT_RDWR))
	{
		(*out->shutdown)(out, SHUT_WR);
	}
	if((how == SHUT_RD || how == SHUT_RDWR))
	{
		(*in->shutdown)(in, SHUT_RD);
	}
}

int pf(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(vs_printf(format, ap)) rv = vs_printf(format, ap);
	va_end(ap);
	return rv;
}

int vs_sayf(const char *format, va_list ap)
{
	int rv = (*out->printf)(out, format, ap);
	(*out->putc)('\n', out);
	++rv;
	return rv;
}

int sf(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(vs_sayf(format, ap)) rv = vs_sayf(format, ap);
	va_end(ap);
	return rv;
}

int print(const char *s)
{
	return pf("%s", s);
}

int say(const char *s)
{
	return sf("%s", s);
}

int rl(buffer *b)
{
	ssize_t len = ((ssize_t)((b->end)-(b->start)));
	while(1)
	{
		char *rv = vs_gets(b->start+len, ((ssize_t)(b->space_end - b->start))-len);
		if(rv == NULL)
		{
			return EOF;
		}
		len += strlen(b->start+len);
		if(b->start[len-1] == '\n')
		{
			if(len>1 && b->start[len-2] == '\r')
			{
				--len;
			}
			--len;
			b->start[len] = '\0';
			break;
		}
		if(len < ((ssize_t)(b->space_end - b->start)) - 1)
		{
			break;
		}
		buffer_double(b);
	}
	buffer_set_size(b, len);
	return 0;
}

cstr rl_0(void)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 128);
	if(rl(b) == 0)
	{
		buffer_squeeze(b);
		return buffer_to_cstr(b);
	}
	else
	{
		buffer_free(b);
		return NULL;
	}
}

vec *read_ints(cstr file)
{
	vec *v;
	v = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
	vec_init_el_size(v, sizeof(int), (200));
	FILE *(skip(1, `my__2536_)s) = (Fopen(file, "rb"));
	vstream *(skip(1, `my__2539_)old_in) = in;
	vstream struct__(skip(1, `my__2541_)vs);
	vstream *(skip(1, `my__2541_)vs) = &struct__(skip(1, `my__2541_)vs);
	vstream_init_stdio(((skip(1, `my__2541_)vs)), ((skip(1, `my__2543_)s)));
	int ((skip(1, `my__2549_)p)) = 0;
}
void ((skip(1, `my__2549_)p))	if ((skip(1, `my__2549_)p)) == 1
{
	{
		++((skip(1, `my__2549_)p));
		
		Fclose(skip(1, `my__2552_)s);
		in = (skip(1, `my__2554_)old_in);
	}
	for(; ((skip(1, `my__2556_)p)) < 2 ; ++((skip(1, `my__2556_)p)))
	{
		if(((skip(1, `my__2556_)p)) == 1)
		{
			goto ((skip(1, `my__2556_)p));
		}
		
		in = (skip(1, `my__2559_)vs);
		
		char *l;
		buffer struct__(skip(1, `my__2563_)b);
		buffer *(skip(1, `my__2563_)b) = &struct__(skip(1, `my__2563_)b);
		(buffer_init(((skip(1, `my__2563_)b)), 128));
		while(1)
		{
			buffer_clear(skip(1, `my__2569_)b);
			if(rl(skip(1, `my__2573_)b))
			{
				break;
			}
			l = (((skip(1, `my__2575_)b))->start);
			*(typeof(((int)atoi(l))) *)vec_push(v) = (((int)atoi(l)));
		}
	}
	vec_squeeze(v);
	return v;
}

vec *read_nums(cstr file)
{
	vec *v;
	v = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
	vec_init_el_size(v, sizeof(num), (200));
	FILE *(skip(1, `my__2591_)s) = (Fopen(file, "rb"));
	vstream *(skip(1, `my__2594_)old_in) = in;
	vstream struct__(skip(1, `my__2596_)vs);
	vstream *(skip(1, `my__2596_)vs) = &struct__(skip(1, `my__2596_)vs);
	vstream_init_stdio(((skip(1, `my__2596_)vs)), ((skip(1, `my__2598_)s)));
	int ((skip(1, `my__2604_)p)) = 0;
}
void ((skip(1, `my__2604_)p))	if ((skip(1, `my__2604_)p)) == 1
{
	{
		++((skip(1, `my__2604_)p));
		
		Fclose(skip(1, `my__2607_)s);
		in = (skip(1, `my__2609_)old_in);
	}
	for(; ((skip(1, `my__2611_)p)) < 2 ; ++((skip(1, `my__2611_)p)))
	{
		if(((skip(1, `my__2611_)p)) == 1)
		{
			goto ((skip(1, `my__2611_)p));
		}
		
		in = (skip(1, `my__2614_)vs);
		
		char *l;
		buffer struct__(skip(1, `my__2618_)b);
		buffer *(skip(1, `my__2618_)b) = &struct__(skip(1, `my__2618_)b);
		(buffer_init(((skip(1, `my__2618_)b)), 128));
		while(1)
		{
			buffer_clear(skip(1, `my__2624_)b);
			if(rl(skip(1, `my__2628_)b))
			{
				break;
			}
			l = (((skip(1, `my__2630_)b))->start);
			*(typeof(((num)atof(l))) *)vec_push(v) = (((num)atof(l)));
		}
	}
	vec_squeeze(v);
	return v;
}

vec *read_cstrs(cstr file)
{
	vec *v;
	v = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
	vec_init_el_size(v, sizeof(cstr), (200));
	FILE *(skip(1, `my__2648_)s) = (Fopen(file, "rb"));
	vstream *(skip(1, `my__2651_)old_in) = in;
	vstream struct__(skip(1, `my__2653_)vs);
	vstream *(skip(1, `my__2653_)vs) = &struct__(skip(1, `my__2653_)vs);
	vstream_init_stdio(((skip(1, `my__2653_)vs)), ((skip(1, `my__2655_)s)));
	int ((skip(1, `my__2661_)p)) = 0;
}
void ((skip(1, `my__2661_)p))	if ((skip(1, `my__2661_)p)) == 1
{
	{
		++((skip(1, `my__2661_)p));
		
		Fclose(skip(1, `my__2664_)s);
		in = (skip(1, `my__2666_)old_in);
	}
	for(; ((skip(1, `my__2668_)p)) < 2 ; ++((skip(1, `my__2668_)p)))
	{
		if(((skip(1, `my__2668_)p)) == 1)
		{
			goto ((skip(1, `my__2668_)p));
		}
		
		in = (skip(1, `my__2671_)vs);
		
		char *l;
		buffer struct__(skip(1, `my__2675_)b);
		buffer *(skip(1, `my__2675_)b) = &struct__(skip(1, `my__2675_)b);
		(buffer_init(((skip(1, `my__2675_)b)), 128));
		while(1)
		{
			buffer_clear(skip(1, `my__2681_)b);
			if(rl(skip(1, `my__2685_)b))
			{
				break;
			}
			l = (((skip(1, `my__2687_)b))->start);
			*(typeof(((normal_Strdup(l)))) *)vec_push(v) = (((normal_Strdup(l))));
		}
	}
	vec_squeeze(v);
	return v;
}

void vstream_init_circbuf(vstream *vs, circbuf *b)
{
	vs->putc = vs_putc_circbuf;
	vs->getc = vs_getc_circbuf;
	vs->printf = vs_printf_circbuf;
	vs->gets = vs_gets_circbuf;
	vs->write = vs_write_circbuf;
	vs->read = vs_read_circbuf;
	vs->flush = vs_flush_circbuf;
	vs->close = vs_close_circbuf;
	vs->shutdown = vs_shutdown_circbuf;
	vs->data = b;
}

void vs_putc_circbuf(int c, vstream *vs)
{
	circbuf *b = vs->data;
	circbuf_cat_char(b, c);
}

int vs_getc_circbuf(vstream *vs)
{
	circbuf *b = vs->data;
	if((b->size))
	{
		int c = circbuf_first_char(b);
		circbuf_shift(b, 1);
		return c;
	}
	else
	{
		return EOF;
	}
}

int vs_printf_circbuf(vstream *vs, const char *format, va_list ap)
{
	circbuf *b = vs->data;
	return Vsprintf_cb(b, format, ap);
}

char *vs_gets_circbuf(char *s, int size, vstream *vs)
{
	circbuf *b = vs->data;
	char *c = (b->data + b->start);
	if(((b->size)) == 0 || *c == 0)
	{
		return NULL;
	}
	if(size > 0)
	{
		char *space_end = (b->data + b->space);
		char *o = s;
		char *e;
		if(((b->size)) > size-1)
		{
			e = (circbuf_get_pos(b, (size-1)));
		}
		else
		{
			e = (circbuf_get_pos(b, b->size));
		}
		do
		{
			if(((*c) == '\0' || (*c) == '\n'))
			{
				c++;
				break;
			}
			*o++ = *c++;
			if(c == space_end)
			{
				c = b->data;
			}
		}
		while(c != e);
		*o++ = '\0';
		ssize_t l = cbindex_not_0(b, c);
		circbuf_shift(b, l);
	}
	return s;
}

void vs_write_circbuf(const void *ptr, size_t size, size_t nmemb, vstream *vs)
{
	circbuf *b = vs->data;
	ssize_t l = size * nmemb;
	circbuf_cat_range(b, ptr, ((const char *)ptr)+l);
}

size_t vs_read_circbuf(void *ptr, size_t size, size_t nmemb, vstream *vs)
{
	circbuf *b = vs->data;
	ssize_t l = size * nmemb;
	if(l > (b->size))
	{
		nmemb = (b->size) / size;
		l = size * nmemb;
		if(!l)
		{
			return 0;
		}
	}
	char *space_end = (b->data + b->space);
	char *i = ((b->data + b->start));
	ssize_t l1 = space_end - i;
	boolean onestep = l <= l1;
	if(onestep)
	{
		l1 = l;
	}
	memmove(ptr, ((b->data + b->start)), l1);
	if(!onestep)
	{
		memmove(((char *)ptr)+l1, b->data, l - l1);
	}
	circbuf_shift(b, l);
	return nmemb;
}

void vs_flush_circbuf(vstream *vs)
{
	circbuf *b = vs->data;
	circbuf_nul_terminate(b);
}

void vs_close_circbuf(vstream *vs)
{
	circbuf *b = vs->data;
	circbuf_to_cstr(b);
}

void vs_shutdown_circbuf(vstream *vs, int how)
{
	if((how == SHUT_WR || how == SHUT_RDWR))
	{
		vs_close_circbuf(vs);
	}
}

void discard(size_t n)
{
	char buf[block_size];
	while(n)
	{
		size_t to_read = imin(block_size, n);
		if((vs_read(buf, 1, to_read)) != to_read)
		{
			error("%s failed: %s", "discard", "file too short");
		}
		n -= to_read;
	}
}

void vcp(void)
{
	char buf[block_size];
	while(1)
	{
		size_t bytes = (vs_read(buf, 1, block_size));
		if(bytes == 0)
		{
			break;
		}
		(vs_write(buf, 1, bytes));
	}
}

int Open(const char *pathname, int flags, mode_t mode)
{
	int fd = open(pathname, flags|0, mode);
	if(fd == -1)
	{
		char msg[8];
		cstr how = "";
		strcpy(msg, "open ");
		switch(flags & 3)
		{
		case O_RDONLY:	how = "r";
			break;
		case O_WRONLY:	how = "w";
			break;
		case O_RDWR:	how = "rw";
		}
		strcat(msg, how);
		failed2(msg, pathname);
	}
	return fd;
}

void Close(int fd)
{
	
	if(close(fd) != 0)
	{
		failed("close");
	}
}

ssize_t Read_some(int fd, void *buf, size_t count)
{
	errno = 0;
	ssize_t bytes_read = read(fd, buf, count);
	if(bytes_read == -1)
	{
		if(errno == EAGAIN)
		{
			bytes_read = 0;
		}
		else
		{
			failed("read");
		}
	}
	return bytes_read;
}

ssize_t Read(int fd, void *buf, size_t count)
{
	ssize_t bytes_read_tot = 0;
	while(1)
	{
		ssize_t bytes_read = Read_some(fd, buf, count);
		bytes_read_tot += bytes_read;
		count -= bytes_read;
		if(count == 0 || bytes_read == 0)
		{
			break;
		}
		buf = (char *)buf + bytes_read;
	}
	return bytes_read_tot;
}

ssize_t Write_some(int fd, const void *buf, size_t count)
{
	ssize_t bytes_written = write(fd, buf, count);
	if(bytes_written == -1)
	{
		if(errno == EAGAIN)
		{
			bytes_written = 0;
		}
		else
		{
			failed("write");
		}
	}
	return bytes_written;
}

void Write(int fd, const void *buf, size_t count)
{
	while(1)
	{
		ssize_t bytes_written = Write_some(fd, buf, count);
		count -= bytes_written;
		if(count == 0)
		{
			break;
		}
		buf = (char *)buf + bytes_written;
	}
}

void slurp_2(int fd, buffer *b)
{
	int space = ((ssize_t)(b->space_end - b->start));
	int size = ((ssize_t)((b->end)-(b->start)));
	char *start = (b->start);
	while(1)
	{
		typeof(Read(fd, start + size, space - size)) bytes_read = Read(fd, start + size, space - size);
		if(bytes_read == 0)
		{
			break;
		}
		buffer_grow(b, bytes_read);
		size += bytes_read;
		if(size == space)
		{
			buffer_double(b);
			space = ((ssize_t)(b->space_end - b->start));
			size = ((ssize_t)((b->end)-(b->start)));
			start = (b->start);
		}
	}
}

buffer *slurp_1(int filedes)
{
	Stats struct__st;
	Stats *st = &struct__st;
	Fstat(filedes, st);
	int size = st->st_size;
	if(size == 0)
	{
		size = 1024;
	}
	else
	{
		++size;
	}
	buffer *b;
	b = (((buffer *)(normal_Malloc(1 * sizeof(buffer)))));
	buffer_init(b, size);
	slurp_2(filedes, b);
	return b;
}

void spurt(int fd, buffer *b)
{
	Write(fd, (b->start), ((ssize_t)((b->end)-(b->start))));
}

void fslurp_2(FILE *s, buffer *b)
{
	int space = ((ssize_t)(b->space_end - b->start));
	int size = ((ssize_t)((b->end)-(b->start)));
	char *start = (b->start);
	while(1)
	{
		int to_read = space - size;
		ssize_t bytes_read = Fread(start + size, 1, to_read, s);
		buffer_grow(b, bytes_read);
		size += bytes_read;
		if(bytes_read < to_read)
		{
			break;
		}
		if(size == space)
		{
			buffer_double(b);
			space = ((ssize_t)(b->space_end - b->start));
			size = ((ssize_t)((b->end)-(b->start)));
			start = (b->start);
		}
	}
}

buffer *fslurp_1(FILE *s)
{
	Stats struct__st;
	Stats *st = &struct__st;
	Fstat(Fileno(s), st);
	int size = st->st_size;
	if(size == 0)
	{
		size = 1024;
	}
	else
	{
		++size;
	}
	buffer *b;
	b = (((buffer *)(normal_Malloc(1 * sizeof(buffer)))));
	buffer_init(b, size);
	fslurp_2(s, b);
	return b;
}

void fspurt(FILE *s, buffer *b)
{
	Fwrite((b->start), 1, ((ssize_t)((b->end)-(b->start))), s);
}

FILE *Fopen(const char *path, const char *mode)
{
	FILE *f = fopen(path, mode);
	if(f == NULL)
	{
		failed3("fopen", mode, path);
	}
	return f;
}

void Fclose(FILE *fp)
{
	
	if(fclose(fp) == EOF)
	{
		failed("fclose");
	}
}

char *Fgets(char *s, int size, FILE *stream)
{
	errno = 0;
	char *rv = fgets(s, size, stream);
	if(errno)
	{
		failed("fgets");
	}
	return rv;
}

int Freadline(buffer *b, FILE *stream)
{
	ssize_t len = ((ssize_t)((b->end)-(b->start)));
	while(1)
	{
		char *rv = Fgets(b->start+len, ((ssize_t)(b->space_end - b->start))-len, stream);
		if(rv == NULL)
		{
			return EOF;
		}
		len += strlen(b->start+len);
		if(b->start[len-1] == '\n')
		{
			if(len>1 && b->start[len-2] == '\r')
			{
				--len;
			}
			--len;
			b->start[len] = '\0';
			break;
		}
		if(len < ((ssize_t)(b->space_end - b->start)) - 1)
		{
			break;
		}
		buffer_double(b);
	}
	buffer_set_size(b, len);
	return 0;
}

int Readline(buffer *b)
{
	return Freadline(b, stdin);
}

cstr Freadline_1(FILE *stream)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 128);
	if(Freadline(b, stream))
	{
		buffer_free(b);
		return NULL;
	}
	return buffer_to_cstr(b);
}

int Printf(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(Vprintf(format, ap)) rv = Vprintf(format, ap);
	va_end(ap);
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

int Fprintf(FILE *stream, const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(Vfprintf(stream, format, ap)) rv = Vfprintf(stream, format, ap);
	va_end(ap);
	return rv;
}

int Vfprintf(FILE *stream, const char *format, va_list ap)
{
	
	int len = vfprintf(stream, format, ap);
	if(len < 0)
	{
		failed("vfprintf");
	}
	return len;
}

void Fflush(FILE *stream)
{
	
	if(fflush(stream) != 0)
	{
		failed("fflush");
	}
}

FILE *Fdopen(int filedes, const char *mode)
{
	FILE *f = fdopen(filedes, mode);
	if(f == NULL)
	{
		failed("fdopen");
	}
	return f;
}

void Nl(FILE *stream)
{
	if(0)
	{
		
	}
	else if(putc('\n', stream) == EOF)
	{
		failed("putc");
	}
}

void crlf(FILE *stream)
{
	Fprintf(stream, "%s", "\r\n");
}

void Puts(const char *s)
{
	
	if(puts(s) < 0)
	{
		failed("puts");
	}
}

void Fsay(FILE *stream, const char *s)
{
	
	Fputs(s, stream);
	if(0)
	{
		
	}
	else if(putc('\n', stream) == EOF)
	{
		failed("putc");
	}
}

void Fputs(const char *s, FILE *stream)
{
	
	if(fputs(s, stream) < 0)
	{
		failed("fputs");
	}
}

int Sayf(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(Vsayf(format, ap)) rv = Vsayf(format, ap);
	va_end(ap);
	return rv;
}

int Vsayf(const char *format, va_list ap)
{
	
	int len = Vprintf(format, ap);
	if(0)
	{
		
	}
	else if(putc('\n', stdout) == EOF)
	{
		failed("putc");
	}
	return len;
}

int Fsayf(FILE *stream, const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(Vfsayf(stream, format, ap)) rv = Vfsayf(stream, format, ap);
	va_end(ap);
	return rv;
}

int Vfsayf(FILE *stream, const char *format, va_list ap)
{
	
	int len = Vfprintf(stream, format, ap);
	if(0)
	{
		
	}
	else if(putc('\n', stream) == EOF)
	{
		failed("putc");
	}
	return len;
}

char *Input(const char *prompt)
{
	return Inputf("%s", prompt);
}

char *Inputf(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(Vinputf(format, ap)) rv = Vinputf(format, ap);
	va_end(ap);
	return rv;
}

char *Vinputf(const char *format, va_list ap)
{
	return Vfinputf(stdin, stdout, format, ap);
}

char *Vfinputf(FILE *in, FILE *out, const char *format, va_list ap)
{
	if(*format)
	{
		Vfprintf(out, format, ap);
	}
	Fflush(out);
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 2);
	int rv = Freadline(b, in);
	if(rv == 0)
	{
		return buffer_to_cstr(b);
	}
	else
	{
		buffer_free(b);
		return NULL;
	}
}

char *Finput(FILE *in, FILE *out, const char *prompt)
{
	return Finputf(in, out, "%s", prompt);
}

char *Finputf(FILE *in, FILE *out, const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(Vfinputf(in, out, format, ap)) rv = Vfinputf(in, out, format, ap);
	va_end(ap);
	return rv;
}

char *Sinput(FILE *s, const char *prompt)
{
	return Sinputf(s, "%s", prompt);
}

char *Sinputf(FILE *s, const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(Vfinputf(s, s, format, ap)) rv = Vfinputf(s, s, format, ap);
	va_end(ap);
	return rv;
}

DIR *Opendir(const char *name)
{
	DIR *d = opendir(name);
	if(d == NULL)
	{
		failed("opendir");
	}
	return d;
}

dirent *Readdir(DIR *dir)
{
	errno = 0;
	struct dirent *e = readdir(dir);
	if(errno)
	{
		failed("readdir");
	}
	return e;
}

void Closedir(DIR *dir)
{
	if(closedir(dir) != 0)
	{
		failed("closedir");
	}
}

vec *Ls(const char *name, int all)
{
	vec *v = ls(name, all);
	if(!v)
	{
		failed2("ls", name);
	}
	return v;
}

vec *ls(const char *name, boolean all)
{
	vec *v;
	v = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
	vec_init_el_size(v, sizeof(cstr), (64));
	return ls_(name, all, v);
}

vec *ls_(const char *name, boolean all, vec *v)
{
	struct dirent *e;
	DIR *dir = opendir(name);
	if(dir == NULL)
	{
		return NULL;
	}
	while(1)
	{
		errno = 0;
		e = readdir(dir);
		if(errno)
		{
			((free(v)), v = NULL);
			v = NULL;
			break;
		}
		if(!e)
		{
			break;
		}
		if(e->d_name[0] == '.' && (!all || e->d_name[1] == '\0' ||  (e->d_name[1] == '.' && e->d_name[2] == '\0')))
		{
			{
				continue;
			}
		}
		*(cstr*)vec_push(v) = (normal_Strdup(e->d_name));
	}
	closedir(dir);
	return v;
}

vec *slurp_lines_0(void)
{
	vec *lines;
	lines = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
	vec_init_el_size(lines, sizeof(cstr), (256));
	return slurp_lines(lines);
}

vec *slurp_lines(vec *lines)
{
	char *s;
	buffer struct__(skip(1, `my__2861_)b);
	buffer *(skip(1, `my__2861_)b) = &struct__(skip(1, `my__2861_)b);
	(buffer_init(((skip(1, `my__2861_)b)), 128));
	while(1)
	{
		buffer_clear(skip(1, `my__2867_)b);
		if(rl(skip(1, `my__2871_)b))
		{
			break;
		}
		s = (((skip(1, `my__2873_)b))->start);
		*(typeof((normal_Strdup(s))) *)vec_push(lines) = ((normal_Strdup(s)));
	}
	return lines;
}

void Remove(const char *path)
{
	if(remove(path) != 0)
	{
		failed("remove");
	}
}

int Temp(buffer *b, char *prefix, char *suffix)
{
	return Tempfile(b, prefix, suffix, NULL, 0, 0600);
}

int Tempdir(buffer *b, char *prefix, char *suffix)
{
	return Tempfile(b, prefix, suffix, NULL, 1, 0600);
}

int Tempfile(buffer *b, char *prefix, char *suffix, char *tmpdir, int dir, int mode)
{
	int n_random_chars = 6;
	char random[n_random_chars + 1];
	char *pathname = b->start;
	if(tmpdir == NULL)
	{
		tmpdir = "/tmp";
	}
	ssize_t len = strlen(tmpdir) + 1 + strlen(prefix) + strlen(suffix) + n_random_chars + 1;
	if(((ssize_t)(b->space_end - b->start)) < len)
	{
		buffer_set_space(b, len);
	}
	random[n_random_chars] = '\0';
	int try;
	for(try=0; try < 10; ++try)
	{
		int i;
		for(i=0; i<n_random_chars; ++i)
		{
			random[i] = random_alphanum();
		}
		snprintf(pathname, len, "%s/%s%s%s", tmpdir, prefix, random, suffix);
		buffer_set_size(b, strlen(pathname));
		if(dir)
		{
			if(mkdir(pathname, mode) == 0)
			{
				return -1;
			}
		}
		else
		{
			int fd = open(pathname, O_RDWR|O_CREAT|O_EXCL, mode);
			if(fd >= 0)
			{
				return fd;
			}
		}
	}
	serror("cannot create tempfile of form %s/%sXXXXXX%s", tmpdir, prefix, suffix);
	return -1;
}

char random_alphanum(void)
{
	int r = ((int)((10 + 26 * 2)*((num)((long double)((long long int)random()*(((1UL<<31)))+random())/((unsigned long long int)(((1UL<<31)))*(((1UL<<31))))))));
	if(r < 10)
	{
		return '0' + r;
	}
	if(r < 10 + 26)
	{
		return 'A' + r - 10;
	}
	return 'a' + r - 10 - 26;
}

int exists(const char *file_name)
{
	struct stat buf;
	return !stat(file_name, &buf);
}

int lexists(const char *file_name)
{
	struct stat buf;
	return !lstat(file_name, &buf);
}

off_t file_size(const char *file_name)
{
	struct stat buf;
	Stat(file_name, &buf);
	return buf.st_size;
}

off_t fd_size(int fd)
{
	struct stat buf;
	Fstat(fd, &buf);
	return buf.st_size;
}

int Stat(const char *file_name, struct stat *buf)
{
	errno = 0;
	int rv = stat(file_name, buf);
	if(rv == 0)
	{
		return 1;
	}
	if(errno == ENOENT || errno == ENOTDIR)
	{
		return 0;
	}
	failed2("stat", file_name);
	return 0;
}

int is_file(const char *file_name)
{
	struct stat buf;
	return Stat(file_name, &buf) && S_ISREG(buf.st_mode);
}

int is_dir(const char *file_name)
{
	struct stat buf;
	return Stat(file_name, &buf) && S_ISDIR(buf.st_mode);
}

int is_symlink(const char *file_name)
{
	struct stat buf;
	return Lstat(file_name, &buf) && S_ISLNK(buf.st_mode);
}

int is_real_dir(const char *file_name)
{
	struct stat buf;
	return Lstat(file_name, &buf) && S_ISDIR(buf.st_mode);
}

void Fstat(int filedes, struct stat *buf)
{
	if(fstat(filedes, buf) == -1)
	{
		failed("fstat");
	}
}

void cx(const char *path)
{
	chmod_add(path, S_IXUSR | S_IXGRP | S_IXOTH);
}

void cnotx(const char *path)
{
	chmod_sub(path, S_IXUSR | S_IXGRP | S_IXOTH);
}

void chmod_add(const char *path, mode_t add_mode)
{
	Stats struct__s;
	Stats *s = &struct__s;
	Stats_init(s, path);
	Chmod(path, s->st_mode | add_mode);
}

void chmod_sub(const char *path, mode_t sub_mode)
{
	Stats struct__s;
	Stats *s = &struct__s;
	Stats_init(s, path);
	Chmod(path, s->st_mode & ~sub_mode);
}

void Stats_init(stats *s, const char *file_name)
{
	if(!Stat(file_name, s))
	{
		(bzero(s, sizeof(*s)));
	}
}

void Lstats_init(stats *s, const char *file_name)
{
	if(!Lstat(file_name, s))
	{
		(bzero(s, sizeof(*s)));
	}
}

void stats_init(stats *s, const char *file_name)
{
	if(stat(file_name, s))
	{
		(bzero(s, sizeof(*s)));
	}
}

void lstats_init(stats *s, const char *file_name)
{
	if(lstat(file_name, s))
	{
		(bzero(s, sizeof(*s)));
	}
}

int Lstat(const char *file_name, struct stat *buf)
{
	errno = 0;
	int rv = lstat(file_name, buf);
	if(rv == 0)
	{
		return 1;
	}
	if(errno == ENOENT || errno == ENOTDIR)
	{
		return 0;
	}
	failed2("lstat", file_name);
	return 0;
}

FILE *Popen(const char *command, const char *type)
{
	FILE *rv = popen(command, type);
	if(rv == NULL)
	{
		failed("popen");
	}
	return rv;
}

int Pclose(FILE *stream)
{
	int rv = pclose(stream);
	if(rv == -1)
	{
		failed("pclose");
	}
	return -1;
}

int Fgetc(FILE *stream)
{
	int c = fgetc(stream);
	if(c == EOF && ferror(stream))
	{
		failed("fgetc");
	}
	return c;
}

void Fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream)
{
	
	size_t count = fwrite(ptr, size, nmemb, stream);
	if(count != nmemb)
	{
		failed("fwrite");
	}
}

size_t Fread(void *ptr, size_t size, size_t nmemb, FILE *stream)
{
	size_t count = fread(ptr, size, nmemb, stream);
	if(count < nmemb && ferror(stream))
	{
		failed("fread");
	}
	return count;
}

size_t Fread_all(void *ptr, size_t size, size_t nmemb, FILE *stream)
{
	size_t count = fread(ptr, size, nmemb, stream);
	if(count < nmemb)
	{
		failed("fread");
	}
	return count;
}

void Fwrite_str(FILE *stream, str s)
{
	Fwrite(s.start, (s.end - s.start), 1, stream);
}

void Fwrite_buffer(FILE *stream, buffer *b)
{
	Fwrite((b->start), ((ssize_t)((b->end)-(b->start))), 1, stream);
}

size_t Fread_buffer(FILE *stream, buffer *b)
{
	return Fread((b->end), ((ssize_t)(b->space_end - b->end)), 1, stream);
}

void Fputc(int c, FILE *stream)
{
	if(0)
	{
		
	}
	else if(fputc(c, stream) == EOF)
	{
		{
			failed("fputc");
		}
	}
}

void Fseek(FILE *stream, long offset, int whence)
{
	if(fseek(stream, offset, whence))
	{
		failed("fseek");
	}
}

long Ftell(FILE *stream)
{
	long ret = ftell(stream);
	if(ret == -1)
	{
		failed("ftell");
	}
	return ret;
}

off_t Lseek(int fd, off_t offset, int whence)
{
	off_t ret = lseek(fd, offset, whence);
	if(ret == -1)
	{
		failed("lseek");
	}
	return ret;
}

void Truncate(const char *path, off_t length)
{
	int ret = truncate(path, length);
	if(ret)
	{
		failed("truncate");
	}
}

void Ftruncate(int fd, off_t length)
{
	int ret = ftruncate(fd, length);
	if(ret)
	{
		failed("ftruncate");
	}
}

int io__readlink2(const char *path, buffer *b)
{
	while(1)
	{
		typeof(readlink(path, (b->end), ((ssize_t)(b->space_end - b->end)))) len = readlink(path, (b->end), ((ssize_t)(b->space_end - b->end)));
		if(len == -1)
		{
			if(errno == ENAMETOOLONG)
			{
				buffer_double(b);
			}
			else
			{
				return -1;
			}
		}
		else
		{
			buffer_grow(b, len);
			return 0;
		}
	}
}

void _Readlink(const char *path, buffer *b)
{
	if(io__readlink2(path, b) < 0)
	{
		failed("readlink");
	}
}

cstr Readlink(const char *path)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 256);
	return (_Readlink(path, b), buffer_to_cstr(b));
}

cstr io__readlink1(const char *path)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 256);
	return (io__readlink2(path, b) < 0 ? (cstr)NULL : buffer_to_cstr(b));
}

cstr readlinks(cstr path, opt_err if_dead)
{
	Stats struct__stat_b;
	Stats *stat_b = &struct__stat_b;
	while(1)
	{
		if(lstat(path, stat_b))
		{
			return opt_err_do(if_dead, (any){.cs=path}, (any){.cs=NULL}, "file does not exist: %s", path).cs;
		}
		if(!S_ISLNK(stat_b->st_mode))
		{
			break;
		}
		typeof(Readlink(path)) path1 = Readlink(path);
		path1 = path_relative_to(path1, path);
		((free(path)), path = NULL);
		path = path1;
	}
	return path;
}

void _Getcwd(buffer *b)
{
	while(1)
	{
		if(getcwd((b->end), ((ssize_t)(b->space_end - b->end))) == NULL)
		{
			if(errno == ERANGE)
			{
				buffer_double(b);
			}
			else
			{
				failed("getcwd");
			}
		}
		else
		{
			buffer_grow(b, strlen(b->end));
			return;
		}
	}
}

cstr Getcwd(void)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 256);
	_Getcwd(b);
	return buffer_to_cstr(b);
}

void Chdir(const char *path)
{
	if(chdir(path) != 0)
	{
		failed2("chdir", path);
	}
}

void Mkdir(const char *pathname, mode_t mode)
{
	int rv = mkdir(pathname, mode);
	if(rv)
	{
		failed2("mkdir", pathname);
	}
}

void Mkdir_if(const char *pathname, mode_t mode)
{
	if(!is_dir(pathname))
	{
		Mkdir(pathname, mode);
	}
}

void say_cstr(cstr s)
{
	Puts(s);
	((free(s)), s = NULL);
}

void Rename(const char *oldpath, const char *newpath)
{
	if(rename(oldpath, newpath) == -1)
	{
		failed("rename");
	}
}

void Chmod(const char *path, mode_t mode)
{
	if(chmod(path, mode) != 0)
	{
		failed("chmod");
	}
}

void Symlink(const char *oldpath, const char *newpath)
{
	if(symlink(oldpath, newpath) == -1)
	{
		failed3("symlink", oldpath, newpath);
	}
}

void Link(const char *oldpath, const char *newpath)
{
	if(link(oldpath, newpath) == -1)
	{
		failed("link");
	}
}

void Pipe(int filedes[2])
{
	if(pipe(filedes) != 0)
	{
		failed("pipe");
	}
}

int Dup(int oldfd)
{
	int fd = dup(oldfd);
	if(fd == -1)
	{
		failed("dup");
	}
	return fd;
}

int Dup2(int oldfd, int newfd)
{
	int fd = dup2(oldfd, newfd);
	if(fd == -1)
	{
		failed("dup2");
	}
	return fd;
}

FILE *Freopen(const char *path, const char *mode, FILE *stream)
{
	FILE *f = freopen(path, mode, stream);
	if(f == NULL)
	{
		failed("freopen");
	}
	return f;
}

void print_range(char *start, char *end)
{
	fprint_range(stdout, start, end);
}

void fprint_range(FILE *stream, char *start, char *end)
{
	Fwrite(start, 1, end-start, stream);
}

void say_range(char *start, char *end)
{
	fsay_range(stdout, start, end);
}

void fsay_range(FILE *stream, char *start, char *end)
{
	fprint_range(stream, start, end);
}

void stats_dump(Stats *s)
{
	Sayf("dev\t%d", s->st_dev);
	Sayf("ino\t%d", s->st_ino);
	Sayf("mode\t%d", s->st_mode);
	Sayf("nlink\t%d", s->st_nlink);
	Sayf("uid\t%d", s->st_uid);
	Sayf("gid\t%d", s->st_gid);
	Sayf("rdev\t%d", s->st_rdev);
	Sayf("size\t%d", s->st_size);
	Sayf("atime\t%d", s->st_atime);
	Sayf("mtime\t%d", s->st_mtime);
	Sayf("ctime\t%d", s->st_ctime);
}

mode_t mode(const char *file_name)
{
	Stats struct__s;
	Stats *s = &struct__s;
	Stats_init(s, file_name);
	return s->st_mode;
}

void cp(const char *from, const char *to, int mode)
{
	int in, out;
	in = ((Open(from, O_RDONLY, 0666)));
	out = (Open(to, O_WRONLY|O_CREAT, mode));
	(cp_fd_unbuf(in, out));
	Close(out);
	Close(in);
}

off_t cp_fd_chunked(int in, int out)
{
	char buf[block_size];
	off_t count = 0;
	while(1)
	{
		size_t len = Read(in, buf, sizeof(buf));
		if(len == 0)
		{
			break;
		}
		Write(out, buf, len);
		count += len;
	}
	return count;
}

off_t cp_fd_unbuf(int in, int out)
{
	char buf[block_size];
	off_t count = 0;
	while(1)
	{
		size_t len = Read_some(in, buf, sizeof(buf));
		if(len == 0)
		{
			goto eof;
		}
		char *p = buf;
		while(len)
		{
			off_t sent = Write_some(out, p, len);
			if(sent == 0)
			{
				failed("cp_fd");
			}
			len -= sent;
			p += sent;
			count += sent;
		}
	}
eof:	return count;
}

void fcp(FILE *in, FILE *out)
{
	char buf[block_size];
	while(1)
	{
		size_t len = Fread(buf, 1, sizeof(buf), in);
		if(len == 0)
		{
			break;
		}
		Fwrite(buf, 1, len, out);
	}
}

int Select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, num timeout)
{
	struct timeval timeout_tv;
	int rv = select(nfds, readfds, writefds, exceptfds, delay_to_timeval(timeout, &timeout_tv));
	if(rv < 0 && errno != EINTR)
	{
		failed("select");
	}
	return rv;
}

void fd_set_init(fd_set *o)
{
	FD_ZERO(o);
}

int can_read(int fd, num timeout)
{
	if(!tmp_fd_set)
	{
		tmp_fd_set = (((fd_set *)(normal_Malloc(1 * sizeof(fd_set)))));
		fd_set_init(tmp_fd_set);
	}
	FD_SET(fd, tmp_fd_set);
	int n_ready = Select(fd+1, tmp_fd_set, NULL, NULL, timeout);
	FD_CLR(fd, tmp_fd_set);
	if(n_ready == -1)
	{
		n_ready = 0;
	}
	return n_ready;
}

int can_write(int fd, num timeout)
{
	if(!tmp_fd_set)
	{
		tmp_fd_set = (((fd_set *)(normal_Malloc(1 * sizeof(fd_set)))));
		fd_set_init(tmp_fd_set);
	}
	FD_SET(fd, tmp_fd_set);
	int n_ready = Select(fd+1, NULL, tmp_fd_set, NULL, timeout);
	FD_CLR(fd, tmp_fd_set);
	if(n_ready == -1)
	{
		n_ready = 0;
	}
	return n_ready;
}

int has_error(int fd, num timeout)
{
	if(!tmp_fd_set)
	{
		tmp_fd_set = (((fd_set *)(normal_Malloc(1 * sizeof(fd_set)))));
		fd_set_init(tmp_fd_set);
	}
	FD_SET(fd, tmp_fd_set);
	int n_ready = Select(fd+1, NULL, NULL, tmp_fd_set, timeout);
	FD_CLR(fd, tmp_fd_set);
	if(n_ready == -1)
	{
		n_ready = 0;
	}
	return n_ready;
}

void Mkdirs(const char *pathname, mode_t mode)
{
	cstr (skip(1, `my__2992_)cwd) = Getcwd();
	Mkdirs_cwd(pathname, mode, (skip(1, `my__2994_)cwd));
	((free((skip(1, `my__2996_)cwd))), ((skip(1, `my__2996_)cwd)) = NULL);
}

void Mkdirs_cwd(const char *pathname, mode_t mode, cstr basedir)
{
	cstr dir1 = (normal_Strdup(pathname));
	cstr dir = dir1;
	while(1)
	{
		typeof(dir) d = dir;
		typeof(dir) b = dir;
		if(mingw && (isalpha((unsigned)(*b))) && b[1] == ':')
		{
			b+=2;
		}
		while(((*b) == '/'))
		{
			++b;
		}
		while(*b != '\0' && !((*b) == '/'))
		{
			++b;
		}
		if(*b)
		{
			*b = '\0';
			++b;
		}
		else
		{
			b = NULL;
		}
		mkdir(d, mode);
		Chdir(d);
		if(!b || !*b)
		{
			break;
		}
		dir = b;
	}
	((free(dir1)), dir1 = NULL);
	Chdir(basedir);
}

void Rmdir(const char *pathname)
{
	if(rmdir(pathname))
	{
		failed("rmdir");
	}
}

void Rmdirs(const char *pathname)
{
	cstr dir = (normal_Strdup(pathname));
	while(1)
	{
		if(rmdir(dir))
		{
			break;
		}
		typeof(dir_name(dir)) d = dir_name(dir);
		if((*d == '.' || *d == '/') && d[1] == '\0')
		{
			break;
		}
		dir = d;
	}
	((free(dir)), dir = NULL);
}

boolean newer(const char *file1, const char *file2)
{
	Stats struct__s1;
	Stats *s1 = &struct__s1;
	Stats_init(s1, file1);
	Stats struct__s2;
	Stats *s2 = &struct__s2;
	Stats_init(s2, file2);
	return s1->st_mtime - s2->st_mtime > 0;
}

void lnsa(cstr from, cstr to, cstr cwd)
{
	cstr cwd1 = path_cat(cwd, "");
	from = path_tidy(path_relative_to((normal_Strdup(from)), cwd1));
	if(is_dir(to))
	{
		cstr from1 = (normal_Strdup(from));
		cstr to1 = path_cat(to, base_name(from1));
		((free(from1)), from1 = NULL);
		remove(to1);
		Symlink(from, to1);
		((free(to1)), to1 = NULL);
	}
	else
	{
		remove(to);
		Symlink(from, to);
	}
	((free(cwd1)), cwd1 = NULL);
	((free(from)), from = NULL);
}

void Cp(cstr from, cstr to, Lstats *sf)
{
	if(S_ISLNK(sf->st_mode))
	{
		if(!Cp_symlink)
		{
			Cp_symlink = &_Cp_symlink;
			buffer_init(Cp_symlink, 256);
		}
		buffer_clear(Cp_symlink);
		Symlink((_Readlink(from, Cp_symlink), buffer_to_cstr(Cp_symlink)), to);
	}
	else if(S_ISREG(sf->st_mode))
	{
		(cp(from, to, 0666));
	}
	else
	{
		warn("irregular file %s not copied", from);
	}
}

void CP(cstr from, cstr to, Lstats *sf)
{
	Cp(from, to, sf);
	cp_attrs_st(sf, to);
}

void cp_attrs(cstr from, cstr to)
{
	Lstats struct__sf;
	Lstats *sf = &struct__sf;
	Lstats_init(sf, from);
	cp_attrs_st(sf, to);
}

void cp_mode(Stats *sf, cstr to)
{
	if(chmod(to, sf->st_mode))
	{
		warn("chmod %s %0d failed", to, sf->st_mode);
	}
}

void Utime(const char *filename, const struct utimbuf *times)
{
	if(utime(filename, (struct utimbuf *)times))
	{
		failed2("utime", filename);
	}
}

void cp_times(Lstats *sf, cstr to)
{
	struct utimbuf times;
	times.actime = sf->st_atime;
	times.modtime = sf->st_mtime;
	if(utime(to, &times))
	{
		warn("utime %s failed", to);
	}
}

void cp_atime(Lstats *sf, cstr to, Lstats *st)
{
	struct utimbuf times;
	times.actime = sf->st_atime;
	times.modtime = st->st_mtime;
	Utime(to, &times);
}

void cp_mtime(Lstats *sf, cstr to, Lstats *st)
{
	struct utimbuf times;
	times.actime = st->st_atime;
	times.modtime = sf->st_mtime;
	Utime(to, &times);
}

void Setvbuf(FILE *stream, char *buf, int mode, size_t size)
{
	if(setvbuf(stream, buf, mode, size))
	{
		failed("setvbuf");
	}
}

ssize_t Readv(int fd, const struct iovec *iov, int iovcnt)
{
	ssize_t rv = readv(fd, iov, iovcnt);
	if(rv < 0)
	{
		failed("readv");
	}
	return rv;
}

ssize_t Writev(int fd, const struct iovec *iov, int iovcnt)
{
	ssize_t rv = writev(fd, iov, iovcnt);
	if(rv < 0)
	{
		failed("writev");
	}
	return rv;
}

int file_cmp(cstr fa, cstr fb)
{
	int cmp;
	Stats struct__sta;
	Stats *sta = &struct__sta;
	Stats_init(sta, fa);
	Stats struct__stb;
	Stats *stb = &struct__stb;
	Stats_init(stb, fb);
	if(sta->st_size != stb->st_size)
	{
		return 1;
	}
	buffer struct__a;
	buffer *a = &struct__a;
	buffer_init(a, block_size);
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, block_size);
	ssize_t na, nb;
	int fda = (open(fa, O_RDONLY|0));
	if(fda == -1)
	{
		return 1;
	}
	int fdb = (open(fb, O_RDONLY|0));
	if(fdb == -1)
	{
		Close(fda);
		return 1;
	}
	while(1)
	{
		na = Read(fda, ((a->start)), ((ssize_t)(a->space_end - a->start)));
		nb = Read(fdb, ((b->start)), ((ssize_t)(b->space_end - b->start)));
		if(na != nb)
		{
			cmp = 1;
			break;
		}
		if(memcmp(((a->start)), ((b->start)), na))
		{
			cmp = 1;
			break;
		}
		if(na < ((ssize_t)(a->space_end - a->start)))
		{
			cmp = 0;
			break;
		}
	}
	Close(fda);
	Close(fdb);
	return cmp;
}

void create_hole(cstr file, off_t size)
{
	int fd = (Open(file, (O_WRONLY|O_CREAT|O_TRUNC), 0666));
	Ftruncate(fd, size);
	Close(fd);
}

void insert_hole(cstr file, off_t offset, off_t size)
{
	int block_size = 4096;
	int fd = (Open(file, (O_RDWR|O_CREAT), 0666));
	off_t old_size = fd_size(fd);
	off_t end = offset+size;
	if(end >= old_size)
	{
		Ftruncate(fd, offset);
		Ftruncate(fd, end);
	}
	else
	{
		char b[block_size];
		buffer struct__temp_name;
		buffer *temp_name = &struct__temp_name;
		buffer_init(temp_name, 128);
		int temp_fd = Temp(temp_name, "hole_", ".tmp");
		off_t n = (old_size - end + block_size - 1) / block_size;
		typeof(0-1) (skip(1, `my__3088_)end) = 0-1;
		typeof(n-1) (skip(1, `my__3093_)v1) = n-1;
		for(; (skip(1, `my__3098_)v1)>(skip(1, `my__3100_)end); --(skip(1, `my__3102_)v1))
		{
			typeof((skip(1, `my__3104_)v1)) i = (skip(1, `my__3104_)v1);
			off_t from = end + i * block_size;
			off_t l = block_size;
			if(from+l > old_size)
			{
				l = old_size - from;
			}
			(Lseek(fd, from, SEEK_SET));
			Read(fd, b, block_size);
			int is_hole = 1;
			typeof(l) (skip(1, `my__3111_)end) = l;
			typeof(0) (skip(1, `my__3116_)v1) = 0;
			for(; (skip(1, `my__3121_)v1)<(skip(1, `my__3123_)end); ++(skip(1, `my__3125_)v1))
			{
				typeof((skip(1, `my__3127_)v1)) check = (skip(1, `my__3127_)v1);
				if(b[check] != 0)
				{
					is_hole = 0;
					break;
				}
			}
			if(is_hole)
			{
				Lseek(temp_fd, block_size, SEEK_CUR);
			}
			else
			{
				Write(temp_fd, b, block_size);
			}
			Ftruncate(fd, from);
		}
		Ftruncate(fd, offset);
		(Lseek(fd, end, SEEK_SET));
		typeof(n) (skip(1, `my__3134_)end) = n;
		typeof(0) (skip(1, `my__3139_)v1) = 0;
		for(; (skip(1, `my__3144_)v1)<(skip(1, `my__3146_)end); ++(skip(1, `my__3148_)v1))
		{
			typeof((skip(1, `my__3150_)v1)) i = (skip(1, `my__3150_)v1);
			off_t from = (n-1-i) * block_size;
			off_t to = end + i * block_size;
			off_t l = block_size;
			if(to+l > old_size)
			{
				l = old_size - to;
			}
			(Lseek(temp_fd, from, SEEK_SET));
			Read(temp_fd, b, block_size);
			int is_hole = 1;
			typeof(l) (skip(1, `my__3157_)end) = l;
			typeof(0) (skip(1, `my__3162_)v1) = 0;
			for(; (skip(1, `my__3167_)v1)<(skip(1, `my__3169_)end); ++(skip(1, `my__3171_)v1))
			{
				typeof((skip(1, `my__3173_)v1)) check = (skip(1, `my__3173_)v1);
				if(b[check] != 0)
				{
					is_hole = 0;
					break;
				}
			}
			if(is_hole)
			{
				Lseek(fd, l, SEEK_CUR);
			}
			else
			{
				Write(fd, b, l);
			}
			Ftruncate(temp_fd, from);
		}
		Ftruncate(fd, imax(old_size, offset+size));
		Close(temp_fd);
		Remove(buffer_to_cstr(temp_name));
	}
	Close(fd);
}

int Fileno(FILE *stream)
{
	int rv = fileno(stream);
	if(rv < 0)
	{
		failed("fileno");
	}
	return rv;
}

void fprint_vec_cstr(FILE *s, cstr h, vec *v)
{
	Fprintf(s, "%s", h);
	vec *(skip(1, `my__3180_)v1) = v;
	cstr *(skip(1, `my__3182_)end) = ((vec_element(((skip(1, `my__3184_)v1)), ((skip(1, `my__3184_)v1))->size)));
	cstr *(skip(1, `my__3188_)i1) = ((vec_element(((skip(1, `my__3190_)v1)), 0)));
	for(; (skip(1, `my__3194_)i1)!=(skip(1, `my__3196_)end) ; ++(skip(1, `my__3198_)i1))
	{
		typeof((skip(1, `my__3200_)i1)) i = (skip(1, `my__3200_)i1);
		
		Fprintf(s, " %s", *i);
	}
	if(0)
	{
		
	}
	else if(putc('\n', s) == EOF)
	{
		failed("putc");
	}
}

cstr read_lines(vec *lines, cstr in_file)
{
	FILE *in = Fopen(in_file, "r");
	cstr data = buffer_to_cstr(fslurp_1(in));
	Fclose(in);
	cstr l = data;
	char *i;
	for(i=data; *i != '\0'; ++i)
	{
		
		if(*i == '\n')
		{
			*i = '\0';
			*(typeof(l) *)vec_push(lines) = l;
			l = i + 1;
		}
	}
	return data;
}

void write_lines(vec *lines, cstr out_file)
{
	FILE *(skip(1, `my__3212_)s) = (Fopen(out_file, "wb"));
	vstream *(skip(1, `my__3215_)old_out) = out;
	vstream struct__(skip(1, `my__3217_)vs);
	vstream *(skip(1, `my__3217_)vs) = &struct__(skip(1, `my__3217_)vs);
	vstream_init_stdio(((skip(1, `my__3217_)vs)), ((skip(1, `my__3219_)s)));
	int ((skip(1, `my__3225_)p)) = 0;
}
void ((skip(1, `my__3225_)p))	if ((skip(1, `my__3225_)p)) == 1
{
	{
		++((skip(1, `my__3225_)p));
		
		Fclose(skip(1, `my__3228_)s);
		out = (skip(1, `my__3230_)old_out);
	}
	for(; ((skip(1, `my__3232_)p)) < 2 ; ++((skip(1, `my__3232_)p)))
	{
		if(((skip(1, `my__3232_)p)) == 1)
		{
			goto ((skip(1, `my__3232_)p));
		}
		
		out = (skip(1, `my__3235_)vs);
		
		dump_lines(lines);
	}
}

void dump_lines(vec *lines)
{
	vec *(skip(1, `my__3238_)v1) = lines;
	cstr *(skip(1, `my__3240_)end) = ((vec_element(((skip(1, `my__3242_)v1)), ((skip(1, `my__3242_)v1))->size)));
	cstr *(skip(1, `my__3246_)i1) = ((vec_element(((skip(1, `my__3248_)v1)), 0)));
	for(; (skip(1, `my__3252_)i1)!=(skip(1, `my__3254_)end) ; ++(skip(1, `my__3256_)i1))
	{
		typeof((skip(1, `my__3258_)i1)) i = (skip(1, `my__3258_)i1);
		
		say(*i);
	}
}

void warn_lines(vec *lines, cstr msg)
{
	if(msg)
	{
		warn("<< dumping lines: %s <<", msg);
	}
	vstream struct__(skip(1, `my__3264_)vs);
	vstream *(skip(1, `my__3264_)vs) = &struct__(skip(1, `my__3264_)vs);
	vstream_init_stdio(((skip(1, `my__3264_)vs)), stderr);
	vstream *((skip(1, `my__3273_)old_out)) = out;
	int ((skip(1, `my__3276_)x)) = 0;
}
void ((skip(1, `my__3276_)x))	if ((skip(1, `my__3276_)x)) == 1
{
	{
		++((skip(1, `my__3276_)x));
		
		out = ((skip(1, `my__3273_)old_out));
	}
	for(; ((skip(1, `my__3279_)x)) < 2 ; ++((skip(1, `my__3279_)x)))
	{
		if(((skip(1, `my__3279_)x)) == 1)
		{
			goto ((skip(1, `my__3279_)x));
		}
		
		((skip(1, `my__3273_)old_out)) = out;
		out = (((skip(1, `my__3270_)vs)));
		
		
		dump_lines(lines);
	}
	if(msg)
	{
		warn(">> done dumping lines: %s >>", msg);
	}
}

void Fspurt(cstr file, cstr content)
{
	FILE *(skip(1, `my__3283_)s) = (Fopen(file, "wb"));
	vstream *(skip(1, `my__3286_)old_out) = out;
	vstream struct__(skip(1, `my__3288_)vs);
	vstream *(skip(1, `my__3288_)vs) = &struct__(skip(1, `my__3288_)vs);
	vstream_init_stdio(((skip(1, `my__3288_)vs)), ((skip(1, `my__3290_)s)));
	int ((skip(1, `my__3296_)p)) = 0;
}
void ((skip(1, `my__3296_)p))	if ((skip(1, `my__3296_)p)) == 1
{
	{
		++((skip(1, `my__3296_)p));
		
		Fclose(skip(1, `my__3299_)s);
		out = (skip(1, `my__3301_)old_out);
	}
	for(; ((skip(1, `my__3303_)p)) < 2 ; ++((skip(1, `my__3303_)p)))
	{
		if(((skip(1, `my__3303_)p)) == 1)
		{
			goto ((skip(1, `my__3303_)p));
		}
		
		out = (skip(1, `my__3306_)vs);
		
		print(content);
	}
}

cstr Fslurp(cstr file)
{
	FILE *s = fopen(file, "rb");
	if(!s)
	{
		return (normal_Strdup(""));
	}
	cstr rv = buffer_to_cstr(fslurp_1(s));
	Fclose(s);
	return rv;
}

cstr dotfile(cstr f)
{
	return path_cat(homedir(), f);
}

cstr scan_cstr(cstr *a, cstr l)
{
	*a = l;
	return scan_skip(l);
}

cstr scan_int(int *a, cstr l)
{
	if(is_scan_space(l))
	{
		error("scan_x: found space");
	}
	if(sscanf(l, "%d", a) != 1)
	{
		error("scan_x: not found");
	}
	return scan_skip(l);
}

cstr scan_short(short *a, cstr l)
{
	if(is_scan_space(l))
	{
		error("scan_x: found space");
	}
	if(sscanf(l, "%hd", a) != 1)
	{
		error("scan_x: not found");
	}
	return scan_skip(l);
}

cstr scan_char(char *a, cstr l)
{
	short i;
	l = scan_short(&i, l);
	*a = (char)i;
	return scan_skip(l);
}

cstr scan_long(long *a, cstr l)
{
	if(is_scan_space(l))
	{
		error("scan_x: found space");
	}
	if(sscanf(l, "%ld", a) != 1)
	{
		error("scan_x: not found");
	}
	return scan_skip(l);
}

cstr scan_long_long(long long *a, cstr l)
{
	if(is_scan_space(l))
	{
		error("scan_x: found space");
	}
	if(sscanf(l, "%lld", a) != 1)
	{
		error("scan_x: not found");
	}
	return scan_skip(l);
}

cstr scan_num(num *a, cstr l)
{
	if(is_scan_space(l))
	{
		error("scan_x: found space");
	}
	if(sscanf(l, "%lf", a) != 1)
	{
		error("scan_x: not found");
	}
	return scan_skip(l);
}

cstr scan_double(double *a, cstr l)
{
	if(is_scan_space(l))
	{
		error("scan_x: found space");
	}
	if(sscanf(l, "%lf", a) != 1)
	{
		error("scan_x: not found");
	}
	return scan_skip(l);
}

cstr scan_float(float *a, cstr l)
{
	if(is_scan_space(l))
	{
		error("scan_x: found space");
	}
	if(sscanf(l, "%f", a) != 1)
	{
		error("scan_x: not found");
	}
	return scan_skip(l);
}

cstr scan_long_double(long double *a, cstr l)
{
	if(is_scan_space(l))
	{
		error("scan_x: found space");
	}
	if(sscanf(l, "%Lf", a) != 1)
	{
		error("scan_x: not found");
	}
	return scan_skip(l);
}

cstr scan_skip(cstr l)
{
	cstr next;
	while(*l && !(next = is_scan_space(l)))
	{
		++l;
	}
	if(*l)
	{
		*l = '\0';
		l = next;
	}
	else
	{
		l = NULL;
	}
	return l;
}

cstr is_scan_space(cstr s)
{
	if(scan_space)
	{
		return cstr_begins_with(s, scan_space);
	}
	else
	{
		return (isspace((unsigned)(*s))) ? s+1 : NULL;
	}
}

void do_delay(num t)
{
	if(t != (-1e100))
	{
		if(can_read(STDIN_FILENO, t))
		{
			((Freadline_1(stdin)));
		}
	}
	else
	{
		((Freadline_1(stdin)));
	}
}

void kv_io_init(void)
{
	scan_space = ": ";
	print_space = ": ";
}

int Fgetline(buffer *b, FILE *stream)
{
	buffer_clear(b);
	typeof(Freadline(b, stream)) rv = Freadline(b, stream);
	return rv;
}

int Getline(buffer *b)
{
	return Fgetline(b, stdin);
}

filetype_t file_type(const char *file_name)
{
	filetype_t type = 0;
	mode_t ft = lstat_ft(file_name);
	if(ft == S_IFLNK)
	{
		type |= FT_LINK;
		ft = stat_ft(file_name);
		if(!ft)
		{
			return type;
		}
	}
	type |= FT_EXISTS;
	if(ft == S_IFDIR)
	{
		type |= FT_DIR;
	}
	else
	{
		type |= FT_FILE;
		switch(ft)
		{
		case S_IFREG:	type |= FT_REG;
			break;
		case S_IFIFO:	type |= FT_FIFO;
			break;
		case S_IFSOCK:	type |= FT_SOCK;
			break;
		case S_IFCHR:	type |= FT_CHR;
			break;
		case S_IFBLK:	type |= FT_BLK;
		}
	}
	return type;
}

mode_t stat_ft(const char *file_name)
{
	struct stat buf;
	return Stat(file_name, &buf) ? buf.st_mode & S_IFMT : 0;
}

mode_t lstat_ft(const char *file_name)
{
	struct stat buf;
	return Lstat(file_name, &buf) ? buf.st_mode & S_IFMT : 0;
}

int Pselect(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, num timeout, const sigset_t *sigmask)
{
	struct timespec timeout_ts;
	int rv = pselect(nfds, readfds, writefds, exceptfds, delay_to_timespec(timeout, &timeout_ts), sigmask);
	if(rv < 0 && errno != EINTR)
	{
		failed("pselect");
	}
	return rv;
}

int Poll(struct pollfd *fds, nfds_t nfds, num timeout)
{
	int rv = poll(fds, nfds, delay_to_ms(timeout));
	if(rv == -1 && errno != EINTR)
	{
		failed("poll");
	}
	return rv;
}

int fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len)
{
	struct flock fl;
	fl.l_type = type;
	fl.l_whence = whence;
	fl.l_start = start;
	fl.l_len = len;
	int rv = fcntl(fd, cmd, &fl);
	return rv;
}

int Fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len)
{
	int rv = fcntl_flock(fd, cmd, type, whence, start, len);
	if(rv == -1)
	{
		failed("fcntl flock");
	}
	return rv;
}

int Fcntl_getfd(int fd)
{
	int rv = fcntl(fd, F_GETFD);
	if(rv == -1)
	{
		error("fcntl_getfd");
	}
	return rv;
}

void Fcntl_setfd(int fd, long arg)
{
	int rv = fcntl(fd, F_SETFD, arg);
	if(rv == -1)
	{
		error("fcntl_setfd");
	}
}

int Fcntl_getfl(int fd)
{
	int rv = fcntl(fd, F_GETFL);
	if(rv == -1)
	{
		error("fcntl_getfl");
	}
	return rv;
}

void Fcntl_setfl(int fd, long arg)
{
	int rv = fcntl(fd, F_SETFL, arg);
	if(rv == -1)
	{
		error("fcntl_setfl");
	}
}

void cloexec(int fd)
{
	Fcntl_setfd(fd, FD_CLOEXEC);
}

void cloexec_off(int fd)
{
	Fcntl_setfd(fd, 0);
}

void Chown(const char *path, uid_t uid, gid_t gid)
{
	if(chown(path, uid, gid) != 0)
	{
		failed("chown");
	}
}

void Lchown(const char *path, uid_t uid, gid_t gid)
{
	if(lchown(path, uid, gid) != 0)
	{
		failed("lchown");
	}
}

void cp_attrs_st(Lstats *sf, cstr to)
{
	if(!S_ISLNK(sf->st_mode))
	{
		cp_mode(sf, to);
	}
	if(((uid_t)(myuid != -1 ? myuid : (myuid = getuid()))) == uid_root)
	{
		cp_owner(sf, to);
	}
	cp_times(sf, to);
}

void cp_owner(Lstats *sf, cstr to)
{
	if(chown(to, sf->st_uid, sf->st_gid))
	{
		warn("chown %s %0d:%0d failed", to, sf->st_uid, sf->st_gid);
	}
}

void Socketpair(int d, int type, int protocol, int sv[2])
{
	if(socketpair(d, type, protocol, sv) != 0)
	{
		failed("socketpair");
	}
}

void nonblock_fcntl(int fd, int nb)
{
	if(nb)
	{
		Fcntl_setfl(fd, Fcntl_getfl(fd) | O_NONBLOCK);
	}
	else
	{
		Fcntl_setfl(fd, Fcntl_getfl(fd) & ~O_NONBLOCK);
	}
}

void nonblock_ioctl(int fd, int nb)
{
	if(ioctl(fd, FIONBIO, &nb) == -1)
	{
		failed("ioctl");
	}
}

int Epoll_create(int size)
{
	int rv = epoll_create(size);
	if(rv < 0)
	{
		failed("epoll_create");
	}
	return rv;
}

void Epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)
{
	int rv = epoll_ctl(epfd, op, fd, event);
	if(rv < 0)
	{
		failed("epoll_ctl");
	}
}

int Epoll_wait(int epfd, struct epoll_event *events, int maxevents, num timeout)
{
	int rv = epoll_wait(epfd, events, maxevents, delay_to_ms(timeout));
	if(rv < 0 && errno != EINTR)
	{
		failed("epoll_wait");
	}
	return rv;
}

int Epoll_pwait(int epfd, struct epoll_event *events, int maxevents, num timeout, const sigset_t *sigmask)
{
	int rv = epoll_pwait(epfd, events, maxevents, delay_to_ms(timeout), sigmask);
	if(rv < 0 && errno != EINTR)
	{
		failed("epoll_pwait");
	}
	return rv;
}

void *normal_Malloc(size_t size)
{
	if(size == 0)
	{
		size = 1;
	}
	void *ptr = malloc(size);
	if(ptr == NULL)
	{
		failed("malloc");
	}
	return ptr;
}

void *normal_Realloc(void *ptr, size_t size)
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

void *normal_Calloc(size_t nmemb, size_t size)
{
	if(nmemb == 0 || size == 0)
	{
		nmemb = 1;
		size = 1;
	}
	void *ptr = calloc(nmemb, size);
	if((ptr == NULL))
	{
		failed("calloc");
	}
	return ptr;
}

cstr normal_Strdup(const char *s)
{
	cstr rv = strdup(s);
	if(rv == NULL)
	{
		failed("strdup");
	}
	return rv;
}

char *normal_Strndup(const char *s, size_t n)
{
	char *rv = strndup(s, n);
	if(!rv)
	{
		failed("strndup");
	}
	return rv;
}

void *rc_malloc(size_t size)
{
	count_t *count = (normal_Malloc(sizeof(count_t) + size));
	*count = 1;
	void *obj = count + 1;
	return obj;
}

count_t rc_use(void *obj)
{
	count_t *count = ((count_t *)obj) - 1;
	return ++ *count;
}

count_t rc_done(void *obj)
{
	count_t *count = ((count_t *)obj) - 1;
	return -- *count;
}

void rc_free(void *obj)
{
	count_t *count = ((count_t *)obj) - 1;
	((free(count)), count = NULL);
}

void *rc_calloc(size_t nmemb, size_t size)
{
	return rc_malloc(nmemb * size);
}

void memlog_stderr(void)
{
	memlog_on = 1;
	memlog = stderr;
}

void memlog_file(cstr file)
{
	memlog_on = 1;
	memlog = Fopen(file, "w");
	((Setvbuf(memlog, NULL, _IOLBF, 0)));
}

void *memlog_Malloc(size_t size, char *file, int line)
{
	void *rv = normal_Malloc(size);
	if(memlog_on)
	{
		Fprintf(memlog, "A\tmalloc\t%010p\t%d\t%s:%d\n", rv, size, file, line);
	}
	return rv;
}

void memlog_Free(void *ptr, char *file, int line)
{
	(free(ptr));
	if(memlog_on)
	{
		Fprintf(memlog, "F\tfree\t%010p\t\t%s:%d\n", ptr, file, line);
	}
}

void *memlog_Realloc(void *ptr, size_t size, char *file, int line)
{
	void *rv = normal_Realloc(ptr, size);
	if(memlog_on)
	{
		Fprintf(memlog, "F\trealloc\t%010p\t\t%s:%d\n", ptr, file, line);
		Fprintf(memlog, "A\trealloc\t%010p\t%d\t%s:%d\n", rv, size, file, line);
	}
	return rv;
}

void *memlog_Calloc(size_t nmemb, size_t size, char *file, int line)
{
	void *rv = normal_Calloc(nmemb, size);
	if(memlog_on)
	{
		Fprintf(memlog, "A\tcalloc\t%010p\t%d\t%s:%d\n", rv, nmemb*size, file, line);
	}
	return rv;
}

cstr memlog_Strdup(const char *s, char *file, int line)
{
	cstr rv = normal_Strdup(s);
	if(memlog_on)
	{
		Fprintf(memlog, "A\tstrdup\t%010p\t%d\t%s:%d\n", rv, strlen(rv), file, line);
	}
	return rv;
}

cstr memlog_Strndup(const char *s, size_t n, char *file, int line)
{
	cstr rv = normal_Strndup(s, n);
	if(memlog_on)
	{
		Fprintf(memlog, "A\tstrndup\t%010p\t%d\t%s:%d\n", rv, strlen(rv), file, line);
	}
	return rv;
}

void *tofree(void *obj)
{
	if(obj)
	{
		*(typeof(obj) *)vec_push(tofree_vec) = obj;
	}
	return obj;
}

void free_all(vec *v)
{
	vec *(skip(1, `my__3341_)v1) = v;
	void* *(skip(1, `my__3343_)end) = ((vec_element(((skip(1, `my__3345_)v1)), ((skip(1, `my__3345_)v1))->size)));
	void* *(skip(1, `my__3349_)i1) = ((vec_element(((skip(1, `my__3351_)v1)), 0)));
	for(; (skip(1, `my__3355_)i1)!=(skip(1, `my__3357_)end) ; ++(skip(1, `my__3359_)i1))
	{
		typeof((skip(1, `my__3361_)i1)) i = (skip(1, `my__3361_)i1);
		
		((free(*i)), (*i) = NULL);
	}
	vec_size(v, 0);
}

void *Mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
{
	void *rv = mmap(addr, length, prot, flags, fd, offset);
	if(rv == MAP_FAILED)
	{
		failed("mmap");
	}
	return rv;
}

int Munmap(void *addr, size_t length)
{
	int rv = munmap(addr, length);
	if(rv < 0)
	{
		failed("munmap");
	}
	return rv;
}

void hexdump(FILE *stream, char *b0, char *b1)
{
	typeof(b1 - b0) n = b1 - b0;
	while(n > 0)
	{
		typeof(imin(n, 16)) c = imin(n, 16);
		typeof((b0 + c)) (skip(1, `my__3378_)end) = (b0 + c);
		typeof(b0) (skip(1, `my__3383_)v1) = b0;
		for(; (skip(1, `my__3388_)v1)<(skip(1, `my__3390_)end); ++(skip(1, `my__3392_)v1))
		{
			typeof((skip(1, `my__3394_)v1)) b = (skip(1, `my__3394_)v1);
			fprintf(stream, "%02x ", (uchar)(*b));
		}
		typeof(((3 * (16 - c) + 4))) (skip(1, `my__3406_)end) = ((3 * (16 - c) + 4));
		typeof(0) (skip(1, `my__3411_)v1) = 0;
		for(; (skip(1, `my__3416_)v1)<(skip(1, `my__3418_)end); ++(skip(1, `my__3420_)v1))
		{
			typeof((skip(1, `my__3422_)v1)) ((skip(1, `my__3403_)i)) = (skip(1, `my__3422_)v1);
			(void)((skip(1, `my__3427_)i));
			if(0)
			{
				
			}
			else if(putc(' ', stream) == EOF)
			{
				failed("putc");
			}
		}
		typeof((b0 + c)) (skip(1, `my__3434_)end) = (b0 + c);
		typeof(b0) (skip(1, `my__3439_)v1) = b0;
		for(; (skip(1, `my__3444_)v1)<(skip(1, `my__3446_)end); ++(skip(1, `my__3448_)v1))
		{
			typeof((skip(1, `my__3450_)v1)) _b = (skip(1, `my__3450_)v1);
			if(0)
			{
				
			}
			else if(putc((printable(*_b) ? (*_b) : '.'), stream) == EOF)
			{
				failed("putc");
			}
		}
		b0 += 16;
		n -= 16;
		if(0)
		{
			
		}
		else if(putc('\n', stream) == EOF)
		{
			failed("putc");
		}
	}
	if(0)
	{
		
	}
	else if(putc('\n', stream) == EOF)
	{
		failed("putc");
	}
}

boolean printable(uchar c)
{
	return c >= 32 && c < 128;
}

void *Id_func(void *x)
{
	return x;
}

void *mem_mem(const void* haystack, size_t haystacklen, const void* needle, size_t needlelen)
{
	int i;
	if(needlelen > haystacklen)
	{
		return 0;
	}
	for(i=haystacklen-needlelen+1; i; --i, haystack = (char*)haystack+1)
	{
		if(!memcmp(haystack,needle,needlelen))
		{
			return (void*)haystack;
		}
	}
	return 0;
}

int num_cmp(const void *a, const void *b)
{
	return ((*(num*)a) > (*(num*)b) ? 1 : (*(num*)a) < (*(num*)b) ? -1 : 0);
}

int int_cmp(const void *a, const void *b)
{
	return ((*(int*)a) > (*(int*)b) ? 1 : (*(int*)a) < (*(int*)b) ? -1 : 0);
}

int long_cmp(const void *a, const void *b)
{
	return ((*(long*)a) > (*(long*)b) ? 1 : (*(long*)a) < (*(long*)b) ? -1 : 0);
}

int off_t_cmp(const void *a, const void *b)
{
	return ((*(off_t*)a) > (*(off_t*)b) ? 1 : (*(off_t*)a) < (*(off_t*)b) ? -1 : 0);
}

size_t arylen(void *_p)
{
	void **p = _p;
	int count = 0;
	while((*p++))
	{
		++count;
	}
	return count;
}

vec *sort_vec(vec *v, cmp_t cmp)
{
	qsort(((vec_element(v, 0))), ((v->size)), (v->element_size), cmp);
	return v;
}

int cstr_cmp(const void *_a, const void *_b)
{
	char * const *a = _a;
	char * const *b = _b;
	return strcmp(*a, *b);
}

int cstrp_cmp_null(const void *_a, const void *_b)
{
	char * const *a = _a;
	char * const *b = _b;
	if(!*a || !*b)
	{
		if(*a)
		{
			return -1;
		}
		else if(*b)
		{
			return 1;
		}
		return 0;
	}
	return strcmp(*a, *b);
}

void comm(vec *merge_v, vec *comm_v, vec *va, vec *vb, cmp_t cmp, free_t *freer)
{
	size_t maxlen = ((va->size))+((vb->size));
	vec_space(merge_v, maxlen);
	vec_space(comm_v, maxlen);
	char *a = ((vec_element(va, 0)));
	char *b = ((vec_element(vb, 0)));
	char *a_end = ((vec_element(va, va->size)));
	char *b_end = ((vec_element(vb, vb->size)));
	size_t e = (merge_v->element_size);
	while(a != a_end && b != b_end)
	{
		int c = cmp(a, b);
		void *m;
		byte w;
		if(c == 0)
		{
			w = 3;
			m = a;
			if(freer)
			{
				(*freer)(*(void **)b);
			}
			a += e;
			b += e;
		}
		else if(c < 0)
		{
			w = 1;
			m = a;
			a += e;
		}
		else
		{
			w = 2;
			m = b;
			b += e;
		}
		void *p = vec_push(merge_v);
		memmove(p, m, e);
		*(typeof(w) *)vec_push(comm_v) = w;
	}
	size_t n = 0;
	byte comm_val;
	if(a != a_end)
	{
		n = (a_end - a) / e;
		((vec_splice(merge_v, (((merge_v->size))), 0, a, n)));
		comm_val = 1;
	}
	else if(b != b_end)
	{
		n = (b_end - b) / e;
		((vec_splice(merge_v, (((merge_v->size))), 0, b, n)));
		comm_val = 2;
	}
	if(n)
	{
		vec_grow(comm_v, n);
		byte *e = ((vec_element(comm_v, comm_v->size)));
		typeof(e) (skip(1, `my__3502_)end) = e;
		typeof((e-n)) (skip(1, `my__3507_)v1) = (e-n);
		for(; (skip(1, `my__3512_)v1)<(skip(1, `my__3514_)end); ++(skip(1, `my__3516_)v1))
		{
			typeof((skip(1, `my__3518_)v1)) i = (skip(1, `my__3518_)v1);
			*i = comm_val;
		}
	}
	vec_squeeze(merge_v);
	vec_squeeze(comm_v);
}

void comm_dump_cstr(vec *merge_v, vec *comm_v)
{
	if(1 && !(((comm_v->size) == (merge_v->size))))
	{
		fault_(__FILE__, __LINE__, "badcall: comm_dump_cstr %d %d", ((((comm_v->size)))), ((((merge_v->size)))));
	}
	*(typeof(NULL) *)vec_push(merge_v) = NULL;
	vec_pop(merge_v);
	cstr *m = (vec_element(merge_v, 0));
	byte *c = (vec_element(comm_v, 0));
	while(*m)
	{
		Sayf("%d\t%s", *c, *m);
		++m;
		++c;
	}
}

void *memdup(const void *src, size_t n, size_t extra)
{
	void *dest = (normal_Malloc(n+extra));
	memcpy(dest, src, n);
	return dest;
}

void cstr_set_add(vec *set, cstr s)
{
	vec *(skip(1, `my__3539_)v1) = set;
	cstr *(skip(1, `my__3541_)end) = ((vec_element(((skip(1, `my__3543_)v1)), ((skip(1, `my__3543_)v1))->size)));
	cstr *(skip(1, `my__3547_)i1) = ((vec_element(((skip(1, `my__3549_)v1)), 0)));
	for(; (skip(1, `my__3553_)i1)!=(skip(1, `my__3555_)end) ; ++(skip(1, `my__3557_)i1))
	{
		typeof((skip(1, `my__3559_)i1)) i = (skip(1, `my__3559_)i1);
		
		if(cstr_eq(*i, s))
		{
			return;
		}
	}
	*(typeof(s) *)vec_push(set) = s;
}

unsigned int bit_reverse(unsigned int x)
{
	int n = 0;
	while(x)
	{
		n <<= 1;
		n |= (x & 1);
		x >>= 1;
	}
	return n;
}

boolean version_ge(cstr v0, cstr v1)
{
	cstr digits = "0123456789";
	while(1)
	{
		int i = atoi(v0), j = atoi(v1);
		if(i > j)
		{
			return 1;
		}
		if(i < j)
		{
			return 0;
		}
		v0 += strspn(v0, digits);
		v0 += strcspn(v0, digits);
		v1 += strspn(v1, digits);
		v1 += strcspn(v1, digits);
		if(*v0 == '\0')
		{
			return 1;
		}
		if(*v1 == '\0')
		{
			return 0;
		}
	}
}

cstr hashbang(cstr file)
{
	cstr exe = NULL;
	FILE *(skip(1, `my__3566_)s) = (Fopen(file, "rb"));
	vstream *(skip(1, `my__3569_)old_in) = in;
	vstream struct__(skip(1, `my__3571_)vs);
	vstream *(skip(1, `my__3571_)vs) = &struct__(skip(1, `my__3571_)vs);
	vstream_init_stdio(((skip(1, `my__3571_)vs)), ((skip(1, `my__3573_)s)));
	int ((skip(1, `my__3579_)p)) = 0;
}
void ((skip(1, `my__3579_)p))	if ((skip(1, `my__3579_)p)) == 1
{
	{
		++((skip(1, `my__3579_)p));
		
		Fclose(skip(1, `my__3582_)s);
		in = (skip(1, `my__3584_)old_in);
	}
	for(; ((skip(1, `my__3586_)p)) < 2 ; ++((skip(1, `my__3586_)p)))
	{
		if(((skip(1, `my__3586_)p)) == 1)
		{
			goto ((skip(1, `my__3586_)p));
		}
		
		in = (skip(1, `my__3589_)vs);
		
		exe = (rl_0());
		if(exe)
		{
			cstr_chomp(exe);
			if(cstr_begins_with(exe, "#!") == 0)
			{
				cstr_chop_start(exe, exe+2);
			}
			else
			{
				((free(exe)), exe = NULL);
			}
		}
	}
	return exe;
}

void *dflt(void *p, void *dflt)
{
	return p ? p : dflt;
}

void remove_null(vec *v)
{
	void* *((skip(1, `my__3597_)o)) = ((vec_element(v, 0)));
	vec *(skip(1, `my__3603_)v1) = v;
	void* *(skip(1, `my__3605_)end) = ((vec_element(((skip(1, `my__3607_)v1)), ((skip(1, `my__3607_)v1))->size)));
	void* *(skip(1, `my__3611_)i1) = ((vec_element(((skip(1, `my__3613_)v1)), 0)));
	for(; (skip(1, `my__3617_)i1)!=(skip(1, `my__3619_)end) ; ++(skip(1, `my__3621_)i1))
	{
		typeof((skip(1, `my__3623_)i1)) i = (skip(1, `my__3623_)i1);
		
		if((((*i))))
		{
			*((skip(1, `my__3597_)o))++ = *i;
		}
		else
		{
			
		}
	}
	vec_size(v, ((skip(1, `my__3597_)o))-(void* *)((vec_element(v, 0))));
	vec_squeeze(v);
}

void *orp(void *a, void *b)
{
	return a ? a : b;
}

int ori(int a, int b)
{
	return a ? a : b;
}

cstr nul_to(char *a, char *b, char replacement)
{
	typeof(b) (skip(1, `my__3634_)end) = b;
	typeof(a) (skip(1, `my__3639_)v1) = a;
	for(; (skip(1, `my__3644_)v1)<(skip(1, `my__3646_)end); ++(skip(1, `my__3648_)v1))
	{
		typeof((skip(1, `my__3650_)v1)) i = (skip(1, `my__3650_)v1);
		if(!*i)
		{
			*i = replacement;
		}
	}
	return a;
}

void uniq_vos(vec *v)
{
	hashtable struct__(((skip(1, `my__3659_)already_ht)));
	hashtable *(((skip(1, `my__3659_)already_ht))) = &struct__(((skip(1, `my__3659_)already_ht)));
	hashtable_init((((skip(1, `my__3659_)already_ht))), cstr_hash, cstr_eq, 1001);
	void* *((skip(1, `my__3670_)o)) = ((vec_element(v, 0)));
	vec *(skip(1, `my__3676_)v1) = v;
	void* *(skip(1, `my__3678_)end) = ((vec_element(((skip(1, `my__3680_)v1)), ((skip(1, `my__3680_)v1))->size)));
	void* *(skip(1, `my__3684_)i1) = ((vec_element(((skip(1, `my__3686_)v1)), 0)));
	for(; (skip(1, `my__3690_)i1)!=(skip(1, `my__3692_)end) ; ++(skip(1, `my__3694_)i1))
	{
		typeof((skip(1, `my__3696_)i1)) i = (skip(1, `my__3696_)i1);
		
		if(((!(hashtable_already((((((skip(1, `my__3659_)already_ht))))), ((void*)(intptr_t)(*i)))))))
		{
			*((skip(1, `my__3670_)o))++ = *i;
		}
		else
		{
			
		}
	}
	vec_size(v, ((skip(1, `my__3670_)o))-(void* *)((vec_element(v, 0))));
	hashtable_free(((skip(1, `my__3659_)already_ht)), NULL, NULL);
}

void uniq_vovos(vec *v)
{
	hashtable struct__(((skip(1, `my__3711_)already_ht)));
	hashtable *(((skip(1, `my__3711_)already_ht))) = &struct__(((skip(1, `my__3711_)already_ht)));
	hashtable_init((((skip(1, `my__3711_)already_ht))), vos_hash, vos_eq, 1001);
	void* *((skip(1, `my__3722_)o)) = ((vec_element(v, 0)));
	vec *(skip(1, `my__3728_)v1) = v;
	void* *(skip(1, `my__3730_)end) = ((vec_element(((skip(1, `my__3732_)v1)), ((skip(1, `my__3732_)v1))->size)));
	void* *(skip(1, `my__3736_)i1) = ((vec_element(((skip(1, `my__3738_)v1)), 0)));
	for(; (skip(1, `my__3742_)i1)!=(skip(1, `my__3744_)end) ; ++(skip(1, `my__3746_)i1))
	{
		typeof((skip(1, `my__3748_)i1)) i = (skip(1, `my__3748_)i1);
		
		if(((!(hashtable_already((((((skip(1, `my__3711_)already_ht))))), ((void*)(intptr_t)(*i)))))))
		{
			*((skip(1, `my__3722_)o))++ = *i;
		}
		else
		{
			
		}
	}
	vec_size(v, ((skip(1, `my__3722_)o))-(void* *)((vec_element(v, 0))));
	hashtable_free(((skip(1, `my__3711_)already_ht)), NULL, NULL);
}

boolean isword(char c)
{
	return (isalnum((unsigned)c)) || c == '_';
}

cstr lookup_cstr(cstr2cstr *ix, cstr key, cstr default_val)
{
	typeof(ix) i = ix;
	for(i=ix; i->k != NULL; ++i)
	{
		if(cstr_eq(i->k, key))
		{
			return i->v;
		}
	}
	return default_val;
}

cstr Lookup_cstr(cstr2cstr *ix, cstr key)
{
	cstr val = lookup_cstr(ix, key, ((void*)-1));
	if(val == ((void*)-1))
	{
		failed2("lookup_cstr", key);
	}
	return val;
}

void io_epoll_init(io_epoll *io)
{
	io->epfd = Epoll_create(io_epoll_size);
	io->max_fd_plus_1 = 0;
	io->count = 0;
	io->events = (((vec *)(normal_Malloc(1 * sizeof(vec)))));
	vec_init_el_size(io->events, sizeof(epoll_event), (io_epoll_maxevents));
}

int io_epoll_wait(io_epoll *io, num delay, sigset_t *sigmask)
{
	int n_ready = Epoll_pwait(io->epfd, ((vec_element((io->events), 0))), ((io->events)->space), delay, sigmask);
	vec_size(io->events, imax(n_ready, 0));
	return n_ready;
}

int io_epoll_add(io_epoll *io, int fd, boolean et)
{
	epoll_event ev;
	ev.events = (et ? EPOLLET : 0) | EPOLLIN | EPOLLOUT;
	ev.data.fd = fd;
	if(epoll_ctl(io->epfd, EPOLL_CTL_ADD, fd, &ev) < 0)
	{
		swarning("failed epoll_ctl ADD %d", fd);
		return -1;
	}
	if(fd >= io->max_fd_plus_1)
	{
		io->max_fd_plus_1 = fd + 1;
		return 1;
	}
	return 0;
}

void io_epoll_rm(io_epoll *io, int fd)
{
	if(epoll_ctl(io->epfd, EPOLL_CTL_DEL, fd, &io_epoll_rm__event))
	{
		swarning("failed epoll_ctl DEL %d", fd);
	}
}

void scheduler_init(scheduler *sched)
{
	sched->exit = 0;
	_deq_init(&sched->q, sizeof(proc_p), (8));
	io_epoll_init(&sched->io);
	vec_init_el_size(&sched->readers, sizeof(proc_p), (8));
	vec_init_el_size(&sched->writers, sizeof(proc_p), (8));
	sched->now = -1;
	vec_init_el_size((((&sched->tos))), sizeof(timeout_p), (64));
	hashtable_init(&sched->child_wait, int_hash, int_eq, sched__children_n_buckets);
	hashtable_init(&sched->child_status, int_hash, int_eq, sched__children_n_buckets);
	sched->step = 0;
	sched->n_children = 0;
	sched->got_sigchld = 0;
	(Sigact(SIGCHLD, sched_sigchld_handler, SA_RESTART|(SIGCHLD == SIGCHLD ? SA_NOCLDSTOP : 0)));
}

void scheduler_free(scheduler *sched)
{
	deq_free(&sched->q);
	vec_free(&sched->readers);
	vec_free(&sched->writers);
	vec_free(&sched->tos);
}

void start_f(proc *p)
{
	*(proc **)deq_push(&sched->q) = p;
}

void run(void)
{
	sched->exit = 0;
	while(!sched->exit)
	{
		step();
	}
}

void step(void)
{
	int need_select;
	num delay;
	int n_ready = 0;
	io_epoll *io = &sched->io;
	timeouts *tos = &sched->tos;
	if(!((((tos->size)) == 0)))
	{
		delay = timeouts_delay(tos, sched_get_time());
	}
	else if(sched->q.size)
	{
		delay = (io->count) ? sched_delay : 0;
	}
	else
	{
		delay = (-1e100);
	}
	if(delay == (-1e100) && (io->count) == 0 && sched->n_children == 0)
	{
		sched->exit = 1;
		return;
	}
	need_select = delay || (sched_busy && (io->count) && sched->step % sched_busy == 0);
	sigset_t oldsigmask, *oldsigmaskp = NULL;
	int got_sigchld = 0;
	if(need_select)
	{
		if(sched->n_children)
		{
			oldsigmaskp = &oldsigmask;
			if(sched_sig_child_exited(oldsigmaskp))
			{
				delay = 0;
			}
		}
		
		n_ready = io_epoll_wait(io, delay, oldsigmaskp);
		sched_forget_time();
		
		if(sched->n_children)
		{
			if(sched_sig_child_exited_2(oldsigmaskp))
			{
				got_sigchld = 1;
			}
		}
	}
	if(got_sigchld)
	{
		pid_t pid;
		while(sched->n_children && (pid = Child_done()))
		{
			proc *p = (hashtable_value_or_null((&sched->child_wait), ((void*)(intptr_t)pid)));
			if(p)
			{
				clr_waitchild(pid);
				waitchild__pid = pid;
				waitchild__status = wait__status;
				
				if(resume(p))
				{
					
					start_f(p);
				}
				else
				{
					
				}
			}
			else
			{
				drop_child(pid, NULL);
				warn("no waiter for child %d", pid);
				(hashtable_add((&sched->child_status), ((void*)(intptr_t)pid), ((void*)(intptr_t)wait__status)));
			}
		}
	}
	if(!((((tos->size)) == 0)))
	{
		timeouts_call(tos, sched_get_time());
	}
	if(n_ready > 0)
	{
		int fd;
		vec *(skip(1, `my__3854_)v1) = io->events;
		epoll_event *(skip(1, `my__3856_)end) = ((vec_element(((skip(1, `my__3858_)v1)), ((skip(1, `my__3858_)v1))->size)));
		epoll_event *(skip(1, `my__3862_)i1) = ((vec_element(((skip(1, `my__3864_)v1)), 0)));
		for(; (skip(1, `my__3868_)i1)!=(skip(1, `my__3870_)end) ; ++(skip(1, `my__3872_)i1))
		{
			typeof((skip(1, `my__3874_)i1)) (skip(1, `my__3851_)e) = (skip(1, `my__3874_)i1);
			
			fd = (skip(1, `my__3879_)e)->data.fd;
			boolean can_read = (skip(1, `my__3881_)e)->events & (EPOLLIN|EPOLLHUP);
			boolean can_write = (skip(1, `my__3883_)e)->events & (EPOLLOUT|EPOLLHUP);
			boolean has_error = (skip(1, `my__3885_)e)->events & EPOLLERR;
			if(!(can_read || can_write || has_error))
			{
				continue;
			}
			
			if(has_error)
			{
				errno = Getsockerr(fd);
				if(!(errno == ECONNRESET || errno == EPIPE))
				{
					swarning("sched: fd %d has an error", fd);
				}
			}
			if(can_read)
			{
				proc *p = *(proc **)vec_element(&sched->readers, fd);
				
				if(p)
				{
					clr_reader(fd);
					if(resume(p))
					{
						
						start_f(p);
					}
					else
					{
						
					}
				}
			}
			if(can_write)
			{
				proc *p = *(proc **)vec_element(&sched->writers, fd);
				
				if(p)
				{
					clr_writer(fd);
					if(resume(p))
					{
						
						start_f(p);
					}
					else
					{
						
					}
				}
			}
		}
	}
	if(sched->q.size)
	{
		proc *p = *(proc **)deq_element(&sched->q, 0);
		deq_shift(&sched->q);
		
		if(resume(p))
		{
			
			start_f(p);
		}
		else
		{
			
		}
	}
	++sched->step;
}

int scheduler_add_fd(scheduler *sched, int fd, int et)
{
	int rv = io_epoll_add(&sched->io, fd, et);
	if(rv == 1)
	{
		vec_ensure_size(&sched->readers, fd+1);
		vec_ensure_size(&sched->writers, fd+1);
		rv = 0;
	}
	if(rv == 0)
	{
		*(proc **)vec_element(&sched->readers, fd) = NULL;
		*(proc **)vec_element(&sched->writers, fd) = NULL;
	}
	return rv;
}

void fd_has_error(int fd)
{
	io_epoll_rm(&sched->io, fd);
	*(proc **)vec_element(&sched->readers, fd) = NULL;
	*(proc **)vec_element(&sched->writers, fd) = NULL;
	close(fd);
}

void set_reader(int fd, proc *p)
{
	
	*(proc**)vec_element(&sched->readers, fd) = p;
	++(&sched->io)->count;
}

void set_writer(int fd, proc *p)
{
	
	*(proc**)vec_element(&sched->writers, fd) = p;
	++(&sched->io)->count;
}

void clr_reader(int fd)
{
	*(proc**)vec_element(&sched->readers, fd) = NULL;
	--(&sched->io)->count;
}

void clr_writer(int fd)
{
	*(proc**)vec_element(&sched->writers, fd) = NULL;
	--(&sched->io)->count;
}

int sched_child_exited(pid_t pid)
{
	int status = (int)((intptr_t)((hashtable_value_or((&sched->child_status), ((void*)(intptr_t)pid), ((void*)(intptr_t)(-1))))));
	if(status != -1)
	{
		(hashtable_delete((&sched->child_status), ((void*)(intptr_t)pid)));
	}
	return status;
}

void set_waitchild(pid_t pid, proc *p)
{
	
	if(1 && !(((hashtable_value_or_null((&sched->child_wait), ((void*)(intptr_t)pid))) == NULL)))
	{
		fault_(__FILE__, __LINE__, "set_waitchild: waiter already set");
	}
	(hashtable_add((&sched->child_wait), ((void*)(intptr_t)pid), ((void*)(intptr_t)p)));
	++sched->n_children;
}

void have_child(pid_t pid, proc *p)
{
	(void)pid;
	(void)p;
	++sched->n_children;
}

void drop_child(pid_t pid, proc *p)
{
	(void)pid;
	(void)p;
	--sched->n_children;
}

void clr_waitchild(pid_t pid)
{
	
	(hashtable_delete((&sched->child_wait), ((void*)(intptr_t)pid)));
	--sched->n_children;
}

void sched_sigchld_handler(int signum)
{
	(void)signum;
	sched->got_sigchld = 1;
}

num sched_get_time(void)
{
	if(sched->now < 0)
	{
		sched_set_time();
	}
	return sched->now;
}

void sched_forget_time(void)
{
	sched->now = -1;
}

void sched_set_time(void)
{
	sched->now = rtime();
}

boolean sched_sig_child_exited(sigset_t *oldsigmask)
{
	*oldsigmask = Sig_defer(SIGCHLD);
	return sched->got_sigchld;
}

boolean sched_sig_child_exited_2(sigset_t *oldsigmask)
{
	boolean got_sigchld = 0;
	if(sched->got_sigchld)
	{
		got_sigchld = 1;
		sched->got_sigchld = 0;
	}
	Sig_setmask(oldsigmask);
	return got_sigchld;
}

void shuttle_init(shuttle *sh, proc *p1, proc *p2)
{
	sh->current = p1;
	sh->other = p2;
	sh->other_state = ACTIVE;
}

boolean pull_f(shuttle *s, proc *p)
{
	
	boolean must_wait = s->current != p;
	if(must_wait)
	{
		s->other_state = WAITING;
		
	}
	return must_wait;
}

void push_f(shuttle *s, proc *p)
{
	
	if(s->current == p)
	{
		
		proc *other = s->other;
		s->current = other;
		s->other = p;
		int other_state = s->other_state;
		s->other_state = ACTIVE;
		if(other_state == WAITING)
		{
			
			start_f(other);
		}
	}
}

void sock_init(sock *s, socklen_t socklen)
{
	s->fd = -1;
	s->sa = (normal_Malloc(socklen));
	s->len = socklen;
	bzero(s->sa, socklen);
}

void sock_free(sock *s)
{
	if(s->fd != -1)
	{
		close(s->fd);
	}
	s->fd = -1;
	((free(s->sa)), (s->sa) = NULL);
}

in_addr sock_in_addr(sock *s)
{
	return ((sockaddr_in*)s->sa)->sin_addr;
}

uint16_t sock_in_port(sock *s)
{
	return ntohs(((sockaddr_in*)s->sa)->sin_port);
}

void listener_tcp_init(listener_try *p, cstr listen_addr, int listen_port)
{
	int listen_fd = (Server_tcp(listen_addr, listen_port));
	listener_try_init(p, listen_fd, sizeof(sockaddr_in));
}

proc listener_sel(int listen_fd, socklen_t socklen)
{
	port sock_p out;
	state sock_p s;
	if((scheduler_add_fd(sched, listen_fd, 0)))
	{
		Close(listen_fd);
		error("listener: can't create listener, too many sockets");
	}
	cloexec(listen_fd);
	((nonblock_ioctl(listen_fd, 1)));
	while(1)
	{
		s = (((sock *)(normal_Malloc(1 * sizeof(sock)))));
		sock_init(s, socklen)
		{
			set_reader(listen_fd, b__p)
			{
				b__p->pc = 2;
				return 0;
			case 2:	;
			}
		}
		s->fd = accept(listen_fd, (struct sockaddr *)s->sa, &s->len);
		if(s->fd < 0)
		{
			sock_free(s);
			if(errno == EAGAIN)
			{
				
			}
			else if(errno == EMFILE || errno == ENFILE)
			{
				warn("listener: maximum number of file descriptors exceeded, rejecting %d", s->fd);
			}
			else
			{
				failed("accept");
			}
		}
		else if(((scheduler_add_fd(sched, ((s->fd)), 1))))
		{
			warn("listener: maximum number of sockets exceeded, rejecting %d", s->fd);
			sock_free(s);
		}
		else
		{
			cloexec(s->fd);
			((nonblock_ioctl(((s->fd)), 1)));
			(keepalive((s->fd), 1));
			
			if(pull_f(&This->out->sh, b__p))
			{
				{
					b__p->pc = 3;
					return 0;
				case 3:	;
				}
			}
			out = s;
			push_f(&This->out->sh, b__p);
		}
	}
}

proc listener_try(int listen_fd, socklen_t socklen)
{
	port sock_p out;
	state sock_p s;
	if((scheduler_add_fd(sched, listen_fd, 1)))
	{
		Close(listen_fd);
		error("listener: can't create listener, too many sockets");
	}
	cloexec(listen_fd);
	((nonblock_ioctl(listen_fd, 1)));
	while(1)
	{
		s = (((sock *)(normal_Malloc(1 * sizeof(sock)))));
		sock_init(s, socklen);
		s->fd = accept(listen_fd, (struct sockaddr *)s->sa, &s->len);
		if(s->fd < 0)
		{
			sock_free(s);
			if(errno == EAGAIN)
			{
				
			}
			else if(errno == EMFILE || errno == ENFILE)
			{
				warn("listener: maximum number of file descriptors exceeded, rejecting %d", s->fd);
			}
			else
			{
				failed("accept");
				set_reader(listen_fd, b__p)
				{
					b__p->pc = 2;
					return 0;
				case 2:	;
				}
			}
		}
		else if(((scheduler_add_fd(sched, ((s->fd)), 1))))
		{
			warn("listener: maximum number of sockets exceeded, rejecting %d", s->fd);
			sock_free(s);
		}
		else
		{
			cloexec(s->fd);
			((nonblock_ioctl(((s->fd)), 1)));
			(keepalive((s->fd), 1));
			
			if(pull_f(&This->out->sh, b__p))
			{
				{
					b__p->pc = 3;
					return 0;
				case 3:	;
				}
			}
			out = s;
			push_f(&This->out->sh, b__p);
		}
	}
}

proc write_sock(void)
{
	port sock_p in;
	state sock_p s;
	while(1)
	{
		
		if(pull_f(&This->in->sh, b__p))
		{
			{
				b__p->pc = 2;
				return 0;
			case 2:	;
			}
		}
		s = in;
		push_f(&This->in->sh, b__p);
		Sayf("%d", s->fd);
		io_epoll_rm(&sched->io, ((s->fd)));
		*(proc **)vec_element(&sched->readers, (((s->fd)))) = NULL;
		*(proc **)vec_element(&sched->writers, (((s->fd)))) = NULL;
		sock_free(s);
	}
}

proc reader_sel(int fd, size_t block_size)
{
	port buffer out;
	state boolean done = 0;
	while(!done)
	{
		
		if(pull_f(&This->out->sh, b__p))
		{
			{
				b__p->pc = 2;
				return 0;
			case 2:	;
			}
		}
		
		buffer_ensure_free(&out, block_size);
		
		{
			set_reader(fd, b__p)
			{
				b__p->pc = 3;
				return 0;
			case 3:	;
			}
		}
		ssize_t n = read(fd, (((&out)->end)), ((ssize_t)((&out)->space_end - (&out)->end)));
		if(n == -1)
		{
			n = 0;
			if(errno != ECONNRESET)
			{
				swarning("reader %010p: error", b__p);
			}
		}
		else if(n)
		{
			buffer_grow(&out, n);
		}
		if(n == 0)
		{
			
			buffer_clear(&out);
			done = 1;
		}
		push_f(&This->out->sh, b__p);
	}
}

proc writer_sel(int fd)
{
	port buffer in;
	state boolean done = 0;
	while(!done)
	{
		
		if(pull_f(&This->in->sh, b__p))
		{
			{
				b__p->pc = 2;
				return 0;
			case 2:	;
			}
		}
		
		if(!(((ssize_t)(((&in)->end)-((&in)->start)))))
		{
			shutdown(fd, SHUT_WR);
			done = 1;
		}
		while((((ssize_t)(((&in)->end)-((&in)->start)))))
		{
			
			{
				set_writer(fd, b__p)
				{
					b__p->pc = 3;
					return 0;
				case 3:	;
				}
			}
			ssize_t n = write(fd, (((&in)->start)), (((ssize_t)(((&in)->end)-((&in)->start)))));
			if(n == -1)
			{
				n = 0;
				swarning("writer %010p: error", b__p);
				done = 1;
				break;
			}
			else
			{
				buffer_shift(&in, n);
			}
		}
		push_f(&This->in->sh, b__p);
	}
}

proc reader_try(int fd, size_t block_size, boolean sel_first)
{
	port buffer out;
	state boolean done = 0;
	if(sel_first)
	{
		{
			set_reader(fd, b__p)
			{
				b__p->pc = 2;
				return 0;
			case 2:	;
			}
		}
	}
	while(!done)
	{
		
		if(pull_f(&This->out->sh, b__p))
		{
			{
				b__p->pc = 3;
				return 0;
			case 3:	;
			}
		}
		
		buffer_ensure_free(&out, block_size);
		ssize_t want = ((ssize_t)((&out)->space_end - (&out)->end));
		ssize_t n = read(fd, (((&out)->end)), want);
		if(n < 0 && errno != EAGAIN)
		{
			n = 0;
			if(errno != ECONNRESET)
			{
				swarning("reader %010p: error", b__p);
			}
		}
		if(n >= 0)
		{
			if(n == 0)
			{
				
				buffer_clear(&out);
				done = 1;
			}
			else
			{
				buffer_grow(&out, n);
			}
			push_f(&This->out->sh, b__p);
		}
		if(n < want)
		{
			
			{
				set_reader(fd, b__p)
				{
					b__p->pc = 4;
					return 0;
				case 4:	;
				}
			}
		}
	}
	
}

proc writer_try(int fd, boolean sel_first)
{
	port buffer in;
	state boolean done = 0;
	if(sel_first)
	{
		{
			set_writer(fd, b__p)
			{
				b__p->pc = 2;
				return 0;
			case 2:	;
			}
		}
	}
	while(!done)
	{
		
		if(pull_f(&This->in->sh, b__p))
		{
			{
				b__p->pc = 3;
				return 0;
			case 3:	;
			}
		}
		
		if(!(((ssize_t)(((&in)->end)-((&in)->start)))))
		{
			shutdown(fd, SHUT_WR);
			done = 1;
		}
		while((((ssize_t)(((&in)->end)-((&in)->start)))))
		{
			ssize_t want = (((ssize_t)(((&in)->end)-((&in)->start))));
			ssize_t n = write(fd, (((&in)->start)), want);
			if(n < 0 && errno != EAGAIN)
			{
				swarning("writer %010p: error", b__p);
				done = 1;
				break;
			}
			if(n >= 0)
			{
				buffer_shift(&in, n);
			}
			if(n < want)
			{
				
				{
					set_writer(fd, b__p)
					{
						b__p->pc = 4;
						return 0;
					case 4:	;
					}
				}
			}
		}
		push_f(&This->in->sh, b__p);
	}
	
}

proc cat(off_t len)
{
	port buffer in;
	port buffer out;
	state ssize_t count;
	while(len)
	{
		if((This->in->sh.current == b__p) && !(((ssize_t)(((&in)->end)-((&in)->start)))))
		{
			buffer_ensure_space(&in, 1);
			push_f(&This->in->sh, b__p);
		}
		while(1)
		{
			if(pull_f(&This->in->sh, b__p))
			{
				{
					b__p->pc = 2;
					return 0;
				case 2:	;
				}
			}
			if((size_t)(((ssize_t)(((&in)->end)-((&in)->start)))) >= (size_t)1 || !(((ssize_t)(((&in)->end)-((&in)->start)))))
			{
				break;
			}
			buffer_ensure_space(&in, 1-(((ssize_t)(((&in)->end)-((&in)->start)))));
			push_f(&This->in->sh, b__p);
		}
		count = (((ssize_t)(((&in)->end)-((&in)->start))));
		if(!count)
		{
			break;
		}
		if(len >= 0)
		{
			count = imin(count, len);
		}
		if(pull_f(&This->out->sh, b__p))
		{
			{
				b__p->pc = 3;
				return 0;
			case 3:	;
			}
		}
		buffer_cat_range(&out, ((((&in)->start))), (((&in)->start+count)));
		
		if(pull_f(&This->out->sh, b__p))
		{
			{
				b__p->pc = 4;
				return 0;
			case 4:	;
			}
		}
		if(!(((ssize_t)(((&out)->end)-((&out)->start)))))
		{
			
		}
		else
		{
			
			push_f(&This->out->sh, b__p);
			if(pull_f(&This->out->sh, b__p))
			{
				{
					b__p->pc = 5;
					return 0;
				case 5:	;
				}
			}
			
		}
		if((((ssize_t)(((&out)->end)-((&out)->start)))))
		{
			swarning("cat %010p: error", b__p);
			break;
		}
		len -= count;
		buffer_shift(&in, count);
	}
	(buffer_clear(&out));
	if(pull_f(&This->out->sh, b__p))
	{
		{
			b__p->pc = 6;
			return 0;
		case 6:	;
		}
	}
	push_f(&This->out->sh, b__p);
}

void debug_io_count(void)
{
	
}

void listener_unix_init(listener_try *p, cstr addr)
{
	int listen_fd = (Server_unix_stream(addr));
	listener_try_init(p, listen_fd, sizeof(sockaddr_un));
}

void coro_init(void)
{
	main_coro.prev = NULL;
	main_coro.next = NULL;
	coro_init_done = 1;
}

int yield_val_2(coro *c, int val)
{
	coro *me = current_coro;
	int v = setjmp(me->j);
	if((v == 0))
	{
		longjmp(c->j, val);
	}
	else if((v == (-2)))
	{
		coro *caller = current_coro;
		current_coro = me;
		new_coro_2(new_coro_f, caller);
	}
	current_coro = me;
	return v;
}

int yield_val(coro **c, int val)
{
	if(*c)
	{
		int v = yield_val_2(*c, val);
		if(v == ( -1))
		{
			*c = NULL;
		}
		return v;
	}
	return ( -3);
}

int ccoro_yield(coro **c)
{
	return yield_val(c, 1);
}

noret new_coro_3(coro_func f, coro *caller)
{
	coro new;
	current_coro = &new;
	if(coro_top)
	{
		coro_top->next = &new;
	}
	new.prev = coro_top;
	new.next = NULL;
	coro_top = &new;
	(*f)(caller);
	if(current_coro->prev)
	{
		current_coro->prev->next = current_coro->next;
	}
	if(current_coro->next)
	{
		current_coro->next->prev = current_coro->prev;
	}
	if(current_coro == coro_top)
	{
		coro_top = current_coro->prev;
	}
	current_coro = NULL;
	longjmp(caller->j, ( -1));
}

noret new_coro_2(coro_func f, coro *caller)
{
	volatile char pad[8192];
	pad[0] = pad[8192-1] = 0;
	new_coro_3(f, caller);
	pad[0] = pad[8192-1] = 0;
}

coro *new_coro(coro_func f)
{
	int v;
	coro *me = current_coro;
	coro *yielder;
	if(!coro_init_done)
	{
		coro_init();
	}
	new_coro_f = f;
	v = setjmp(current_coro->j);
	if((v == 0))
	{
		if(current_coro == coro_top)
		{
			new_coro_2(f, current_coro);
		}
		else
		{
			longjmp(coro_top->j, (-2));
		}
	}
	yielder = current_coro;
	current_coro = me;
	return yielder;
}

void main__init(int _argc, char *_argv[])
{
	argc = _argc;
	argv = _argv;
	vstreams_init();
	error_init();
	main_dir = Getcwd();
	program_full = argv[0];
	if(!exists(program_full))
	{
		program_full = Which(program_full);
	}
	program_real = (readlinks(((normal_Strdup(program_full))), OE_ERROR));
	typeof(dirbasename((normal_Strdup(program_real)))) (skip(1, `my__4287_)rv) = dirbasename((normal_Strdup(program_real)));
	typeof((skip(1, `my__4292_)rv).dir) d = (skip(1, `my__4292_)rv).dir;
	typeof((skip(1, `my__4297_)rv).base) b = (skip(1, `my__4297_)rv).base;
	program_dir = d;
	program = b;
	if(mingw && cstr_case_ends_with(program, ".exe"))
	{
		cstr_chop(program, 4);
	}
	if(program[0] == '.')
	{
		++program;
	}
	arg = argv+1;
	args = argc - 1;
	seed();
	
}

void opts_init(opts *O, size_t opts_hash_size)
{
	vec_init_el_size(&O->v, sizeof(opt), (16));
	hashtable_init(&O->h, cstr_hash, cstr_eq, opts_hash_size);
}

opts *get_options(cstr options[][3])
{
	hashtable struct__short_ht;
	hashtable *short_ht = &struct__short_ht;
	hashtable_init(short_ht, cstr_hash, cstr_eq, 257);
	if(options)
	{
		table_cstr_to_hashtable(short_ht, options, 3, 0, 1);
	}
	opts *O;
	O = (((opts *)(normal_Malloc(1 * sizeof(opts)))));
	(opts_init(O, 257));
	char **p = arg;
	char **out = arg;
	while(*p)
	{
		typeof(*p) i = *p;
		if(i[0] != '-' || i[1] == '\0')
		{
			*out++ = *p++;
			continue;
		}
		if(i[1] == '-' && i[2] == '\0')
		{
			++p;
			while(*p)
			{
				*out++ = *p++;
			}
			args_literal = 1;
			break;
		}
		opt *o = vec_push(&O->v);
		boolean short_opt = i[1] != '-';
		if(short_opt)
		{
			o->name = i + 1;
			i = o->name + 1;
		}
		else
		{
			o->name = i + 2;
			i = o->name + strcspn(o->name, "=:");
		}
		o->arg = NULL;
		char optargs_type = *i;
		*i++ = '\0';
		if(short_opt)
		{
			cstr name_long = (hashtable_value_or_null(short_ht, ((void*)(intptr_t)(o->name))));
			if(name_long)
			{
				o->name = name_long;
			}
			else
			{
				o->name = sym(o->name);
			}
		}
		mput(&O->h, o->name, o);
		if(optargs_type == '=')
		{
			o->arg = ((cstr *)(normal_Malloc(2 * sizeof(cstr))));
			if(*i != '\0')
			{
				o->arg[0] = i;
			}
			else
			{
				++p;
				o->arg[0] = *p;
			}
			o->arg[1] = NULL;
		}
		else if(optargs_type == ':')
		{
			vec struct__v;
			vec *v = &struct__v;
			vec_init_el_size(v, sizeof(cstr), (16));
			if(*i != '\0')
			{
				*(cstr *)vec_push(v) = i;
			}
			while(p[1] && p[1][0] != '-')
			{
				cstr oa = *++p;
				if(oa[0] == '\\')
				{
					++oa;
				}
				*(cstr *)vec_push(v) = oa;
			}
			o->arg = vec_to_array(v);
		}
		else if(optargs_type != '\0' && short_opt)
		{
			*--i = optargs_type;
			*--i = '-';
			*p = i;
			vec struct__v;
			vec *v = &struct__v;
			array_to_vec(v, p);
			continue;
		}
		++p;
	}
	*out = NULL;
	args = out - arg;
	if(args_literal || args)
	{
		args_list = 1;
	}
	return O;
}

void dump_options(opts *O)
{
	vec *(skip(1, `my__4333_)v1) = &O->v;
	opt *(skip(1, `my__4335_)end) = ((vec_element(((skip(1, `my__4337_)v1)), ((skip(1, `my__4337_)v1))->size)));
	opt *(skip(1, `my__4341_)i1) = ((vec_element(((skip(1, `my__4343_)v1)), 0)));
	for(; (skip(1, `my__4347_)i1)!=(skip(1, `my__4349_)end) ; ++(skip(1, `my__4351_)i1))
	{
		typeof((skip(1, `my__4353_)i1)) o = (skip(1, `my__4353_)i1);
		
		Fprintf(stderr, "%s", (o->name));
		if(o->arg)
		{
			Fprintf(stderr, "%s", " =");
			typeof(&((o->arg))[0]) ((skip(1, `my__4361_)i)) = &((o->arg))[0];
			for(; *((skip(1, `my__4361_)i)) ; ++((skip(1, `my__4361_)i)))
			{
				
				typeof(*(skip(1, `my__4367_)i)) j = *(skip(1, `my__4367_)i);
				
				Fprintf(stderr, " %s", j);
			}
		}
		if(0)
		{
			
		}
		else if(putc('\n', stderr) == EOF)
		{
			failed("putc");
		}
	}
	if(0)
	{
		
	}
	else if(putc('\n', stderr) == EOF)
	{
		failed("putc");
	}
}

void help_(cstr version, cstr description, cstr *usage, cstr options[][3])
{
	if(*description)
	{
		sf("%s version %s - %s", program, version, description);
	}
	else
	{
		sf("%s version %s", program, version);
	}
	fsay_usage_(stdout, usage);
	say("options:");
	typeof(&*options) i;
	int max_len = 0;
	for(i = options; (*i)[0]; ++i)
	{
		cstr long_opt = (*i)[1];
		int len = strlen(long_opt);
		if(len > max_len)
		{
			max_len = len;
		}
	}
	for(i = options; (*i)[0]; ++i)
	{
		cstr short_opt = (*i)[0];
		cstr long_opt = (*i)[1];
		cstr desc = (*i)[2];
		if(*short_opt)
		{
			Sayf("  -%1s  --%-*s  %s", short_opt, max_len, long_opt, desc);
		}
		else
		{
			Sayf("      --%-*s  %s", max_len, long_opt, desc);
		}
	}
}

cstr darcs_root(void)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 256);
	while(!(exists("_darcs")))
	{
		_Getcwd(b);
		if(cstr_eq(buffer_to_cstr(b), "/"))
		{
			error("not in a darcs repository");
		}
		buffer_clear(b);
		Chdir("..");
	}
	_Getcwd(b);
	return buffer_to_cstr(b);
}

cstr _darcs_path(cstr path, cstr root, cstr cwd)
{
	typeof((format("%s%s", cwd, "/"))) ref = (format("%s%s", cwd, "/"));
	path = path_relative_to(path, ref);
	((free(ref)), ref = NULL);
	path = path_tidy(path);
	path = path_under(root, path);
	if(!path)
	{
		error("path outside repository", path);
	}
	return path;
}

cstr darcs_exists(cstr darcs_path)
{
	typeof((format("%s%s", "_darcs/current/", darcs_path))) rv = (format("%s%s", "_darcs/current/", darcs_path));
	return exists(rv) ? rv : NULL;
}

void html_split(boolean split_entities)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 128);
	int c;
	c = (vs_getc());
	cstr end_text = split_entities ? "<&\n" : "<\n";
	while(c != EOF)
	{
		if(c == '<')
		{
			while(strchr(">", c) == NULL && c != EOF)
			{
				buffer_cat_char(b, c);
				c = (vs_getc());
			}
			if(c != EOF)
			{
				buffer_cat_char(b, c);
				c = (vs_getc());
			}
		}
		else if(split_entities && c == '&')
		{
			while(strchr(";", c) == NULL && c != EOF)
			{
				buffer_cat_char(b, c);
				c = (vs_getc());
			}
			if(c != EOF)
			{
				buffer_cat_char(b, c);
				c = (vs_getc());
			}
		}
		else
		{
			while(strchr(end_text, c) == NULL && c != EOF)
			{
				buffer_cat_char(b, c);
				c = (vs_getc());
			}
			if(c == '\n')
			{
				buffer_cat_char(b, c);
				c = (vs_getc());
			}
		}
		
		{
			typeof(((b->end))) (skip(1, `my__4440_)end) = ((b->end));
			typeof(((b->start))) (skip(1, `my__4445_)v1) = ((b->start));
			for(; (skip(1, `my__4450_)v1)<(skip(1, `my__4452_)end); ++(skip(1, `my__4454_)v1))
			{
				typeof((skip(1, `my__4456_)v1)) i = (skip(1, `my__4456_)v1);
				switch(*i)
				{
				case '\n':	*i = '\r';
				}
			}
		}
		say(buffer_to_cstr(b));
		buffer_clear(b);
	}
	if(((ssize_t)((b->end)-(b->start))))
	{
		say(buffer_to_cstr(b));
		buffer_clear(b);
	}
}

void html_join(void)
{
	char *l;
	buffer struct__(skip(1, `my__4468_)b);
	buffer *(skip(1, `my__4468_)b) = &struct__(skip(1, `my__4468_)b);
	(buffer_init(((skip(1, `my__4468_)b)), 128));
	while(1)
	{
		buffer_clear(skip(1, `my__4474_)b);
		if(rl(skip(1, `my__4478_)b))
		{
			break;
		}
		l = (((skip(1, `my__4480_)b))->start);
		typeof(((l+strlen(l)))) (skip(1, `my__4486_)end) = ((l+strlen(l)));
		typeof(l) (skip(1, `my__4491_)v1) = l;
		for(; (skip(1, `my__4496_)v1)<(skip(1, `my__4498_)end); ++(skip(1, `my__4500_)v1))
		{
			typeof((skip(1, `my__4502_)v1)) i = (skip(1, `my__4502_)v1);
			switch(*i)
			{
			case '\r':	*i = '\n';
			}
		}
		print(l);
	}
}

void tagn(cstr name, ...)
{
	va_list ap;
	va_start(ap, name);
	vtag(name, ap);
	va_end(ap);
}

void vtag(cstr name, va_list ap)
{
	pf("<%s", name);
	while(1)
	{
		cstr k = va_arg(ap, cstr);
		if(!k)
		{
			break;
		}
		cstr v = va_arg(ap, cstr);
		if(!v)
		{
			error("tag: missing value for key %s", k);
		}
		if(v == tag__no_value)
		{
			pf(" %s", k);
		}
		else
		{
			typeof(html_encode(v)) v1 = html_encode(v);
			pf(" %s=\"%s\"", k, v1);
			((free(v1)), v1 = NULL);
		}
	}
	pf(">");
}

void _html_encode(buffer *b, cstr v)
{
	while(*v != 0)
	{
		for(char *c = html_entity_char+1; *c; ++c)
		{
			if(*v == *c)
			{
				buffer_cat_cstr(b, html_entity[c-html_entity_char]);
				goto done;
			}
		}
		buffer_cat_char(b, *v);
done:		++v;
	}
}

cstr html_encode(cstr v)
{
	buffer struct__b;
	buffer *b = &struct__b;
	(buffer_init(b, 128));
	_html_encode(b, v);
	return buffer_to_cstr(b);
}

void _html_decode(buffer *b, cstr v)
{
	while(*v)
	{
		if(*v == '&')
		{
			for(cstr *s = html_entity; *s; ++s)
			{
				int l = strlen(*s);
				if(!strncmp(v, *s, l))
				{
					buffer_cat_char(b, html_entity_char[s-html_entity]);
					v += l;
					goto done;
				}
			}
		}
		buffer_cat_char(b, *v);
		++v;
done:		;
	}
}

cstr html_decode(cstr v)
{
	buffer struct__b;
	buffer *b = &struct__b;
	(buffer_init(b, 128));
	_html_decode(b, v);
	return buffer_to_cstr(b);
}

cstr html2text(cstr html)
{
	circbuf struct__b_html;
	circbuf *b_html = &struct__b_html;
	circbuf_from_cstr(b_html, html, strlen(html));
	circbuf struct__b_split;
	circbuf *b_split = &struct__b_split;
	circbuf_init(b_split, 1024);
	vstream struct__(skip(1, `my__4528_)vsi);
	vstream *(skip(1, `my__4528_)vsi) = &struct__(skip(1, `my__4528_)vsi);
	vstream_init_circbuf(((skip(1, `my__4528_)vsi)), b_html);
	vstream struct__(skip(1, `my__4534_)vso);
	vstream *(skip(1, `my__4534_)vso) = &struct__(skip(1, `my__4534_)vso);
	vstream_init_circbuf(((skip(1, `my__4534_)vso)), b_split);
	vstream *((skip(1, `my__4545_)old_in)) = in, *((skip(1, `my__4547_)old_out)) = out;
	int ((skip(1, `my__4550_)x)) = 0;
}
void ((skip(1, `my__4550_)x))	if ((skip(1, `my__4550_)x)) == 1
{
	{
		++((skip(1, `my__4550_)x));
		
		in = ((skip(1, `my__4545_)old_in));
		out = ((skip(1, `my__4547_)old_out));
	}
	for(; ((skip(1, `my__4553_)x)) < 2 ; ++((skip(1, `my__4553_)x)))
	{
		if(((skip(1, `my__4553_)x)) == 1)
		{
			goto ((skip(1, `my__4553_)x));
		}
		
		((skip(1, `my__4545_)old_in)) = in;
		((skip(1, `my__4547_)old_out)) = out;
		in = (((skip(1, `my__4540_)vsi)));
		out = (((skip(1, `my__4542_)vso)));
		
		
		html_split(0);
	}
	circbuf struct__b_text;
	circbuf *b_text = &struct__b_text;
	circbuf_init(b_text, 1024);
	boolean hide = 0;
	boolean at_break = 1;
	buffer struct__decoded;
	buffer *decoded = &struct__decoded;
	buffer_init(decoded, 1024);
	vstream struct__(skip(1, `my__4564_)vsi);
	vstream *(skip(1, `my__4564_)vsi) = &struct__(skip(1, `my__4564_)vsi);
	vstream_init_circbuf(((skip(1, `my__4564_)vsi)), b_split);
	vstream struct__(skip(1, `my__4570_)vso);
	vstream *(skip(1, `my__4570_)vso) = &struct__(skip(1, `my__4570_)vso);
	vstream_init_circbuf(((skip(1, `my__4570_)vso)), b_text);
	vstream *((skip(1, `my__4581_)old_in)) = in, *((skip(1, `my__4583_)old_out)) = out;
	int ((skip(1, `my__4586_)x)) = 0;
}
void ((skip(1, `my__4586_)x))	if ((skip(1, `my__4586_)x)) == 1
{
	{
		++((skip(1, `my__4586_)x));
		
		in = ((skip(1, `my__4581_)old_in));
		out = ((skip(1, `my__4583_)old_out));
	}
	for(; ((skip(1, `my__4589_)x)) < 2 ; ++((skip(1, `my__4589_)x)))
	{
		if(((skip(1, `my__4589_)x)) == 1)
		{
			goto ((skip(1, `my__4589_)x));
		}
		
		((skip(1, `my__4581_)old_in)) = in;
		((skip(1, `my__4583_)old_out)) = out;
		in = (((skip(1, `my__4576_)vsi)));
		out = (((skip(1, `my__4578_)vso)));
		
		
		char *s;
		buffer struct__(skip(1, `my__4594_)b);
		buffer *(skip(1, `my__4594_)b) = &struct__(skip(1, `my__4594_)b);
		(buffer_init(((skip(1, `my__4594_)b)), 128));
		while(1)
		{
			buffer_clear(skip(1, `my__4600_)b);
			if(rl(skip(1, `my__4604_)b))
			{
				break;
			}
			s = (((skip(1, `my__4606_)b))->start);
			if(s[0] != '<')
			{
				if(!hide)
				{
					(buffer_clear(decoded));
					(_html_decode(decoded, s));
					print(buffer_to_cstr(decoded));
					at_break = 0;
				}
			}
			else if((!strncasecmp(s, "<br", 3) && ((s[3]) == ' ' || (s[3]) == '>' || (s[3]) == '/'))  || !strcasecmp(s, "</p>") || !strcasecmp(s, "</tr>") || !strcasecmp(s, "</div>"))
			{
				if(!hide)
				{
					((sf("")));
					at_break = 1;
				}
			}
			else if(!strcasecmp(s, "</td>"))
			{
				if(!hide)
				{
					print("\t");
					at_break = 1;
				}
			}
			else
			{
				if(!at_break)
				{
					print(" ");
					at_break = 1;
				}
				if((!strncasecmp(s, "<script", 7) && ((s[7]) == ' ' || (s[7]) == '>')) ||  (!strncasecmp(s, "<style", 7) && ((s[7]) == ' ' || (s[7]) == '>')))
				{
					hide = 1;
				}
				else if(!strcasecmp(s, "</script>") ||  !strcasecmp(s, "</style>"))
				{
					hide = 0;
				}
			}
		}
	}
	buffer_free(decoded);
	circbuf_free(b_split);
	return circbuf_to_cstr(b_text);
}

void url_decode(cstr q)
{
	cstr o = q;
	while(*q)
	{
		if(*q == '%' && q[1] && q[2])
		{
			char c[3] = { q[1], q[2], '\0' };
			*o = (char)strtol(c, NULL, 16);
			q+=2;
		}
		else
		{
			*o = *q;
		}
		++q;
		++o;
	}
	*o = '\0';
}

cstr url_encode(cstr q)
{
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 256);
	while(*q)
	{
		char c = *q++;
		if(!(isalnum((unsigned)c)) && !strchr(":_-/?.", c))
		{
			Sprintf(b, "%%%02x", c);
		}
		else
		{
			buffer_cat_char(b, c);
		}
	}
	return buffer_to_cstr(b);
}

cstr get_host_from_url(cstr url)
{
	cstr host = strstr(url, "://");
	if(host)
	{
		host += 3;
		char *e = strchr(host, '/');
		if(e)
		{
			host = (normal_Strndup(host, (e-host)));
		}
		else
		{
			host = NULL;
		}
	}
	return host;
}

cstr get_path_from_url(cstr url)
{
	cstr path = url;
	cstr host = strstr(url, "://");
	if(host)
	{
		host += 3;
		path = strchr(host, '/');
		if(!path)
		{
			path = "/";
		}
	}
	return path;
}

void http_fake_browser(boolean f)
{
	_http_fake_browser = f;
}

cstr http(cstr method, cstr url, buffer *req_headers, buffer *req_data, buffer *rsp_headers, buffer *rsp_data)
{
	cstr host_port = get_host_from_url(url);
	if(!host_port)
	{
		error("http: invalid url %s", url);
	}
	cstr path = Strchr(Strstr(url, "//") + 2, '/');
	if(!*path)
	{
		path = "/";
	}
	int port = 80;
	cstr host = (normal_Strdup(host_port));
	cstr port_s = strchr(host, ':');
	if(port_s)
	{
		*port_s++ = '\0';
		port = atoi(port_s);
	}
	if(http_debug)
	{
		warn("connecting to %s port %d", host, port);
	}
	int fd = (Client_tcp(host, port));
	FILE *s = Fdopen(fd, "r+b");
	Fprintf(s, "%s %s HTTP/1.0\r\n", method, url);
	if(http_debug)
	{
		warn("%s %s HTTP/1.0", method, url);
	}
	if(_http_fake_browser)
	{
		Fprintf(s, "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.6) Gecko/2009020911 Ubuntu/8.10 (intrepid) Firefox/3.0.6\r\n");
		Fprintf(s, "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n");
		if(http_debug)
		{
			warn("User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.6) Gecko/2009020911 Ubuntu/8.10 (intrepid) Firefox/3.0.6");
			warn("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
		}
	}
	if(req_headers)
	{
		Fwrite_buffer(s, req_headers);
		if(http_debug)
		{
			warn("%s", req_headers);
		}
	}
	crlf(s);
	if(req_data)
	{
		Fwrite_buffer(s, req_data);
		if(http_debug)
		{
			warn("%s", req_data);
		}
	}
	Fflush(s);
	(Shutdown(fd, SHUT_WR));
	buffer struct__rsp_headers_tmp;
	buffer *rsp_headers_tmp = &struct__rsp_headers_tmp;
	buffer *rsp_headers_orig = rsp_headers;
	if(!rsp_headers_orig)
	{
		buffer_init(rsp_headers_tmp, 512);
		rsp_headers = rsp_headers_tmp;
	}
	while(1)
	{
		if(Freadline(rsp_headers, s) == EOF)
		{
			break;
		}
		if(buffer_ends_with_char(rsp_headers, '\r'))
		{
			buffer_grow(rsp_headers, -1);
		}
		if(buffer_ends_with_char(rsp_headers, '\n'))
		{
			break;
		}
		buffer_cat_char(rsp_headers, '\n');
	}
	if(http_debug)
	{
		buffer_nul_terminate(rsp_headers);
		warn("%s", ((rsp_headers->start)));
	}
	if(!rsp_headers_orig)
	{
		buffer_free(rsp_headers_tmp);
	}
	if(rsp_data)
	{
		(fslurp_2(s, rsp_data));
		if(http_debug)
		{
			buffer_nul_terminate(rsp_data);
			warn("%s", ((rsp_data->start)));
		}
	}
	Fclose(s);
	((free(host_port)), host_port = NULL);
	((free(host)), host = NULL);
	if(!rsp_data && rsp_headers)
	{
		rsp_data = rsp_headers;
	}
	if(rsp_data)
	{
		buffer_nul_terminate(rsp_data);
		return ((rsp_data->start));
	}
	return NULL;
}

cstr http_get_1(cstr url)
{
	buffer *rsp_data;
	rsp_data = (((buffer *)(normal_Malloc(1 * sizeof(buffer)))));
	buffer_init(rsp_data, 1024);
	return http_get(url, rsp_data);
}

cstr http_get(cstr url, buffer *rsp_data)
{
	return http("GET", url, NULL, NULL, NULL, rsp_data);
}

cstr http_head_1(cstr url)
{
	buffer *rsp_headers;
	rsp_headers = (((buffer *)(normal_Malloc(1 * sizeof(buffer)))));
	buffer_init(rsp_headers, 1024);
	return http_head(url, rsp_headers);
}

cstr http_head(cstr url, buffer *rsp_headers)
{
	return http("HEAD", url, NULL, NULL, rsp_headers, NULL);
}

cstr http_post_1(cstr url, cstr req_data)
{
	buffer *rsp_data;
	rsp_data = (((buffer *)(normal_Malloc(1 * sizeof(buffer)))));
	buffer_init(rsp_data, 1024);
	return http_post(url, req_data, rsp_data);
}

cstr http_post(cstr url, cstr _req_data, buffer *rsp_data)
{
	buffer struct__req_data;
	buffer *req_data = &struct__req_data;
	buffer_from_cstr(req_data, _req_data, strlen(_req_data));
	return http("POST", url, NULL, req_data, NULL, rsp_data);
}

void base64_decode_buffers(buffer *i, buffer *o)
{
	vstream struct__(skip(1, `my__4675_)vsi);
	vstream *(skip(1, `my__4675_)vsi) = &struct__(skip(1, `my__4675_)vsi);
	vstream_init_buffer(((skip(1, `my__4675_)vsi)), i);
	vstream struct__(skip(1, `my__4681_)vso);
	vstream *(skip(1, `my__4681_)vso) = &struct__(skip(1, `my__4681_)vso);
	vstream_init_buffer(((skip(1, `my__4681_)vso)), o);
	vstream *((skip(1, `my__4692_)old_in)) = in, *((skip(1, `my__4694_)old_out)) = out;
	int ((skip(1, `my__4697_)x)) = 0;
}
void ((skip(1, `my__4697_)x))	if ((skip(1, `my__4697_)x)) == 1
{
	{
		++((skip(1, `my__4697_)x));
		
		in = ((skip(1, `my__4692_)old_in));
		out = ((skip(1, `my__4694_)old_out));
	}
	for(; ((skip(1, `my__4700_)x)) < 2 ; ++((skip(1, `my__4700_)x)))
	{
		if(((skip(1, `my__4700_)x)) == 1)
		{
			goto ((skip(1, `my__4700_)x));
		}
		
		((skip(1, `my__4692_)old_in)) = in;
		((skip(1, `my__4694_)old_out)) = out;
		in = (((skip(1, `my__4687_)vsi)));
		out = (((skip(1, `my__4689_)vso)));
		
		
		base64_decode();
	}
}

void base64_decode(void)
{
	if(!base64_decode_map)
	{
		base64_decode_map = ((normal_Calloc(128, 1)));
		typeof(64) (skip(1, `my__4707_)end) = 64;
		typeof(0) (skip(1, `my__4712_)v1) = 0;
		for(; (skip(1, `my__4717_)v1)<(skip(1, `my__4719_)end); ++(skip(1, `my__4721_)v1))
		{
			typeof((skip(1, `my__4723_)v1)) i = (skip(1, `my__4723_)v1);
			base64_decode_map[(unsigned int)base64_encode_map[i]] = i;
		}
	}
	int c;
	while(1)
	{
		long o = 0;
		typeof(0) i = 0;
		typeof(4) (skip(1, `my__4732_)end) = 4;
		for(; i<(skip(1, `my__4737_)end); ++i)
		{
			do
			{
				c = (vs_getc());
			}
			while(isspace(c));
			if(c == EOF || c == '=')
			{
				break;
			}
			o |= base64_decode_map[c & 0x7F] << (6*(3-i));
		}
		typeof((i-1)) (skip(1, `my__4741_)end) = (i-1);
		typeof(0) (skip(1, `my__4746_)v1) = 0;
		for(; (skip(1, `my__4751_)v1)<(skip(1, `my__4753_)end); ++(skip(1, `my__4755_)v1))
		{
			typeof((skip(1, `my__4757_)v1)) j = (skip(1, `my__4757_)v1);
			(vs_putc((char)(o>>((2-j)*8))));
		}
		if(i < 4)
		{
			break;
		}
	}
}

http__method http_which_method(cstr method)
{
	http__method rv;
	if(cstr_eq(method, "GET"))
	{
		rv = HTTP_GET;
	}
	else if(cstr_eq(method, "HEAD"))
	{
		rv = HTTP_HEAD;
	}
	else if(cstr_eq(method, "POST"))
	{
		rv = HTTP_POST;
	}
	else if(cstr_eq(method, "PUT"))
	{
		rv = HTTP_PUT;
	}
	else if(cstr_eq(method, "DELETE"))
	{
		rv = HTTP_DELETE;
	}
	else
	{
		rv = HTTP_INVALID;
	}
	return rv;
}

void hunk(cstr in_file, cstr out_dir, int avg_hunk_size, int max_hunk_size, int sum_window_size)
{
	(Mkdir_if(out_dir, 0777));
	cp_attrs(in_file, out_dir);
	FILE *in = Fopen(in_file, "r");
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, avg_hunk_size*2);
	buffer struct__out_file;
	buffer *out_file = &struct__out_file;
	buffer_init(out_file, 256);
	int c;
	int sum = 0;
	int hunk_count = 0;
	off_t offset = 0;
	while(1)
	{
		c = getc(in);
		if(c == EOF && ferror(in))
		{
			failed("getc");
		}
		if(c != EOF)
		{
			buffer_cat_char(b, (char)c);
			sum += c;
		}
		if((int)((ssize_t)((b->end)-(b->start))) >= sum_window_size || c == EOF)
		{
			if((sum % avg_hunk_size == 0) || (int)((ssize_t)((b->end)-(b->start))) == max_hunk_size || c == EOF)
			{
				buffer_clear(out_file);
				Sprintf(out_file, "%016x", offset);
				char *out_file_path = path_cat(out_dir, (out_file->start));
				FILE *out = Fopen(out_file_path, "wb");
				Fwrite((b->start), 1, ((ssize_t)((b->end)-(b->start))), out);
				Fclose(out);
				((free(out_file_path)), out_file_path = NULL);
				++hunk_count;
				offset += ((ssize_t)((b->end)-(b->start)));
				if(c == EOF)
				{
					break;
				}
				buffer_clear(b);
				sum = 0;
			}
			else
			{
				sum -= (b->start)[((ssize_t)((b->end)-(b->start)))-sum_window_size];
			}
		}
	}
	Fclose(in);
}

void cgi_html(void)
{
	cgi_content_type("text/html");
}

void cgi_content_type(cstr type)
{
	if(!cgi__sent_headers)
	{
		Printf("Content-Type: %s", type);
		crlf(stdout);
		crlf(stdout);
		Fflush(stdout);
		cgi__sent_headers = 1;
	}
}

void cgi_text(void)
{
	cgi_content_type("text/plain");
}

void cgi_init(void)
{
	cgi_query_hash = &_cgi_query_hash;
	cgi_query_hash = (((hashtable *)(normal_Malloc(1 * sizeof(hashtable)))));
	hashtable_init(cgi_query_hash, cstr_hash, cstr_eq, 1009);
	cgi_query_load(normal_Strdup(((Getenv("QUERY_STRING", "")))));
	if(cstr_eq(((Getenv("REQUEST_METHOD", ""))), "POST"))
	{
		buffer struct__b;
		buffer *b = &struct__b;
		buffer_init(b, block_size);
		buffer_cat_cstr(b, ((Getenv("REQUEST_BODY_1", ""))));
		(slurp_2(0, b));
		cgi_query_load(buffer_to_cstr(b));
	}
}

void cgi_query_load(cstr data)
{
	cstr i = data;
	while(1)
	{
		typeof(strchr(i, '&')) amp = strchr(i, '&');
		if(amp)
		{
			*amp = '\0';
		}
		url_decode(i);
		char *val = strchr(i, '=');
		if(val)
		{
			*val = '\0';
			++val;
		}
		else
		{
			val = (normal_Strdup(""));
		}
		char *key = (normal_Strdup(i));
		mput(cgi_query_hash, key, val);
		if(!amp)
		{
			break;
		}
		i = amp+1;
	}
}

cstr cgi(cstr key, cstr _default)
{
	vec *v = (mget(cgi_query_hash, key));
	if(v && ((v->size)) > 0)
	{
		return ((vec_element(v, 0)));
	}
	return _default;
}

cstr cgi_required(cstr key)
{
	cstr v = (cgi(key, NULL));
	if(!v)
	{
		error("cgi_required: key not found: %s", key);
	}
	return v;
}

void cgi_errors_to_browser(void)
{
	error_handler *h = vec_push(error_handlers);
	h->handler.func = cgi_error_to_browser;
	h->handler.obj = NULL;
	h->handler.common_arg = NULL;
	h->jump = NULL;
	h->err = 0;
}

void *cgi_error_to_browser(void *obj, void *common_arg, void *specific_arg)
{
	(void)obj;
	(void)common_arg;
	err *e = specific_arg;
	cgi_text();
	Puts(e->msg);
	Fflush(stdout);
	vec_pop(error_handlers);
	(throw_(NULL));
	return (((void*)(intptr_t)1));
}

void qmath_init(void)
{
	_qsin = ((num *)(normal_Malloc(360 * sizeof(num))));
	_qcos = ((num *)(normal_Malloc(360 * sizeof(num))));
	_qatan = ((num *)(normal_Malloc((500+1) * sizeof(num))));
	typeof(360) (skip(1, `my__4850_)end) = 360;
	typeof(0) (skip(1, `my__4855_)v1) = 0;
	for(; (skip(1, `my__4860_)v1)<(skip(1, `my__4862_)end); ++(skip(1, `my__4864_)v1))
	{
		typeof((skip(1, `my__4866_)v1)) i = (skip(1, `my__4866_)v1);
		num a = i*2*pi/360;
		_qsin[i] = sin(a);
		_qcos[i] = cos(a);
	}
	typeof((500+1)) (skip(1, `my__4874_)end) = (500+1);
	typeof(0) (skip(1, `my__4879_)v1) = 0;
	for(; (skip(1, `my__4884_)v1)<(skip(1, `my__4886_)end); ++(skip(1, `my__4888_)v1))
	{
		typeof((skip(1, `my__4890_)v1)) j = (skip(1, `my__4890_)v1);
		_qatan[j] = atan(j/(num)500);
	}
}

void mimetypes_init(void)
{
	if(!mimetypes)
	{
		mimetypes = &struct__mimetypes;
		hashtable_init(mimetypes, cstr_hash, cstr_eq, mimetypes_n_buckets);
	}
}

void load_mimetypes_vio(void)
{
	mimetypes_init();
	sym_init();
	char *l;
	buffer struct__(skip(1, `my__4899_)b);
	buffer *(skip(1, `my__4899_)b) = &struct__(skip(1, `my__4899_)b);
	(buffer_init(((skip(1, `my__4899_)b)), 128));
	while(1)
	{
		buffer_clear(skip(1, `my__4905_)b);
		if(rl(skip(1, `my__4909_)b))
		{
			break;
		}
		l = (((skip(1, `my__4911_)b))->start);
		if(((*l) == '#' || (*l) == '\0'))
		{
			continue;
		}
		cstr type = l;
		cstr ext = strrchr(l, '\t');
		if(ext++)
		{
			*Strchr(type, '\t') = '\0';
			type = sym(type);
			(cstr_tolower(ext));
			cstr *exts = split(ext, ' ');
			typeof(&exts[0]) ((skip(1, `my__4917_)i)) = &exts[0];
			for(; *((skip(1, `my__4917_)i)) ; ++((skip(1, `my__4917_)i)))
			{
				
				typeof(*(skip(1, `my__4923_)i)) e = *(skip(1, `my__4923_)i);
				
				(hashtable_lookup_or_add_key(mimetypes, ((void*)(intptr_t)(sym(e))), ((void*)(intptr_t)type)));
			}
			((free(exts)), exts = NULL);
		}
	}
}

cstr mimetype(cstr ext)
{
	char ext_lc[strlen(ext)+1];
	strcpy(ext_lc, ext);
	(cstr_tolower(ext_lc));
	return (hashtable_value_or(mimetypes, ((void*)(intptr_t)ext_lc), ((void*)(intptr_t)NULL)));
}

cstr Mimetype(cstr ext)
{
	cstr mt = mimetype(ext);
	if(!mt)
	{
		failed2("mimetype", ext);
	}
	return mt;
}

void meta_init(void)
{
	type_ix = (((hashtable *)(normal_Malloc(1 * sizeof(hashtable)))));
	hashtable_init(type_ix, cstr_hash, cstr_eq, 1009);
}

void type_add(type *t)
{
	cstr name = t->name;
	(hashtable_add(type_ix, ((void*)(intptr_t)name), ((void*)(intptr_t)t)));
	if(((t->type) == TYPE_STRUCT || (t->type) == TYPE_UNION))
	{
		type__struct_union *s = (type__struct_union *)t;
		typeof((s->n)) (skip(1, `my__4953_)end) = (s->n);
		typeof(0) (skip(1, `my__4958_)v1) = 0;
		for(; (skip(1, `my__4963_)v1)<(skip(1, `my__4965_)end); ++(skip(1, `my__4967_)v1))
		{
			typeof((skip(1, `my__4969_)v1)) i = (skip(1, `my__4969_)v1);
			cstr element_name = format("%s.%s", name, s->e[i].name);
			(hashtable_add(type_ix, ((void*)(intptr_t)element_name), ((void*)(intptr_t)i)));
		}
	}
}

type *type_get(cstr name)
{
	return (hashtable_value_or_null(type_ix, ((void*)(intptr_t)name)));
}

void read_structs(vec *v, type__struct_union *t)
{
	while((read_struct((vec_push(v)), t, OE_ERROR)))
	{
		
	}
	vec_pop(v);
}

void write_structs(vec *v, type__struct_union *t)
{
	vec *(skip(1, `my__4981_)v1) = v;
	char *(skip(1, `my__4983_)end) = ((vec_element(((skip(1, `my__4985_)v1)), ((skip(1, `my__4985_)v1))->size)));
	char *(skip(1, `my__4989_)i1) = ((vec_element(((skip(1, `my__4991_)v1)), 0)));
	for(; (skip(1, `my__4995_)i1)!=(skip(1, `my__4997_)end) ; (skip(1, `my__4999_)i1) += (skip(1, `my__5001_)v1)->element_size)
	{
		void *i = (skip(1, `my__5003_)i1);
		
		(write_struct(i, t, OE_ERROR));
	}
}

int read_struct(void *s, type__struct_union *t, opt_err unknown_key)
{
	(bzero(((char*)s), ((char*)s+t->t.size)-((char*)s)));
	cstr name = t->t.name;
	buffer struct__b;
	buffer *b = &struct__b;
	buffer_init(b, 64);
	boolean more = 0;
	long i = 0;
	long n = t->n;
	char *l;
	buffer struct__(skip(1, `my__5012_)b);
	buffer *(skip(1, `my__5012_)b) = &struct__(skip(1, `my__5012_)b);
	(buffer_init(((skip(1, `my__5012_)b)), 128));
	while(1)
	{
		buffer_clear(skip(1, `my__5018_)b);
		if(rl(skip(1, `my__5022_)b))
		{
			break;
		}
		l = (((skip(1, `my__5024_)b))->start);
		cstr k;
		l = scan_cstr(&k, l);
		cstr v = l;
		if(*k)
		{
			if(!v)
			{
				error("read_struct: missing delimiter after key: %s", k);
			}
			make_name(cstr_tolower(k));
			type__element *e;
			while(1)
			{
				if(i==n)
				{
					Sprintf(b, "%s.%s", name, k);
					int i = ((intptr_t)((hashtable_value_or(type_ix, ((void*)(intptr_t)(buffer_add_nul(b))), ((void*)(intptr_t)(-1))))));
					(buffer_clear(b));
					if(i == -1)
					{
						if(!opt_err_do(unknown_key, (any){.i=1}, (any){.i=0}, "read_struct: unknown key: %s", k).i)
						{
							return 0;
						}
						else
						{
							goto skip;
						}
					}
					e = &t->e[i];
					break;
				}
				e = &t->e[i];
				if(cstr_eq(k, e->name))
				{
					break;
				}
				++i;
			}
			char *p = (char*)s + e->offset;
			if(((e->type) == ((type*)(t_defs + 0)) || (e->type) == ((type*)(t_points + 0))))
			{
				*(cstr*)p = (normal_Strdup(v));
			}
			else if(((e->type) == ((type*)(t_ints + 0)) || (e->type) == ((type*)(t_ints + 10)) || (e->type) == ((type*)(t_ints + 5))))
			{
				v = scan_int(&(*(int*)p), v);
			}
			else if(((e->type) == ((type*)(t_ints + 2)) || (e->type) == ((type*)(t_ints + 12)) || (e->type) == ((type*)(t_ints + 7))))
			{
				v = scan_short(&(*(short*)p), v);
			}
			else if(((e->type) == ((type*)(t_ints + 1)) || (e->type) == ((type*)(t_ints + 11)) || (e->type) == ((type*)(t_ints + 6))))
			{
				v = scan_char(&(*(char*)p), v);
			}
			else if(((e->type) == ((type*)(t_ints + 3)) || (e->type) == ((type*)(t_ints + 13)) || (e->type) == ((type*)(t_ints + 8))))
			{
				v = scan_long(&(*(long*)p), v);
			}
			else if(((e->type) == ((type*)(t_ints + 4)) || (e->type) == ((type*)(t_ints + 14)) || (e->type) == ((type*)(t_ints + 9))))
			{
				v = scan_long_long(&(*(long_long*)p), v);
			}
			else if(e->type == (type*)(t_floats + 0))
			{
				v = scan_float(&(*(float*)p), v);
			}
			else if(e->type == (type*)(t_floats + 1))
			{
				v = scan_double(&(*(double*)p), v);
			}
			else if(e->type == (type*)(t_floats + 2))
			{
				v = scan_long_double(&(*(long_double*)p), v);
			}
			else
			{
				error("read_struct: only cstr, integer and floating point members, not type %s", e->type->name);
			}
		}
		else
		{
			more = 1;
			break;
		}
skip:		;
	}
	if(more == 0 && i>0)
	{
		error("read_struct: missing newline before EOF");
	}
	buffer_free(b);
	return more;
}

boolean write_struct(void *s, type__struct_union *t, opt_err unknown_type)
{
	typeof((t->n)) (skip(1, `my__5073_)end) = (t->n);
	typeof(0) (skip(1, `my__5078_)v1) = 0;
	for(; (skip(1, `my__5083_)v1)<(skip(1, `my__5085_)end); ++(skip(1, `my__5087_)v1))
	{
		typeof((skip(1, `my__5089_)v1)) i = (skip(1, `my__5089_)v1);
		type__element *e = &t->e[i];
		char *p = (char*)s + e->offset;
		if(((e->type) == ((type*)(t_defs + 0)) || (e->type) == ((type*)(t_points + 0))))
		{
			if(*(cstr*)p)
			{
				pf("%s", (e->name));
				print(print_space);
				pf("%s", (*(cstr*)p));
				(sf(""));
			}
		}
		else
		{
			pf("%s", (e->name));
			print(print_space);
			if(((e->type) == ((type*)(t_ints + 0)) || (e->type) == ((type*)(t_ints + 5))))
			{
				pf("%d", (*(int*)p));
				(sf(""));
			}
			else if(((e->type) == ((type*)(t_ints + 2)) || (e->type) == ((type*)(t_ints + 7))))
			{
				pf("%h", (*(short*)p));
				(sf(""));
			}
			else if(((e->type) == ((type*)(t_ints + 1)) || (e->type) == ((type*)(t_ints + 6))))
			{
				pf("%hhd", (*(char*)p));
				(sf(""));
			}
			else if(((e->type) == ((type*)(t_ints + 3)) || (e->type) == ((type*)(t_ints + 8))))
			{
				pf("%ld", (*(long*)p));
				(sf(""));
			}
			else if(((e->type) == ((type*)(t_ints + 4)) || (e->type) == ((type*)(t_ints + 9))))
			{
				pf("%lld", (*(long_long*)p));
				(sf(""));
			}
			else if(((e->type) == ((type*)(t_ints + 10))))
			{
				pf("%ud", (*(unsigned_int*)p));
				(sf(""));
			}
			else if(((e->type) == ((type*)(t_ints + 12))))
			{
				pf("%uh", (*(unsigned_short*)p));
				(sf(""));
			}
			else if(((e->type) == ((type*)(t_ints + 11))))
			{
				pf("%uhhd", (*(unsigned_char*)p));
				(sf(""));
			}
			else if(((e->type) == ((type*)(t_ints + 13))))
			{
				pf("%uld", (*(unsigned_long*)p));
				(sf(""));
			}
			else if(((e->type) == ((type*)(t_ints + 14))))
			{
				pf("%ulld", (*(unsigned_long_long*)p));
				(sf(""));
			}
			else if(e->type == (type*)(t_floats + 0))
			{
				pf("%f", (*(float*)p));
				(sf(""));
			}
			else if(e->type == (type*)(t_floats + 1))
			{
				pf("%f", (*(double*)p));
				(sf(""));
			}
			else if(e->type == (type*)(t_floats + 2))
			{
				pf("%Lf", (*(long_double*)p));
				(sf(""));
			}
			else
			{
				if(!opt_err_do(unknown_type, (any){.i=1}, (any){.i=0}, "write_struct: only cstr, integer and floating point members, not type %s", e->type->name).i)
				{
					return 0;
				}
			}
		}
	}
	(sf(""));
	return 1;
}

range check_range(sample *s0, sample *s1)
{
	range r;
	r.min = 1e100;
	r.max = -1e100;
	typeof(s1) (skip(1, `my__5174_)end) = s1;
	typeof(s0) (skip(1, `my__5179_)v1) = s0;
	for(; (skip(1, `my__5184_)v1)<(skip(1, `my__5186_)end); ++(skip(1, `my__5188_)v1))
	{
		typeof((skip(1, `my__5190_)v1)) s = (skip(1, `my__5190_)v1);
		if(*s < r.min)
		{
			r.min = *s;
		}
		if(*s > r.max)
		{
			r.max = *s;
		}
	}
	return r;
}

boolean range_ok(sample *s0, sample *s1)
{
	range r = check_range(s0, s1);
	return r.min >= -1 && r.max <= 1;
}

void sound_print(sample *s0, sample *s1)
{
	int (skip(1, `my__5197_)i) = 0;
	typeof(s1) (skip(1, `my__5201_)end) = s1;
	typeof(s0) (skip(1, `my__5206_)v1) = s0;
	for(; (skip(1, `my__5211_)v1)<(skip(1, `my__5213_)end); ++(skip(1, `my__5215_)v1))
	{
		typeof((skip(1, `my__5217_)v1)) s = (skip(1, `my__5217_)v1);
		if((skip(1, `my__5222_)i) == 2)
		{
			((Nl(stdout)));
			(skip(1, `my__5224_)i) = 0;
		}
		++(skip(1, `my__5226_)i);
		printf("%.2f ", *s);
	}
	if(0)
	{
		
	}
	else if(putc('\n', stdout) == EOF)
	{
		failed("putc");
	}
	if(0)
	{
		
	}
	else if(putc('\n', stdout) == EOF)
	{
		failed("putc");
	}
}

void normalize(sample *s0, sample *s1, boolean softer)
{
	range r = check_range(s0, s1);
	sample vol0 = fabs(r.min);
	sample vol1 = fabs(r.max);
	sample max = vol0 > vol1 ? vol0 : vol1;
	if(!softer || max > 1)
	{
		amplify(s0, s1, 1.0/max);
		clip(s0, s1);
	}
}

void amplify(sample *s0, sample *s1, num factor)
{
	typeof(s1) (skip(1, `my__5239_)end) = s1;
	typeof(s0) (skip(1, `my__5244_)v1) = s0;
	for(; (skip(1, `my__5249_)v1)<(skip(1, `my__5251_)end); ++(skip(1, `my__5253_)v1))
	{
		typeof((skip(1, `my__5255_)v1)) s = (skip(1, `my__5255_)v1);
		*s *= factor;
	}
}

void clip(sample *s0, sample *s1)
{
	typeof(s1) (skip(1, `my__5262_)end) = s1;
	typeof(s0) (skip(1, `my__5267_)v1) = s0;
	for(; (skip(1, `my__5272_)v1)<(skip(1, `my__5274_)end); ++(skip(1, `my__5276_)v1))
	{
		typeof((skip(1, `my__5278_)v1)) s = (skip(1, `my__5278_)v1);
		if(*s < -1)
		{
			*s = -1;
		}
		else if(*s > 1)
		{
			*s = 1;
		}
	}
}

void add_noise(sample *s0, sample *s1, num vol)
{
	typeof(s1) (skip(1, `my__5284_)end) = s1;
	typeof(s0) (skip(1, `my__5289_)v1) = s0;
	for(; (skip(1, `my__5294_)v1)<(skip(1, `my__5296_)end); ++(skip(1, `my__5298_)v1))
	{
		typeof((skip(1, `my__5300_)v1)) i = (skip(1, `my__5300_)v1);
		*i += (((num)((long double)((long long int)random()*(((1UL<<31)))+random())/((unsigned long long int)(((1UL<<31)))*(((1UL<<31))))))*vol)-vol/2;
	}
}

void sound_init(sound *s, ssize_t size)
{
	vec_init_el_size(s, sizeof(sample), (size));
	vec_size(s, size);
}

void sound_clear(sound *s)
{
	typeof((((sample *)(vec_element(s, s->size))))) (skip(1, `my__5322_)end) = (((sample *)(vec_element(s, s->size))));
	typeof((((sample *)(vec_element(s, 0))))) (skip(1, `my__5327_)v1) = (((sample *)(vec_element(s, 0))));
	for(; (skip(1, `my__5332_)v1)<(skip(1, `my__5334_)end); ++(skip(1, `my__5336_)v1))
	{
		typeof((skip(1, `my__5338_)v1)) i = (skip(1, `my__5338_)v1);
		*i = 0;
	}
}

void mix_range(sample *up, sample *a0, sample *a1)
{
	while(a0 != a1)
	{
		*up += *a0;
		++up;
		++a0;
	}
}

void sound_same_size(sound *s1, sound *s2)
{
	sound_grow(s1, (s2->size));
	sound_grow(s2, (s1->size));
}

void sound_grow(sound *s, ssize_t size)
{
	typeof((s->size)) old_size = (s->size);
	if(old_size < size)
	{
		vec_size(s, size);
		typeof((((sample *)(vec_element(s, s->size))))) (skip(1, `my__5359_)end) = (((sample *)(vec_element(s, s->size))));
		typeof((((sample *)(vec_element(s, 0)))+old_size)) (skip(1, `my__5364_)v1) = (((sample *)(vec_element(s, 0)))+old_size);
		for(; (skip(1, `my__5369_)v1)<(skip(1, `my__5371_)end); ++(skip(1, `my__5373_)v1))
		{
			typeof((skip(1, `my__5375_)v1)) i = (skip(1, `my__5375_)v1);
			*i = 0;
		}
	}
}

void mix(sound *up, sound *add)
{
	sound_grow(up, (add->size));
	mix_range(((sample *)(vec_element(up, 0))), ((sample *)(vec_element(add, 0))), ((sample *)(vec_element(add, add->size))));
}

void mix_to_new(sample *out, sample *a0, sample *a1, sample *b0, sample *b1)
{
	while(a0 != a1 && b0 != b1)
	{
		*out = *a0 + *b0;
		++out;
		++a0;
		++b0;
	}
	if(b0 == b1)
	{
		typeof(&a0) ((skip(1, `my__5390_)ap)) = &a0;
		typeof(&b0) ((skip(1, `my__5392_)bp)) = &b0;
		typeof(*((skip(1, `my__5392_)bp))) ((skip(1, `my__5394_)tmp)) = *((skip(1, `my__5392_)bp));
		*((skip(1, `my__5392_)bp)) = *((skip(1, `my__5390_)ap));
		*((skip(1, `my__5390_)ap)) = ((skip(1, `my__5394_)tmp));
		typeof(&a1) ((skip(1, `my__5407_)ap)) = &a1;
		typeof(&b1) ((skip(1, `my__5409_)bp)) = &b1;
		typeof(*((skip(1, `my__5409_)bp))) ((skip(1, `my__5411_)tmp)) = *((skip(1, `my__5409_)bp));
		*((skip(1, `my__5409_)bp)) = *((skip(1, `my__5407_)ap));
		*((skip(1, `my__5407_)ap)) = ((skip(1, `my__5411_)tmp));
	}
	while(a0 != a1)
	{
		*out = *a0;
		++out;
		++a0;
	}
}

void sound_set_rate(int r)
{
	sound_rate = r;
	sound_dt = 1.0 / sound_rate;
}

void audio_init(audio *a)
{
	(void)a;
}

void audio_init_2(audio *a, int channels, int n_samples)
{
	a->channels = channels;
	a->n_samples = n_samples;
	a->sound = ((sound *)(normal_Malloc(channels * sizeof(sound))));
	typeof(channels) (skip(1, `my__5428_)end) = channels;
	typeof(0) (skip(1, `my__5433_)v1) = 0;
	for(; (skip(1, `my__5438_)v1)<(skip(1, `my__5440_)end); ++(skip(1, `my__5442_)v1))
	{
		typeof((skip(1, `my__5444_)v1)) i = (skip(1, `my__5444_)v1);
		sound_init(&a->sound[i], n_samples);
		vec_size(&a->sound[i], 0);
	}
}

void load_wav(audio *a)
{
	size_t header_size_1 = 36;
	size_t header_size_2 = 8;
	char headers[header_size_1 + header_size_2];
	if((vs_read(headers, 1, header_size_1)) != header_size_1)
	{
		error("%s failed: %s", "load_wav", "file too short");
	}
	if(strncmp(headers, "RIFF", 4) || strncmp(headers+8, "WAVEfmt ", 8))
	{
		error("%s failed: %s", "load_wav", "invalid / unknown wav format");
	}
	size_t format_size = (((unsigned char)(headers + 16)[0]) | (((unsigned char)((headers + 16)+1)[0])<<8) | (((unsigned char)((headers + 16)+2)[0])<<16) | (((unsigned char)((headers + 16)+3)[0])<<24));
	if(format_size < 0x10)
	{
		error("%s failed: %s", "load_wav", "format_size too small");
	}
	int compression_code = (((unsigned char)(headers + 20)[0]) | (((unsigned char)((headers + 20)+1)[0])<<8));
	if(compression_code != 1)
	{
		error("%s failed: %s", "load_wav", "compression not supported");
	}
	size_t size = (((unsigned char)(headers+4)[0]) | (((unsigned char)((headers+4)+1)[0])<<8) | (((unsigned char)((headers+4)+2)[0])<<16) | (((unsigned char)((headers+4)+3)[0])<<24)) - 20 - format_size;
	discard(format_size - 0x10);
	if((vs_read((headers + header_size_1), 1, header_size_2)) != header_size_2)
	{
		error("%s failed: %s", "load_wav", "file too short");
	}
	if(strncmp(headers + header_size_1, "data", 4))
	{
		error("%s failed: %s", "load_wav", "data chunk not found");
	}
	if((size_t)(((unsigned char)(headers + header_size_1 + 4)[0]) | (((unsigned char)((headers + header_size_1 + 4)+1)[0])<<8) | (((unsigned char)((headers + header_size_1 + 4)+2)[0])<<16) | (((unsigned char)((headers + header_size_1 + 4)+3)[0])<<24)) != size)
	{
		error("%s failed: %s", "load_wav", "file size mismatch");
	}
	a->channels = (((unsigned char)(headers + 22)[0]) | (((unsigned char)((headers + 22)+1)[0])<<8));
	a->sample_rate = (((unsigned char)(headers + 24)[0]) | (((unsigned char)((headers + 24)+1)[0])<<8) | (((unsigned char)((headers + 24)+2)[0])<<16) | (((unsigned char)((headers + 24)+3)[0])<<24));
	int bytes_per_second = (((unsigned char)(headers + 28)[0]) | (((unsigned char)((headers + 28)+1)[0])<<8) | (((unsigned char)((headers + 28)+2)[0])<<16) | (((unsigned char)((headers + 28)+3)[0])<<24));
	(void)bytes_per_second;
	int block_align = (((unsigned char)(headers + 32)[0]) | (((unsigned char)((headers + 32)+1)[0])<<8));
	a->bits_per_sample = (((unsigned char)(headers + 34)[0]) | (((unsigned char)((headers + 34)+1)[0])<<8));
	if(a->bits_per_sample * a->channels != 8 * block_align)
	{
		error("%s failed: %s", "load_wav", "bits_per_sample * channels != 8 * block_align");
	}
	if(size % block_align)
	{
		error("%s failed: %s", "load_wav", "size is not a whole number of blocks");
	}
	if(a->bits_per_sample % 8)
	{
		error("%s failed: %s", "load_wav", "bits_per_sample is not a multiple of 8");
	}
	int bytes_per_sample = a->bits_per_sample / 8;
	a->n_samples = size / bytes_per_sample / a->channels;
	a->sound = ((sound *)(normal_Malloc((a->channels) * sizeof(sound))));
	typeof((a->channels)) (skip(1, `my__5505_)end) = (a->channels);
	typeof(0) (skip(1, `my__5510_)v1) = 0;
	for(; (skip(1, `my__5515_)v1)<(skip(1, `my__5517_)end); ++(skip(1, `my__5519_)v1))
	{
		typeof((skip(1, `my__5521_)v1)) i = (skip(1, `my__5521_)v1);
		sound_init(&a->sound[i], a->n_samples);
	}
	float divide = 1<<(a->bits_per_sample-1);
	float origin = bytes_per_sample == 1 ? (divide/2) : 0;
	switch(bytes_per_sample)
	{
	case 1:	
		{
			sample *O[((a->channels))];
			typeof((((a->channels)))) (skip(1, `my__5543_)end) = (((a->channels)));
			typeof(0) (skip(1, `my__5548_)v1) = 0;
			for(; (skip(1, `my__5553_)v1)<(skip(1, `my__5555_)end); ++(skip(1, `my__5557_)v1))
			{
				typeof((skip(1, `my__5559_)v1)) i = (skip(1, `my__5559_)v1);
				O[i] = ((sample *)(vec_element((&((a->sound))[i]), 0)));
			}
			int ((skip(1, `my__5527_)chunk_size)) = block_size - block_size % (1 * ((a->channels)));
			int ((skip(1, `my__5529_)chunk_samples)) = ((skip(1, `my__5527_)chunk_size)) / (1 * ((a->channels)));
			int ((skip(1, `my__5531_)remain)) = ((a->n_samples));
			char buf[((skip(1, `my__5527_)chunk_size))];
			while(((skip(1, `my__5531_)remain)))
			{
				int ((skip(1, `my__5533_)to_read)) = imin(((skip(1, `my__5529_)chunk_samples)), ((skip(1, `my__5531_)remain)));
				size_t ((skip(1, `my__5535_)to_read_bytes)) = ((skip(1, `my__5533_)to_read)) * ((a->channels)) * 1;
				if((vs_read(buf, 1, (((skip(1, `my__5535_)to_read_bytes))))) != ((skip(1, `my__5535_)to_read_bytes)))
				{
					error("%s failed: %s", "read_samples", "file too short");
				}
				((skip(1, `my__5531_)remain)) -= ((skip(1, `my__5533_)to_read));
				char *((skip(1, `my__5537_)in)) = buf;
				char *((skip(1, `my__5539_)end)) = buf + ((skip(1, `my__5535_)to_read_bytes));
				while(((skip(1, `my__5537_)in)) < ((skip(1, `my__5539_)end)))
				{
					typeof((((a->channels)))) (skip(1, `my__5569_)end) = (((a->channels)));
					typeof(0) (skip(1, `my__5574_)v1) = 0;
					for(; (skip(1, `my__5579_)v1)<(skip(1, `my__5581_)end); ++(skip(1, `my__5583_)v1))
					{
						typeof((skip(1, `my__5585_)v1)) i = (skip(1, `my__5585_)v1);
						*(O[i]++) = ((unsigned char)((skip(1, `my__5537_)in))[0]) / divide - origin;
						((skip(1, `my__5537_)in)) += 1;
					}
				}
			}
		}
		break;
	case 2:	
		{
			sample *O[((a->channels))];
			typeof((((a->channels)))) (skip(1, `my__5608_)end) = (((a->channels)));
			typeof(0) (skip(1, `my__5613_)v1) = 0;
			for(; (skip(1, `my__5618_)v1)<(skip(1, `my__5620_)end); ++(skip(1, `my__5622_)v1))
			{
				typeof((skip(1, `my__5624_)v1)) i = (skip(1, `my__5624_)v1);
				O[i] = ((sample *)(vec_element((&((a->sound))[i]), 0)));
			}
			int ((skip(1, `my__5592_)chunk_size)) = block_size - block_size % (2 * ((a->channels)));
			int ((skip(1, `my__5594_)chunk_samples)) = ((skip(1, `my__5592_)chunk_size)) / (2 * ((a->channels)));
			int ((skip(1, `my__5596_)remain)) = ((a->n_samples));
			char buf[((skip(1, `my__5592_)chunk_size))];
			while(((skip(1, `my__5596_)remain)))
			{
				int ((skip(1, `my__5598_)to_read)) = imin(((skip(1, `my__5594_)chunk_samples)), ((skip(1, `my__5596_)remain)));
				size_t ((skip(1, `my__5600_)to_read_bytes)) = ((skip(1, `my__5598_)to_read)) * ((a->channels)) * 2;
				if((vs_read(buf, 1, (((skip(1, `my__5600_)to_read_bytes))))) != ((skip(1, `my__5600_)to_read_bytes)))
				{
					error("%s failed: %s", "read_samples", "file too short");
				}
				((skip(1, `my__5596_)remain)) -= ((skip(1, `my__5598_)to_read));
				char *((skip(1, `my__5602_)in)) = buf;
				char *((skip(1, `my__5604_)end)) = buf + ((skip(1, `my__5600_)to_read_bytes));
				while(((skip(1, `my__5602_)in)) < ((skip(1, `my__5604_)end)))
				{
					typeof((((a->channels)))) (skip(1, `my__5634_)end) = (((a->channels)));
					typeof(0) (skip(1, `my__5639_)v1) = 0;
					for(; (skip(1, `my__5644_)v1)<(skip(1, `my__5646_)end); ++(skip(1, `my__5648_)v1))
					{
						typeof((skip(1, `my__5650_)v1)) i = (skip(1, `my__5650_)v1);
						*(O[i]++) = (((long)(((unsigned char)((skip(1, `my__5602_)in))[0]) | (((unsigned char)(((skip(1, `my__5602_)in))+1)[0])<<8))) << 16 >> 16) / divide - origin;
						((skip(1, `my__5602_)in)) += 2;
					}
				}
			}
		}
		break;
	case 3:	
		{
			sample *O[((a->channels))];
			typeof((((a->channels)))) (skip(1, `my__5676_)end) = (((a->channels)));
			typeof(0) (skip(1, `my__5681_)v1) = 0;
			for(; (skip(1, `my__5686_)v1)<(skip(1, `my__5688_)end); ++(skip(1, `my__5690_)v1))
			{
				typeof((skip(1, `my__5692_)v1)) i = (skip(1, `my__5692_)v1);
				O[i] = ((sample *)(vec_element((&((a->sound))[i]), 0)));
			}
			int ((skip(1, `my__5660_)chunk_size)) = block_size - block_size % (3 * ((a->channels)));
			int ((skip(1, `my__5662_)chunk_samples)) = ((skip(1, `my__5660_)chunk_size)) / (3 * ((a->channels)));
			int ((skip(1, `my__5664_)remain)) = ((a->n_samples));
			char buf[((skip(1, `my__5660_)chunk_size))];
			while(((skip(1, `my__5664_)remain)))
			{
				int ((skip(1, `my__5666_)to_read)) = imin(((skip(1, `my__5662_)chunk_samples)), ((skip(1, `my__5664_)remain)));
				size_t ((skip(1, `my__5668_)to_read_bytes)) = ((skip(1, `my__5666_)to_read)) * ((a->channels)) * 3;
				if((vs_read(buf, 1, (((skip(1, `my__5668_)to_read_bytes))))) != ((skip(1, `my__5668_)to_read_bytes)))
				{
					error("%s failed: %s", "read_samples", "file too short");
				}
				((skip(1, `my__5664_)remain)) -= ((skip(1, `my__5666_)to_read));
				char *((skip(1, `my__5670_)in)) = buf;
				char *((skip(1, `my__5672_)end)) = buf + ((skip(1, `my__5668_)to_read_bytes));
				while(((skip(1, `my__5670_)in)) < ((skip(1, `my__5672_)end)))
				{
					typeof((((a->channels)))) (skip(1, `my__5702_)end) = (((a->channels)));
					typeof(0) (skip(1, `my__5707_)v1) = 0;
					for(; (skip(1, `my__5712_)v1)<(skip(1, `my__5714_)end); ++(skip(1, `my__5716_)v1))
					{
						typeof((skip(1, `my__5718_)v1)) i = (skip(1, `my__5718_)v1);
						*(O[i]++) = (((long)(((unsigned char)((skip(1, `my__5670_)in))[0]) | (((unsigned char)(((skip(1, `my__5670_)in))+1)[0])<<8) | (((unsigned char)(((skip(1, `my__5670_)in))+2)[0])<<16))) << 8 >> 8) / divide - origin;
						((skip(1, `my__5670_)in)) += 3;
					}
				}
			}
		}
		break;
	case 4:	
		{
			sample *O[((a->channels))];
			typeof((((a->channels)))) (skip(1, `my__5745_)end) = (((a->channels)));
			typeof(0) (skip(1, `my__5750_)v1) = 0;
			for(; (skip(1, `my__5755_)v1)<(skip(1, `my__5757_)end); ++(skip(1, `my__5759_)v1))
			{
				typeof((skip(1, `my__5761_)v1)) i = (skip(1, `my__5761_)v1);
				O[i] = ((sample *)(vec_element((&((a->sound))[i]), 0)));
			}
			int ((skip(1, `my__5729_)chunk_size)) = block_size - block_size % (4 * ((a->channels)));
			int ((skip(1, `my__5731_)chunk_samples)) = ((skip(1, `my__5729_)chunk_size)) / (4 * ((a->channels)));
			int ((skip(1, `my__5733_)remain)) = ((a->n_samples));
			char buf[((skip(1, `my__5729_)chunk_size))];
			while(((skip(1, `my__5733_)remain)))
			{
				int ((skip(1, `my__5735_)to_read)) = imin(((skip(1, `my__5731_)chunk_samples)), ((skip(1, `my__5733_)remain)));
				size_t ((skip(1, `my__5737_)to_read_bytes)) = ((skip(1, `my__5735_)to_read)) * ((a->channels)) * 4;
				if((vs_read(buf, 1, (((skip(1, `my__5737_)to_read_bytes))))) != ((skip(1, `my__5737_)to_read_bytes)))
				{
					error("%s failed: %s", "read_samples", "file too short");
				}
				((skip(1, `my__5733_)remain)) -= ((skip(1, `my__5735_)to_read));
				char *((skip(1, `my__5739_)in)) = buf;
				char *((skip(1, `my__5741_)end)) = buf + ((skip(1, `my__5737_)to_read_bytes));
				while(((skip(1, `my__5739_)in)) < ((skip(1, `my__5741_)end)))
				{
					typeof((((a->channels)))) (skip(1, `my__5771_)end) = (((a->channels)));
					typeof(0) (skip(1, `my__5776_)v1) = 0;
					for(; (skip(1, `my__5781_)v1)<(skip(1, `my__5783_)end); ++(skip(1, `my__5785_)v1))
					{
						typeof((skip(1, `my__5787_)v1)) i = (skip(1, `my__5787_)v1);
						*(O[i]++) = (((long)(((unsigned char)((skip(1, `my__5739_)in))[0]) | (((unsigned char)(((skip(1, `my__5739_)in))+1)[0])<<8) | (((unsigned char)(((skip(1, `my__5739_)in))+2)[0])<<16) | (((unsigned char)(((skip(1, `my__5739_)in))+3)[0])<<24)))) / divide - origin;
						((skip(1, `my__5739_)in)) += 4;
					}
				}
			}
		}
		break;
	default:	error("%s failed: %s", "load_wav", "bytes_per_sample is not 1, 2, 3 or 4");
	}
}

void dsp_play_sound(sample *i, sample *e)
{
	size_t buf_size = (dsp_buf->size);
	short *buf0 = ((short *)(vec_element(dsp_buf, 0)));
	while(i < e)
	{
		size_t count = imin(e-i, buf_size);
		normalize(i, (i+count), 1);
		dsp_encode(i, i+count, buf0);
		dsp_play((char *)buf0, (char *)(buf0 + count));
		i += count;
	}
}

void dsp_init(void)
{
	dsp_buffer_init(dsp_buf, dsp_rate * dsp_buf_initial_duration);
	dsp_fd = (Open(dsp_outfile, (O_WRONLY|O_CREAT|O_APPEND), 0666));
	if(use_dsp)
	{
		int arg;
		int status;
		arg = bits_per_sample;
		status = ioctl(dsp_fd, SOUND_PCM_WRITE_BITS, &arg);
		if(status == -1)
		{
			error("SOUND_PCM_WRITE_BITS ioctl failed");
		}
		if((arg != bits_per_sample))
		{
			error("unable to set sample size");
		}
		arg = dsp_channels;
		status = ioctl(dsp_fd, SOUND_PCM_WRITE_CHANNELS, &arg);
		if((status == -1))
		{
			error("SOUND_PCM_WRITE_CHANNELS ioctl failed");
		}
		if((arg != dsp_channels))
		{
			error("unable to set number of channels");
		}
		arg = dsp_rate;
		status = ioctl(dsp_fd, SOUND_PCM_WRITE_RATE, &arg);
		if((status == -1))
		{
			error("SOUND_PCM_WRITE_RATE ioctl failed");
		}
		if(arg != dsp_rate)
		{
			warn("using sample rate %d instead of %d\n", arg, dsp_rate);
			dsp_rate = arg;
		}
	}
	sound_set_rate(dsp_rate);
}

void dsp_play(char *b0, char *b1)
{
	size_t size = b1 - b0;
	Write(dsp_fd, b0, size);
}

void dsp_sync(void)
{
	if(use_dsp)
	{
		int status = ioctl(dsp_fd, SOUND_PCM_SYNC, 0);
		if((status == -1))
		{
			error("SOUND_PCM_SYNC ioctl failed");
		}
	}
}

void dsp_buffer_init(dsp_buffer *b, size_t size)
{
	vec_init_el_size(b, bytes_per_sample, size);
	vec_size(b, size);
	typeof((((short *)(vec_element(b, b->size))))) (skip(1, `my__5813_)end) = (((short *)(vec_element(b, b->size))));
	typeof((((short *)(vec_element(b, 0))))) (skip(1, `my__5818_)v1) = (((short *)(vec_element(b, 0))));
	for(; (skip(1, `my__5823_)v1)<(skip(1, `my__5825_)end); ++(skip(1, `my__5827_)v1))
	{
		typeof((skip(1, `my__5829_)v1)) i = (skip(1, `my__5829_)v1);
		*i = 0;
	}
}

void dsp_buffer_print(dsp_buffer *b)
{
	buffer_dump(stderr, (&b->b));
}

size_t dsp_sample_size(void)
{
	return bytes_per_sample;
}

void dsp_encode(sample *in0, sample *in1, short *out)
{
	if(1 && !((bits_per_sample == 16 && dsp_channels == 1 && bytes_per_sample == 2)))
	{
		fault_(__FILE__, __LINE__, "dsp_encode can only produce 16bit mono sound at the moment");
	}
	if(1 && !((sizeof(short) == bytes_per_sample)))
	{
		fault_(__FILE__, __LINE__, "short type is not two bytes!! oh dear");
	}
	typeof(in1) (skip(1, `my__5848_)end) = in1;
	typeof(in0) (skip(1, `my__5853_)v1) = in0;
	for(; (skip(1, `my__5858_)v1)<(skip(1, `my__5860_)end); ++(skip(1, `my__5862_)v1))
	{
		typeof((skip(1, `my__5864_)v1)) in = (skip(1, `my__5864_)v1);
		*out++ = (0x7fff * *in);
	}
}

void dur(num d)
{
	_dur = d;
}

void vol(num v)
{
	_vol = v;
}

void freq(num f)
{
	_freq = f;
}

void relfreq(num rf)
{
	_rf = rf;
	_freq = relfreq2freq(rf);
	_p = relfreq2pitch(rf);
}

void pitch(num p)
{
	_p = p;
	_rf = pitch2relfreq(_p);
	_freq = relfreq2freq(_rf);
}

void note(void)
{
	sound struct__buf;
	sound *buf = &struct__buf;
	sound_init(buf, _dur * sound_rate);
	wavegen(((sample *)(vec_element(buf, 0))), ((sample *)(vec_element(buf, buf->size))));
	dsp_play_sound(((sample *)(vec_element(buf, 0))), ((sample *)(vec_element(buf, buf->size))));
	dsp_sync();
}

void envelope(num attack, num release)
{
	_attack = attack;
	_release = release;
}

void vibrato(num power, num freq)
{
	if(1 && !((power >= 1)))
	{
		fault_(__FILE__, __LINE__, "vibrato power must be >= 1");
	}
	vibrato_power = power;
	vibrato_freq = freq;
}

void tremolo(num dpitch, num freq)
{
	tremolof(pitch2relfreq(dpitch), freq);
}

void tremolof(num power, num freq)
{
	tremolo_power = power;
	tremolo_freq = freq;
}

void wavegen(float *from, float *to)
{
	num loud_factor = 1;
	num dur = _dur;
	num peak = _vol * loud_factor;
	num attack = _attack;
	num release = _release;
	num sustain = _dur - (attack + release);
	if(sustain < 0)
	{
		num factor = dur / (attack + release);
		attack *= factor;
		release *= factor;
		peak *= factor;
		sustain = 0;
	}
	size_t attack_c = attack * sound_rate;
	size_t sustain_c = sustain * sound_rate;
	size_t release_c = release * sound_rate;
	num attack_dvol = peak / attack_c;
	num sustain_dvol = 0;
	num release_dvol = -peak / release_c;
	float t = 0.0;
	num evol = 0;
	typeof(to) (skip(1, `my__5897_)end) = to;
	typeof(from) (skip(1, `my__5902_)v1) = from;
	for(; (skip(1, `my__5907_)v1)<(skip(1, `my__5909_)end); ++(skip(1, `my__5911_)v1))
	{
		typeof((skip(1, `my__5913_)v1)) v = (skip(1, `my__5913_)v1);
		num vol;
		if(vibrato_power > 1)
		{
			vol = pow(vibrato_power, sin(2*pi*t*vibrato_freq)) * evol;
		}
		else
		{
			vol = evol;
		}
		num freq;
		if(tremolo_power > 1)
		{
			freq = pow(tremolo_power, sin(2*pi*t*tremolo_freq)) * _freq;
		}
		else
		{
			freq = _freq;
		}
		*v += vol*(*music_wave)(t*freq);
		if(attack_c)
		{
			--attack_c;
			evol += attack_dvol;
		}
		else if(sustain_c)
		{
			--sustain_c;
			evol += sustain_dvol;
		}
		else if(release_c)
		{
			--release_c;
			evol += release_dvol;
		}
		t += sound_dt;
	}
}

num puretone(num t)
{
	return sin(2*pi*t);
}

num sawtooth(num t)
{
	return rmod(t, 1)*2-1;
}

void chordf(int n, num f[])
{
	sound struct__buf;
	sound *buf = &struct__buf;
	sound_init(buf, _dur * sound_rate);
	typeof(n) (skip(1, `my__5922_)end) = n;
	typeof(0) (skip(1, `my__5927_)v1) = 0;
	for(; (skip(1, `my__5932_)v1)<(skip(1, `my__5934_)end); ++(skip(1, `my__5936_)v1))
	{
		typeof((skip(1, `my__5938_)v1)) i = (skip(1, `my__5938_)v1);
		freq(f[i]);
		wavegen(((sample *)(vec_element(buf, 0))), ((sample *)(vec_element(buf, buf->size))));
	}
	dsp_play_sound(((sample *)(vec_element(buf, 0))), ((sample *)(vec_element(buf, buf->size))));
	dsp_sync();
}

void rfChord(int n, num relfreq[])
{
	num freq[n];
	typeof(n) (skip(1, `my__5963_)end) = n;
	typeof(0) (skip(1, `my__5968_)v1) = 0;
	for(; (skip(1, `my__5973_)v1)<(skip(1, `my__5975_)end); ++(skip(1, `my__5977_)v1))
	{
		typeof((skip(1, `my__5979_)v1)) i = (skip(1, `my__5979_)v1);
		freq[i] = relfreq2freq(relfreq[i]);
	}
	chordf(n, freq);
}

void chord(int n, num pitch[])
{
	num relfreq[n];
	typeof(n) (skip(1, `my__5985_)end) = n;
	typeof(0) (skip(1, `my__5990_)v1) = 0;
	for(; (skip(1, `my__5995_)v1)<(skip(1, `my__5997_)end); ++(skip(1, `my__5999_)v1))
	{
		typeof((skip(1, `my__6001_)v1)) i = (skip(1, `my__6001_)v1);
		relfreq[i] = pitch2relfreq(pitch[i]);
	}
	rfChord(n, relfreq);
}

void chord2f(num a0, num a1)
{
	num a[2] = { a0, a1 };
	chordf(2, a);
}

void rfChord2(num a0, num a1)
{
	num a[2] = { a0, a1 };
	rfChord(2, a);
}

void chord2(num a0, num a1)
{
	num a[2] = { a0, a1 };
	chord(2, a);
}

void chord3f(num a0, num a1, num a2)
{
	num a[3] = { a0, a1, a2 };
	chordf(3, a);
}

void rfChord3(num a0, num a1, num a2)
{
	num a[3] = { a0, a1, a2 };
	rfChord(3, a);
}

void chord3(num a0, num a1, num a2)
{
	num a[3] = { a0, a1, a2 };
	chord(3, a);
}

void chord4f(num a0, num a1, num a2, num a3)
{
	num a[4] = { a0, a1, a2, a3 };
	chordf(4, a);
}

void rfChord4(num a0, num a1, num a2, num a3)
{
	num a[4] = { a0, a1, a2, a3 };
	rfChord(4, a);
}

void chord4(num a0, num a1, num a2, num a3)
{
	num a[4] = { a0, a1, a2, a3 };
	chord(4, a);
}

void note_1_in_bits(num freq)
{
	int buf_dur = imin(1, _dur);
	int rate = sound_rate;
	int whole_size = _dur * rate;
	int buf_size = buf_dur * rate;
	sound struct__buf;
	sound *buf = &struct__buf;
	sound_init(buf, buf_size);
	float t = 0.0;
	while(whole_size > 0)
	{
		int size = imin(buf_size, whole_size);
		vec_size(buf, size);
		typeof((((sample *)(vec_element(buf, buf->size))))) (skip(1, `my__6016_)end) = (((sample *)(vec_element(buf, buf->size))));
		typeof((((sample *)(vec_element(buf, 0))))) (skip(1, `my__6021_)v1) = (((sample *)(vec_element(buf, 0))));
		for(; (skip(1, `my__6026_)v1)<(skip(1, `my__6028_)end); ++(skip(1, `my__6030_)v1))
		{
			typeof((skip(1, `my__6032_)v1)) v = (skip(1, `my__6032_)v1);
			*v = _vol*sin(2*pi*t*freq);
			t += sound_dt;
		}
		dsp_play_sound(((sample *)(vec_element(buf, 0))), ((sample *)(vec_element(buf, buf->size))));
		whole_size -= size;
	}
	dsp_sync();
}

void key_note_freq(num freq)
{
	key_freq = freq;
}

void key_note(num pitch)
{
	key_freq = ref_freq;
	key_freq = pitch2freq(pitch);
}

num pitch2freq(num pitch)
{
	return relfreq2freq(pitch2relfreq(pitch));
}

num freq2pitch(num freq)
{
	return relfreq2pitch(freq2relfreq(freq));
}

num pitch2relfreq(num pitch)
{
	return pow(2, pitch/12);
}

num relfreq2pitch(num freq)
{
	return 12 * log(freq) / log(2);
}

num relfreq2freq(num relfreq)
{
	return relfreq * key_freq;
}

num freq2relfreq(num relfreq)
{
	return relfreq / key_freq;
}

void harmony(int p)
{
	relfreq(harmony2relfreq(p));
}

num harmony2relfreq(int p)
{
	int octave, degree;
	divmod_range(p, -5, 7, &octave, &degree);
	return pow(2, octave) * _harmony[degree + 5];
}

num harmony2freq(int p)
{
	return harmony2relfreq(p) * key_freq;
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

void sprite_init(sprite *s, long width, long height)
{
	s->pixels = ((pix_t *)(normal_Malloc((width*height) * sizeof(pix_t))));
	s->width = width;
	s->height = height;
	s->stride = width;
}

void sprite_clear(sprite *s, pix_t c)
{
	pix_t *p = s->pixels;
	for(long y=0; y<s->height; ++y)
	{
		for(long x=0; x<s->width; ++x)
		{
			*p++ = c;
		}
		p += s->stride - s->width;
	}
}

void sprite_clip(sprite *target, sprite *source, sprite *target_full, sprite *source_full, long x, long y)
{
	*source = *source_full;
	if(x < 0)
	{
		source->width += x;
		source->pixels -= x * 1;
		if(source->width < 0)
		{
			source->width = 0;
		}
		x = 0;
	}
	long (skip(1, `my__6051_)x_over) = x + source->width - target_full->width;
	if((skip(1, `my__6053_)x_over) > 0)
	{
		source->width -= (skip(1, `my__6055_)x_over);
		if(source->width < 0)
		{
			source->width = 0;
		}
	}
	if(y < 0)
	{
		source->height += y;
		source->pixels -= y * (source->stride);
		if(source->height < 0)
		{
			source->height = 0;
		}
		y = 0;
	}
	long (skip(1, `my__6058_)x_over) = y + source->height - target_full->height;
	if((skip(1, `my__6060_)x_over) > 0)
	{
		source->height -= (skip(1, `my__6062_)x_over);
		if(source->height < 0)
		{
			source->height = 0;
		}
	}
	target->stride = target_full->stride;
	target->pixels = target_full->pixels + y*target->stride + x;
	target->width = source->width;
	target->height = source->height;
}

void sprite_blit(sprite *to, sprite *from)
{
	pix_t *i = from->pixels;
	pix_t *o = to->pixels;
	long w = imin(from->width, to->width);
	long h = imin(from->height, to->height);
	for(long y=0; y<h; ++y)
	{
		for(long x=0; x<w; ++x)
		{
			*o++ = *i++;
		}
		i += from->stride - w;
		o += to->stride - w;
	}
}

void sprite_blit_transl(sprite *to, sprite *from)
{
	pix_t *i = from->pixels;
	pix_t *o = to->pixels;
	long w = imin(from->width, to->width);
	long h = imin(from->height, to->height);
	for(long y=0; y<h; ++y)
	{
		for(long x=0; x<w; ++x)
		{
			pix_t c = *i++;
			int a = (c>>24 & 0xFF);
			if(a == 0)
			{
				*o = c;
			}
			else if(a < 255)
			{
				pix_t old = *o;
				int a1 = 255 - a;
				int r = ((c>>16 & 0xFF) * a1 + (old>>16 & 0xFF) * a) / 255;
				int g = ((c>>8 & 0xFF) * a1 + (old>>8 & 0xFF) * a) / 255;
				int b = ((c & 0xFF) * a1 + (old & 0xFF) * a) / 255;
				*o = ((pix_t)r<<16 | (pix_t)g<<8 | (pix_t)b);
			}
			++o;
		}
		i += from->stride - w;
		o += to->stride - w;
	}
}

void sprite_blit_transp(sprite *to, sprite *from)
{
	pix_t *i = from->pixels;
	pix_t *o = to->pixels;
	long w = imin(from->width, to->width);
	long h = imin(from->height, to->height);
	for(long y=0; y<h; ++y)
	{
		for(long x=0; x<w; ++x)
		{
			pix_t c = *i++;
			int a = (c>>24 & 0xFF);
			if(a != 255)
			{
				*o = c;
			}
			++o;
		}
		i += from->stride - w;
		o += to->stride - w;
	}
}

void sprite_gradient(sprite *s, colour c00, colour c10, colour c01, colour c11)
{
	sprite_gradient_angle(s, c00, c10, c01, c11, 0);
}

void sprite_gradient_angle(sprite *s, colour _c00, colour _c10, colour _c01, colour _c11, num angle)
{
	pix_t c00 = colour_to_pix(_c00);
	pix_t c10 = colour_to_pix(_c10);
	pix_t c01 = colour_to_pix(_c01);
	pix_t c11 = colour_to_pix(_c11);
	pix_t *p = s->pixels;
	long w = s->width;
	long h = s->height;
	num r0 = ((c00>>16 & 0xFF) / 256.0), g0 = ((c00>>8 & 0xFF) / 256.0), b0 = ((c00 & 0xFF) / 256.0);
	num r1 = ((c10>>16 & 0xFF) / 256.0), g1 = ((c10>>8 & 0xFF) / 256.0), b1 = ((c10 & 0xFF) / 256.0);
	num r01 = ((c01>>16 & 0xFF) / 256.0), g01 = ((c01>>8 & 0xFF) / 256.0), b01 = ((c01 & 0xFF) / 256.0);
	num r11 = ((c11>>16 & 0xFF) / 256.0), g11 = ((c11>>8 & 0xFF) / 256.0), b11 = ((c11 & 0xFF) / 256.0);
	if(angle != 0)
	{
		num s = sin(angle), c = cos(angle);
		num r0a = grad_value((s-c+1)/2, (-c-s+1)/2, r0, r1, r01, r11);
		num r1a = grad_value((s+c+1)/2, (-c+s+1)/2, r0, r1, r01, r11);
		num r01a = grad_value((-s-c+1)/2, (c-s+1)/2, r0, r1, r01, r11);
		num r11a = grad_value((-s+c+1)/2, (c+s+1)/2, r0, r1, r01, r11);
		r0 = r0a;
		r1 = r1a;
		r01 = r01a;
		r11 = r11a;
		num g0a = grad_value((s-c+1)/2, (-c-s+1)/2, g0, g1, g01, g11);
		num g1a = grad_value((s+c+1)/2, (-c+s+1)/2, g0, g1, g01, g11);
		num g01a = grad_value((-s-c+1)/2, (c-s+1)/2, g0, g1, g01, g11);
		num g11a = grad_value((-s+c+1)/2, (c+s+1)/2, g0, g1, g01, g11);
		g0 = g0a;
		g1 = g1a;
		g01 = g01a;
		g11 = g11a;
		num b0a = grad_value((s-c+1)/2, (-c-s+1)/2, b0, b1, b01, b11);
		num b1a = grad_value((s+c+1)/2, (-c+s+1)/2, b0, b1, b01, b11);
		num b01a = grad_value((-s-c+1)/2, (c-s+1)/2, b0, b1, b01, b11);
		num b11a = grad_value((-s+c+1)/2, (c+s+1)/2, b0, b1, b01, b11);
		b0 = b0a;
		b1 = b1a;
		b01 = b01a;
		b11 = b11a;
	}
	num dr0 = (r01 - r0) / h, dg0 = (g01 - g0) / h, db0 = (b01 - b0) / h;
	num dr1 = (r11 - r1) / h, dg1 = (g11 - g1) / h, db1 = (b11 - b1) / h;
	for(long y=0; y<h; ++y)
	{
		num r = r0, g = g0, b = b0;
		num dr = (r1 - r0) / w, dg = (g1 - g0) / w, db = (b1 - b0) / w;
		for(long x=0; x<w; ++x)
		{
			pix_t c = (((pix_t)(((iclamp(((int)(r*256)), 0, 255))))<<16 | (pix_t)(((iclamp(((int)(g*256)), 0, 255))))<<8 | (pix_t)(((iclamp(((int)(b*256)), 0, 255))))));
			*p++ = c;
			r += dr;
			g += dg;
			b += db;
		}
		p += s->stride - w;
		r0 += dr0;
		g0 += dg0;
		b0 += db0;
		r1 += dr1;
		g1 += dg1;
		b1 += db1;
	}
}

num grad_value(num x, num y, num v00, num v10, num v01, num v11)
{
	num v0 = v00 + (v01 - v00) * y;
	num v1 = v10 + (v11 - v10) * y;
	num v = v0 + (v1 - v0) * x;
	return v;
}

void sprite_translucent(sprite *s, num a)
{
	pix_t *p = s->pixels;
	long w = s->width;
	long h = s->height;
	for(long y=0; y<h; ++y)
	{
		for(long x=0; x<w; ++x)
		{
			pix_t c = *p;
			int a_old = 255 - (c>>24 & 0xFF);
			int A = (int)(255 - a_old * a) << 24;
			c &= ~0xFF000000;
			c |= A;
			*p++ = c;
		}
		p += s->stride - w;
	}
}

void sprite_circle(sprite *s)
{
	pix_t *p = s->pixels;
	long w = s->width;
	long h = s->height;
	for(long y=0; y<h; ++y)
	{
		for(long x=0; x<w; ++x)
		{
			num X = (x*2.0 / w) - 1;
			num Y = (y*2.0 / h) - 1;
			num R2 = X*X + Y*Y;
			if(R2 > 1)
			{
				*p |= 0xFF000000;
			}
			++p;
		}
		p += s->stride - w;
	}
}

void sprite_circle_aa(sprite *s)
{
	pix_t *p = s->pixels;
	long w = s->width;
	long h = s->height;
	num u = 4.0/(w+h);
	for(long y=0; y<h; ++y)
	{
		for(long x=0; x<w; ++x)
		{
			num X = (x*2.0 / w) - 1;
			num Y = (y*2.0 / h) - 1;
			num R = hypot(X, Y);
			if(R > 1+u/2)
			{
				*p |= 0xFF000000;
			}
			else if(R > 1-u/2)
			{
				num f = (R - (1-u/2)) / u;
				*p |= iclamp(255*f, 0, 255) << 24;
			}
			++p;
		}
		p += s->stride - w;
	}
}

sprite *sprite_load_png(sprite *s, cstr filename)
{
	FILE *fp = Fopen(filename, "rb");
	int ((skip(1, `my__6108_)x)) = 0;
}
void ((skip(1, `my__6108_)x))	if ((skip(1, `my__6108_)x)) == 1
{
	{
		++((skip(1, `my__6108_)x));
		
		Fclose(fp);
	}
	for(; ((skip(1, `my__6111_)x)) < 2 ; ++((skip(1, `my__6111_)x)))
	{
		if(((skip(1, `my__6111_)x)) == 1)
		{
			goto ((skip(1, `my__6111_)x));
		}
		
		
		sprite_load_png_stream(s, fp);
	}
	return s;
}

sprite *sprite_load_png_stream(sprite *s, FILE *in)
{
	png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, (png_voidp)NULL, NULL, NULL);
	if(!png_ptr)
	{
		failed("png_create_read_struct");
	}
	png_infop info_ptr = png_create_info_struct(png_ptr);
	if(!info_ptr)
	{
		png_destroy_read_struct(&png_ptr, (png_infopp)NULL, (png_infopp)NULL);
		failed("png_create_info_struct");
	}
	png_infop end_info = png_create_info_struct(png_ptr);
	if(!end_info)
	{
		png_destroy_read_struct(&png_ptr, &info_ptr, (png_infopp)NULL);
		failed("png_create_info_struct");
	}
	if(setjmp(png_jmpbuf(png_ptr)))
	{
		png_destroy_read_struct(&png_ptr, &info_ptr, &end_info);
		error("sprite_load_png: failed");
	}
	png_init_io(png_ptr, in);
	png_read_info(png_ptr, info_ptr);
	png_uint_32 width, height;
	int bit_depth, color_type, interlace_type, compression_type, filter_type;
	png_get_IHDR(png_ptr, info_ptr, &width, &height, &bit_depth, &color_type, &interlace_type, &compression_type, &filter_type);
	if(color_type == PNG_COLOR_TYPE_PALETTE)
	{
		
		png_set_palette_to_rgb(png_ptr);
	}
	if(color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8)
	{
		
		png_set_expand_gray_1_2_4_to_8(png_ptr);
	}
	if(png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS))
	{
		
		png_set_tRNS_to_alpha(png_ptr);
	}
	if(bit_depth == 16)
	{
		
		png_set_strip_16(png_ptr);
	}
	png_set_invert_alpha(png_ptr);
	if((color_type == PNG_COLOR_TYPE_RGB || color_type == PNG_COLOR_TYPE_GRAY || color_type == PNG_COLOR_TYPE_PALETTE))
	{
		
		png_set_add_alpha(png_ptr, 0x0, PNG_FILLER_AFTER);
	}
	if((color_type == PNG_COLOR_TYPE_GRAY || color_type == PNG_COLOR_TYPE_GRAY_ALPHA))
	{
		
		png_set_gray_to_rgb(png_ptr);
	}
	if((color_type == PNG_COLOR_TYPE_RGB || color_type == PNG_COLOR_TYPE_RGB_ALPHA || color_type == PNG_COLOR_TYPE_PALETTE))
	{
		png_set_bgr(png_ptr);
	}
	if(interlace_type == PNG_INTERLACE_ADAM7)
	{
		
		int number_of_passes = png_set_interlace_handling(png_ptr);
		(void)number_of_passes;
	}
	png_read_update_info(png_ptr, info_ptr);
	png_uint_32 rowbytes = png_get_rowbytes(png_ptr, info_ptr);
	if(rowbytes != width * 4)
	{
		error("sprite_load_png: rowbytes != width * 4 ; %ld != %ld", (long)rowbytes, (long)width*4);
	}
	sprite_init(s, width, height);
	png_bytep row_pointers[height];
	for(long y=0; y<(long)height; ++y)
	{
		row_pointers[y] = (png_bytep)(s->pixels + y * width);
	}
	png_read_image(png_ptr, row_pointers);
	png_read_end(png_ptr, end_info);
	png_destroy_read_struct(&png_ptr, &info_ptr, &end_info);
	return s;
}

pix_t sprite_at(sprite *s, long x, long y)
{
	if(x < 0 || y < 0 || x >= s->width || y >= s->height)
	{
		return pix_transp;
	}
	return s->pixels[y*s->stride + x];
}

pix_t colour_to_pix(colour c)
{
	return c;
}

void sprite_loop_init(sprite_loop *l, sprite *spr)
{
	l->spr = spr;
	l->px = spr->pixels;
	l->end = l->px + spr->height * spr->stride;
	l->endrow = l->px + spr->width;
	l->d = spr->stride - spr->width;
}

void gr_deco(int _d)
{
	_deco = _d;
}

void gr_fullscreen(void)
{
	fullscreen = 1;
	w = root_w;
	h = root_h;
	gr_deco(0);
}

void xflip(void)
{
	_xflip = !_xflip;
	text_origin_x *= -1;
}

void yflip(void)
{
	_yflip = !_yflip;
	text_origin_y *= -1;
}

void origin(num _ox, num _oy)
{
	ox = _ox;
	oy = _oy;
}

void zoom(num _sc)
{
	sc = _sc;
	a_pixel = isd(1);
}

num isx(num sx)
{
	if(_xflip)
	{
		sx = w_2-1-sx;
	}
	else
	{
		sx = sx-w_2;
	}
	return sx/sc+ox;
}

num isy(num sy)
{
	if(_yflip)
	{
		sy = sy-h_2;
	}
	else
	{
		sy = h_2-1-sy;
	}
	return sy/sc+oy;
}

num isd(num sd)
{
	return sd/sc;
}

void move(num x, num y)
{
	lx2 = lx;
	ly2 = ly;
	lx = x;
	ly = y;
}

void move2(num x1, num y1, num x2, num y2)
{
	lx2 = x1;
	ly2 = y1;
	lx = x2;
	ly = y2;
}

void draw(num x, num y)
{
	line(lx, ly, x, y);
}

void gprint_anchor(num xanc, num yanc)
{
	_xanc = xanc;
	_yanc = yanc;
}

int gprintf(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(vgprintf(format, ap)) rv = vgprintf(format, ap);
	va_end(ap);
	return rv;
}

int vgprintf(const char *format, va_list ap)
{
	buffer struct__b;
	buffer *b = &struct__b;
	(buffer_init(b, 128));
	int len = Vsprintf(b, format, ap);
	buffer_add_nul(b);
	gprint(b->start);
	buffer_free(b);
	return len;
}

void gsay(char *p)
{
	gprint(p);
	gnl();
}

int gsayf(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	typeof(vgsayf(format, ap)) rv = vgsayf(format, ap);
	va_end(ap);
	return rv;
}

int vgsayf(const char *format, va_list ap)
{
	int len = vgprintf(format, ap);
	gnl();
	return len;
}

void gnl(void)
{
	num dy = -font_height();
	if(_yflip)
	{
		dy = -dy;
	}
	move(text_origin_x, ly + dy);
	text_at_col0 = 1;
}

void text_origin(num x, num y)
{
	text_origin_x = x;
	text_origin_y = y;
}

void move_to_text_origin(void)
{
	move(text_origin_x, text_origin_y);
}

void bg(colour bg)
{
	bg_col = bg;
}

void Clear(colour c)
{
	bg(c);
	clear();
	gr_sync();
}

void pix_clear(colour c)
{
	bg(c);
	pix_t cp = colour_to_pix(c);
	if(depth > 16)
	{
		uint32_t *px = (((void *)(((char *)vid) + ((int)0*w + (int)0) * pixel_size_i)));
		typeof(((w*h))) (skip(1, `my__6162_)end) = ((w*h));
		typeof(0) (skip(1, `my__6167_)v1) = 0;
		for(; (skip(1, `my__6172_)v1)<(skip(1, `my__6174_)end); ++(skip(1, `my__6176_)v1))
		{
			typeof((skip(1, `my__6178_)v1)) ((skip(1, `my__6159_)i)) = (skip(1, `my__6178_)v1);
			(void)((skip(1, `my__6183_)i));
			*px++ = cp;
		}
	}
	else if(depth == 16)
	{
		uint16_t *px = (((void *)(((char *)vid) + ((int)0*w + (int)0) * pixel_size_i)));
		typeof(((w*h))) (skip(1, `my__6193_)end) = ((w*h));
		typeof(0) (skip(1, `my__6198_)v1) = 0;
		for(; (skip(1, `my__6203_)v1)<(skip(1, `my__6205_)end); ++(skip(1, `my__6207_)v1))
		{
			typeof((skip(1, `my__6209_)v1)) ((skip(1, `my__6190_)i)) = (skip(1, `my__6209_)v1);
			(void)((skip(1, `my__6214_)i));
			*px++ = cp;
		}
	}
	else if(depth == 8)
	{
		uint8_t *px = (((void *)(((char *)vid) + ((int)0*w + (int)0) * pixel_size_i)));
		typeof(((w*h))) (skip(1, `my__6224_)end) = ((w*h));
		typeof(0) (skip(1, `my__6229_)v1) = 0;
		for(; (skip(1, `my__6234_)v1)<(skip(1, `my__6236_)end); ++(skip(1, `my__6238_)v1))
		{
			typeof((skip(1, `my__6240_)v1)) ((skip(1, `my__6221_)i)) = (skip(1, `my__6240_)v1);
			(void)((skip(1, `my__6245_)i));
			*px++ = cp;
		}
	}
	else
	{
		error("unsupported video depth: %d", depth);
	}
}

void gr__change_hook(void)
{
	if(_autopaint)
	{
		paint();
	}
	if(_delay)
	{
		Rsleep(_delay);
	}
}

void paint(void)
{
	paint_sync(1);
}

void Paint(void)
{
	paint_sync(2);
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
	autopaint(1);
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
	typeof(360) (skip(1, `my__6251_)end) = 360;
	typeof(0) (skip(1, `my__6256_)v1) = 0;
	for(; (skip(1, `my__6261_)v1)<(skip(1, `my__6263_)end); ++(skip(1, `my__6265_)v1))
	{
		typeof((skip(1, `my__6267_)v1)) i = (skip(1, `my__6267_)v1);
		rb[i] = _rainbow(i * pi / 180.0);
	}
}

colour _rainbow(num a)
{
	num r = rb_red_power * (cos(a-rb_red_angle)+1)/2;
	num g = rb_green_power * (cos(a-rb_green_angle)+1)/2;
	num b = rb_blue_power * (cos(a-rb_blue_angle)+1)/2;
	return rgb(r, g, b);
}

void random_colour(void)
{
	rgb(rand(), rand(), rand());
}

colour _hsv(num hue, num sat, num val)
{
	num r = rb_red_power * (cos(hue-rb_red_angle)+1)/2;
	num g = rb_green_power * (cos(hue-rb_green_angle)+1)/2;
	num b = rb_blue_power * (cos(hue-rb_blue_angle)+1)/2;
	r *= sat;
	g *= sat;
	b *= sat;
	r = 1-(1-r)*(1-val);
	g = 1-(1-g)*(1-val);
	b = 1-(1-b)*(1-val);
	return rgb(r, g, b);
}

void curve(num x, num y)
{
	if(curve_at_start)
	{
		move(x, y);
		curve_at_start = 0;
	}
	else
	{
		draw(x, y);
	}
}

colour colour_rand(void)
{
	return rgb(((num)((long double)((long long int)random()*(((1UL<<31)))+random())/((unsigned long long int)(((1UL<<31)))*(((1UL<<31)))))), ((num)((long double)((long long int)random()*(((1UL<<31)))+random())/((unsigned long long int)(((1UL<<31)))*(((1UL<<31)))))), ((num)((long double)((long long int)random()*(((1UL<<31)))+random())/((unsigned long long int)(((1UL<<31)))*(((1UL<<31)))))));
}

void gr_at_exit(void)
{
	gr_exiting = 1;
	if(!die && !gr_done)
	{
		Paint();
		event_loop();
	}
	gr_free();
}

void gr_cleanup_sig_handler(int sig)
{
	warn("gr_cleanup_sig_handler: got signal %d, exiting", sig);
	gr_done_signal = sig;
	(Sigact(sig, (gr_cleanup_prev_handler[sig]), SA_RESTART|(sig == SIGCHLD ? SA_NOCLDSTOP : 0)));
	gr_done = 1;
	if(!gr_exiting)
	{
		exit(1);
	}
}

void gr_cleanup_catch_signals(void)
{
	typeof(SIGHUP) ((skip(1, `my__6306_)ary))[14];
	((skip(1, `my__6306_)ary))[0] = SIGHUP;
	((skip(1, `my__6306_)ary))[1] = SIGINT;
	((skip(1, `my__6306_)ary))[2] = SIGQUIT;
	((skip(1, `my__6306_)ary))[3] = SIGILL;
	((skip(1, `my__6306_)ary))[4] = SIGABRT;
	((skip(1, `my__6306_)ary))[5] = SIGFPE;
	((skip(1, `my__6306_)ary))[6] = SIGSEGV;
	((skip(1, `my__6306_)ary))[7] = SIGPIPE;
	((skip(1, `my__6306_)ary))[8] = SIGTERM;
	((skip(1, `my__6306_)ary))[9] = SIGBUS;
	((skip(1, `my__6306_)ary))[10] = SIGSYS;
	((skip(1, `my__6306_)ary))[11] = SIGTRAP;
	((skip(1, `my__6306_)ary))[12] = SIGXCPU;
	((skip(1, `my__6306_)ary))[13] = SIGXFSZ;
	typeof(&(((skip(1, `my__6311_)ary)))[sizeof(((skip(1, `my__6311_)ary)))/sizeof((((skip(1, `my__6311_)ary)))[0])]) (skip(1, `my__6317_)end) = &(((skip(1, `my__6311_)ary)))[sizeof(((skip(1, `my__6311_)ary)))/sizeof((((skip(1, `my__6311_)ary)))[0])];
	typeof(&(((skip(1, `my__6311_)ary)))[0]) (skip(1, `my__6322_)i1) = &(((skip(1, `my__6311_)ary)))[0];
	for(; (skip(1, `my__6327_)i1)<(skip(1, `my__6329_)end) ; ++(skip(1, `my__6331_)i1))
	{
		typeof((skip(1, `my__6333_)i1)) ((skip(1, `my__6314_)i)) = (skip(1, `my__6333_)i1);
		typeof(*(skip(1, `my__6338_)i)) sig = *(skip(1, `my__6338_)i);
		
		
		gr_cleanup_prev_handler[sig] = (Sigact(sig, gr_cleanup_sig_handler, SA_RESTART|(sig == SIGCHLD ? SA_NOCLDSTOP : 0)));
	}
}

void font(cstr name, int size)
{
	typeof(format("-*-%s-r-normal--%d-*-100-100-p-*-iso8859-1", name, size)) xfontname = format("-*-%s-r-normal--%d-*-100-100-p-*-iso8859-1", name, size);
	xfont(xfontname);
	((free(xfontname)), xfontname = NULL);
}

void gr_init(void)
{
	gr_alloced = 1;
	Atexit(gr_at_exit);
	gr_cleanup_catch_signals();
	if((display = XOpenDisplay(NULL)) == NULL)
	{
		error("cannot open display");
	}
	x11_fd = ConnectionNumber(display);
	screen_number = DefaultScreen(display);
	visual = DefaultVisual(display, screen_number);
	int nitems_return;
	XVisualInfo vinfo_template;
	vinfo_template.visualid = XVisualIDFromVisual(visual);
	visual_info = XGetVisualInfo(display, VisualIDMask, &vinfo_template, &nitems_return);
	if(visual_info == NULL || nitems_return != 1)
	{
		failed("XGetVisualInfo");
	}
	depth = DefaultDepth(display, screen_number);
	white = WhitePixel(display, screen_number);
	black = BlackPixel(display, screen_number);
	colormap = DefaultColormap(display, screen_number);
	pixel_size = depth / 8.0;
	if(pixel_size == 3)
	{
		pixel_size = 4;
	}
	pixel_size_i = (int)pixel_size;
	gc = DefaultGC(display, screen_number);
	gcvalues.function = GXcopy;
	gcvalues.foreground = white;
	gcvalues.cap_style = CapNotLast;
	gcvalues.line_width = _line_width;
	XChangeGC(display, gc, GCFunction|GCForeground|GCCapStyle|GCLineWidth, &gcvalues);
	root_window = DefaultRootWindow(display);
	colours_init();
	font("helvetica-medium", 12);
	XWindowAttributes window_attributes;
	if(XGetWindowAttributes(display, root_window, &window_attributes))
	{
		root_w = window_attributes.width;
		root_h = window_attributes.height;
	}
	rainbow_init();
	event_handler_init();
}

void _paper(int width, int height, colour _bg_col, colour _fg_col)
{
	cstr geom = Getenv("GEOM", NULL);
	if(geom && *geom)
	{
		cstr delim = geom+strspn(geom, "0123456789");
		if(!*delim || !delim[1] || delim == geom)
		{
			error("invalid GEOM %s", geom);
		}
		w = atoi(geom);
		h = atoi(delim+1);
	}
	else if(!width || (geom && !*geom))
	{
		gr_fullscreen();
	}
	else
	{
		w = width;
		h = height;
	}
	bg_col_init = bg_col = _bg_col;
	fg_col = _fg_col;
	w_2 = w/2;
	h_2 = h/2;
	ox = oy = 0;
	sc = 1;
	text_origin(-w_2, h_2);
	text_wrap_sx = w;
	unsigned long valuemask = 0;
	XSetWindowAttributes attributes;
	if(!_deco)
	{
		valuemask |= CWOverrideRedirect;
		attributes.override_redirect = True;
	}
	window = XCreateWindow(display, root_window, 0, 0, w, h, 0, CopyFromParent, InputOutput, CopyFromParent, valuemask, &attributes);
	if(atoi(Getenv("MITSHM", "1")))
	{
		shm_version = XShmQueryVersion(display, &shm_major, &shm_minor, &shm_pixmaps);
	}
	else
	{
		shm_version = 0;
		shm_pixmaps = 0;
	}
	if(shm_version)
	{
		
		shmseginfo = (((XShmSegmentInfo *)(normal_Malloc(1 * sizeof(XShmSegmentInfo)))));
		(bzero(shmseginfo, sizeof(*shmseginfo)));
		shmseginfo->shmid = shmget(IPC_PRIVATE, w * h * pixel_size, IPC_CREAT|0777);
		if(shmseginfo->shmid < 0)
		{
			failed("shmget");
		}
		shmseginfo->shmaddr = shmat(shmseginfo->shmid, NULL, 0);
		vid = (char *)shmseginfo->shmaddr;
		if(!vid)
		{
			failed("shmat");
		}
		shmseginfo->readOnly = False;
		gr__x_error_handler *old_h = XSetErrorHandler(gr__mitshm_fault_h);
		int attach_ok = XShmAttach(display, shmseginfo);
		gr_sync();
		if(!(attach_ok && shm_version))
		{
			shm_version = 0;
			shm_pixmaps = 0;
			vid = NULL;
			if(shmseginfo)
			{
				free_shmseg();
			}
		}
		XSetErrorHandler(old_h);
	}
	else
	{
		
	}
	if(shm_pixmaps && XShmPixmapFormat(display) == ZPixmap)
	{
		gr_buf = XShmCreatePixmap(display, window, vid, shmseginfo, w, h, depth);
		
	}
	else if(shm_version)
	{
		gr_buf_image = XShmCreateImage(display, visual, depth, ZPixmap, vid, shmseginfo, w, h);
		
	}
	else
	{
		vid = (normal_Malloc(w*h*pixel_size_i));
		gr_buf_image = XCreateImage(display, visual, depth, ZPixmap, 0, vid, w, h, BitmapPad(display), 0);
		
	}
	if(gr_buf_image)
	{
		if(1 && !((w*h*pixel_size == gr_buf_image->bytes_per_line * gr_buf_image->height)))
		{
			fault_(__FILE__, __LINE__, "XShmCreateImage returned a strangely sized image");
		}
	}
	else if(!shm_pixmaps)
	{
		failed("XCreateImage");
	}
	if(!shm_pixmaps)
	{
		gr_buf = XCreatePixmap(display, window, w, h, depth);
		
	}
	XSizeHints *normal_hints;
	XWMHints *wm_hints;
	XClassHint  *class_hints;
	normal_hints = XAllocSizeHints();
	wm_hints = XAllocWMHints();
	class_hints = XAllocClassHint();
	normal_hints->flags = PPosition | PSize;
	wm_hints->initial_state = NormalState;
	wm_hints->input = True;
	wm_hints->flags = StateHint | InputHint;
	class_hints->res_name = program;
	class_hints->res_class = program;
	XTextProperty xtp_name;
	XStringListToTextProperty(&program, 1, &xtp_name);
	XSetWMProperties(display, window, &xtp_name, &xtp_name, argv, argc, normal_hints, wm_hints, class_hints);
	wm_protocols = XInternAtom(display, "WM_PROTOCOLS", False);
	wm_delete = XInternAtom(display, "WM_DELETE_WINDOW", False);
	XSetWMProtocols(display, window, &wm_delete, 1);
	XSelectInput(display, window, ExposureMask|ButtonPressMask|ButtonReleaseMask|ButtonMotionMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask);
	XMapWindow(display, window);
	if(fullscreen && fullscreen_grab_keyboard)
	{
		XGrabKeyboard(display, window, True, GrabModeAsync, GrabModeAsync, CurrentTime);
	}
	if(use_vid)
	{
		vid_init();
	}
	col(fg_col);
	clear();
	if(gr_buf_image)
	{
		(pix_clear(bg_col));
	}
	gr_done = 0;
	Paint();
}

int gr__mitshm_fault_h(Display *d, XErrorEvent *e)
{
	
	if(d == display && e->error_code == BadAccess && e->request_code == 139 /* MIT-SHM */ && e->minor_code == 1)
	{
		
		shm_version = 0;
	}
	return 0;
}

void gr_free(void)
{
	if(gr_done_signal)
	{
		if(shmseginfo)
		{
			free_shmseg();
			shmseginfo = NULL;
		}
		kill(getpid(), gr_done_signal);
		return;
	}
	if(gr_alloced)
	{
		if(fullscreen && fullscreen_grab_keyboard)
		{
			XUngrabKeyboard(display, CurrentTime);
		}
		if(visual_info)
		{
			XFree(visual_info);
		}
		if(shmseginfo)
		{
			XShmDetach(display, shmseginfo);
		}
		if(gr_buf)
		{
			XFreePixmap(display, gr_buf);
		}
		if(gr_buf_image)
		{
			XDestroyImage(gr_buf_image);
		}
		if(shmseginfo)
		{
			free_shmseg();
		}
		if(window)
		{
			XDestroyWindow(display, window);
		}
		if(display)
		{
			XCloseDisplay(display);
		}
		gr_alloced = 0;
	}
}

void free_shmseg(void)
{
	shmdt(shmseginfo->shmaddr);
	shmctl(shmseginfo->shmid, IPC_RMID, NULL);
	((free(shmseginfo)), shmseginfo = NULL);
}

void xfont(const char *font_name)
{
	if((_font = XLoadQueryFont(display, font_name)) == NULL)
	{
		warn("cannot load font %s", font_name);
		return;
	}
	gcvalues.font = _font->fid;
	XChangeGC(display, gc, GCFont, &gcvalues);
}

colour rgb(num red, num green, num blue)
{
	colour c;
	int r = iclamp(red*256, 0, 255);
	int g = iclamp(green*256, 0, 255);
	int b = iclamp(blue*256, 0, 255);
	if(depth >= 24)
	{
		c = r<<16 | g<<8 | b;
		col(c);
	}
	else
	{
		char name[8];
		snprintf(name, sizeof(name), "#%02x%02x%02x", r, g, b);
		c = coln(name);
	}
	return c;
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
	int w = (((int)((((width*sc)))+0.5)));
	gcvalues.line_width = w;
	XChangeGC(display, gc, GCLineWidth, &gcvalues);
}

void rect(num x, num y, num w, num h)
{
	move(x, y);
	draw(x+w-1, y);
	draw(x+w-1, y+h-1);
	draw(x, y+h-1);
	draw(x, y);
}

void rect_fill(num x, num y, num w, num h)
{
	int X, Y, W, H;
	X = (((int)((((w_2+((_xflip ? -((((x-ox))*sc))-1 : ((((x-ox))*sc)))))))+0.5)));
	Y = (((int)((((h_2-1-((_yflip ? -((((y-oy))*sc))-1 : ((((y-oy))*sc)))))))+0.5)));
	W = (((int)((((w*sc)))+0.5)));
	H = (((int)((((h*sc)))+0.5)));
	if(!_yflip)
	{
		Y -= H;
	}
	XFillRectangle(display, gr_buf, gc, X, Y, W, H);
	gr__change_hook();
}

void line(num x0, num y0, num x1, num y1)
{
	XDrawLine(display, gr_buf, gc, (((int)((((w_2+((_xflip ? -((((x0-ox))*sc))-1 : ((((x0-ox))*sc)))))))+0.5))), (((int)((((h_2-1-((_yflip ? -((((y0-oy))*sc))-1 : ((((y0-oy))*sc)))))))+0.5))), (((int)((((w_2+((_xflip ? -((((x1-ox))*sc))-1 : ((((x1-ox))*sc)))))))+0.5))), (((int)((((h_2-1-((_yflip ? -((((y1-oy))*sc))-1 : ((((y1-oy))*sc)))))))+0.5))));
	move(x1, y1);
	gr__change_hook();
}

void point(num x, num y)
{
	XDrawPoint(display, gr_buf, gc, (((int)((((w_2+((_xflip ? -((((x-ox))*sc))-1 : ((((x-ox))*sc)))))))+0.5))), (((int)((((h_2-1-((_yflip ? -((((y-oy))*sc))-1 : ((((y-oy))*sc)))))))+0.5))));
	gr__change_hook();
}

void circle(num x, num y, num r)
{
	int x0, y0, x1, y1, w, h, tmp;
	x0 = (((int)((((w_2+((_xflip ? -(((((x-r)-ox))*sc))-1 : (((((x-r)-ox))*sc)))))))+0.5)));
	y0 = (((int)((((h_2-1-((_yflip ? -(((((y-r)-oy))*sc))-1 : (((((y-r)-oy))*sc)))))))+0.5)));
	x1 = (((int)((((w_2+((_xflip ? -(((((x+r)-ox))*sc))-1 : (((((x+r)-ox))*sc)))))))+0.5)));
	y1 = (((int)((((h_2-1-((_yflip ? -(((((y+r)-oy))*sc))-1 : (((((y+r)-oy))*sc)))))))+0.5)));
	if((x1 < x0))
	{
		tmp = x0;
		x0 = x1;
		x1 = tmp;
	}
	if((y1 < y0))
	{
		tmp = y0;
		y0 = y1;
		y1 = tmp;
	}
	w = x1 - x0;
	h = y1 - y0;
	if(w == 0)
	{
		XDrawPoint(display, gr_buf, gc, x0, y0);
	}
	else
	{
		XDrawArc(display, gr_buf, gc, x0, y0, w, h, 0, 64*360);
	}
	gr__change_hook();
}

void circle_fill(num x, num y, num r)
{
	int old_width = _line_width;
	line_width(0);
	int x0, y0, x1, y1, w, h, tmp;
	x0 = (((int)((((w_2+((_xflip ? -(((((x-r)-ox))*sc))-1 : (((((x-r)-ox))*sc)))))))+0.5)));
	y0 = (((int)((((h_2-1-((_yflip ? -(((((y-r)-oy))*sc))-1 : (((((y-r)-oy))*sc)))))))+0.5)));
	x1 = (((int)((((w_2+((_xflip ? -(((((x+r)-ox))*sc))-1 : (((((x+r)-ox))*sc)))))))+0.5)));
	y1 = (((int)((((h_2-1-((_yflip ? -(((((y+r)-oy))*sc))-1 : (((((y+r)-oy))*sc)))))))+0.5)));
	if((x1 < x0))
	{
		tmp = x0;
		x0 = x1;
		x1 = tmp;
	}
	if((y1 < y0))
	{
		tmp = y0;
		y0 = y1;
		y1 = tmp;
	}
	w = x1 - x0;
	h = y1 - y0;
	if(w == 0)
	{
		XDrawPoint(display, gr_buf, gc, x0, y0);
	}
	else
	{
		XFillArc(display, gr_buf, gc, x0, y0, w, h, 0, 64*360);
		XDrawArc(display, gr_buf, gc, x0, y0, w, h, 0, 64*360);
	}
	gr__change_hook();
	line_width(old_width);
}

void polygon_start(struct polygon *p, int n_points_estimate)
{
	p->points = (normal_Malloc(n_points_estimate * sizeof(XPoint)));
	p->n_points = 0;
	p->space = n_points_estimate;
}

void _polygon_point(struct polygon *p, short x, short y)
{
	if(p->n_points == p->space)
	{
		p->space = p->n_points * 2;
		((p->points) = normal_Realloc((p->points), (p->space * sizeof(XPoint))));
	}
	XPoint *point = p->points + p->n_points;
	point->x = x;
	point->y = y;
	++p->n_points;
}

void polygon_point(struct polygon *p, num x, num y)
{
	_polygon_point(p, (((int)((((w_2+((_xflip ? -((((x-ox))*sc))-1 : ((((x-ox))*sc)))))))+0.5))), (((int)((((h_2-1-((_yflip ? -((((y-oy))*sc))-1 : ((((y-oy))*sc)))))))+0.5))));
}

void polygon_draw(struct polygon *p)
{
	XPoint *first_point = p->points;
	_polygon_point(p, first_point->x, first_point->y);
	XDrawLines(display, gr_buf, gc, p->points, p->n_points, CoordModeOrigin);
	--(p->n_points);
	gr__change_hook();
}

void polygon_fill(struct polygon *p)
{
	XFillPolygon(display, gr_buf, gc, p->points, p->n_points, Complex, CoordModeOrigin);
	XDrawPoint(display, gr_buf, gc, p->points->x, p->points->y);
	gr__change_hook();
}

void polygon_end(struct polygon *p)
{
	((free(p->points)), (p->points) = NULL);
}

num text_width(char *p)
{
	int tabs_width = 0;
	while(*p == '\t')
	{
		tabs_width += gprint_tab_width * font_height();
		++p;
	}
	int len = strlen(p);
	return tabs_width + isd(XTextWidth(_font, p, len));
}

void gprint(char *p)
{
	while(*p == '\t')
	{
		lx += gprint_tab_width * font_height();
		++p;
	}
	int len = strlen(p);
	int text_width = XTextWidth(_font, p, len);
	XDrawString(display, gr_buf, gc, (int)((((int)((((w_2+((_xflip ? -((((lx-ox))*sc))-1 : ((((lx-ox))*sc)))))))+0.5)))-text_width*(_xanc+1)/2.0+1), (int)((((int)((((h_2-1-((_yflip ? -((((ly-oy))*sc))-1 : ((((ly-oy))*sc)))))))+0.5)))+_font->ascent*(_yanc+1)/2.0+0.5), p, len);
	move(lx + text_width, ly);
	gr__change_hook();
}

num font_height(void)
{
	return isd(_font->ascent + _font->descent);
}

void paint_sync(int syncage)
{
	if(shm_pixmaps || !use_vid)
	{
		
		XCopyArea(display, gr_buf, window, gc, 0, 0, w, h, 0, 0);
	}
	else if(shm_version)
	{
		
		XShmPutImage(display, window, gc, gr_buf_image, 0, 0, 0, 0, w, h, False);
	}
	else
	{
		
		XPutImage(display, window, gc, gr_buf_image, 0, 0, 0, 0, w, h);
	}
	switch(syncage)
	{
	case 2:	gr_sync();
		break;
	case 1:	XFlush(display);
	}
	if(paint_handle_events || ((gr_need_delay_callbacks->size)))
	{
		handle_events(0);
	}
}

void gr_sync(void)
{
	XSync(display, False);
}

void gr_flush(void)
{
	XFlush(display);
}

void clear(void)
{
	colour fg = fg_col;
	col(bg_col);
	XFillRectangle(display, gr_buf, gc, 0, 0, w, h);
	col(fg);
	gr__change_hook();
}

void triangle(num x2, num y2)
{
	XPoint p[3];
	(p[0]).x = (((int)((((w_2+((_xflip ? -((((lx2-ox))*sc))-1 : ((((lx2-ox))*sc)))))))+0.5)));
	(p[0]).y = (((int)((((h_2-1-((_yflip ? -((((ly2-oy))*sc))-1 : ((((ly2-oy))*sc)))))))+0.5)));
	(p[1]).x = (((int)((((w_2+((_xflip ? -((((lx-ox))*sc))-1 : ((((lx-ox))*sc)))))))+0.5)));
	(p[1]).y = (((int)((((h_2-1-((_yflip ? -((((ly-oy))*sc))-1 : ((((ly-oy))*sc)))))))+0.5)));
	(p[2]).x = (((int)((((w_2+((_xflip ? -((((x2-ox))*sc))-1 : ((((x2-ox))*sc)))))))+0.5)));
	(p[2]).y = (((int)((((h_2-1-((_yflip ? -((((y2-oy))*sc))-1 : ((((y2-oy))*sc)))))))+0.5)));
	XFillPolygon(display, gr_buf, gc, p, 3, Convex, CoordModeOrigin);
	move2(lx, ly, x2, y2);
}

void quadrilateral(num x2, num y2, num x3, num y3)
{
	XPoint p[4];
	(p[0]).x = (((int)((((w_2+((_xflip ? -((((lx2-ox))*sc))-1 : ((((lx2-ox))*sc)))))))+0.5)));
	(p[0]).y = (((int)((((h_2-1-((_yflip ? -((((ly2-oy))*sc))-1 : ((((ly2-oy))*sc)))))))+0.5)));
	(p[1]).x = (((int)((((w_2+((_xflip ? -((((lx-ox))*sc))-1 : ((((lx-ox))*sc)))))))+0.5)));
	(p[1]).y = (((int)((((h_2-1-((_yflip ? -((((ly-oy))*sc))-1 : ((((ly-oy))*sc)))))))+0.5)));
	(p[2]).x = (((int)((((w_2+((_xflip ? -((((x2-ox))*sc))-1 : ((((x2-ox))*sc)))))))+0.5)));
	(p[2]).y = (((int)((((h_2-1-((_yflip ? -((((y2-oy))*sc))-1 : ((((y2-oy))*sc)))))))+0.5)));
	(p[3]).x = (((int)((((w_2+((_xflip ? -((((x3-ox))*sc))-1 : ((((x3-ox))*sc)))))))+0.5)));
	(p[3]).y = (((int)((((h_2-1-((_yflip ? -((((y3-oy))*sc))-1 : ((((y3-oy))*sc)))))))+0.5)));
	XFillPolygon(display, gr_buf, gc, p, 4, Convex, CoordModeOrigin);
	move2(x2, y2, x3, y3);
}

void dump_img(cstr type, cstr file, num scale)
{
	cstr file_out = "";
	cstr scale_filter = "";
	cstr tool;
	if(cstr_eq(type, "png"))
	{
		tool = "pnmtopng";
	}
	else if(cstr_eq(type, "gif"))
	{
		tool = "ppmquant 256 | ppmtogif";
	}
	else if(cstr_eq(type, "jpeg"))
	{
		tool = "pnmtojpeg";
	}
	else
	{
		error("dump_img: unsupported image type: %s", type);
		return;
	}
	if(file)
	{
		buffer struct__b;
		buffer *b = &struct__b;
		buffer_init(b, 256);
		sh_quote(file, b);
		cstr file_q = buffer_to_cstr(b);
		file_out = format("> %s", file_q);
		((free(file_q)), file_q = NULL);
	}
	if(scale != 1)
	{
		scale_filter = format("pnmscale %f |", scale);
	}
	Systemf("exec 2>/dev/null; " "xwd -id %ld | xwdtopnm | %s %s %s", window, scale_filter, tool, file_out);
	if(file)
	{
		((free(file_out)), file_out = NULL);
	}
	if(scale != 1)
	{
		((free(scale_filter)), scale_filter = NULL);
	}
}

void gr_do_delay(num dt)
{
	gr_do_delay_done = 0;
	thunk old_handler = key_handler_default;
	key_handler_default = ((thunk){ gr_do_delay_handler, NULL, NULL });
	if(dt == (-1e100))
	{
		while(!gr_do_delay_done)
		{
			handle_events(1);
		}
	}
	else
	{
		num t = rtime();
		num t1 = t + dt;
		while(t < t1 && !gr_do_delay_done)
		{
			if(events_queued(0) || ((gr_need_delay_callbacks->size)) || can_read(x11_fd, t1-t))
			{
				handle_events(0);
			}
			t = rtime();
		}
	}
	key_handler_default = old_handler;
}

void *gr_do_delay_handler(void *obj, void *a0, void *event)
{
	(void)obj;
	(void)a0;
	gr_event *e = event;
	if(e->type == KeyPress)
	{
		gr_do_delay_done = 1;
	}
	return (((void*)(intptr_t)1));
}

void vid_init(void)
{
	if(!screen)
	{
		
		use_vid = 1;
		screen = &struct__screen;
		sprite_screen(screen);
	}
}

void sprite_screen(sprite *s)
{
	s->width = w;
	s->height = h;
	s->stride = w;
	s->pixels = (pix_t *)(((screen ? 0 : (vid_init(),0)), ((void *)(((char *)vid) + ((int)0*w + (int)0) * pixel_size_i))));
}

void control_init(void)
{
	control_null = (controller){ ((thunk){ thunk_void, NULL, NULL }), ((thunk){ thunk_void, NULL, NULL }) };
	control_normal = (controller){ ((thunk){ key_handler_main, NULL, NULL }), ((thunk){ mouse_handler_main, NULL, NULL }) };
	key_handlers_init();
	mouse_handlers_init();
}

void control_default(void)
{
	key_handlers_default();
	mouse_handlers_default();
}

void control_ignore(void)
{
	key_handlers_ignore();
	mouse_handlers_ignore();
}

void event_handler_init(void)
{
	vec_init_el_size(gr_need_delay_callbacks, sizeof(gr_event_callback), (4));
	control_init();
}

void event_loop(void)
{
	while(!gr_done)
	{
		handle_events(1);
	}
}

int handle_events(boolean wait_for_event)
{
	int n = gr_call_need_delay_callbacks();
	while(!gr_done && handle_event_maybe(wait_for_event))
	{
		++n;
		wait_for_event = 0;
	}
	return n;
}

boolean handle_event_maybe(boolean wait_for_event)
{
	int n = events_queued(wait_for_event);
	if(n)
	{
		handle_event();
	}
	else
	{
		gr_flush();
	}
	return n;
}

int gr_call_need_delay_callbacks(void)
{
	int n = 0;
	size_t old_size = ((gr_need_delay_callbacks->size));
	vec *(skip(1, `my__6818_)v1) = gr_need_delay_callbacks;
	gr_event_callback *(skip(1, `my__6820_)end) = ((vec_element(((skip(1, `my__6822_)v1)), ((skip(1, `my__6822_)v1))->size)));
	gr_event_callback *(skip(1, `my__6826_)i1) = ((vec_element(((skip(1, `my__6828_)v1)), 0)));
	for(; (skip(1, `my__6832_)i1)!=(skip(1, `my__6834_)end) ; ++(skip(1, `my__6836_)i1))
	{
		typeof((skip(1, `my__6838_)i1)) i = (skip(1, `my__6838_)i1);
		
		if(((*(&i->t)->func)((&i->t)->obj, (&i->t)->common_arg, (&i->e))))
		{
			++n;
		}
	}
	((vec_splice(gr_need_delay_callbacks, 0, old_size, NULL, 0)));
	return n;
}

int gr_getc(void)
{
	gr_getc_char = -1;
	thunk old_handler = key_handler_default;
	key_handler_default = ((thunk){ gr_getc_handler, NULL, NULL });
	while(gr_getc_char < 0)
	{
		handle_events(1);
	}
	key_handler_default = old_handler;
	return gr_getc_char;
}

void *gr_getc_handler(void *obj, void *a0, void *event)
{
	(void)obj;
	(void)a0;
	gr_event *e = event;
	if(e->type == KeyPress)
	{
		gr_getc_char = e->which;
	}
	return (((void*)(intptr_t)1));
}

void key_handlers_init(void)
{
	XDisplayKeycodes(display, &key_first, &key_last);
	key_first = 0;
	key_last = 255;
	key_handlers = (void*)((thunk *)(normal_Malloc(((key_last-key_first+1)*2) * sizeof(thunk))));
	key_down = ((char *)(normal_Calloc((((key_last-key_first+1))), (sizeof(char)))));
	key_handlers_default();
}

void key_handlers_default(void)
{
	key_handlers_ignore();
	typeof(&quit_key[0]) ((skip(1, `my__6862_)i)) = &quit_key[0];
	for(; *((skip(1, `my__6862_)i)) ; ++((skip(1, `my__6862_)i)))
	{
		
		typeof(*(skip(1, `my__6868_)i)) key = *(skip(1, `my__6868_)i);
		
		(key_handlers[keystr_ix(key)][key_event_type_ix(KeyPress)]) = ((thunk){ quit, NULL, NULL });
	}
}

void key_handlers_ignore(void)
{
	typeof(((key_last-key_first+1))) (skip(1, `my__6877_)end) = ((key_last-key_first+1));
	typeof(0) (skip(1, `my__6882_)v1) = 0;
	for(; (skip(1, `my__6887_)v1)<(skip(1, `my__6889_)end); ++(skip(1, `my__6891_)v1))
	{
		typeof((skip(1, `my__6893_)v1)) i = (skip(1, `my__6893_)v1);
		typeof(2) (skip(1, `my__6900_)end) = 2;
		typeof(0) (skip(1, `my__6905_)v1) = 0;
		for(; (skip(1, `my__6910_)v1)<(skip(1, `my__6912_)end); ++(skip(1, `my__6914_)v1))
		{
			typeof((skip(1, `my__6916_)v1)) j = (skip(1, `my__6916_)v1);
			key_handlers[i][j] = ((thunk){ thunk_void, NULL, NULL });
		}
	}
	key_handler_default = ((thunk){ thunk_void, NULL, NULL });
}

void *quit(void *obj, void *a0, void *event)
{
	(void)obj;
	(void)a0;
	(void)event;
	gr_done = 1;
	if(!gr_exiting)
	{
		exit(0);
	}
	return (((void*)(intptr_t)1));
}

int keystr_ix(cstr keystr)
{
	return XKeysymToKeycode(display, XStringToKeysym(keystr)) - key_first;
}

int keysym_ix(KeySym keysym)
{
	return XKeysymToKeycode(display, keysym) - key_first;
}

int key_event_type_ix(int event_type)
{
	switch(event_type)
	{
	case KeyPress:	event_type = 0;
		break;
	case KeyRelease:	event_type = 1;
		break;
	default:	error("unknown key event type: %d = %s", event_type, event_type_name(event_type));
	}
	return event_type;
}

void *key_handler_main(void *obj, void *a0, void *event)
{
	(void)obj;
	(void)a0;
	int is_callback = ((intptr_t)a0);
	(void)is_callback;
	gr_event *e = event;
	boolean ignore = 0;
	int event_type = 0;
	switch(e->type)
	{
	case KeyPress:	;
		event_type = 0;
		ignore = gr_key_avoid_auto_repeat_press(e);
		if(!ignore && key_down[e->which-key_first])
		{
			key_event_debug("ignoring %s - key already down: %s", e);
			ignore = 1;
		}
		if(!ignore)
		{
			key_down[e->which-key_first] = 1;
		}
		break;
	case KeyRelease:	;
		event_type = 1;
		if(!key_down[e->which-key_first])
		{
			key_event_debug("ignoring %s - key not down: %s", e);
			ignore = 1;
		}
		ignore = gr_key_avoid_auto_repeat_release(e, is_callback);
		if(!ignore)
		{
			key_down[e->which-key_first] = 0;
		}
		if(gr_key_ignore_release)
		{
			ignore = 1;
		}
	}
	if(!ignore && XKeycodeToKeysym(display, e->which, e->state & ShiftMask && 1) == NoSymbol)
	{
		ignore = 1;
	}
	if(ignore)
	{
		return (((void*)(intptr_t)1));
	}
	thunk *handler = &key_handlers[e->which-key_first][event_type];
	void *rv = ((*handler->func)(handler->obj, handler->common_arg, e));
	if(!rv)
	{
		rv = ((*(&key_handler_default)->func)((&key_handler_default)->obj, (&key_handler_default)->common_arg, e));
	}
	if(!rv)
	{
		key_event_debug("unhandled %s: %s", e);
	}
	return rv;
}

cstr event_key_string(gr_event *e)
{
	int shift = e->state & ShiftMask && 1;
	return key_string(e->which, shift);
}

void key_event_debug(cstr format, gr_event *e)
{
	(void)format;
	cstr key_string = event_key_string(e);
	if(key_string != NULL)
	{
		
	}
}

cstr key_string(int keycode, boolean shift)
{
	return XKeysymToString(XKeycodeToKeysym(display, keycode, shift));
}

void mouse_handlers_init(void)
{
	mouse_handlers_default();
}

void mouse_handlers_default(void)
{
	mouse_handlers_ignore();
}

void mouse_handlers_ignore(void)
{
	typeof(((3-1+1))) (skip(1, `my__6947_)end) = ((3-1+1));
	typeof(0) (skip(1, `my__6952_)v1) = 0;
	for(; (skip(1, `my__6957_)v1)<(skip(1, `my__6959_)end); ++(skip(1, `my__6961_)v1))
	{
		typeof((skip(1, `my__6963_)v1)) i = (skip(1, `my__6963_)v1);
		typeof(3) (skip(1, `my__6970_)end) = 3;
		typeof(0) (skip(1, `my__6975_)v1) = 0;
		for(; (skip(1, `my__6980_)v1)<(skip(1, `my__6982_)end); ++(skip(1, `my__6984_)v1))
		{
			typeof((skip(1, `my__6986_)v1)) j = (skip(1, `my__6986_)v1);
			mouse_handlers[i][j] = ((thunk){ thunk_void, NULL, NULL });
		}
	}
	mouse_handler_default = ((thunk){ thunk_void, NULL, NULL });
}

int mouse_event_type_ix(int event_type)
{
	switch(event_type)
	{
	case ButtonPress:	event_type = 0;
		break;
	case ButtonRelease:	event_type = 1;
		break;
	case MotionNotify:	event_type = 2;
		break;
	default:	error("unknown mouse event type: %d = %s", event_type, event_type_name(event_type));
	}
	return event_type;
}

void *mouse_handler_main(void *obj, void *a0, void *event)
{
	(void)obj;
	(void)a0;
	static int button = 0;
	gr_event *e = event;
	boolean ok = 0;
	int event_type = 0;
	switch(e->type)
	{
	case ButtonPress:	;
		event_type = 0;
		if(button != 0)
		{
			
			button = 0;
		}
		else
		{
			button = e->which;
			ok = 1;
		}
		break;
	case ButtonRelease:	;
		event_type = 1;
		if(button == 0)
		{
			
		}
		else if(e->which != button)
		{
			
		}
		else
		{
			ok = 1;
		}
		button = 0;
		break;
	case MotionNotify:	;
		event_type = 2;
		if(button == 0)
		{
			
		}
		else
		{
			e->which = button;
			ok = 1;
		}
	}
	if(ok && e->type != MotionNotify && !((e->which) >= 1 && (e->which) <= 3))
	{
		
		return (((void*)(intptr_t)0));
	}
	if(ok)
	{
		thunk *handler = &mouse_handlers[e->which-1][event_type];
		void *rv = ((*handler->func)(handler->obj, handler->common_arg, e));
		if(!rv)
		{
			rv = ((*(&mouse_handler_default)->func)((&mouse_handler_default)->obj, (&mouse_handler_default)->common_arg, e));
		}
		if(!rv)
		{
			
		}
		return rv;
	}
	return (((void*)(intptr_t)1));
}

cstr event_type_name(int type)
{
	typeof(&event_type_names[sizeof(event_type_names)/sizeof(event_type_names[0])]) (skip(1, `my__7024_)end) = &event_type_names[sizeof(event_type_names)/sizeof(event_type_names[0])];
	typeof(&event_type_names[0]) (skip(1, `my__7029_)i1) = &event_type_names[0];
	for(; (skip(1, `my__7034_)i1)<(skip(1, `my__7036_)end) ; ++(skip(1, `my__7038_)i1))
	{
		typeof((skip(1, `my__7040_)i1)) i = (skip(1, `my__7040_)i1);
		if(i->k == type)
		{
			return i->v;
		}
	}
	return NULL;
}

int events_queued(boolean wait_for_event)
{
	int n = XEventsQueued(display, QueuedAlready);
	if(!n)
	{
		num timeout = wait_for_event && !((gr_need_delay_callbacks->size)) ? (-1e100) : 0;
		gr_flush();
		if(can_read(x11_fd, timeout))
		{
			n = XEventsQueued(display, QueuedAfterReading);
		}
	}
	return n;
}

void handle_event(void)
{
	XNextEvent(display, &x_event);
	switch(x_event.type)
	{
	case ClientMessage:	;
		if(x_event.xclient.message_type == wm_protocols && x_event.xclient.format == 32 && (Atom)x_event.xclient.data.l[0] == wm_delete)
		{
			quit(NULL, NULL, &x_event);
		}
		else
		{
			
		}
		break;
	case ConfigureNotify:	;
		while(XCheckTypedEvent(display, ConfigureNotify, &x_event))
		{
			
		}
		configure_notify();
		break;
	case Expose:	;
	case GraphicsExpose:	;
		if(x_event.xexpose.count == 0)
		{
			paint();
		}
		break;
	case NoExpose:	;
		break;
	case MapNotify:	;
		break;
	case UnmapNotify:	;
		break;
	case ReparentNotify:	;
		break;
	case KeyPress:	;
	case KeyRelease:	
		{
			gr_event e =
			{
				x_event.type, x_event.xkey.keycode, -1, -1,
				x_event.xkey.state, x_event.xkey.time
			};
			((*(&control->keyboard)->func)((&control->keyboard)->obj, (&control->keyboard)->common_arg, (&e)));
		}
		break;
	case MotionNotify:	;
		while(XCheckTypedEvent(display, MotionNotify, &x_event))
		{
			
		}
	case ButtonPress:	;
	case ButtonRelease:	
		{
			gr_event e =
			{
				x_event.type, x_event.xbutton.button,
				x_event.xbutton.x, x_event.xbutton.y,
				x_event.xbutton.state, x_event.xkey.time
			};
			((*(&control->mouse)->func)((&control->mouse)->obj, (&control->mouse)->common_arg, (&e)));
		}
		break;
	default:	;
		
	}
}

boolean gr_key_avoid_auto_repeat_press(gr_event *e)
{
	boolean ignore = gr_key_auto_repeat == 0 && 1.99 && gr_key_last_release_key == e->which &&  e->time - gr_key_last_release_time <= (int)1.99;
	gr_key_last_release_key = -1;
	return ignore;
}

boolean gr_key_avoid_auto_repeat_release(gr_event *e, boolean is_callback)
{
	boolean push_callback = 0;
	boolean ignore = 0;
	if(gr_key_auto_repeat == 0 && 1.99)
	{
		if(is_callback)
		{
			if(gr_key_last_release_key == -1)
			{
				ignore = 1;
			}
			else if(rtime()-gr_key_last_release_time_real <= 1.99/1000.0)
			{
				push_callback = 1;
			}
		}
		else
		{
			push_callback = 1;
		}
		if(push_callback)
		{
			if(!is_callback)
			{
				gr_key_last_release_time_real = rtime();
			}
			gr_event_callback *cb = (((gr_event_callback *)(normal_Malloc(1 * sizeof(gr_event_callback)))));
			cb->t = ((thunk){ key_handler_main, NULL, (((void*)(intptr_t)1)) });
			cb->e = *e;
			cb->time = rtime();
			*(typeof(*cb) *)vec_push(gr_need_delay_callbacks) = (*cb);
			ignore = 1;
		}
		if(!ignore || push_callback)
		{
			gr_key_last_release_key = e->which;
			gr_key_last_release_time = e->time;
		}
	}
	return ignore;
}

void configure_notify(void)
{
	int _x, _y;
	Window _root;
	unsigned int _border, _depth, new_width, new_height;
	
	XGetGeometry(display, window, &_root, &_x, &_y, &new_width, &new_height, &_border, &_depth);
	if((int)new_width != w || (int)new_height != h)
	{
		
	}
}

void north(num d)
{
	((turtle_a = 0));
	forward(d);
}

void east(num d)
{
	((turtle_a = (pi/2)));
	forward(d);
}

void south(num d)
{
	((turtle_a = pi));
	forward(d);
}

void west(num d)
{
	((turtle_a = (-pi/2)));
	forward(d);
}

void turtle_go(num dx, num dy)
{
	num x = lx + (_xflip ? -dx : dx);
	num y = ly + (_yflip ? -dy : dy);
	if(turtle_pendown)
	{
		draw(x, y);
	}
	else
	{
		move(x, y);
	}
}

void forward(num d)
{
	turtle_go(sin(turtle_a) * d, cos(turtle_a) * d);
}

void back(num d)
{
	turtle_go(sin(turtle_a+pi) * d, cos(turtle_a+pi) * d);
}

turtle_pos get_pos(void)
{
	turtle_pos p = { lx, ly, lx2, ly2, turtle_a };
	return p;
}

void set_pos(turtle_pos p)
{
	lx = p.lx;
	ly = p.ly;
	lx2 = p.lx2;
	ly2 = p.ly2;
	turtle_a = p.turtle_a;
}

void raw(void)
{
	int rv;
	rv = tcgetattr(STDIN_FILENO, &term);
	if(rv < 0)
	{
		error("tcgetattr failed");
	}
	term_orig = term;
	term.c_iflag &= ~(IGNBRK|BRKINT|PARMRK|ISTRIP|INLCR|IGNCR|ICRNL|IXON);
	term.c_iflag |= IGNBRK | BRKINT;
	term.c_oflag |= OPOST;
	term.c_lflag &= ~(ECHO|ECHONL|ICANON|IEXTEN);
	term.c_lflag |= ISIG;
	term.c_cflag &= ~(CSIZE|PARENB);
	term.c_cflag |= CS8;
	term.c_cc[VMIN] = 1;
	term.c_cc[VTIME] = 0;
	rv = tcsetattr(STDIN_FILENO, TCSANOW, &term);
	if(rv < 0)
	{
		error("tcsetattr failed");
	}
	key_raw = 1;
}

void cooked(void)
{
	int rv;
	rv = tcsetattr(STDIN_FILENO, TCSAFLUSH, &term_orig);
	if(rv < 0)
	{
		error("tcsetattr failed");
	}
}

void noecho(void)
{
	int rv;
	rv = tcgetattr(STDIN_FILENO, &term);
	if(rv < 0)
	{
		error("tcgetattr failed");
	}
	term_orig = term;
	term.c_lflag &= ~(ECHO|ECHONL);
	term.c_lflag |= ISIG;
	rv = tcsetattr(STDIN_FILENO, TCSANOW, &term);
	if(rv < 0)
	{
		error("tcsetattr failed");
	}
	key_noecho = 1;
}

void echo(void)
{
	key_noecho = 0;
}

void key_init(void)
{
	raw();
	(Sigact(SIGCONT, cont_handler, SA_RESTART|(SIGCONT == SIGCHLD ? SA_NOCLDSTOP : 0)));
	(Sigact(SIGINT, int_handler, SA_RESTART|(SIGINT == SIGCHLD ? SA_NOCLDSTOP : 0)));
	(Sigact(SIGPIPE, int_handler, SA_RESTART|(SIGPIPE == SIGCHLD ? SA_NOCLDSTOP : 0)));
}

void key_final(void)
{
	cooked();
}

int key(void)
{
	unsigned char c;
	ssize_t s;
	s = read(STDIN_FILENO, &c, 1);
	if(s == 0)
	{
		return -1;
	}
	return c;
}

void cont_handler(int signum)
{
	(void)signum;
	raw();
}

void int_handler(int signum)
{
	(void)signum;
	cooked();
	Exit(1);
}

cstr Input_passwd(cstr prompt)
{
	noecho();
	cstr pass = Input(prompt);
	if(0)
	{
		
	}
	else if(putc('\n', stdout) == EOF)
	{
		failed("putc");
	}
	cooked();
	return pass;
}

void cgi_png(int w, int h, num scale)
{
	char *p = strchr(cgi_png_display, '.');
	if(!p)
	{
		error("cgi_png_display %s is invalid, should be like :99.0", cgi_png_display);
	}
	cgi_png_display1 = strndup(cgi_png_display, p-cgi_png_display);
	cgi_png_scale = scale;
	cgi_content_type("image/png");
	Putenv(format("DISPLAY=%s", cgi_png_display));
	cstr user = whoami();
	Setenv("USER", user, 1);
	Putenv(format("HOME=/home/%s", user));
	Systemf("exec 2>/dev/null; " "tightvncserver -kill %s; tightvncserver %s -geometry %dx%d -depth 16 ; xsetroot -solid black", cgi_png_display1, cgi_png_display1, w, h);
	Atexit(cgi_png_done);
}

void cgi_png_done(void)
{
	paint();
	if(cgi_png_scale == 1)
	{
		dump_img("png", NULL, 1);
	}
	else
	{
		dump_img("png", NULL, cgi_png_scale);
	}
	Systemf("exec 2>/dev/null; " "tightvncserver -kill %s", cgi_png_display1);
	gr_done = 1;
}

