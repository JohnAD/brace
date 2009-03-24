export sys/select.h poll.h sys/ioctl.h

export error types
use util

int Pselect(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, const struct timespec *timeout, const sigset_t *sigmask)
	int rv = pselect(nfds, readfds, writefds, exceptfds, timeout, sigmask)
	if rv == -1 && errno != EINTR
		failed("pselect")
	return rv

typedef struct pollfd pollfd

int Poll(struct pollfd *fds, nfds_t nfds, int timeout)
	int rv = poll(fds, nfds, timeout)
	if rv == -1 && errno != EINTR
		failed("poll")
	return rv

def Poll(fds, nfds) Poll(fds, nfds, -1)

#int Ppoll(struct pollfd *fds, nfds_t nfds, const struct timespec *timeout, const sigset_t *sigmask)
#	int rv = ppoll(fds, nfds, timeout, sigmask)
#	if rv == -1 && errno != EINTR
#		failed("ppoll")
#	return rv

nonblock(int fd, int nb)
	if ioctl(fd, FIONBIO, &nb) == -1
		failed("ioctl")

#nonblock(int fd)
#	Fcntl_setfl(fd, Fcntl_getfl(fd) | O_NONBLOCK)
#nonblock_off(int fd)
#	Fcntl_setfl(fd, Fcntl_getfl(fd) & ~O_NONBLOCK)

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

int Fcntl_getfd(int fd)
	int rv = fcntl(fd, F_GETFD)
	if rv == -1
		error("fcntl_getfd")
	return rv

Fcntl_setfd(int fd, long arg)
	int rv = fcntl(fd, F_SETFD, arg)
	if rv == -1
		error("fcntl_setfd")

int Fcntl_getfl(int fd)
	int rv = fcntl(fd, F_GETFL)
	if rv == -1
		error("fcntl_getfl")
	return rv

Fcntl_setfl(int fd, long arg)
	int rv = fcntl(fd, F_SETFL, arg)
	if rv == -1
		error("fcntl_setfl")

#cloexec(int fd)
#	Fcntl_setfd(fd, Fcntl_getfd(fd) | FD_CLOEXEC)
#cloexec_off(int fd)
#	Fcntl_setfd(fd, Fcntl_getfd(fd) & ~FD_CLOEXEC)

# the following assumes no other flag exists / is set except FD_CLOEXEC
cloexec(int fd)
	Fcntl_setfd(fd, FD_CLOEXEC)
cloexec_off(int fd)
	Fcntl_setfd(fd, 0)
