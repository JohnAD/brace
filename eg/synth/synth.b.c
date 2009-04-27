#include <stdlib.h>
#include <sys/types.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <dirent.h>
#include <utime.h>
#include <errno.h>
#include <setjmp.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/un.h>
#include <sys/sendfile.h>
#include <sys/select.h>
#include <poll.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <math.h>
#include <limits.h>
#include <time.h>
#include <sys/time.h>
#include <locale.h>
#include <signal.h>
#include <pwd.h>
#include <shadow.h>
#include <sched.h>
#include <sys/wait.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/XShm.h>

struct str;
struct buffer;
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
struct vstream;
struct vec;
struct ropev;
union rope;
struct rope_p;
struct cons;
struct dirbase;
struct complex;
struct proc;
struct timeout;
struct io_select;
struct scheduler;
struct shuttle;
struct sock;
struct shuttle_buffer;
struct shuttle_sock_p;
struct listener_sel;
struct listener_try;
struct write_sock;
struct reader_sel;
struct writer_sel;
struct reader_try;
struct writer_try;
struct place;
struct range;
struct sound_info;
struct polygon;
struct turtle_pos;
struct shuttle_deq;

typedef struct str str;
typedef struct buffer buffer;
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
typedef struct vstream vstream;
typedef struct vec vec;
typedef struct ropev ropev;
typedef union rope rope;
typedef struct rope_p rope_p;
typedef struct cons cons;
typedef struct dirbase dirbase;
typedef struct complex complex;
typedef struct proc proc;
typedef struct timeout timeout;
typedef struct io_select io_select;
typedef struct scheduler scheduler;
typedef struct shuttle shuttle;
typedef struct sock sock;
typedef struct shuttle_buffer shuttle_buffer;
typedef struct shuttle_sock_p shuttle_sock_p;
typedef struct listener_sel listener_sel;
typedef struct listener_try listener_try;
typedef struct write_sock write_sock;
typedef struct reader_sel reader_sel;
typedef struct writer_sel writer_sel;
typedef struct reader_try reader_try;
typedef struct writer_try writer_try;
typedef struct place place;
typedef struct range range;
typedef struct sound_info sound_info;
typedef struct polygon polygon;
typedef struct turtle_pos turtle_pos;
typedef struct shuttle_deq shuttle_deq;

typedef unsigned char byte;
typedef double num;
typedef unsigned char boolean;
typedef char *cstr;
typedef unsigned int count_t;
typedef unsigned char uchar;
typedef struct timeval timeval;
typedef struct timespec timespec;
typedef struct tm datetime;
typedef void (*free_t)(void *);
typedef unsigned int (*hash_func)(void *key);
typedef boolean (*eq_func)(void *k1, void *k2);
typedef void *(*thunk_func)(void *obj, void *common_arg, void *specific_arg);
typedef struct sockaddr sockaddr;
typedef struct sockaddr_in sockaddr_in;
typedef struct sockaddr_un sockaddr_un;
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
typedef enum { if_dead_error, if_dead_null, if_dead_path, if_dead_warn=1<<31 } readlinks_if_dead;
typedef struct pollfd pollfd;
typedef int (*cmp_t)(const void *, const void *);
typedef vec priq;
typedef struct itimerval itimerval;
typedef int (*proc_func)(proc *p);
typedef proc *proc_p;
typedef priq timeouts;
typedef timeout *timeout_p;
typedef sock *sock_p;
typedef listener_try listener_tcp;
typedef listener_try listener_unix;
typedef enum { HTTP_GET, HTTP_HEAD, HTTP_POST, HTTP_PUT, HTTP_DELETE, HTTP_INVALID } http__method;
typedef enum { NAME, SPACE, BRACKET, OP, NEWLINE, TABS, DELIMIT, NUMBER, COMMENT, STRING, CHARACTER, BSPACE, TOKEN_TYPE_TOP, ILLEGAL = -1 } token_types;
typedef char char_table[256];
typedef void (*sighandler_t)(int);
typedef struct sched_param sched_param;
typedef struct passwd passwd;
typedef struct spwd spwd;
typedef float sample;
typedef vec sound;
typedef vec dsp_buffer;
typedef num (*wave_f)(num t);
typedef struct termios termios;
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
	ssize_t size;
	ssize_t space;
	ssize_t start;
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

struct vec
{
	buffer b;
	size_t element_size;
	size_t space;
	size_t size;
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

struct complex
{
	num r;
	num i;
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

struct io_select
{
	fd_set readfds, writefds, exceptfds;
	fd_set readfds_ready, writefds_ready, exceptfds_ready;
	int max_fd_plus_1;
	int count;
};

struct scheduler
{
	int exit;
	deq q;
	io_select io;
	vec readers;
	vec writers;
	num now;
	timeouts tos;
	hashtable children;
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

struct listener_sel
{
	proc p;
	int listen_fd;
	socklen_t socklen;
	shuttle_sock_p *out;
	sock_p s;
};

struct listener_try
{
	proc p;
	int listen_fd;
	socklen_t socklen;
	shuttle_sock_p *out;
	sock_p s;
};

struct write_sock
{
	proc p;
	shuttle_sock_p *in;
	sock_p s;
};

struct reader_sel
{
	proc p;
	int fd;
	size_t block_size;
	shuttle_buffer *out;
	boolean done;
};

struct writer_sel
{
	proc p;
	int fd;
	shuttle_buffer *in;
	boolean done;
};

struct reader_try
{
	proc p;
	int fd;
	size_t block_size;
	boolean sel_first;
	shuttle_buffer *out;
	boolean done;
};

struct writer_try
{
	proc p;
	int fd;
	boolean sel_first;
	shuttle_buffer *in;
	boolean done;
};

struct place
{
	int ns, ns_min, ns_sec, ew, ew_min, ew_sec;
};

struct range
{
	sample min, max;
};

struct sound_info
{
	int channels;
	int sample_rate;
	size_t n_samples;
	int bits_per_sample;
};

struct polygon
{
	XPoint *points;
	int n_points;
	int space;
};

struct turtle_pos
{
	num lx, ly;
	num lx2, ly2;
	num turtle_a;
};

struct shuttle_deq
{
	shuttle sh;
	deq d;
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
int Vsnprintf(char *buf, size_t size, const char *format, va_list ap);
int Vsprintf(buffer *b, const char *format, va_list ap);
void buffer_add_nul(buffer *b);
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
void hashtable_init(hashtable *ht, hash_func hash, eq_func eq, size_t size);
list *alloc_buckets(size_t size);
list *hashtable_lookup_ref(hashtable *ht, void *key);
key_value *hashtable_lookup(hashtable *ht, void *key);
key_value *hashtable_ref_lookup(list *l);
void *hashtable_value(hashtable *ht, void *key);
void *hashtable_value_or_null(hashtable *ht, void *key);
void *hashtable_value_or(hashtable *ht, void *key, void *def);
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
key_value *hashtable_lookup_or_die(hashtable *ht, void *key);
unsigned int int_hash(void *i_ptr);
boolean int_eq(int *a, int *b);
void hashtable_free(hashtable *ht);
void circbuf_init(circbuf *b, ssize_t space);
char *circbuf_get_pos(circbuf *b, int index);
void circbuf_free(circbuf *b);
void circbuf_set_space(circbuf *b, ssize_t space);
void circbuf_ensure_space(circbuf *b, size_t space);
void circbuf_set_size(circbuf *b, ssize_t size);
void circbuf_grow(circbuf *b, ssize_t delta_size);
void circbuf_shift(circbuf *b, ssize_t delta_size);
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
void circbuf_from_cstr(circbuf *b, cstr s, size_t len);
void _deq_init(deq *q, size_t element_size, size_t space);
void deq_free(deq *q);
void deq_space(deq *q, size_t space);
void deq_size(deq *q, size_t size);
void deq_clear(deq *q);
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
void warn_failed(const char *funcname);
void swarning(const char *format, ...);
void memdump(const char *from, const char *to);
void error__assert(int should_be_true, const char *format, ...);
void usage(char *syntax);
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
void cork(int fd, int cork);
void reuseaddr(int fd, int reuseaddr);
void Getsockopt(int s, int level, int optname, void *optval, socklen_t *optlen);
int Getsockerr(int fd);
int Server_unix_stream(char *addr);
int Client_unix_stream(char *addr);
void Sockaddr_unix(struct sockaddr_un *sa, char *addr);
ssize_t Sendfile(int out_fd, int in_fd, off_t *offset, size_t count);
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
void Fwrite_str(FILE *stream, str s);
void Fwrite_buffer(FILE *stream, buffer *b);
size_t Fread_buffer(FILE *stream, buffer *b);
void Fputc(int c, FILE *stream);
void Fseek(FILE *stream, long offset, int whence);
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
void Mkdir(const char *pathname, mode_t mode);
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
void stats_dump(Stats *s);
mode_t mode(const char *file_name);
void cp(const char *from, const char *to, int mode);
off_t cp_fd(int in, int out);
void fcp(FILE *in, FILE *out);
int Select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout);
void fd_set_init(fd_set *o);
cstr which(cstr file);
int can_read(int fd);
int can_write(int fd);
int has_error(int fd);
void Mkdirs(const char *pathname, mode_t mode);
void Mkdirs_cwd(const char *pathname, mode_t mode, cstr basedir);
void Rmdir(const char *pathname);
void Rmdirs(const char *pathname);
boolean newer(const char *file1, const char *file2);
void lnsa(cstr from, cstr to, cstr cwd);
void Cp(cstr from, cstr to, Lstats *sf);
void CP(cstr from, cstr to, Lstats *sf);
void cp_attrs(cstr from, cstr to);
void cp_attrs_st(Lstats *sf, cstr to);
void cp_mode(Stats *sf, cstr to);
void cp_owner(Lstats *sf, cstr to);
void Utime(const char *filename, const struct utimbuf *times);
void cp_times(Lstats *sf, cstr to);
void cp_atime(Lstats *sf, cstr to, Lstats *st);
void cp_mtime(Lstats *sf, cstr to, Lstats *st);
void Setvbuf(FILE *stream, char *buf, int mode, size_t size);
ssize_t Readv(int fd, const struct iovec *iov, int iovcnt);
ssize_t Writev(int fd, const struct iovec *iov, int iovcnt);
void Socketpair(int d, int type, int protocol, int sv[2]);
int file_cmp(cstr fa, cstr fb);
void create_hole(cstr file, off_t size);
void insert_hole(cstr file, off_t offset, off_t size);
int Pselect(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, const struct timespec *timeout, const sigset_t *sigmask);
int Poll(struct pollfd *fds, nfds_t nfds, int timeout);
void nonblock(int fd, int nb);
int fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len);
int Fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len);
int Fcntl_getfd(int fd);
void Fcntl_setfd(int fd, long arg);
int Fcntl_getfl(int fd);
void Fcntl_setfl(int fd, long arg);
void cloexec(int fd);
void cloexec_off(int fd);
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
void *Mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);
int Munmap(void *addr, size_t length);
void hexdump(FILE *stream, char *b0, char *b1);
boolean printable(uchar c);
void *mem_mem(const void* haystack, size_t haystacklen, const void* needle, size_t needlelen);
int num_cmp(const void *a, const void *b);
int int_cmp(const void *a, const void *b);
int off_t_cmp(const void *a, const void *b);
size_t arylen(void *_p);
void sort_vec(vec *v, cmp_t cmp);
int cstrp_cmp(const void *_a, const void *_b);
int cstrp_cmp_null(const void *_a, const void *_b);
void comm(vec *merge_v, vec *comm_v, vec *va, vec *vb, cmp_t cmp, free_t freer);
void comm_dump_cstr(vec *merge_v, vec *comm_v);
void *memdup(const void *src, size_t n, size_t extra);
void cstr_set_add(vec *set, cstr s);
unsigned int bit_reverse(unsigned int x);
void vec_init_el_size(vec *v, size_t element_size, size_t space);
void vec_clear(vec *v);
void vec_free(vec *v);
void vec_Free(vec *v);
void vec_space(vec *v, size_t space);
void vec_size(vec *v, size_t size);
void vec_double(vec *v);
void vec_squeeze(vec *v);
void *vec_element(vec *v, size_t index);
void *vec_top(vec *v, size_t index);
void *vec_push(vec *v);
void vec_pop(vec *v);
void vec_grow(vec *v, size_t delta_size);
vec *vec_dup_0(vec *from);
vec *vec_dup(vec *to, vec *from);
void vec_ensure_size(vec *v, size_t size);
void *vec_to_array(vec *v);
void vec_splice(vec *v, size_t i, size_t cut, void *in, size_t ins);
vec *Subvec(vec *v, size_t i, size_t n, size_t extra);
vec *subvec(vec *sub, vec *v, size_t i, size_t n);
void cstr_dos_to_unix(cstr s);
cstr cstr_unix_to_dos(cstr s);
void cstr_chomp(cstr s);
int cstr_eq(cstr s1, cstr s2);
int cstr_is_empty(cstr s1);
int cstr_ends_with(cstr s, cstr substr);
cstr cstr_begins_with(cstr s, cstr substr);
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
cstr join(cstr sep, cstr *s);
cstr joinv(cstr sep, vec *v);
char *Strstr(const char *haystack, const char *needle);
char *Strcasestr(const char *haystack, const char *needle);
char *Strchr(const char *s, int c);
char *Strrchr(const char *s, int c);
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
void lsleep_init(void);
void lsleep(num dt);
void Getitimer(int which, struct itimerval *value);
void Setitimer(int which, const struct itimerval *value, struct itimerval *ovalue);
void Ualarm(num dt);
void rtime_to_timeval(num rtime, struct timeval *tv);
void rtime_to_timespec(num rtime, struct timespec *ts);
num timeval_to_rtime(const struct timeval *tv);
num timespec_to_rtime(const struct timespec *ts);
int rtime_to_ms(num rtime);
num ms_to_rtime(int ms);
void date_rfc1123_init(void);
char *date_rfc1123(time_t t);
complex c_add(complex a, complex b);
complex c_sub(complex a, complex b);
complex c_mul(complex a, complex b);
complex c_div(complex a, complex b);
num c_norm(complex a);
num c_mag(complex a);
num c_ang(complex a);
complex c_conj(complex a);
complex c_add_r(complex a, num b);
complex c_sub_r(complex a, num b);
complex c_add_i(complex a, num b);
complex c_sub_i(complex a, num b);
complex c_mul_r(complex a, num b);
complex c_div_r(complex a, num b);
complex c_mul_i(complex a, num b);
complex c_div_i(complex a, num b);
complex c_mul_i1(complex a);
complex c_div_i1(complex a);
complex c_neg(complex a);
complex cis(num ang);
complex c_exp(complex a);
complex c_log(complex a);
complex c_pow(complex a, complex b);
complex c_pow_r(complex a, num b);
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
num rand_normal(void);
void fft(complex *in, complex *out, int log2_n);
char *Getenv(const char *name, char *_default);
boolean is_env(const char *name);
void Putenv(char *string);
void dump_env(void);
void Setenv(const char *name, const char *value, int overwrite);
void Unsetenv(const char *name);
void Clearenv(void);
int clear_env(void);
void Atexit(void (*function)(void));
void find_vec(cstr root, vec *v);
void find_vec_all(cstr root, vec *v);
void find_vec_files(cstr root, vec *v);
void proc_init(proc *p, proc_func f);
int resume(proc *p);
void proc_dump(proc *p);
void timeout_init(timeout *timeout, num time, thunk_func func, void *obj, void *common_arg);
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
void io_select_init(io_select *io);
int io_select_wait(io_select *io, num delay, sigset_t *sigmask);
int io_select_add(io_select *io, int fd, boolean et);
void io_select_rm(io_select *io, int fd);
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
void set_waitchild(pid_t pid, proc *p);
void clr_waitchild(pid_t pid);
void sigchld_handler(int signum);
num sched_get_time(void);
void sched_forget_time(void);
void sched_set_time(void);
void shuttle_init(shuttle *sh, proc *p1, proc *p2);
boolean pull_f(shuttle *s, proc *p);
void push_f(shuttle *s, proc *p);
void sock_init(sock *s, socklen_t socklen);
void sock_free(sock *s);
void listener_tcp_init(listener_try *p, cstr listen_addr, int listen_port);
void listener_unix_init(listener_try *p, cstr addr);
void listener_sel_init(listener_sel *d, int listen_fd, socklen_t socklen);
int listener_sel_f(proc *b__p);
void listener_try_init(listener_try *d, int listen_fd, socklen_t socklen);
int listener_try_f(proc *b__p);
void write_sock_init(write_sock *d);
int write_sock_f(proc *b__p);
void reader_sel_init(reader_sel *d, int fd, size_t block_size);
int reader_sel_f(proc *b__p);
void writer_sel_init(writer_sel *d, int fd);
int writer_sel_f(proc *b__p);
void reader_try_init(reader_try *d, int fd, size_t block_size, boolean sel_first);
int reader_try_f(proc *b__p);
void writer_try_init(writer_try *d, int fd, boolean sel_first);
int writer_try_f(proc *b__p);
void main__init(int _argc, char *_argv[], char *_envp[]);
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
void http_fake_browser(int f);
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
void tok_init(void);
char token_type_(char c);
void hunk(cstr in_file, cstr out_dir, int avg_hunk_size, int max_hunk_size, int sum_window_size);
void Execv(const char *path, char *const argv[]);
void Execvp(const char *file, char *const argv[]);
void Execve(const char *filename, char *const argv[], char *const envp[]);
void exit_exec_failed(void);
void Execl(const char *path, ...);
void Execlp(const char *path, ...);
void Execle(const char *path, ...);
void sh_quote(const char *from, buffer *to);
void cmd_quote(const char *from, buffer *to);
int System(const char *s);
int Systemf(const char *format, ...);
void SYSTEM(const char *s);
void SYSTEMF(const char *format, ...);
void VSYSTEMF(const char *format, va_list ap);
int Vsystemf(const char *format, va_list ap);
sighandler_t Signal(int signum, sighandler_t handler);
int Systema(const char *filename, char *const argv[]);
int Systemv(const char *filename, char *const argv[]);
int Systeml(const char *filename, ...);
cstr cmd(cstr c);
sighandler_t Sigact(int signum, sighandler_t handler, int sa_flags);
void Sigdfl_all(void);
void Raise(int sig);
void catch_signal_null(int sig);
pid_t Fork(void);
pid_t Waitpid(pid_t pid, int *status, int options);
int Child_wait(pid_t pid);
pid_t Child_done(void);
int fix_exit_status(int status);
pid_t Waitpid_intr(pid_t pid, int *status, int options);
void Sched_setscheduler(pid_t pid, int policy, const sched_param *p);
void set_priority(pid_t pid, int priority);
cstr whoami(void);
int auth(passwd *pw, cstr pass);
hashtable *load_passwd(void);
passwd *passwd_dup(passwd *_p);
void passwd_free(passwd *p);
struct passwd *Getpwent(void);
struct passwd *Getpwnam(const char *name);
struct passwd *Getpwuid(uid_t uid);
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
void cgi_html(void);
void cgi_content_type(cstr type);
void cgi_text(void);
void cgi_env(cstr prefix);
void cgi_env_load(cstr data);
cstr cgi(cstr k, cstr _default);
void cgi_errors_to_browser(void);
void *cgi_error_to_browser(void *obj, void *common_arg, void *specific_arg);
void place_init(place *p, int ns, int ns_min, int ns_sec, int ew, int ew_min, int ew_sec);
void qmath_init(void);
void mimetypes_init(void);
void load_mimetypes_vio(void);
cstr mimetype(cstr ext);
cstr Mimetype(cstr ext);
range check_range(sample *s0, sample *s1);
boolean range_ok(sample *s0, sample *s1);
void sound_print(sample *s0, sample *s1);
void fit(sample *s0, sample *s1);
void amplify(sample *s0, sample *s1, num factor);
void clip(sample *s0, sample *s1);
void sound_init(sound *s, size_t size);
void sound_clear(sound *s);
void mix_range(sample *up, sample *a0, sample *a1);
void sound_same_size(sound *s1, sound *s2);
void sound_grow(sound *s, size_t size);
void mix(sound *up, sound *add);
void mix_to_new(sample *out, sample *a0, sample *a1, sample *b0, sample *b1);
void sound_set_rate(int r);
sound_info load_wav(sound *s);
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
void raw(void);
void cooked(void);
void noecho(void);
void key_init(void);
void key_final(void);
int key(void);
void cont_handler(int signum);
void int_handler(int signum);
cstr Input_passwd(cstr prompt);
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
void paint(void);
void Paint(void);
void gr_sync(void);
void clear(void);
void event_loop(void);
void triangle(num x2, num y2);
void quad(num x2, num y2, num x3, num y3);
void dump_img(cstr type, cstr file, num scale);
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
void north(num d);
void east(num d);
void south(num d);
void west(num d);
void turtle_go(num dx, num dy);
void turtle_go_back(num dx, num dy);
void forward(num d);
void back(num d);
turtle_pos get_pos(void);
void set_pos(turtle_pos p);
void cgi_png(int w, int h, num scale);
void cgi_png_done(void);
int getnote(void);
int main(int main__argc, char *main__argv[], char *main__envp[]);
cstr sign(num r);
void scales(void);
void play_major_scale_equal(void);
void play_minor_scale_equal(void);
void play_chromatic_scale_equal(void);
num oboe(num t);
num violin(num t);

extern str str_null;
extern key_value kv_null;
extern thunk _thunk_null;
extern thunk *thunk_null;
extern int exit__error;
extern int exit__fault;
extern int throw_faults;
extern thunk _thunk_error_warn;
extern thunk *thunk_error_warn;
extern thunk _thunk_error_ignore;
extern thunk *thunk_error_ignore;
extern vec *error_handlers;
extern vec *errors;
extern hashtable *extra_error_messages;
extern int listen_backlog;
extern char hostname__[256];
extern vstream struct__in, *in;
extern vstream struct__out, *out;
extern vstream struct__er, *er;
extern size_t block_size;
extern fd_set *tmp_fd_set;
extern buffer _Cp_symlink, *Cp_symlink;
extern int memlog_on;
extern int rope_p_char;
extern int rope_p_rope;
extern int rope_p_start;
extern int rope_p_end;
extern int rope_p_on;
extern size_t syms_n_buckets;
extern hashtable *syms;
extern hashtable syms__struct;
extern int unix_path;
extern cstr dt_format;
extern cstr dt_format_tz;
extern boolean sleep_debug;
extern long double csleep_last;
extern long double asleep_small;
extern boolean lsleep_inited;
extern num bm_start;
extern boolean bm_enabled;
extern complex c_0;
extern complex c_1;
extern complex c_i;
extern const double pi;
extern const double e;
extern char **environ;
extern char *env__required;
extern num sched_delay;
extern int sched_busy;
extern int sched__children_n_buckets;
extern scheduler struct__sched, *sched;
extern pid_t waitchild__pid;
extern int waitchild__status;
extern int max_line_length;
extern int argc;
extern int args;
extern char **argv;
extern char **envp;
extern char *program_full;
extern char *program;
extern char *program_dir;
extern char **arg;
extern char *main_dir;
extern int mingw;
extern int unix_main;
extern cstr tag__no_value;
extern cstr html_entity[];
extern char html_entity_char[];
extern int _http_fake_browser;
extern const char *base64_encode_map;
extern char *base64_decode_map;
extern char_table ct_token_type;
extern char_table ct_name2;
extern int exit__execfailed;
extern int status__execfailed;
extern int sig_execfailed;
extern boolean exec__warn_fail;
extern uid_t uid_root;
extern int myuid;
extern int mygid;
extern int passwd_n_buckets;
extern int wait__status;
extern int cgi__sent_headers;
extern cstr cgi__prefix;
extern num *_qsin;
extern num *_qcos;
extern num *_qatan;
extern cstr mimetypes_file;
extern size_t mimetypes_n_buckets;
extern hashtable struct__mimetypes, *mimetypes;
extern int sound_rate;
extern num sound_dt;
extern int dsp_rate;
extern int bits_per_sample;
extern int channels;
extern num dsp_buf_initial_duration;
extern int bytes_per_sample;
extern char *dsp_outfile;
extern int use_dsp;
extern dsp_buffer *dsp_buf;
extern int dsp_fd;
extern dsp_buffer struct__dsp_buf;
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
extern termios term;
extern termios term_orig;
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
extern XEvent x_event;
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
extern num turtle_a;
extern num turtle_pendown;
extern cstr cgi_png_display;
extern cstr cgi_png_display1;
extern num cgi_png_scale;
extern int INT_NULL;
extern boolean mean;
extern boolean set_key;
extern char symbol[12];
extern int kn;

int p;

int INT_NULL = 0x80 << (sizeof(int)-1)*8;
boolean mean = 0;
boolean set_key = 0;
char symbol[12] = "({[</o\\>]})x";
int kn = 0;

int getnote(void)
{
	cstr notekeys = "asdfghjkl;'\tqwertyuiop[`1234567890-=\x7f";
	while(1)
	{
		while(1)
		{
			_harmony[11] = 45.0/32;
			typeof(key()) c = key();
			char *x = strchr(notekeys, c);
			if(x != NULL)
			{
				p = x - notekeys - 12 - 5;
				break;
			}
			else if(c == ']')
			{
				_harmony[11] = 64.0/45;
				p = 6;
				break;
			}
			else if(c == '\r')
			{
				_harmony[11] = 64.0/45;
				p = -6;
				break;
			}
			else if(c == 27)
			{
				return INT_NULL;
			}
			else if(c == 'z')
			{
				mean = 0;
			}
			else if(c == 'x')
			{
				mean = 1;
			}
			else if(c == '.')
			{
				kn += 12;
				key_note(kn);
			}
			else if(c == ',')
			{
				kn -= 12;
				key_note(kn);
			}
			else if(c == 'n')
			{
				kn += p;
				key_note(kn);
			}
			else if(c == '/')
			{
				kn += 7;
				key_note(kn);
			}
			else if(c == 'm')
			{
				kn -= 7;
				key_note(kn);
			}
			else if(c == ' ')
			{
				set_key = 1;
			}
			else if(c == 'b')
			{
				kn = 0;
				key_note(kn);
			}
			else
			{
				warn("unbound key pressed, ASCII %d", c);
			}
		}
		if(set_key)
		{
			kn += p;
			key_note(kn);
			set_key = 0;
		}
		else
		{
			break;
		}
	}
	return p;
}

int main(int main__argc, char *main__argv[], char *main__envp[])
{
	main__init(main__argc, main__argv, main__envp);
	dsp_init();
	key_init();
	key_note(kn);
	envelope(0.025, 0.05);
	dur(0.1);
	music_wave = oboe;
	while(1)
	{
		int n = getnote();
		if(n == INT_NULL)
		{
			break;
		}
		vol(1);
		if(mean)
		{
			pitch(n);
			note();
		}
		else
		{
			harmony(n);
			note();
		}
		int octave, degree;
		divmod_range(n, -5, 7, &octave, &degree);
		Sayf("%c %s%d%s%d %f %f %f", symbol[degree+5], sign(octave), octave, sign(degree), degree, _p, _rf, _freq);
	}
	key_final();
	return 0;
}

cstr sign(num r)
{
	if(r == 0)
	{
		return ".";
	}
	else if(r > 0)
	{
		return "+";
	}
	else
	{
		return "";
	}
}

void scales(void)
{
	dur(0.2);
	play_major_scale_equal();
	play_minor_scale_equal();
	play_chromatic_scale_equal();
	dur(2);
	chord3(0, 4, 7);
	chord3(0, 3, 7);
}

void play_major_scale_equal(void)
{
	harmony(0);
	note();
	harmony(2);
	note();
	harmony(4);
	note();
	harmony(5);
	note();
	harmony(7);
	note();
	harmony(9);
	note();
	harmony(11);
	note();
	harmony(12);
	note();
}

void play_minor_scale_equal(void)
{
	harmony(0);
	note();
	harmony(2);
	note();
	harmony(3);
	note();
	harmony(5);
	note();
	harmony(7);
	note();
	harmony(8);
	note();
	harmony(10);
	note();
	harmony(12);
	note();
}

void play_chromatic_scale_equal(void)
{
	typeof(13) my__26_end = 13;
	for(typeof(0) i = 0; i<my__26_end; ++i)
	{
		harmony(i);
		note();
	}
}

num oboe(num t)
{
	return (puretone(t) + puretone(t*2) + puretone(t*3) + puretone(t*4) + puretone(t*5) + puretone(t*6) + puretone(t*7))/7;
}

num violin(num t)
{
	return (puretone(t)*2 + sawtooth(t))/3;
}

num puretone(num t)
{
	return sin(2*pi*t);
}

num sawtooth(num t)
{
	return rmod(t, 1)*2-1;
}

