export stdio.h sys/stat.h fcntl.h unistd.h dirent.h
export winsock2.h
use stdarg.h string.h

# FD_SETSIZE is only 64 by default, let's increase that? e.g. -DFD_SETSIZE=1024

export str error buffer types
use m alloc util path net

use io

struct iovec
	void *iov_base
	size_t iov_len

# FIXME mingw doesn't have lstat (yet), and mkdir doesn't take mode,
# and missing mode stuff, etc, etc

def S_ISLNK(mode) 0
def lstat stat
def mkdir(path, mode) mkdir(path+(mode-mode))
 # this having to use all arguments thing can be annoying!
def S_IXUSR 0100
def S_IXGRP 0010
def S_IXOTH 0001
 # FIXME more?

# these are bogus

int readlink(const char *path, char *buf, size_t bufsiz)
	let(len, strlen(path))
	if len > bufsiz
		errno = ENAMETOOLONG
		return -1
	memcpy(buf, path, len)
	return len

# FIXME these are a bit bogus as theoretically they shouldn't die on an error

int link(const char *oldpath, const char *newpath)
	cp(oldpath, newpath)
	return 0

int symlink(const char *oldpath, const char *newpath)
	cp(oldpath, newpath)
	return 0

def pipe(phandles) _pipe (phandles, 4096, _O_BINARY)

int truncate(const char *path, off_t length)
	int ret
	int fd = open(path, O_RDWR)
	if fd == -1
		return -1
	ret = ftruncate(fd, length)
	if ret
		close(fd)
		return -1
	ret = close(fd)
	if ret == -1
		return -1
	return 0

# bogus lock implementation for mingw
# FIXME it probably does have a lock implementation of its own

def Lock(lockfile)
	Lock(lockfile, my(fd), my(x))

def Lock(lockfile, fd, x)
	int fd
	num delay = 0.01, maxdelay = 1
	repeat
		fd = open(lockfile, O_RDWR|O_CREAT|O_EXCL, 0777)
		if fd != -1
			break
		if errno != EEXIST
			failed("lock/open")
		Rsleep(delay)
		delay *= 2
		if delay > maxdelay
			delay = maxdelay
	post(x)
		Close(fd)
		Remove(lockfile)
	pre(x)
		.

def lock(lockfile)
	Lock(lockfile)

def lock(lockfile, fd, x)
	Lock(lockfile, fd, x)

nonblock(int fd, int nb)
	u_long _nb = nb
	if ioctlsocket(fd_to_socket(fd), FIONBIO, &_nb) == -1
		failed("ioctlsocket")

def fd_full(new_fd, set) set->fd_count >= FD_SETSIZE

#def windows_setmode_binary(f)
#	setmode(fileno(f), _O_BINARY)

ssize_t readv(int fd, const struct iovec *iov, int iovcnt)
	ssize_t rv = 0
	ssize_t c = 0
	while iovcnt
		c = read(fd, iov->iov_base, iov->iov_len)
		if c == -1
			return -1
		rv += c
		if c < (ssize_t)iov->iov_len
			break
		++iov ; --iovcnt
	return rv

ssize_t writev(int fd, const struct iovec *iov, int iovcnt)
	ssize_t rv = 0
	ssize_t c = 0
	while iovcnt
		c = write(fd, iov->iov_base, iov->iov_len)
		if c == -1
			return -1
		rv += c
		if c < (ssize_t)iov->iov_len
			break
		++iov ; --iovcnt
	return rv

cp_attrs_st(Lstats *sf, cstr to)
	if !S_ISLNK(sf->st_mode)
		cp_mode(sf, to)
	cp_times(sf, to)

# these do nothing on mingw
def cloexec(fd)
	.
def cloexec_off(fd)
	.

int Pselect(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, num timeout, const sigset_t *sigmask)
	use(sigmask)
	return Select(nfds, readfds, writefds, exceptfds, timeout)


# these are fake as mingw does not have symlinks or sockets
def S_IFLNK 0xa000
def S_IFSOCK 0xc000
