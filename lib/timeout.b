export priq types thunk time
use util

typedef priq timeouts

typedef timeout *timeout_p

struct timeout
	num time
	thunk handler
	int i

def timeout_init(timeout, time, func)
	timeout_init(timeout, time, func, timeout)

def timeout_init(timeout, time, func, obj)
	timeout_init(timeout, time, func, obj, NULL)

timeout_init(timeout *timeout, num time, thunk_func func, void *obj, void *common_arg)
	new(th, thunk, func, obj, common_arg)
	timeout_init_thunk(timeout, time, th)

timeout_init_thunk(timeout *timeout, num time, thunk *handler)
	timeout->time = time
	timeout->handler = *handler

def timeouts_init(q)
	timeouts_init(q, 64)

def timeouts_init(q, space)
	init(q, priq, timeout_p, space)

def timeouts_free(q)
	priq_free(q)

def timeouts_cmp_macro(a, b) (*(timeout_p*)a)->time - (*(timeout_p*)b)->time

timeouts_add(timeouts *q, timeout *o)
	priq_push(q, timeout_p, timeouts_cmp_macro, &o, i, timeouts_move_notify, NULL)
	o->i = i

timeouts_rm(timeouts *q, timeout *o)
	if o->i >= 0
		priq_remove(q, timeout_p, timeouts_cmp_macro, o->i, timeouts_move_notify, NULL)
		o->i = -1

def timeouts_move_notify(q, to, from, arg_dummy)
	(*(timeout_p*)vec_element(q, to))->i = to

timeout *timeouts_next(timeouts *q)
	return *(timeout_p*)priq_peek(q)

timeouts_shift(timeouts *q)
	priq_shift(q, timeout_p, timeouts_cmp_macro)

def timeouts_empty(q) priq_empty(q)

def timeout_call(timeout)
	timeout_call_keep(timeout)
	
def timeout_call_keep(timeout) thunk_call(&timeout->handler)
 # no specific_arg for timeouts as of yet

timeouts_call(timeouts *timeouts, num time)
	while !timeouts_empty(timeouts)
		timeout *timeout_next = timeouts_next(timeouts)
		if timeout_next->time > time
			break
		timeouts_call_next(timeouts)

def timeouts_call_next(timeouts)
	timeout *my(next) = timeouts_next(timeouts)
	timeout_call(my(next))
	if !timeouts_empty(timeouts) && timeouts_next(timeouts) == my(next)
		timeouts_shift(timeouts)

num timeouts_delay(timeouts *timeouts, num time)
	if timeouts_empty(timeouts)
		return -1
	 else
		timeout *next = timeouts_next(timeouts)
		num delay = next->time - time
		if delay < 0
			delay = 0
		return delay

timeouts_delay_tv(timeouts *timeouts, num time, timeval **tv)
	num d = timeouts_delay(timeouts, time)
	if d < 0
		*tv = NULL
	 else
		rtime_to_timeval(d, *tv)

timeouts_delay_ts(timeouts *timeouts, num time, timespec **ts)
	num d = timeouts_delay(timeouts, time)
	if d < 0
		*ts = NULL
	 else
		rtime_to_timespec(d, *ts)

int timeouts_delay_ms(timeouts *timeouts, num time)
	num d = timeouts_delay(timeouts, time)
	if d < 0
		return -1
	 else
		return (int)d*1000
