#  scheduler

export proc
export timeout

use deq
use io
use util
use error
use process
use hash

int sched__children_n_buckets = 1009

struct scheduler
	int exit
	deq q
	fd_set readfds, writefds, exceptfds
	fd_set readfds_ready, writefds_ready, exceptfds_ready
	int max_fd_plus_1
	vec readers
	vec writers
	int io_wait_count
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
	deq_init(&sched->q, proc_p, 8)
	init(&sched->readfds, fd_set)
	init(&sched->writefds, fd_set)
	init(&sched->exceptfds, fd_set)
	init(&sched->readfds_ready, fd_set)
	init(&sched->writefds_ready, fd_set)
	init(&sched->exceptfds_ready, fd_set)
	sched->max_fd_plus_1 = 0
	init(&sched->readers, vec, proc_p, 8)
	init(&sched->writers, vec, proc_p, 8)
	sched->io_wait_count = 0
	sched->now = rtime()
	init(&sched->tos, timeouts)
	init(&sched->children, hashtable, int_hash, (eq_func)int_eq, sched__children_n_buckets)
	sched->step = 0
	sched->n_children = 0
	sched->got_sigchld = 0
	Sigact(SIGCHLD, sigchld_handler)

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

num sched_delay = 0
              # = 0      # don't sleep between steps
              # = 0.01   # sleep for 0.01 secs at each IO check

int sched_busy = 16
             # = 0       # check IO only when no procs queued
             # = 1       # check IO at every step
             # = n       # check IO when no procs queued or every n steps

# sched->now is set to the startup time, or the time after the last select
# If you need more precise timing, call rtime() again.

def delay_forever -1

step()
	struct timespec struct__delay_ts, *delay_ts = &struct__delay_ts
	int need_select
	num delay
	int n_ready = 0

	if !timeouts_empty(&sched->tos)
		sched->now = rtime()
		delay = timeouts_delay(&sched->tos, sched->now)
	 eif sched->q.size
		delay = sched->io_wait_count ? sched_delay : 0
	 else
		delay = delay_forever

	if delay == delay_forever && sched->io_wait_count == 0 && sched->n_children == 0
		sched->exit = 1
		return

	need_select = delay ||
	 (sched_busy && sched->io_wait_count && sched->step % sched_busy == 0)

	sigset_t oldsigmask, *oldsigmaskp = &oldsigmask

	int got_sigchld = 0

	if need_select
		if sched->n_children
			oldsigmask = Sig_defer(SIGCHLD)
			if sched->got_sigchld
				delay = 0
		 else
			oldsigmaskp = NULL
		if delay == delay_forever
			delay_ts = NULL
		 else
			rtime_to_timespec(delay, delay_ts)
		sched->readfds_ready = sched->readfds
		sched->writefds_ready = sched->writefds
		sched->exceptfds_ready = sched->exceptfds
		proc_debug("calling select on %d waiters for %f secs, max_fd_plus_1 is %d", sched->io_wait_count, delay, sched->max_fd_plus_1)
#		proc_debug_selectors()
		n_ready = Pselect(sched->max_fd_plus_1, &sched->readfds_ready, &sched->writefds_ready, &sched->exceptfds_ready, delay_ts, oldsigmaskp)
		proc_debug("select done")
		sched->now = rtime()
		if sched->n_children
			if sched->got_sigchld
				got_sigchld = 1
				sched->got_sigchld = 0
			Sig_setmask(&oldsigmask)

	if got_sigchld
		while sched->n_children
			pid_t pid = Child_done()
			if !pid
				break
			proc *p = get(&sched->children, &pid)
			if p
				clr_waitchild(pid)
				waitchild__pid = pid
				waitchild__status = wait__status
				proc_debug("child %d finished - resuming %010p", pid, p)
				sched_resume(p)
			 else
				error("no waiter for child %d", pid)

	# TODO test timeouts, modify to work with procs directly?
	if !timeouts_empty(&sched->tos)
		timeouts_call(&sched->tos, sched->now)

	if n_ready > 0
		int fd
		for fd=0; fd < sched->max_fd_plus_1; ++fd
			int can_read = fd_isset(fd, &sched->readfds_ready)
			int can_write = fd_isset(fd, &sched->writefds_ready)
			int has_error = fd_isset(fd, &sched->exceptfds_ready)
			if has_error
				# XXX how to handle errors properly?
				warn("sched: fd %d has an error - closing", fd)
				fd_has_error(fd)
			if can_read && fd_alive(fd)
				clr_reader(fd)
				proc *p = *(proc **)vec_element(&sched->readers, fd)
				proc_debug("fd %d ready to read - resuming %010p", fd, p)
				sched_resume(p)
			if can_write && fd_alive(fd)
				clr_writer(fd)
				proc *p = *(proc **)vec_element(&sched->writers, fd)
				proc_debug("fd %d ready to write - resuming %010p", fd, p)
				sched_resume(p)

	if sched->q.size
		proc *p = *(proc **)deq_element(&sched->q, 0)
		deq_shift(&sched->q)
		proc_debug("resuming %010p", p)
		sched_resume(p)

	++sched->step

def proc_debug_selectors()
	for(fd, 0, sched->max_fd_plus_1)
		if fd_isset(fd, &sched->readfds)
			proc_debug("wantread %d", fd)
		if fd_isset(fd, &sched->writefds)
			proc_debug("wantwrite %d", fd)
		if fd_isset(fd, &sched->exceptfds)
			proc_debug("wantexcept %d", fd)

def fd_alive(fd) fd_isset(fd, &sched->exceptfds)

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

def add_fd(fd) scheduler_add_fd(sched, fd)

int scheduler_add_fd(scheduler *sched, int fd)
	if sched_io_full(fd)
		return 1
	fd_set(fd, &sched->exceptfds)
	if fd >= sched->max_fd_plus_1
		sched->max_fd_plus_1 = fd + 1
	vec_ensure_size(&sched->readers, fd+1)
	vec_ensure_size(&sched->writers, fd+1)
	return 0

def rm_fd(fd)
	scheduler_rm_fd(sched, fd)

scheduler_rm_fd(scheduler *sched, int fd)
	if fd_isset(fd, &sched->readfds)
		clr_reader(fd)
	if fd_isset(fd, &sched->writefds)
		clr_writer(fd)
	fd_clr(fd, &sched->exceptfds)

fd_has_error(int fd)
	close(fd)
	rm_fd(fd)

def read(fd)
		set_reader(fd, b__p)
		wait

def write(fd)
		set_writer(fd, b__p)
		wait

set_reader(int fd, proc *p)
	proc_debug("set_reader %d", fd)
	assert(!fd_isset(fd, &sched->readfds), "set_reader: reader already set")
	*(proc**)vec_element(&sched->readers, fd) = p
	fd_set(fd, &sched->readfds)
	++sched->io_wait_count

set_writer(int fd, proc *p)
	proc_debug("set_writer %d", fd)
	assert(!fd_isset(fd, &sched->writefds), "set_writer: writer already set")
	*(proc**)vec_element(&sched->writers, fd) = p
	fd_set(fd, &sched->writefds)
	++sched->io_wait_count

clr_reader(int fd)
	proc_debug("clr_reader %d", fd)
	assert(fd_isset(fd, &sched->readfds), "clr_reader: reader not set")
	fd_clr(fd, &sched->readfds)
	--sched->io_wait_count

clr_writer(int fd)
	proc_debug("clr_writer %d", fd)
	assert(fd_isset(fd, &sched->writefds), "clr_writer: writer not set")
	fd_clr(fd, &sched->writefds)
	--sched->io_wait_count

def sched_io_full(fd) fd_full(fd, &sched->exceptfds)

pid_t waitchild__pid
int waitchild__status

def waitchild(pid, status)
		set_waitchild(pid, b__p)
		wait
		status = waitchild__status

# waitchild(0) or waitchild(-1) do not work yet

set_waitchild(pid_t pid, proc *p)
	proc_debug("set_waitchild %d", pid, p)
	assert(get(&sched->children, &pid) == NULL, "set_waitchild: waiter already set")
	pid_t *pidp = Talloc(pid_t)
	*pidp = pid
	put(&sched->children, pidp, p)
	++sched->n_children

clr_waitchild(pid_t pid)
	proc_debug("clr_waitchild %d", pid)
	key_value kv = del(&sched->children, &pid)
	Free(kv.key)
	--sched->n_children

void sigchld_handler(int signum)
	use(signum)
	sched->got_sigchld = 1
