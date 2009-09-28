#  scheduler

export proc time timeout selector
use deq io error process hash
use sched

#def io_selector io_epoll
#def io_selector io_select

num sched_delay = 0
    # = 0      # don't sleep between steps
    # = 0.01   # sleep for 0.01 secs at each IO check / wait

int sched_busy = 16
    # = 0       # check IO / wait only when no procs queued
    # = 1       # check IO / wait at every step
    # = n       # check IO / wait when no queue or every n steps

int sched__children_n_buckets = 1009

struct scheduler
	int exit
	deq q
	io_selector io
	vec readers
	vec writers
	num now
	timeouts tos
	hashtable children
	int step
	int n_children
	int got_sigchld

scheduler struct__sched, *sched = &struct__sched

def sched_init()
	scheduler_init(sched)

scheduler_init(scheduler *sched)
	sched->exit = 0
	init(&sched->q, deq, proc_p, 8)
	init(&sched->io, io_selector)
	init(&sched->readers, vec, proc_p, 8)
	init(&sched->writers, vec, proc_p, 8)
	sched->now = -1
	init(&sched->tos, timeouts)
	init(&sched->children, hashtable, int_hash, int_eq, sched__children_n_buckets)
	sched->step = 0
	sched->n_children = 0
	sched->got_sigchld = 0
	set_child_handler(sigchld_handler)

def sched_free()
	scheduler_free(sched)

scheduler_free(scheduler *sched)
	deq_free(&sched->q)
	vec_free(&sched->readers)
	vec_free(&sched->writers)
	timeouts_free(&sched->tos)

start_f(proc *p)
#	Fprintf(stderr, "start_f: "); proc_dump(p); nl(stderr)
	*(proc **)deq_push(&sched->q) = p

def start(coro)
	start_f(&coro->p)

run()
	sched->exit = 0
	while !sched->exit
		step()
#		queue_dump(&sched->q)

step()
	int need_select
	num delay
	int n_ready = 0
	io_selector *io = &sched->io
	timeouts *tos = &sched->tos

	if !timeouts_empty(tos)
		delay = timeouts_delay(tos, sched_get_time())
	 eif sched->q.size
		delay = io_count(io) ? sched_delay : 0
	 else
		delay = time_forever

	if delay == time_forever && io_count(io) == 0 && sched->n_children == 0
		sched->exit = 1
		return

	need_select = delay ||
	 (sched_busy && io_count(io) && sched->step % sched_busy == 0)

	sigset_t oldsigmask, *oldsigmaskp = NULL

	int got_sigchld = 0

	if need_select
		if sched->n_children
			oldsigmaskp = &oldsigmask
			if sched_sig_child_exited(oldsigmaskp)
				delay = 0
		proc_debug("polling %d waiters for %f secs", io_count(io), delay)
#		proc_debug_selectors()

		n_ready = io_wait(io, delay, oldsigmaskp)
		sched_forget_time()

		proc_debug("polling done")

		if sched->n_children
			if sched_sig_child_exited_2(oldsigmaskp)
				got_sigchld = 1

	if got_sigchld
		pid_t pid
		while sched->n_children && (pid = Child_done())
			proc *p = get(&sched->children, pid)
			if p
				clr_waitchild(pid)
				waitchild__pid = pid
				waitchild__status = wait__status
				proc_debug("child %d finished - resuming %010p", pid, p)
				sched_resume(p)
			 else
				warn("no waiter for child %d", pid)

	# TODO test timeouts, modify to work with procs directly?
	if !timeouts_empty(tos)
		timeouts_call(tos, sched_get_time())

	if n_ready > 0
		io_events(io, fd, can_read, can_write, has_error)
			if has_error
				# XXX how to handle errors properly?
				# I think it might be better if I just ignore errors,
				# and let them fall through to read / write / whatever
				errno = Getsockerr(fd)
				if !among(errno, ECONNRESET, EPIPE)
					swarning("sched: fd %d has an error", fd)
#				fd_has_error(fd)
#				continue
			if can_read
				proc *p = *(proc **)vec_element(&sched->readers, fd)
				clr_reader(fd)
				proc_debug("fd %d ready to read - resuming %010p", fd, p)
				if p
					sched_resume(p)
			if can_write
				proc *p = *(proc **)vec_element(&sched->writers, fd)
				clr_writer(fd)
				proc_debug("fd %d ready to write - resuming %010p", fd, p)
				if p
					sched_resume(p)

	if sched->q.size
		proc *p = *(proc **)deq_element(&sched->q, 0)
		deq_shift(&sched->q)
		proc_debug("resuming %010p", p)
		sched_resume(p)

	++sched->step

#def proc_debug_selectors()
#	for(fd, 0, io_fd_top(io))
#		if fd_isset(fd, &sched->readfds)
#			proc_debug("wantread %d", fd)
#		if fd_isset(fd, &sched->writefds)
#			proc_debug("wantwrite %d", fd)
#		if fd_isset(fd, &sched->exceptfds)
#			proc_debug("wantexcept %d", fd)

#def fd_alive(fd) io_exists(&sched->io, fd)   # FIXME

def sched_resume(p)
	if resume(p)
		proc_debug("  resume %010p returned %d, enqueuing again", p, p->pc)
		start_f(p)
	 else
		proc_debug("  resume %010p returned 0, stopped", p)

def sched_dump(&sched->q)
	Fprintf(stderr, "queue dump: ")
	for(i, 0, deq_get_size(&sched->q))
		let(p, *(proc **)deq_element(&sched->q, i))
		proc_dump(p)
	nl(stderr)

def add_fd(fd) add_fd(fd, 1)
def add_fd(fd, et) scheduler_add_fd(sched, fd, et)

int scheduler_add_fd(scheduler *sched, int fd, int et)
	int rv = io_add(&sched->io, fd, et)
	if rv == 1
		vec_ensure_size(&sched->readers, fd+1)
		vec_ensure_size(&sched->writers, fd+1)
		rv = 0
	if rv == 0
		scheduler_clr(sched, fd)
	return rv

def rm_fd(fd)
	scheduler_rm_fd(sched, fd)

def scheduler_rm_fd(sched, fd)
	io_rm(&sched->io, fd)
	scheduler_clr(sched, fd)

def scheduler_clr(sched, fd)
	*(proc **)vec_element(&sched->readers, fd) = NULL
	*(proc **)vec_element(&sched->writers, fd) = NULL

fd_has_error(int fd)
	rm_fd(fd)
	close(fd)

def read(fd)
		set_reader(fd, b__p)
		wait

def write(fd)
		set_writer(fd, b__p)
		wait

set_reader(int fd, proc *p)
	proc_debug("set_reader %d", fd)
#	assert(!fd_isset(fd, &sched->readfds), "set_reader: reader already set")
	*(proc**)vec_element(&sched->readers, fd) = p
	io_read(&sched->io, fd)

set_writer(int fd, proc *p)
	proc_debug("set_writer %d", fd)
#	assert(!fd_isset(fd, &sched->writefds), "set_writer: writer already set")
	*(proc**)vec_element(&sched->writers, fd) = p
	io_write(&sched->io, fd)

clr_reader(int fd)
#	assert(fd_isset(fd, &sched->readfds), "clr_reader: reader not set")
	*(proc**)vec_element(&sched->readers, fd) = NULL
	io_clr_read(&sched->io, fd)

clr_writer(int fd)
#	assert(fd_isset(fd, &sched->writefds), "clr_writer: writer not set")
	*(proc**)vec_element(&sched->writers, fd) = NULL
	io_clr_write(&sched->io, fd)

pid_t waitchild__pid
int waitchild__status

def waitchild(pid, status)
		set_waitchild(pid, b__p)
		wait
		status = waitchild__status

# waitchild(0) or waitchild(-1) do not work yet

set_waitchild(pid_t pid, proc *p)
	proc_debug("set_waitchild %d", pid, p)
	assert(get(&sched->children, pid) == NULL, "set_waitchild: waiter already set")
	put(&sched->children, pid, p)
	++sched->n_children

clr_waitchild(pid_t pid)
	proc_debug("clr_waitchild %d", pid)
	key_value kv = del(&sched->children, pid)
	--sched->n_children

sigchld_handler(int signum)
	use(signum)
	sched->got_sigchld = 1

num sched_get_time()
	if sched->now < 0
		sched_set_time()
	return sched->now

# You should call sched_forget_time after anything that is likely to be slow.
# sched calls it after pselect returns

sched_forget_time()
	sched->now = -1

sched_set_time()
	sched->now = rtime()

def sched_exit()
	sched->exit = 1
