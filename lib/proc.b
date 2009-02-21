# proc library - lightweight coroutine processes!

use sched
use error
use io
use util

typedef int (*proc_func)(proc *p)
struct proc
	proc_func f
	int pc
proc_init(proc *p, proc_func f)
	p->f = f
	p->pc = 1

def proc_debug void

int resume(proc *p)
	proc_debug("resuming: %08x at %d", p, p->pc)
	int rv = (*p->f)(p)
	proc_debug("resuming %08x returned: %d", p, rv)
	if rv
		p->pc = rv
	return rv

# primitives:
# start is defined in sched.b

def stop
	return 0

def yield
		proc_debug("yeilding")
		return b__pc_next
		b__pc_inc
	b__pc	.

def wait
		b__p->pc = b__pc_next
		stop
		b__pc_inc
	b__pc	.

#Def coro_f(name)
#	int name^^_f(proc *p)
#		name *d = (name *)p
#		switch p->pc
#		b__pc	.
#		.
##		...
##		stop

def b__d(foo) b__P->foo

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
	Fprintf(stderr, "%08x(%08x %d) ", p, p->f, p->pc)
