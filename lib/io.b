export stdio.h sys/stat.h fcntl.h unistd.h dirent.h stdarg.h string.h utime.h

export str error buffer types net vec vio
use m alloc util path env process

use io

size_t block_size = 1024

# todo split io and fs

int Open(const char *pathname, int flags, mode_t mode)
	int fd = open(pathname, flags, mode)
	if fd == -1
		char msg[8]
		cstr how = ""
		strcpy(msg, "open ")
		which flags & 3
		O_RDONLY	how = "r"
		O_WRONLY	how = "w"
		O_RDWR	how = "rw"
		strcat(msg, how)
		failed(msg, pathname)
	return fd
def Open(pathname, flags) Open(pathname, flags, 0666)

def openin(pathname) Open(pathname, O_RDONLY)
def openout(pathname, mode) Open(pathname, O_WRONLY|O_CREAT, mode)
def openout(pathname) openout(pathname, 0666)
def Open(pathname) openin(pathname)
def open(pathname) open(pathname, O_RDONLY)

# FIXME many uses of openout would want O_TRUNC

Close(int fd)
	winsock_close(fd)
	if close(fd) != 0
		failed("close")

# Read_some (and Read) return 0 at EOF, and also return 0 if a non-blocking fd
# has no bytes to read. In that case, use Read_eof(fd) to check errno whether
# it is 0 (eof) or EAGAIN (no bytes were read).

ssize_t Read_some(int fd, void *buf, size_t count)
	errno = 0
	ssize_t bytes_read = read(fd, buf, count)
	if bytes_read == -1
		if errno == EAGAIN
			bytes_read = 0
		 else
			failed("read")
	return bytes_read

ssize_t Read(int fd, void *buf, size_t count)
	ssize_t bytes_read_tot = 0
	repeat
		ssize_t bytes_read = Read_some(fd, buf, count)
		bytes_read_tot += bytes_read
		count -= bytes_read
		if count == 0 || bytes_read == 0
			break
		buf = (char *)buf + bytes_read
	return bytes_read_tot

def Read_eof(fd) errno == 0

ssize_t Write_some(int fd, const void *buf, size_t count)
	ssize_t bytes_written = write(fd, buf, count)
	if bytes_written == -1
		if errno == EAGAIN
			bytes_written = 0
		 else
			failed("write")
	return bytes_written

Write(int fd, const void *buf, size_t count)
	repeat
		ssize_t bytes_written = Write_some(fd, buf, count)
		count -= bytes_written
		if count == 0
			break
		buf = (char *)buf + bytes_written

slurp_2(int fd, buffer *b)
	int space = buffer_get_space(b)
	int size = buffer_get_size(b)
	char *start = buffer_get_start(b)
	repeat
		let(bytes_read, Read(fd, start + size, space - size))
		if bytes_read == 0
			break
		buffer_grow(b, bytes_read)
		size += bytes_read
		if size == space
			buffer_double(b)
			space = buffer_get_space(b)
			size = buffer_get_size(b)
			start = buffer_get_start(b)

# TODO fix slurp(fd, buffer) so that it does the fstat instead of this one

buffer *slurp_1(int filedes)
	decl(st, Stats)
	Fstat(filedes, st)
	int size = st->st_size

	if size == 0
		size = 1024
	 else
	 	++size
		# to avoid a problem with
		# doubling the buffer on the last read at EOF.
		# Also this is handy if client wants to convert to a cstr :)

	New(b, buffer, size)
	slurp_2(filedes, b)

	return b

def slurp(fd, b) slurp_2(fd, b)
def slurp(fd) slurp_1(fd)
def slurp() slurp(STDIN_FILENO)

def spurt(b) spurt(STDOUT_FILENO, b)

spurt(int fd, buffer *b)
	Write(fd, buffer_get_start(b), buffer_get_size(b))

fslurp_2(FILE *s, buffer *b)
	int space = buffer_get_space(b)
	int size = buffer_get_size(b)
	char *start = buffer_get_start(b)
	repeat
		int to_read = space - size
		ssize_t bytes_read = Fread(start + size, 1, to_read, s)
		buffer_grow(b, bytes_read)
		size += bytes_read
		if bytes_read < to_read
			break
		if size == space
			buffer_double(b)
			space = buffer_get_space(b)
			size = buffer_get_size(b)
			start = buffer_get_start(b)

# TODO fix slurp(fd, buffer) so that it does the fstat instead of this one

buffer *fslurp_1(FILE *s)
	decl(st, Stats)
	Fstat(Fileno(s), st)
	int size = st->st_size

	if size == 0
		size = 1024
	 else
	 	++size
		# to avoid a problem with
		# doubling the buffer on the last read at EOF.
		# Also this is handy if client wants to convert to a cstr :)

	New(b, buffer, size)
	fslurp_2(s, b)

	return b

def fslurp(s, b) fslurp_2(s, b)
def fslurp(s) fslurp_1(s)
def fslurp() fslurp(stdin)

def fspurt(b) fspurt(stdout, b)

fspurt(FILE *s, buffer *b)
	Fwrite(buffer_get_start(b), 1, buffer_get_size(b), s)

FILE *Fopen(const char *path, const char *mode)
	FILE *f = fopen(path, mode)
	if f == NULL
		failed("fopen", mode, path)
	return f
def Fopen(pathname) Fopen(pathname, "rb")
def Fopenout(pathname) Fopen(pathname, "wb")

Fclose(FILE *fp)
	winsock_fclose(fp)
	if fclose(fp) == EOF
		failed("fclose")

char *Fgets(char *s, int size, FILE *stream)
	errno = 0
	char *rv = fgets(s, size, stream)
	if errno
		failed("fgets")
	return rv

# NOTE you should reset the size of the buffer to 0
# before calling Freadline, else it will append the line to the buffer.
int Freadline(buffer *b, FILE *stream)
	ssize_t len = buffer_get_size(b)
	repeat
		char *rv = Fgets(b->start+len, buffer_get_space(b)-len, stream)
		if rv == NULL
			return EOF
		len += strlen(b->start+len)
		if b->start[len-1] == '\n'
			# chomp it - XXX should we do this?
			b->start[len-1] = '\0'
			--len
			break
		if len < buffer_get_space(b) - 1
			break
		buffer_double(b)
	buffer_set_size(b, len)
	return 0

int Readline(buffer *b)
	return Freadline(b, stdin)

def Readline() Freadline(stdin)
def Freadline(stream) Freadline_1(stream)

cstr Freadline_1(FILE *stream)
	new(b, buffer, 128)
	if Freadline(b, stream)
		buffer_free(b)
		return NULL
	return buffer_to_cstr(b)

int Printf(const char *format, ...)
	collect(Vprintf, format)
int Vprintf(const char *format, va_list ap)
	winsock_vfprintf(stdout, format, ap)
	int len = vprintf(format, ap)
	if len < 0
		failed("vprintf")
	return len

int Fprintf(FILE *stream, const char *format, ...)
	collect(Vfprintf, stream, format)
int Vfprintf(FILE *stream, const char *format, va_list ap)
	winsock_vfprintf(stream, format, ap)
	int len = vfprintf(stream, format, ap)
	if len < 0
		failed("vfprintf")
	return len

Fflush(FILE *stream)
	winsock_fflush(stream)
	if fflush(stream) != 0
		failed("fflush")

def Fflush()
	Fflush(stdout)

# don't forget to use the "b" flag, e.g. "r+b"
FILE *Fdopen(int filedes, const char *mode)
	FILE *f = fdopen(filedes, mode)
	if f == NULL
		failed("fdopen")
#	windows_setmode_binary(f)
	return f
def Fdopen(filedes) Fdopen(filedes, "r+b")

def nl(stream)
	Putc('\n', stream)
def nl()
	nl(stdout)
def nls(stream, n)
	repeat(n)
		nl(stream)
def nls(n)
	nls(stdout, n)
Nl(FILE *stream)
	nl(stream)
def Nl() Nl(stdout)

def tab(stream)
	Putc('\t', stream)
def tab()
	tab(stdout)
def tabs(stream, n)
	repeat(n)
		tab(stream)
def tabs(n)
	tabs(stdout, n)

def spc(stream)
	Putc(' ', stream)
def spc()
	spc(stdout)
def spcs(stream, n)
	repeat(n)
		spc(stream)
def spcs(n)
	spcs(stdout, n)

crlf(FILE *stream)
	Fprint(stream, "\r\n")
def crlf()
	crlf(stdout)

# like perl, Say adds a newline, Print doesn't
def Print(s)
	Fprint(stdout, s)
def Fprint(stream, s)
	Fprintf(stream, "%s", s)

def Say(s)
	Puts(s)
Puts(const char *s)
	winsock_fsay(stdout, s)
	if puts(s) < 0
		failed("puts")

Fsay(FILE *stream, const char *s)
	winsock_fsay(stream, s)
	Fputs(s, stream)
	nl(stream)

Fputs(const char *s, FILE *stream)
	winsock_fsay(stream, s)
	if fputs(s, stream) < 0
		failed("fputs")

int Sayf(const char *format, ...)
	collect(Vsayf, format)
int Vsayf(const char *format, va_list ap)
	winsock_vfsayf(stdout, format, ap)
	int len = Vprintf(format, ap)
	nl()
	return len

int Fsayf(FILE *stream, const char *format, ...)
	collect(Vfsayf, stream, format)
int Vfsayf(FILE *stream, const char *format, va_list ap)
	winsock_vfsayf(stdout, format, ap)
	int len = Vfprintf(stream, format, ap)
	nl(stream)
	return len

# TODO: improve brace so can make this var-args stuff nicer

char *Input(const char *prompt)
	return Inputf("%s", prompt)
def Input() Input("")

# XXX Inputf doesn't handle lines with '\0' in them properly
# XXX Inputf calls fgets too many times.  should use a static buffer then
# copy to return?  but it's meant for terminal input, who cares if it's slow?

char *Inputf(const char *format, ...)
	collect(Vinputf, format)
char *Vinputf(const char *format, va_list ap)
	return Vfinputf(stdin, stdout, format, ap)
char *Vfinputf(FILE *in, FILE *out, const char *format, va_list ap)
	if *format
		Vfprintf(out, format, ap)
	Fflush(out)
	
	new(b, buffer, 2)
	int rv = Freadline(b, in)
	if rv == 0
		return buffer_to_cstr(b)
	else
		buffer_free(b)
		return NULL

char *Finput(FILE *in, FILE *out, const char *prompt)
	return Finputf(in, out, "%s", prompt)
def Finput(in, out) Finput(in, out, "")

char *Finputf(FILE *in, FILE *out, const char *format, ...)
	collect(Vfinputf, in, out, format)

char *Sinput(FILE *s, const char *prompt)
	return Sinputf(s, "%s", prompt)
def Sinput(s) Sinput(s, "")

char *Sinputf(FILE *s, const char *format, ...)
	collect(Vfinputf, s, s, format)

# TODO would be good to use sscanf to scan a line?

# TODO: BelchIfChanged

DIR *Opendir(const char *name)
	DIR *d = opendir(name)
	if d == NULL
		failed("opendir")
	return d

typedef struct dirent dirent
dirent *Readdir(DIR *dir)
	errno = 0
	struct dirent *e = readdir(dir)
	if errno
		failed("readdir")
	return e

Closedir(DIR *dir)
	if closedir(dir) != 0
		failed("closedir")

def Ls-a(name) Ls(name, 1)
def Ls(name) Ls(name, 0)
vec *Ls(const char *name, int all)
	vec *v = ls(name, all)
	if !v
		failed("ls", name)
	return v

# TODO use dir->d_type ?

def ls(name) ls(name, 0)
def ls-a(name) ls(name, 1)
vec *ls(const char *name, boolean all)
	New(v, vec, cstr, 64)
	return ls_(name, all, v)

vec *ls_(const char *name, boolean all, vec *v)
	struct dirent *e
	DIR *dir = opendir(name)
	if dir == NULL
		return NULL
	repeat
		errno = 0
		e = readdir(dir)
		if errno
			Free(v)
			v = NULL
			break
		if !e
			break
		if e->d_name[0] == '.' &&
		 (!all || e->d_name[1] == '\0' ||
		  (e->d_name[1] == '.' && e->d_name[2] == '\0'))
				continue
		*(cstr*)vec_push(v) = Strdup(e->d_name)

	closedir(dir)
	return v

def slurp_lines() slurp_lines_0()
vec *slurp_lines_0()
	New(lines, vec, cstr, 256)
	return slurp_lines(lines)

vec *slurp_lines(vec *lines)
	eachline(s)
		vec_push(lines, Strdup(s))
	return lines

def lines() slurp_lines()
def lines(v) slurp_lines(v)

Remove(const char *path)
	if remove(path) != 0
		failed("remove")

int Temp(buffer *b, char *prefix, char *suffix)
	return Tempfile(b, prefix, suffix, NULL, 0, 0600)

int Tempdir(buffer *b, char *prefix, char *suffix)
	return Tempfile(b, prefix, suffix, NULL, 1, 0600)

# TODO while else, for else and do-while else loops

int Tempfile(buffer *b, char *prefix, char *suffix, char *tmpdir, int dir, int mode)
	int n_random_chars = 6
	char random[n_random_chars + 1]
	char *pathname = b->start
	if tmpdir == NULL
		tmpdir = "/tmp"
	ssize_t len = strlen(tmpdir) + 1 + strlen(prefix) + strlen(suffix) + n_random_chars + 1
	if buffer_get_space(b) < len
		buffer_set_space(b, len)
	random[n_random_chars] = '\0'
	int try
	for try=0; try < 10; ++try
		int i
		for i=0; i<n_random_chars; ++i
			random[i] = random_alphanum()
		snprintf(pathname, len, "%s/%s%s%s", tmpdir, prefix, random, suffix)
		buffer_set_size(b, strlen(pathname))
		if dir
			if mkdir(pathname, mode) == 0
				return -1
		else
			int fd = open(pathname, O_RDWR|O_CREAT|O_EXCL, mode)
			if fd >= 0
				return fd
	serror("cannot create tempfile of form %s/%sXXXXXX%s", tmpdir, prefix, suffix)
	# this is not reached, just to keep cc happy
	return -1

char random_alphanum()
	int r = randi(10 + 26 * 2)
	if r < 10
		return '0' + r
	if r < 10 + 26
		return 'A' + r - 10
	return 'a' + r - 10 - 26

# Theoretically don't need to stat a file to find out if it exists -
# (just look for the directory entry).  but no quick way to do that
# - a unix bug?

int exists(const char *file_name)
	struct stat buf
	return !stat(file_name, &buf)

int lexists(const char *file_name)
	struct stat buf
	return !lstat(file_name, &buf)

def stat_exists(st) S_EXISTS(st->st_mode)

off_t file_size(const char *file_name)
	struct stat buf
	Stat(file_name, &buf)
	return buf.st_size

off_t fd_size(int fd)
	struct stat buf
	Fstat(fd, &buf)
	return buf.st_size

# Stat returns 1 if the file exists, 0 if not
# FIXME is this ok?  not consistent with stat(2)

int Stat(const char *file_name, struct stat *buf)
	errno = 0
	int rv = stat(file_name, buf)
	if rv == 0
		return 1
	if errno == ENOENT || errno == ENOTDIR
		return 0
	failed("stat", file_name)
	# keep gcc happy
	return 0

int is_file(const char *file_name)
	struct stat buf
	return Stat(file_name, &buf) && S_ISREG(buf.st_mode)

int is_dir(const char *file_name)
	struct stat buf
	return Stat(file_name, &buf) && S_ISDIR(buf.st_mode)

int is_symlink(const char *file_name)
	struct stat buf
	return Lstat(file_name, &buf) && S_ISLNK(buf.st_mode)

int is_real_dir(const char *file_name)
	struct stat buf
	return Lstat(file_name, &buf) && S_ISDIR(buf.st_mode)

# TODO make io stateful, so use like
#   out(channel) say(...)
#   instead of e.g. Fsay(channel, ...)
#  then get rid of all the ffoo functions
#  Problem: I already used "out" and "in" for redirection of stdout, stdin
#  to a named file.
#  another problem: should save the current stream in a "process local"
#  variable I guess.  although processes should really use a different sort of
#  IO altogether.

Fstat(int filedes, struct stat *buf)
	if fstat(filedes, buf) == -1
		failed("fstat")

cx(const char *path)
	chmod_add(path, S_IXUSR | S_IXGRP | S_IXOTH)

cnotx(const char *path)
	chmod_sub(path, S_IXUSR | S_IXGRP | S_IXOTH)

chmod_add(const char *path, mode_t add_mode)
	new(s, Stats, path)
	Chmod(path, s->st_mode | add_mode)

chmod_sub(const char *path, mode_t sub_mode)
	new(s, Stats, path)
	Chmod(path, s->st_mode & ~sub_mode)

typedef struct stat stats
typedef struct stat lstats
typedef struct stat Stats
typedef struct stat Lstats

Stats_init(stats *s, const char *file_name)
	if !Stat(file_name, s)
		bzero(s)

Lstats_init(stats *s, const char *file_name)
	if !Lstat(file_name, s)
		bzero(s)

stats_init(stats *s, const char *file_name)
	if stat(file_name, s)
		bzero(s)

lstats_init(stats *s, const char *file_name)
	if lstat(file_name, s)
		bzero(s)

def S_EXISTS(m) m

int Lstat(const char *file_name, struct stat *buf)
	errno = 0
	int rv = lstat(file_name, buf)
	if rv == 0
		return 1
	if errno == ENOENT || errno == ENOTDIR
		return 0
	failed("lstat", file_name)
	# keep gcc happy
	return 0

#struct stat Stat(const char *file_name)
#	decl(s, struct stat)
#	Stat(file_name, s)
#	return struct__s
#def Stat(file_name, buf) _Stat(file_name, buf)

FILE *Popen(const char *command, const char *type)
	FILE *rv = popen(command, type)
	if rv == NULL
		failed("popen")
	return rv

int Pclose(FILE *stream)
	int rv = pclose(stream)
	if rv == -1
		failed("pclose")
	return -1

int Fgetc(FILE *stream)
	int c = fgetc(stream)
	if c == EOF && ferror(stream)
		failed("fgetc")
	return c

def Getc(c, stream)
	c = getc(stream)
	if c == EOF && ferror(stream)
		failed("getc")

def Getchar(c)
	c = getchar()
	if c == EOF && ferror(stdin)
		failed("getchar")
def Getchar()
	# this is only useful to wait for an unneeded keypress or something
	int my(c)
	Getchar(my(c))

Fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream)
	winsock_fwrite(ptr, size, nmemb, stream)
	size_t count = fwrite(ptr, size, nmemb, stream)
	if count != nmemb
		failed("fwrite")

size_t Fread(void *ptr, size_t size, size_t nmemb, FILE *stream)
	size_t count = fread(ptr, size, nmemb, stream)
	if count < nmemb && ferror(stream)
		failed("fread")
	return count

size_t Fread_all(void *ptr, size_t size, size_t nmemb, FILE *stream)
	size_t count = fread(ptr, size, nmemb, stream)
	if count < nmemb
		failed("fread")
	return count

Fwrite_str(FILE *stream, str s)
	Fwrite(s.start, str_get_size(s), 1, stream)

Fwrite_buffer(FILE *stream, buffer *b)
	Fwrite(buffer_get_start(b), buffer_get_size(b), 1, stream)

size_t Fread_buffer(FILE *stream, buffer *b)
	return Fread(buffer_get_end(b), buffer_get_free(b), 1, stream)

Fputc(int c, FILE *stream)
	winsock_putc(c, stream)
	eif fputc(c, stream) == EOF
			failed("fputc")

# TODO swap args? or an alias that has them in the right order?
def Putc(c, stream)
	winsock_putc(c, stream)
	eif putc(c, stream) == EOF
		failed("putc")

def Putchar(c)
	winsock_putc(c, stdout)
	eif putchar(c) == EOF
		failed("putchar")

Fseek(FILE *stream, long offset, int whence)
	if fseek(stream, offset, whence)
		failed("fseek")

long Ftell(FILE *stream)
	long ret = ftell(stream)
	if ret == -1
		failed("ftell")
	return ret

# these don't seem to work:
#Fseeko(FILE *stream, off_t offset, int whence)
#	if fseeko(stream, offset, whence)
#		failed("fseeko")
#
#off_t Ftello(FILE *stream)
#	off_t ret = ftello(stream)
#	if ret == -1
#		failed("ftello")
#	return ret

off_t Lseek(int fd, off_t offset, int whence)
	off_t ret = lseek(fd, offset, whence)
	if ret == -1
		failed("lseek")
	return ret

def Lseek(fd, offset) Lseek(fd, offset, SEEK_SET)

Truncate(const char *path, off_t length)
	int ret = truncate(path, length)
	if ret
		failed("truncate")

Ftruncate(int fd, off_t length)
	int ret = ftruncate(fd, length)
	if ret
		failed("ftruncate")

_Readlink(const char *path, buffer *b)
	repeat
		let(len, readlink(path, buffer_get_end(b), buffer_get_free(b)))
		if len == -1
			if errno == ENAMETOOLONG
				buffer_double(b)
			 else
				failed("readlink")
		 else
			buffer_grow(b, len)
			return

def Readlink(path, b) _Readlink(path, b), buffer_to_cstr(b)

# this returns a malloc'd cstr

cstr Readlink(const char *path)
	new(b, buffer, 256)
	return Readlink(path, b)

# readlinks must be called with a malloc'd string
# i.e. use Strdup.
# it will free it if it was a link
# the string it returns will also be malloc'd

# this does NOT necessarily resolve to the canonical name,
# it just reads links recursively

cstr readlinks(cstr path, opt_err if_dead)
#	path = Strdup(path)

	decl(stat_b, Stats)
	repeat
		if !Lstat(path, stat_b)
			return opt_err_do(if_dead, (any){.cs=path}, (any){.cs=NULL}, "file does not exist: %s", path).cs
		if !S_ISLNK(stat_b->st_mode)
			break
		let(path1, Readlink(path))
		Path_relative_to(path1, path)
		Free(path)
		path = path1
	return path

def readlinks(path) readlinks(path, OE_ERROR)

_Getcwd(buffer *b)
	repeat
		if getcwd(buffer_get_end(b), buffer_get_free(b)) == NULL
			if errno == ERANGE
				buffer_double(b)
			 else
				failed("getcwd")
		 else
			buffer_grow(b, strlen(buffer_get_end(b)))
#			if buffer_last_char(b) != '/'
#				buffer_cat_char(b, '/')
			return

Def Getcwd(b) _Getcwd(b)

# this returns a malloc'd cstr

cstr Getcwd()
	new(b, buffer, 256)
	Getcwd(b)
	return buffer_to_cstr(b)

Chdir(const char *path)
	if chdir(path) != 0
		failed("chdir", path)

Mkdir(const char *pathname, mode_t mode)
	int rv = mkdir(pathname, mode)
	if rv
		failed("mkdir", pathname)

def Mkdir(pathname) Mkdir(pathname, 0777)

Mkdir_if(const char *pathname, mode_t mode)
	if !is_dir(pathname)
		Mkdir(pathname, mode)

def Mkdir_if(pathname) Mkdir_if(pathname, 0777)

say_cstr(cstr s)
	Say(s)
	Free(s)

Rename(const char *oldpath, const char *newpath)
	if rename(oldpath, newpath) == -1
		failed("rename")

Chmod(const char *path, mode_t mode)
	if chmod(path, mode) != 0
		failed("chmod")

Symlink(const char *oldpath, const char *newpath)
	if symlink(oldpath, newpath) == -1
		failed("symlink", oldpath, newpath)

Link(const char *oldpath, const char *newpath)
	if link(oldpath, newpath) == -1
		failed("link")

Pipe(int filedes[2])
	if pipe(filedes) != 0
		failed("pipe")

int Dup(int oldfd)
	int fd = dup(oldfd)
	if fd == -1
		failed("dup")
	return fd

int Dup2(int oldfd, int newfd)
	int fd = dup2(oldfd, newfd)
	# FIXME should call close(newfd) explicitly and check for errors? nah!
	if fd == -1
		failed("dup2")
	return fd

FILE *Freopen(const char *path, const char *mode, FILE *stream);
	FILE *f = freopen(path, mode, stream)
	if f == NULL
		failed("freopen")
	return f

print_range(char *start, char *end)
	fprint_range(stdout, start, end)
fprint_range(FILE *stream, char *start, char *end)
	Fwrite(start, 1, end-start, stream)
say_range(char *start, char *end)
	fsay_range(stdout, start, end)
fsay_range(FILE *stream, char *start, char *end)
	fprint_range(stream, start, end)

stats_dump(Stats *s)
	Sayf("dev\t%d", s->st_dev)
	Sayf("ino\t%d", s->st_ino)
	Sayf("mode\t%d", s->st_mode)
	Sayf("nlink\t%d", s->st_nlink)
	Sayf("uid\t%d", s->st_uid)
	Sayf("gid\t%d", s->st_gid)
	Sayf("rdev\t%d", s->st_rdev)
	Sayf("size\t%d", s->st_size)
	
	# not in mingw
	#	Sayf("blksize\t%d", s->st_blksize)
	#	Sayf("blocks\t%d", s->st_blocks)
	
	Sayf("atime\t%d", s->st_atime)
	Sayf("mtime\t%d", s->st_mtime)
	Sayf("ctime\t%d", s->st_ctime)

mode_t mode(const char *file_name)
	new(s, Stats, file_name)
	return s->st_mode

def cp(oldpath, newpath) cp(oldpath, newpath, 0666)
cp(const char *from, const char *to, int mode)
	int in, out
	in = openin(from)
	out = openout(to, mode)
	cp_fd(in, out)
	Close(out)
	Close(in)

off_t cp_fd(int in, int out)
	char buf[4096]
	off_t count = 0
	repeat
		size_t len = Read(in, buf, sizeof(buf))
		if len == 0
			break
		Write(out, buf, len)
		count += len
	return count

fcp(FILE *in, FILE *out)
	char buf[4096]
	repeat
		size_t len = Fread(buf, 1, sizeof(buf), in)
		if len == 0
			break
		Fwrite(buf, 1, len, out)

# this can return -1 on EINTR

int Select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, num timeout)
	struct timeval timeout_tv
	int rv = select(nfds, readfds, writefds, exceptfds, delay_to_timeval(timeout, &timeout_tv))
	if rv < 0 && errno != EINTR
		failed("select")
	return rv

def Select(nfds, readfds, writefds, exceptfds) Select(nfds, readfds, writefds, exceptfds, NULL)

fd_set_init(fd_set *o)
	fd_zero(o)


def fd_clr(fd, set)
	FD_CLR(fd_to_socket(fd), set)
def fd_isset(fd, set) FD_ISSET(fd_to_socket(fd), set)
def fd_set(fd, set)
	FD_SET(fd_to_socket(fd), set)
def fd_zero(set)
	FD_ZERO(set)

fd_set *tmp_fd_set = NULL

def can_read(fd) can_read(fd, 0)
def can_write(fd) can_write(fd, 0)
def has_error(fd) has_error(fd, 0)

int can_read(int fd, num timeout)
	select_wrap(fd, tmp_fd_set, NULL, NULL, timeout)

int can_write(int fd, num timeout)
	select_wrap(fd, NULL, tmp_fd_set, NULL, timeout)

int has_error(int fd, num timeout)
	select_wrap(fd, NULL, NULL, tmp_fd_set, timeout)

def select_wrap(fd, read_fds, write_fds, except_fds, timeout)
	if !tmp_fd_set
		global(tmp_fd_set, fd_set)
	timeval tv
	rtime_to_timeval(timeout, &tv)
	fd_set(fd, tmp_fd_set)
	int n_ready = select(fd+1, read_fds, write_fds, except_fds, &tv)
	fd_clr(fd, tmp_fd_set)
	if n_ready == -1
		failed("select")
	return n_ready

def dir1rest(path, d, b)
	let(d, path)
	let(b, path)
	while path__is_sep(*b)
		++b
	while *b != '\0' && !path__is_sep(*b)
		++b
	if *b
		*b = '\0'
		++b
	 else
		b = NULL

Mkdirs(const char *pathname, mode_t mode)
	cstr my(cwd) = Getcwd()
	Mkdirs_cwd(pathname, mode, my(cwd))
	Free(my(cwd))

Mkdirs_cwd(const char *pathname, mode_t mode, cstr basedir)
	cstr dir1 = Strdup(pathname)
	cstr dir = dir1
	repeat
		dir1rest(dir, d, b)
		mkdir(d, mode)
		Chdir(d)
		if !b || !*b
			break
		dir = b
	
	Free(dir1)
	Chdir(basedir)

def Mkdirs(pathname) Mkdirs(pathname, 0777)

Rmdir(const char *pathname)
	if rmdir(pathname)
		failed("rmdir")

Rmdirs(const char *pathname)
	cstr dir = Strdup(pathname)
	repeat
		if rmdir(dir)
			break
		let(d, dir_name(dir))
		if (*d == '.' || *d == '/') && d[1] == '\0'
			break
		dir = d
	
	Free(dir)

boolean newer(const char *file1, const char *file2)
	new(s1, Stats, file1)
	new(s2, Stats, file2)
	return s1->st_mtime - s2->st_mtime > 0

lnsa(cstr from, cstr to, cstr cwd)
	cstr cwd1 = path_cat(cwd, "")
	from = path_tidy(path_relative_to(Strdup(from), cwd1))
	if is_dir(to)
		cstr from1 = Strdup(from)  # this is ugly, write a base_name which does not modify the string
		cstr to1 = path_cat(to, base_name(from1))
		Free(from1)
		remove(to1)
		Symlink(from, to1)
		Free(to1)
	 else
		remove(to)
		Symlink(from, to)
	Free(cwd1)
	Free(from)

buffer _Cp_symlink, *Cp_symlink = NULL

def Cp(from, to)
	new(my(sf), Lstats, from)
	Cp(from, to, sf)
Cp(cstr from, cstr to, Lstats *sf)
	if S_ISLNK(sf->st_mode)
		if !Cp_symlink
			Cp_symlink = &_Cp_symlink
			init(Cp_symlink, buffer, 256)
		buffer_clear(Cp_symlink)
		Symlink(Readlink(from, Cp_symlink), to)
	 eif S_ISREG(sf->st_mode)
		cp(from, to)
	 else
		warn("irregular file %s not copied", from)

def CP(from, to)
	new(my(sf), Lstats, from)
	CP(from, to, my(sf))
CP(cstr from, cstr to, Lstats *sf)
	Cp(from, to, sf)
	cp_attrs_st(sf, to)

cp_attrs(cstr from, cstr to)
	new(sf, Lstats, from)
	cp_attrs_st(sf, to)

cp_mode(Stats *sf, cstr to)
	if chmod(to, sf->st_mode)
		warn("chmod %s %0d failed", to, sf->st_mode)

Utime(const char *filename, const struct utimbuf *times)
	if utime(filename, (struct utimbuf *)times)
		failed("utime", filename)

cp_times(Lstats *sf, cstr to)
	struct utimbuf times
	times.actime = sf->st_atime
	times.modtime = sf->st_mtime
	if utime(to, &times)
		warn("utime %s failed", to)

def cp_atime(sf, to)
	new(my(st), Lstats, to)
	cp_atime(sf, to, st)
cp_atime(Lstats *sf, cstr to, Lstats *st)
	struct utimbuf times
	times.actime = sf->st_atime
	times.modtime = st->st_mtime
	Utime(to, &times)

def cp_mtime(sf, to)
	new(my(st), Lstats, to)
	cp_mtime(sf, to, st)
cp_mtime(Lstats *sf, cstr to, Lstats *st)
	struct utimbuf times
	times.actime = st->st_atime
	times.modtime = sf->st_mtime
	Utime(to, &times)

def Sayd(x) Sayf("%d", (int)x)
def Sayl(x) Sayf("%ld", (long)x)
def Sayn(x) Sayf("%f", x)
def Sayp(x) Sayf("%010p", x)
def Sayx(x) Sayf("%08lx", (long)x)
def Sayb(x) Sayf("%02x", (int)x)

def Sayd(s, x) Sayf("%s%d", s, (int)x)
def Sayl(s, x) Sayf("%s%ld", s, (long)x)
def Sayn(s, x) Sayf("%s%f", s, x)
def Sayp(s, x) Sayf("%s%010p", s, x)
def Sayx(s, x) Sayf("%s%08lx", s, (long)x)
def Sayb(s, x) Sayf("%s%02x", s, (int)x)

def Printd(x) Printf("%d", (int)x)
def Printl(x) Printf("%ld", (long)x)
def Printn(x) Printf("%f", x)
def Printp(x) Printf("%010p", x)
def Printx(x) Printf("%08lx", (long)x)
def Printb(x) Printf("%02x", (int)x)

def Printd(s, x) Printf("%s%d", s, (int)x)
def Printl(s, x) Printf("%s%ld", s, (long)x)
def Printn(s, x) Printf("%s%f", s, x)
def Printp(s, x) Printf("%s%010p", s, x)
def Printx(s, x) Printf("%s%08lx", s, (long)x)
def Printb(s, x) Printf("%s%02x", s, (int)x)

def Setvbuf(stream, mode) Setvbuf(stream, NULL, mode, 0)
Setvbuf(FILE *stream, char *buf, int mode, size_t size)
	if setvbuf(stream, buf, mode, size)
		failed("setvbuf")
def Setlinebuf(stream) Setvbuf(stream, _IOLBF)

ssize_t Readv(int fd, const struct iovec *iov, int iovcnt)
	ssize_t rv = readv(fd, iov, iovcnt)
	if rv < 0
		failed("readv")
	return rv

ssize_t Writev(int fd, const struct iovec *iov, int iovcnt)
	ssize_t rv = writev(fd, iov, iovcnt)
	if rv < 0
		failed("writev")
	return rv

def nonblock(fd) nonblock(fd, 1)

# This returns 0 for same, 1 for different

int file_cmp(cstr fa, cstr fb)
	int cmp
	new(sta, Stats, fa)
	new(stb, Stats, fb)
	if sta->st_size != stb->st_size
		return 1
	new(a, buffer, 4096)
	new(b, buffer, 4096)
	ssize_t na, nb
	int fda = open(fa)
	if fda == -1
		return 1
	int fdb = open(fb)
	if fdb == -1
		Close(fda)
		return 1
	repeat
		na = Read(fda, buf0(a), buffer_get_space(a))
		nb = Read(fdb, buf0(b), buffer_get_space(b))
		if na != nb
			cmp = 1
			break
		if memcmp(buf0(a), buf0(b), na)
			cmp = 1
			break
		if na < buffer_get_space(a)
			cmp = 0
			break
	Close(fda)
	Close(fdb)
	return cmp


create_hole(cstr file, off_t size)
	int fd = Open(file, O_WRONLY|O_CREAT|O_TRUNC)
	Ftruncate(fd, size)
	Close(fd)

insert_hole(cstr file, off_t offset, off_t size)
	int block_size = 4096
	int fd = Open(file, O_RDWR|O_CREAT)
	off_t old_size = fd_size(fd)
	off_t end = offset+size
	if end >= old_size
		Ftruncate(fd, offset)
		Ftruncate(fd, end)
	 else
		# This is designed not to use lots of extra disk space, only one block or so.
		# It reads two files backwards block by block, which might be inefficient.

		char b[block_size]
		new(temp_name, buffer, 128)
		int temp_fd = Temp(temp_name, "hole_", ".tmp")
		off_t n = (old_size - end + block_size - 1) / block_size

		back(i, n-1, -1)
			off_t from = end + i * block_size
			off_t l = block_size
			if from+l > old_size
				l = old_size - from
			Lseek(fd, from)
			Read(fd, b, block_size)
			int is_hole = 1
			for(check, 0, l)
				if b[check] != 0
					is_hole = 0
					break
			if is_hole
				Lseek(temp_fd, block_size, SEEK_CUR)
			 else
				Write(temp_fd, b, block_size)
			Ftruncate(fd, from)

		Ftruncate(fd, offset)
		Lseek(fd, end)

		# Now the tail of the file has been cut off into the temp file.
		# It is stored in reverse order, the last block of the tail is
		# stored in the first block of the temp file.

		for(i, 0, n)
			off_t from = (n-1-i) * block_size
			off_t to = end + i * block_size
			off_t l = block_size
			if to+l > old_size
				l = old_size - to
			Lseek(temp_fd, from)
			Read(temp_fd, b, block_size)
			int is_hole = 1
			for(check, 0, l)
				if b[check] != 0
					is_hole = 0
					break
			if is_hole
				Lseek(fd, l, SEEK_CUR)
			 else
				Write(fd, b, l)
			Ftruncate(temp_fd, from)

		Ftruncate(fd, imax(old_size, offset+size))

		Close(temp_fd)
		Remove(buffer_to_cstr(temp_name))

	Close(fd)

int Fileno(FILE *stream)
	int rv = fileno(stream)
	if rv < 0
		failed("fileno")
	return rv

# TODO should use try / finally here, and make it re-throw (by default?)
# TODO this will not work on mingw as it is

def stdio_redirect(stream, to_stream)
	stdio_redirect(stream, to_stream, my(real_fd), my(saved_fd), my(x))
def stdio_redirect(stream, to_stream, real_fd, saved_fd, x)
	int real_fd = Fileno(stream)
	int saved_fd
	post(x)
		Fflush(stream)
		Dup2(saved_fd, real_fd)
		Close(saved_fd)
	pre(x)
		Fflush(stream)
		saved_fd = Dup(real_fd)
		Dup2(Fileno(to_stream), real_fd)

fprint_vec_cstr(FILE *s, cstr h, vec *v)
	Fprint(s, h)
	for_vec(i, v, cstr)
		Fprintf(s, " %s", *i)
	nl(s)

def warn_vec_cstr(s, v) fprint_vec_cstr(stderr, s, v)
def print_vec_cstr(s, v) fprint_vec_cstr(stdout, s, v)

cstr read_lines(vec *lines, cstr in_file)
	FILE *in = Fopen(in_file, "r")
	cstr data = buffer_to_cstr(fslurp(in))
	Fclose(in)
	cstr l = data
	for_cstr(i, data)
		if *i == '\n'
			*i = '\0'
			vec_push(lines, l)
			l = i + 1
	return data

write_lines(vec *lines, cstr out_file)
	F_out(out_file)
		dump_lines(lines)

dump_lines(vec *lines)
	for_vec(i, lines, cstr)
		say(*i)

warn_lines(vec *lines, cstr msg)
	if msg
		warn("<< dumping lines: %s <<", msg)
	f_out(stderr)
		dump_lines(lines)
	if msg
		warn(">> done dumping lines: %s >>", msg)

Fspurt(cstr file, cstr content)
	F_out(file)
		print(content)

cstr Fslurp(cstr file)
	FILE *s = fopen(file, "rb")
	if !s
		return Strdup("")
	cstr rv = buffer_to_cstr(fslurp(s))
	Fclose(s)
	return rv

cstr dotfile(cstr f)
	return path_cat(homedir(), f)

cstr print_space = " "

def pr(type)
	.
def pr(type, a0)
	pr_^^type(a0)
	print(print_space)
def pr(type, a0, a1)
	pr(type, a0)
	pr(type, a1)
def pr(type, a0, a1, a2)
	pr(type, a0, a1)
	pr(type, a2)
def pr(type, a0, a1, a2, a3)
	pr(type, a0, a1, a2)
	pr(type, a3)
def pr(type, a0, a1, a2, a3, a4)
	pr(type, a0, a1, a2, a3)
	pr(type, a4)
def pr(type, a0, a1, a2, a3, a4, a5)
	pr(type, a0, a1, a2, a3, a4)
	pr(type, a5)
def Pr(type)
	pr(type)
	sf()
def Pr(type, a0)
	pr(type, a0)
	sf()
def Pr(type, a0, a1)
	pr(type, a0, a1)
	sf()
def Pr(type, a0, a1, a2)
	pr(type, a0, a1, a2)
	sf()
def Pr(type, a0, a1, a2, a3)
	pr(type, a0, a1, a2, a3)
	sf()
def Pr(type, a0, a1, a2, a3, a4)
	pr(type, a0, a1, a2, a3, a4)
	sf()
def Pr(type, a0, a1, a2, a3, a4, a5)
	pr(type, a0, a1, a2, a3, a4, a5)
	sf()

def pr_cstr(a0)
	pf("%s", a0)
def pr_int(a0)
	pf("%d", a0)
def pr_long(a0)
	pf("%ld", a0)
def pr_num(a0)
	pf("%f", a0)
def pr_double(a0)
	pf("%f", a0)
def pr_float(a0)
	pf("%f", a0)

def sc(type, l)
	.
def sc(type, l, a0)
	l = scan_^^type(&a0, l)
def sc(type, l, a0, a1)
	sc(type, l, a0)
	sc(type, l, a1)
def sc(type, l, a0, a1, a2)
	sc(type, l, a0, a1)
	sc(type, l, a2)
def sc(type, l, a0, a1, a2, a3)
	sc(type, l, a0, a1, a2)
	sc(type, l, a3)
def sc(type, l, a0, a1, a2, a3, a4)
	sc(type, l, a0, a1, a2, a3)
	sc(type, l, a4)
def sc(type, l, a0, a1, a2, a3, a4, a5)
	sc(type, l, a0, a1, a2, a3, a4)
	sc(type, l, a5)

def Sc(type, l)
	.
def Sc(type, l, a0)
	type a0
	sc(type, l, a0)
def Sc(type, l, a0, a1)
	Sc(type, l, a0)
	Sc(type, l, a1)
def Sc(type, l, a0, a1, a2)
	Sc(type, l, a0, a1)
	Sc(type, l, a2)
def Sc(type, l, a0, a1, a2, a3)
	Sc(type, l, a0, a1, a2)
	Sc(type, l, a3)
def Sc(type, l, a0, a1, a2, a3, a4)
	Sc(type, l, a0, a1, a2, a3)
	Sc(type, l, a4)
def Sc(type, l, a0, a1, a2, a3, a4, a5)
	Sc(type, l, a0, a1, a2, a3, a4)
	Sc(type, l, a5)

cstr scan_cstr(cstr *a, cstr l)
	*a = l
	return scan_skip(l)

cstr scan_int(int *a, cstr l)
	scan_x(int, "%d", a, l)

cstr scan_long(long *a, cstr l)
	scan_x(long, "%ld", a, l)

cstr scan_num(num *a, cstr l)
	scan_x(num, "%lf", a, l)

cstr scan_double(double *a, cstr l)
	scan_x(double, "%lf", a, l)

cstr scan_float(float *a, cstr l)
	scan_x(float, "%f", a, l)

cstr scan_skip(cstr l)
	cstr next
	while *l && !(next = is_scan_space(l))
		++l
	if *l
		*l = '\0'
		l = next
	return l

def scan_x(type, format, a, l)
	if is_scan_space(l)
		error("scan_x: found space")
	if sscanf(l, format, a) != 1
		error("scan_x: not found")
	return scan_skip(l)

cstr scan_space = NULL
cstr is_scan_space(cstr s)
	if scan_space
		return cstr_begins_with(s, scan_space)
#		return strchr(scan_space, *s) ? s+1 : NULL
	 else
		return isspace(*s) ? s+1 : NULL

do_delay(num t)
	if t
		if can_read(STDIN_FILENO, t)
			Readline()
	 else
	 	Readline()
