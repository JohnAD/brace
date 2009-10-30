use process error
use time

boolean lsleep_inited = 0
lsleep_init()
	Sigact(SIGALRM, catch_signal_null)
	lsleep_inited = 1

lsleep(num dt)
	if !lsleep_inited
		lsleep_init()
#	itimerval v
#	rtime_to_timeval(dt, &v.it_value)
#	v.it_interval.tv_sec = v.it_interval.tv_usec = 0
#	Setitimer(ITIMER_REAL, &v, NULL)
	Ualarm(dt)
	rsleep(dt+1)

typedef struct itimerval itimerval

Getitimer(int which, struct itimerval *value);
	if getitimer(which, value)
		failed("getitimer")

Setitimer(int which, const struct itimerval *value, struct itimerval *ovalue);
	if setitimer(which, value, ovalue)
		failed("setitimer")

Ualarm(num dt)
	itimerval v
	rtime_to_timeval(dt, &v.it_value)
	v.it_interval.tv_sec = v.it_interval.tv_usec = 0
	Setitimer(ITIMER_REAL, &v, NULL)

long double asleep_small = 0.03  # 0.0001
