export io time selector
use m

def io_selector io_epoll

int io_epoll_size = 1024
int io_epoll_maxevents = 1024

struct io_epoll
	int epfd
	int max_fd_plus_1
	int count
	vec *events

io_epoll_init(io_epoll *io)
	io->epfd = Epoll_create(io_epoll_size)
	io->max_fd_plus_1 = 0
	io->count = 0
	NEW(io->events, vec, epoll_event, io_epoll_maxevents)

def io_epoll_fd_top(io) io->max_fd_plus_1
def io_epoll_count(io) io->count

int io_epoll_wait(io_epoll *io, num delay, sigset_t *sigmask)
	int n_ready = Epoll_pwait(io->epfd, vec0(io->events), vec_get_space(io->events), delay, sigmask)
#	warn("n_ready %d", n_ready)
	vec_set_size(io->events, imax(n_ready, 0))
	return n_ready

def io_epoll_events(io, fd, can_read, can_write, has_error)
	state int fd
	for_vec(my(e), io->events, epoll_event)
		fd = my(e)->data.fd
		state boolean can_read = my(e)->events & (EPOLLIN|EPOLLHUP)
		state boolean can_write = my(e)->events & (EPOLLOUT|EPOLLHUP)
		state boolean has_error = my(e)->events & EPOLLERR
#		warn("fd %d events %08x", fd, my(e)->events)
		unless(can_read || can_write || has_error)
			continue
		.

def io_epoll_add(io, fd) io_epoll_add(io, fd, 1)

int io_epoll_add(io_epoll *io, int fd, boolean et)
	epoll_event ev
	ev.events = (et ? EPOLLET : 0) | EPOLLIN | EPOLLOUT
	ev.data.fd = fd   # could put the proc here
	if epoll_ctl(io->epfd, EPOLL_CTL_ADD, fd, &ev) < 0
		swarning("failed epoll_ctl ADD %d", fd)
		return -1
#	io->count += 2
	if fd >= io->max_fd_plus_1
		io->max_fd_plus_1 = fd + 1
		return 1
	return 0

epoll_event io_epoll_rm__event = { 0, { .u64 = 0 } }
io_epoll_rm(io_epoll *io, int fd)
	if epoll_ctl(io->epfd, EPOLL_CTL_DEL, fd, &io_epoll_rm__event)
		swarning("failed epoll_ctl DEL %d", fd)
#	io->count -= 2

def io_epoll_read(io, fd)
	++io->count
	warn("io_epoll_read: io->count = %d", io->count)

def io_epoll_write(io, fd)
	++io->count
	warn("io_epoll_write: io->count = %d", io->count)

def io_epoll_clr_read(io, fd)
	--io->count
	warn("io_epoll_clr_read: io->count = %d", io->count)

def io_epoll_clr_write(io, fd)
	--io->count
	warn("io_epoll_clr_write: io->count = %d", io->count)

