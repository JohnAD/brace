export sys/select.h poll.h

export error types
use util

typedef struct pollfd pollfd

int Poll(struct pollfd *fds, nfds_t nfds, int timeout)
	int rv = poll(fds, nfds, timeout)
	if rv == -1
		failed("poll")
	return rv

def Poll(fds, nfds) Poll(fds, nfds, -1)

#int Ppoll(struct pollfd *fds, nfds_t nfds, const struct timespec *timeout, const sigset_t *sigmask)
#	int rv = ppoll(fds, nfds, timeout, sigmask)
#	if rv == -1
#		failed("ppoll")
#	return rv

#def Ppoll(fds, nfds, timeout) Ppoll(fds, nfds, timeout, NULL)
#def Ppoll(fds, nfds) Ppoll(fds, nfds, NULL, NULL)

nonblock(int fd)
	if fcntl(fd, F_SETFL, O_NONBLOCK) == -1
		failed("fcntl")

int Fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len)
	struct flock fl
	fl.l_type = type
	fl.l_whence = whence
	fl.l_start = start
	fl.l_len = len
	int rv = fcntl(fd, cmd, &fl)
	if rv == -1
		failed("fcntl flock")
	return rv

def wrlck(fd) Fcntl_flock(fd, F_SETLKW, F_WRLCK, SEEK_SET, 0, 0)
def rdlck(fd) Fcntl_flock(fd, F_SETLKW, F_RDLCK, SEEK_SET, 0, 0)
def unlck(fd) Fcntl_flock(fd, F_SETLKW, F_UNLCK, SEEK_SET, 0, 0)

def wrlck_nb(fd) Fcntl_flock(fd, F_SETLK, F_WRLCK, SEEK_SET, 0, 0)
def rdlck_nb(fd) Fcntl_flock(fd, F_SETLK, F_RDLCK, SEEK_SET, 0, 0)
def unlck_nb(fd) Fcntl_flock(fd, F_SETLK, F_UNLCK, SEEK_SET, 0, 0)

def lock(lockfile)
	lock(lockfile, my(fd), my(x))

def lock(lockfile, fd, x)
	int fd = Open(lockfile, O_RDWR|O_CREAT, 0777)
	wrlck(fd)
	post(x)
		remove(lockfile)
		unlck(fd)
		Close(fd)
	pre(x)
		.

def fd_full(new_fd, set) new_fd >= FD_SETSIZE

#def windows_setmode_binary(f)
#	void(f)
