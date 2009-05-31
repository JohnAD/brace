export sys/select.h poll.h sys/ioctl.h sys/socket.h

export error types process
use util

# this can return -1 on EINTR

int Pselect(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, num timeout, const sigset_t *sigmask)
	struct timespec timeout_ts
	int rv = pselect(nfds, readfds, writefds, exceptfds, delay_to_timespec(timeout, &timeout_ts), sigmask)
	if rv < 0 && errno != EINTR
		failed("pselect")
	return rv

typedef struct pollfd pollfd

int Poll(struct pollfd *fds, nfds_t nfds, num timeout)
	int rv = poll(fds, nfds, delay_to_ms(timeout))
	if rv == -1 && errno != EINTR
		failed("poll")
	return rv

def Poll(fds, nfds) Poll(fds, nfds, -1)

#int Ppoll(struct pollfd *fds, nfds_t nfds, num timeout, const sigset_t *sigmask)
#	struct timespec timeout_ts
#	int rv = ppoll(fds, nfds, delay_to_timespec(timeout, &timeout_ts), sigmask)
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

int fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len)
	struct flock fl
	fl.l_type = type
	fl.l_whence = whence
	fl.l_start = start
	fl.l_len = len
	int rv = fcntl(fd, cmd, &fl)
	return rv

int Fcntl_flock(int fd, int cmd, short type, short whence, off_t start, off_t len)
	int rv = fcntl_flock(fd, cmd, type, whence, start, len)
	if rv == -1
		failed("fcntl flock")
	return rv

def wrlck(fd) fcntl_flock(fd, F_SETLKW, F_WRLCK, SEEK_SET, 0, 0)
def rdlck(fd) fcntl_flock(fd, F_SETLKW, F_RDLCK, SEEK_SET, 0, 0)
def unlck(fd) fcntl_flock(fd, F_SETLKW, F_UNLCK, SEEK_SET, 0, 0)

def wrlck_nb(fd) fcntl_flock(fd, F_SETLK, F_WRLCK, SEEK_SET, 0, 0)
def rdlck_nb(fd) fcntl_flock(fd, F_SETLK, F_RDLCK, SEEK_SET, 0, 0)
def unlck_nb(fd) fcntl_flock(fd, F_SETLK, F_UNLCK, SEEK_SET, 0, 0)

def Wrlck(fd) Fcntl_flock(fd, F_SETLKW, F_WRLCK, SEEK_SET, 0, 0)
def Rdlck(fd) Fcntl_flock(fd, F_SETLKW, F_RDLCK, SEEK_SET, 0, 0)
def Unlck(fd) Fcntl_flock(fd, F_SETLKW, F_UNLCK, SEEK_SET, 0, 0)

def Wrlck_nb(fd) Fcntl_flock(fd, F_SETLK, F_WRLCK, SEEK_SET, 0, 0)
def Rdlck_nb(fd) Fcntl_flock(fd, F_SETLK, F_RDLCK, SEEK_SET, 0, 0)
def Unlck_nb(fd) Fcntl_flock(fd, F_SETLK, F_UNLCK, SEEK_SET, 0, 0)

def Lock(lockfile)
	Lock(lockfile, my(fd), my(x))

def Lock(lockfile, fd, x)
	int fd = Open(lockfile, O_RDWR|O_CREAT, 0777)
	Wrlck(fd)
	post(x)
		Remove(lockfile)
		Unlck(fd)
		Close(fd)
	pre(x)
		.

def lock(lockfile)
	lock(lockfile, my(fd), my(x))

def lock(lockfile, fd, x)
	int fd = open(lockfile, O_RDWR|O_CREAT, 0777)
	if fd >= 0
		Wrlck(fd)
	post(x)
		if fd >= 0
			remove(lockfile)
			unlck(fd)
			close(fd)
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

def mkdir(pathname) mkdir(pathname, 0777)

Chown(const char *path, uid_t uid, gid_t gid)
	if chown(path, uid, gid) != 0
		failed("chown")

Lchown(const char *path, uid_t uid, gid_t gid)
	if lchown(path, uid, gid) != 0
		failed("lchown")

cp_attrs_st(Lstats *sf, cstr to)
	if !S_ISLNK(sf->st_mode)
		cp_mode(sf, to)
	if Getuid() == uid_root
		cp_owner(sf, to)
	cp_times(sf, to)

cp_owner(Lstats *sf, cstr to)
	if chown(to, sf->st_uid, sf->st_gid)
		warn("chown %s %0d:%0d failed", to, sf->st_uid, sf->st_gid)

def Socketpair(sv[2]) Socketpair(AF_UNIX, SOCK_STREAM, 0, sv)
Socketpair(int d, int type, int protocol, int sv[2])
	if socketpair(d, type, protocol, sv) != 0
		failed("socketpair")
