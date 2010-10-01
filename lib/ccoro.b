export setjmp.h
use stdlib.h

# ccoro - coroutines in standard C
# Sam Watkins, 2009
# this code is public domain
#
# ccoro use setjmp and longjmp to achieve plain ANSI C coroutines /
# non-preemptive threading.  It works by allocating all threads stack space on
# the normal stack.  It makes sure that each thread has enough space to run
# using a padding variable, of size 8k by default, which is inserted by a
# function that starts the thread.  Simple, huh?  It uses some fairly simple
# trickery to create new threads that don't overlap with the other threads.
#
# TODO use a free-list instead of always allocating new coros at the top
# TODO why doesn't it work with -O2 on ADM64? (gcc 4.3.2)
#
# This works with at least gcc-4.3, tcc, tendra and lcc on Linux x86 and
# amd64, and with mingw gcc-4.4 and Visual C++ 98 Express on Windows.
#
# An earlier version was reported not to work with tendra on netbsd, I have
# fixed bugs since then so maybe it works now.

def coro_pad 8192

typedef void noret

struct coro
	coro *next
	coro *prev
	jmp_buf j

typedef void (*coro_func)(coro *caller)

noret new_coro_2(coro_func f, coro *caller)

int coro_init_done = 0
coro main_coro
coro *coro_top = &main_coro
coro *current_coro = &main_coro

coro_func new_coro_f

jmp_buf alloc_ret
coro yielder

def coro_code_done  -1
def coro_code_alloc -2
def coro_code_dead  -3

coro_init()
	main_coro.prev = NULL
	main_coro.next = NULL
	coro_init_done = 1

int yield_val_2(coro *c, int val)
	coro *me = current_coro
	int v = setjmp(me->j)
	if (v == 0)         # yield
		longjmp(c->j, val)
	else if (v == coro_code_alloc)   # new - this is top
		coro *caller = current_coro
		current_coro = me
		new_coro_2(new_coro_f, caller)
		# cannot return
	# else returned
	current_coro = me
	return v

int yield_val(coro **c, int val)
	if *c
		int v = yield_val_2(*c, val)
		if v == coro_code_done
			*c = NULL
		return v
	return coro_code_dead

def yield(c) ccoro_yield(c)
int ccoro_yield(coro **c)
	return yield_val(c, 1)

noret new_coro_3(coro_func f, coro *caller)
	coro new
	current_coro = &new

	if coro_top
		coro_top->next = &new
	new.prev = coro_top
	new.next = NULL
	coro_top = &new

	(*f)(caller)

	if current_coro->prev
		current_coro->prev->next = current_coro->next
	if current_coro->next
		current_coro->next->prev = current_coro->prev

	if current_coro == coro_top
		coro_top = current_coro->prev

	current_coro = NULL

	longjmp(caller->j, coro_code_done)  # finished

noret new_coro_2(coro_func f, coro *caller)
	volatile char pad[coro_pad]
	pad[0] = pad[coro_pad-1] = 0;
	new_coro_3(f, caller)
	pad[0] = pad[coro_pad-1] = 0;
	# cannot return

coro *new_coro(coro_func f)
	int v
	coro *me = current_coro
	coro *yielder
	if !coro_init_done
		coro_init()
	new_coro_f = f
	v = setjmp(current_coro->j)
	if (v == 0)            # new
		if current_coro == coro_top
			new_coro_2(f, current_coro)
		else
			longjmp(coro_top->j, coro_code_alloc)
		# cannot return
	# else yielded
	yielder = current_coro
	current_coro = me
	return yielder
