export io time selector

def io_selector io_select

struct io_select
	fd_set readfds, writefds, exceptfds
	fd_set readfds_ready, writefds_ready, exceptfds_ready
	int max_fd_plus_1
	int count

io_select_init(io_select *io)
	init(&io->readfds, fd_set)
	init(&io->writefds, fd_set)
	init(&io->exceptfds, fd_set)
	io->max_fd_plus_1 = 0
	io->count = 0

def io_select_fd_top(io) io->max_fd_plus_1
def io_select_count(io) io->count

int io_select_wait(io_select *io, num delay, sigset_t *sigmask)
	io->readfds_ready = io->readfds
	io->writefds_ready = io->writefds
	io->exceptfds_ready = io->exceptfds
	int n_ready = Pselect(io->max_fd_plus_1, &io->readfds_ready, &io->writefds_ready, &io->exceptfds_ready, delay, sigmask)
	return n_ready

def io_select_events(io, fd, can_read, can_write, has_error)
	state int fd
	for fd=0; fd < io_select_fd_top(io); ++fd
		if !io_select_exists(io, fd)
			continue
		state boolean can_read = io_select_can_read(io, fd)
		state boolean can_write = io_select_can_write(io, fd)
		state boolean has_error = io_select_has_error(io, fd)
		unless(can_read || can_write || has_error)
			continue
		.

# TODO for select, could try fds in order of expected matches, i.e.
# ones with most recent IO first, and quit when n_ready == 0

def io_select_exists(io, fd) fd_isset(fd, &io->exceptfds)

def io_select_add(io, fd) io_select_add(io, fd, 0)

int io_select_add(io_select *io, int fd, boolean et)
	use(et)  # ignored
	if io_select_full(io, fd)
		return -1
	fd_set(fd, &io->exceptfds)
	if fd >= io->max_fd_plus_1
		io->max_fd_plus_1 = fd + 1
		return 1
	return 0

io_select_rm(io_select *io, int fd)
	if fd_isset(fd, &io->readfds)
		io_select_clr_read(io, fd)
	if fd_isset(fd, &io->writefds)
		io_select_clr_write(io, fd)
	fd_clr(fd, &io->exceptfds)

def io_select_read(io, fd)
	fd_set(fd, &io->readfds)
	++io->count

def io_select_write(io, fd)
	fd_set(fd, &io->writefds)
	++io->count

def io_select_clr_read(io, fd)
	fd_clr(fd, &io->readfds)
	--io->count

def io_select_clr_write(io, fd)
	fd_clr(fd, &io->writefds)
	--io->count

# internal methods

def io_select_can_read(io, fd) fd_isset(fd, &io->readfds_ready)
def io_select_can_write(io, fd) fd_isset(fd, &io->writefds_ready)
def io_select_has_error(io, fd) fd_isset(fd, &io->exceptfds_ready)

def io_select_full(io, fd) fd_full(fd, &io->exceptfds)
