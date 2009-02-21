#  scheduler

use deq
export proc
use io
use util
use error

local deq struct__q
local deq *q

sched_init()
	q = &struct__q
	deq_init(q, proc, 8)

start_f(proc *p)
#	Fprintf(stderr, "start_f: "); proc_dump(p); nl(stderr)
	*(proc **)deq_push(q) = p

def start(coro)
	start_f(&coro->p)

run()
	while q->size
#		queue_dump(q)
		step()

step()
	proc *p = *(proc **)deq_element(q, 0)
	deq_shift(q)
	proc_debug("stepping to %08x", p)
	if resume(p)
		proc_debug("  resume %08x returned %d, enqueuing again", p, p->pc)
		start_f(p)
	else
		proc_debug("  resume %08x returned 0, p->pc is %d", p, p->pc)

def queue_dump(q)
	Fprintf(stderr, "queue dump: ")
	for(i, 0, deq_get_size(q))
		let(p, *(proc **)deq_element(q, i))
		proc_dump(p)
	nl(stderr)
