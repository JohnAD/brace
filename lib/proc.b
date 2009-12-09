# proc library - lightweight coroutine processes!

use sched
use error
use io
use util

#def proc_debug void
def proc_debug warn

typedef int (*proc_func)(proc *p)
struct proc
	proc_func f
	int pc
typedef proc *proc_p
proc_init(proc *p, proc_func f)
	p->f = f
	p->pc = 1

int resume(proc *p)
	proc_debug("resuming: %010p at %d", p, p->pc)
	int rv
	if p->pc == -1
		rv = 0
	 else
		rv = (*p->f)(p)
	proc_debug("resuming %010p returned: %d", p, rv)
	if rv
		p->pc = rv
	return rv

# primitives:
# start is defined in sched.b

def stop()
	return 0

def yield()
		proc_debug("yeilding")
		return b__pc_next
		b__pc_inc
	b__pc	.

def wait()
		b__p->pc = b__pc_next
		stop()
		b__pc_inc
	b__pc	.

#Def coro_f(name)
#	int name^^_f(proc *p)
#		name *d = (name *)p
#		switch p->pc
#		b__pc	.
#		.
##		...
##		stop()

def b__d(foo) This->foo

# a fancy macro to declare and init a proc
# XXX does not work if the proc init function takes arguments
Def proc(var_name, proc_name)
	proc_name var_name
	proc_name^^_init(&var_name)

# a hack to support 1,2,3 arg proc init functions
Def proc(var_name, proc_name, a1)
	proc_name var_name
	proc_name^^_init(&var_name, a1)
Def proc(var_name, proc_name, a1, a2)
	proc_name var_name
	proc_name^^_init(&var_name, a1, a2)
Def proc(var_name, proc_name, a1, a2, a3)
	proc_name var_name
	proc_name^^_init(&var_name, a1, a2, a3)

proc_dump(proc *p)
	Fprintf(stderr, "%010p(%010p %d) ", p, p->f, p->pc)

def halt(p)
	((proc*)p)->pc = -1

# XXX XXX FIXME this is a busy wait.  An on-stop hook would be better than this,
# and would also allow parallel events.
# XXX also many procs do not "stop" as such, they simply do not get scheduled
# any more as there is no more data... fix this, so can free them etc?
def await(p)
	while ((proc*)p)->pc >= 0
		yield()

# FIXME when scheduler resumes a proc, pass an event to it to indicate why it
# was awakened (e.g. port X, child process Y, proc Z, yielded, signal, ...)

# TODO maybe, use numbers 0,1,2... for ports like unix does?  not yet
