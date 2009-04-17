export stdio.h sys/stat.h fcntl.h unistd.h dirent.h
export winsock2.h
use stdarg.h string.h

# FD_SETSIZE is only 64 by default, let's increase that? e.g. -DFD_SETSIZE=1024

export str error buffer types
use m alloc util path net

use io

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

def lock(lockfile)
	lock(lockfile, my(fd), my(x))

def lock(lockfile, fd, x)
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

nonblock(int fd, u_long nb)
	if ioctlsocket(fd_to_socket(fd), FIONBIO, &nb) == -1
		failed("ioctlsocket")

def fd_full(new_fd, set) set->fd_count >= FD_SETSIZE

#def windows_setmode_binary(f)
#	setmode(fileno(f), _O_BINARY)
