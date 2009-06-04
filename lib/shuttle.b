export proc
use stdlib.h
 # for NULL
use sched
 # for start()
export types
 # for boolean
use error
 # for assert
export util

# type-specific shuttle structs

def shuttle(type)
	struct sh(type)
		shuttle sh
		type d

# this sh(type) is a bit dodgy because doesn't work for complex C types,
# need to use typedef, e.g. char * -> cstr

struct shuttle
	proc *current
	proc *other
	enum { ACTIVE, WAITING, GONE } other_state
shuttle_init(shuttle *sh, proc *p1, proc *p2)
	sh->current = p1
	sh->other = p2
	sh->other_state = ACTIVE

# here are the general shuttle methods:
# pull - receives the shuttle from partner, returns 0 if partner is gone,
# does nothing if we already have shuttle
# push - sends the shuttle to partner, returns 0 if partner is gone,
# does nothing if we don't have shuttle

# XXX these are not "optimal" yet
# TODO push_pull_f ?

boolean pull_f(shuttle *s, proc *p)
	proc_debug("%010p %010p %010p: pull_f", p, s, s->current)
	boolean must_wait = s->current != p
	if must_wait
		s->other_state = WAITING
		proc_debug("  waiting")
	return must_wait

push_f(shuttle *s, proc *p)
	proc_debug("%010p %010p: push_f", p, s)
	if s->current == p
		proc_debug("  pushing")
		proc *other = s->other
#		Fprintf(stderr, "    other: "); proc_dump(other); nl(stderr)
		s->current = other
		s->other = p
		int other_state = s->other_state
		s->other_state = ACTIVE
		if other_state == WAITING
			proc_debug("  starting other (%010p)", other)
			start_f(other)

def pull(s)
	if pull_f(&This->s->sh, b__p)
		wait

def push(s)
	push_f(&This->s->sh, b__p)

def here(s) This->s->sh.current == b__p

Def sh(type) shuttle_^^type

# fancy macros to connect two procs' ports with a shuttle

def sh_init(s, from_proc, to_proc)
	sh_init(s, from_proc, out, to_proc, in)

def sh_init(s, from_proc, from_port, to_proc, to_port)
	shuttle_init(&s->sh, &from_proc->p, &to_proc->p)
	from_proc->from_port = s
	to_proc->to_port = s
	proc_debug("sh_init: %010p = %010p -> %010p", s, from_proc, to_proc)

def sh(type, from_proc, to_proc)
	sh(my(sh), type, from_proc, to_proc)
def sh(type, from_proc, from_port, to_proc, to_port)
	sh(my(sh), type, from_proc, from_port, to_proc, to_port)
def sh(var_name, type, from_proc, to_proc)
	shuttle(var_name, type, from_proc, to_proc)
def sh(var_name, type, from_proc, from_port, to_proc, to_port)
	shuttle(var_name, type, from_proc, from_port, to_proc, to_port)
def shuttle(var_name, type, from_proc, to_proc)
	shuttle(var_name, type, from_proc, out, to_proc, in)
def shuttle(var_name, type, from_proc, from_port, to_proc, to_port)
	decl(var_name, sh(type))
	sh_init(var_name, from_proc, from_port, to_proc, to_port)

# these are the "passive" (non-controlling) rd/wr

def wr(s, v)
	proc_debug("%010p %010p: wr", b__p, s)
	pull(s)
	s = v
	push(s)

def rd(s, v)
	proc_debug("%010p %010p: rd", b__p, s)
	pull(s)
	v = s
	push(s)

# next does a push,pull on a shuttle - this is different way to use the channel, where the function needs to be in control of the object at all times while it is active.

# coros that use "next" should call "pull" initially to make sure they have the
# shuttle if they need to write to it initially

def next(s)
	proc_debug("%010p %010p: next", b__p, s)
	push(s)
	pull(s)

# this is "cut", which closes a shuttle

#int cut_f(shuttle *s, proc *p)
#	int must_wait = s->controlling == p
#	if must_wait
#		r(s)->waiting = NULL
#	return must_wait
#
#cut_f(shuttle *s, proc *p)
#	assert(s->controlling == p, "cut_f must only called after pull")
#		if s->waiting
#			s->controlling = s->waiting
#			start_f(s->waiting)
#			s->waiting = NULL
#
#def cut(s)
#	pull(s)
#	s->d = 1
#	push(s)
#
#	int must_wait
#	# being in control of a shuttle where no one is waiting is 
#	push_f(s, NULL)
#
#def cl(s)
#	pull(s)
#	cut(s)
#
#def CL(s)
#	cut(s)
