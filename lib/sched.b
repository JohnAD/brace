#  scheduler

use deq
export proc
use io
use util
use error
export timeout

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
	int step

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
	sched->step = 0

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
	while !sched->exit
		step()
#		queue_dump(&sched->q)

int sched_delay = 0
              # = 0      # don't sleep between steps
              # = 0.01   # sleep for 0.01 secs between steps

int sched_busy = 16
             # = 0       # check IO only when no procs queued
             # = 1       # check IO at every step
             # = n       # check IO when no procs queued or every n steps

# sched->now is set to the startup time, or the time after the last select
# If you need more precise timing, call rtime() yourself.

def delay_forever -1

step()
	struct timeval struct__delay_tv, *delay_tv = &struct__delay_tv
	int need_select
	num delay
	int n_ready = 0

	if sched->q.size
		delay = sched_delay
	 eif !timeouts_empty(&sched->tos)
		sched->now = rtime()
		delay = timeouts_delay(&sched->tos, sched->now)
	 else
		delay = delay_forever

	if delay == delay_forever && sched->io_wait_count == 0
		sched->exit = 1
		return

	need_select = delay ||
	 (sched_busy && sched->io_wait_count && sched->step % sched_busy == 0)

	if need_select
		if delay == delay_forever
			delay_tv = NULL
		 else
			rtime_to_timeval(delay, delay_tv)
		sched->readfds_ready = sched->readfds
		sched->writefds_ready = sched->writefds
		sched->exceptfds_ready = sched->exceptfds
		proc_debug("calling select on %d waiters for %f secs", sched->io_wait_count, delay)
		proc_debug_selectors()
		n_ready = Select(sched->max_fd_plus_1, &sched->readfds_ready, &sched->writefds_ready, &sched->exceptfds_ready, delay_tv)
		proc_debug("select done")
		sched->now = rtime()

	if !timeouts_empty(&sched->tos)
		timeouts_call(&sched->tos, sched->now)

	if n_ready
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
				proc_debug("fd %d ready to read - resuming %08x", fd, p)
				sched_resume(p)
			if can_write && fd_alive(fd)
				clr_writer(fd)
				proc *p = *(proc **)vec_element(&sched->writers, fd)
				proc_debug("fd %d ready to write - resuming %08x", fd, p)
				sched_resume(p)

	if sched->q.size
		proc *p = *(proc **)deq_element(&sched->q, 0)
		deq_shift(&sched->q)
		proc_debug("resuming %08x", p)
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
		proc_debug("  resume %08x returned %d, enqueuing again", p, p->pc)
		start_f(p)
	 else
		proc_debug("  resume %08x returned 0, stopped", p)

def sched_dump(&sched->q)
	Fprintf(stderr, "queue dump: ")
	for(i, 0, deq_get_size(&sched->q))
		let(p, *(proc **)deq_element(&sched->q, i))
		proc_dump(p)
	nl(stderr)

def add_fd(fd)
	scheduler_add_fd(sched, fd)

scheduler_add_fd(scheduler *sched, int fd)
	fd_set(fd, &sched->exceptfds)
	if fd >= sched->max_fd_plus_1
		sched->max_fd_plus_1 = fd + 1
	vec_ensure_size(&sched->readers, fd+1)
	vec_ensure_size(&sched->writers, fd+1)

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
