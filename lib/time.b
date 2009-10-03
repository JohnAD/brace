export time.h
export sys/time.h
export locale.h
use math.h
use stdio.h
use stdlib.h
use string.h

export buffer
use error util m env process
use time

def time_forever -1

# datetime:
#
#    struct tm {
#            int     tm_sec;         /* seconds */
#            int     tm_min;         /* minutes */
#            int     tm_hour;        /* hours */
#            int     tm_mday;        /* day of the month */
#            int     tm_mon;         /* month */
#            int     tm_year;        /* year */
#            int     tm_wday;        /* day of the week */
#            int     tm_yday;        /* day in the year */
#            int     tm_isdst;       /* daylight saving time */
#    };

export types

def Sleep(time) Rsleep(time)
  # to be consistent, this should really be like sleep(int time)
  # - but rsleep(num time) behaves the same given an int arguement.

Rsleep(num time)
	repeat
		time = rsleep(time)
		if time == 0
			break
		if time == -1
			failed("nanosleep")

num rsleep(num time)
	if time <= 0
		return 0
	struct timespec delay
	rtime_to_timespec(time, &delay)
	if nanosleep(&delay, &delay) == -1
		if errno == EINTR
			return timespec_to_rtime(&delay)
		return -1
	return 0

def Sleep_forever()
	repeat
		Sleep(1e6)

# it would be good to have a "cached time" function that only
# calls gettimeofday(2) if the process has blocked since the
# last call to cached_time...

num rtime()
	struct timeval tv
	Gettimeofday(&tv)
	return timeval_to_rtime(&tv)

Gettimeofday(struct timeval *tv)
	if gettimeofday(tv) != 0
		failed("gettimeofday")

def gettimeofday(tv) gettimeofday(tv, NULL)

def time() time(NULL)

# there is no Time because X11 defines it

# it would be good to have an "automatically declare a temporary
# struct for something to be returned in" feature in NIPL.

def datetime_init(dt)
	.

Gmtime(double t, datetime *result)
	time_t t1 = (time_t)t
	if gmtime_r(&t1, result) == NULL
		failed("gmtime_r")

Localtime(double t, datetime *result)
	time_t t1 = (time_t)t
	if localtime_r(&t1, result) == NULL
		failed("localtime_r")

int Mktime(datetime *t)
	int rv = mktime(t)
	if rv == -1
		failed("mktime")
	return rv

cstr dt_format = "%F %T"
cstr dt_format_tz = "%F %T %z"
# Y-m-d h-m-s

# as usual, this APPENDS to a buffer, so clear it first.
Timef(buffer *b, const datetime *tm, const char *format)
	int len
	repeat
		b->start[0] = 'x'
		len = strftime(b->end,
		 buffer_get_free(b), format, tm)
		if len != 0 || b->start[0] == '\0'
			break
		# XXX I hope this is correct!
		buffer_double(b)
	buffer_set_size(b, len + 1)

# this returns a cstr, you should free it
def Timef(dt, format) Timef_cstr(dt, format)
def Timef(dt) Timef_cstr(dt, dt_format)
cstr Timef_cstr(datetime *dt, const char *format)
	new(b, buffer)
	Timef(b, dt, format)
	# squeeze - once have made buffer always end in nul
	return buffer_get_start(b)

def datetime_init(dt, year, month, day) datetime_init(year, month, day, 0, 0, 0)

datetime_init(datetime *dt, int year, int month, int day,  int hour, int min, int sec)
	dt->tm_year = year - 1900
	dt->tm_mon = month - 1
	dt->tm_mday = day
	
	dt->tm_hour = hour
	dt->tm_min = min
	dt->tm_sec = sec

# FIXME I doubt this stuff needs to use long double

boolean sleep_debug = 0

# csleep: cumulative sleep.
# You should call it once first outside the loop to initialize it.
# The first time you call it, it records csleep_last, and optionally syncs the
# current time to match the step so printing the time will make more sense.  If
# one sleep is to short, the next will probably be longer.  If too long, the
# next should be shorter.
# TODO do this as an object, and make it proc compatible.

long double csleep_last = 0
def csleep(step) csleep(step, 0, 1, 0)
csleep(long double step, boolean sync, boolean use_asleep, boolean rush)
	long double t = rtime()
	long double to_sleep
	if !csleep_last
		# first step
		if sync
			long double t1 = rdiv(t, step)*step+step
			to_sleep = t1 - t
			xsleep(to_sleep, t, use_asleep)
			csleep_last = t1
		 else
			xsleep(step, t, use_asleep)
			csleep_last = t + step
	 else
		long double dt = t - csleep_last
		long double to_sleep = step - dt
		if to_sleep > 0
			xsleep(to_sleep, t, use_asleep)
			csleep_last += step
		 else
			# adjust for possible stoppage, etc
			if sleep_debug
				warn("sleep_step running late")
			if sync
				csleep_last += (rdiv(dt, step)+1)*step
				to_sleep = csleep_last - t
				xsleep(to_sleep, t, use_asleep)
			 eif !rush
				csleep_last = t
	if sleep_debug
		warn("%f %Lf", rtime(), csleep_last)

def xsleep(dt, t, use_asleep)
	if use_asleep
		asleep(dt, t)
	 else
		Sleep(dt)

# this asleep (accurate sleep) is still a bit dodgy,
# e.g. asleep_small probably should vary by machine
# TODO maybe start asleep_small very small, and double it every time asleep
# fails to be accurate?

def asleep(dt) asleep(dt, rtime())
long double asleep(long double dt, long double t)
	if dt <= 0.0
		return t
	t += dt
	if dt <= asleep_small
		long double t1
		while (t1=rtime()) < t
			.
			# sched_yield might makes this busy loop a little less busy if other processes need to run?
			# any other way to do it?  a real-time alarm?
			#sched_yield()
		return t1
	 else
		lsleep(dt-asleep_small)
		long double t2 = rtime()
		long double dt2 = t - t2
		if dt2 > 0
			return asleep(dt2, t2)
		 eif dt < 0
			asleep_small *= 2
			if sleep_debug
				warn("asleep: slept too long, doubling asleep_small to %f", asleep_small)
		return t2


# benchmarking stuff

num bm_start = 0
num bm_end = 0
boolean bm_enabled = 1

def bm_block(msg)
	post(my(x))
		bm(msg)
	pre(my(x))
		bm_start()

def bm_block(msg, reps)
	post(my(x))
		bm_ps(msg, reps)
	pre(my(x))
		bm_start()

def bm_start()
	if bm_enabled
		bm_start = rtime()

def bm()
	if bm_enabled
		if bm_start == 0
			bm_start()
		else
			bm_end = rtime()

def bm(s)
	bm()
	if bm_end
		warn("%s: %f", s, bm_end-bm_start)

def bm(s, n)
	bm()
	if bm_end
		warn("%s: %f = %f * %d", s, bm_end-bm_start, (bm_end-bm_start)/n, (size_t)n)

def bm_ps(s)
	bm_ps(s, 1)
def bm_ps(s, n)
	bm()
	if bm_end
		warn("%s: %f / sec", s, n / (bm_end-bm_start))

rtime_to_timeval(num rtime, struct timeval *tv)
	tv->tv_sec = (long)rtime
	tv->tv_usec = (long)((rtime - tv->tv_sec) * 1e6)

rtime_to_timespec(num rtime, struct timespec *ts)
	ts->tv_sec = (long)rtime
	ts->tv_nsec = (long)((rtime - ts->tv_sec) * 1e9)

num timeval_to_rtime(const struct timeval *tv)
	return (num)tv->tv_sec + tv->tv_usec / 1e6

num timespec_to_rtime(const struct timespec *ts)
	return (num)ts->tv_sec + ts->tv_nsec / 1e9

int rtime_to_ms(num rtime)
	return (int)(rtime * 1000)

num ms_to_rtime(int ms)
	return ms / 1000.0

int delay_to_ms(num delay)
	if delay == time_forever
		return -1
	 else
		return rtime_to_ms(delay)

struct timespec *delay_to_timespec(num delay, struct timespec *p)
	if delay == time_forever
		return NULL
	 else
		rtime_to_timespec(delay, p)
		return p

struct timeval *delay_to_timeval(num delay, struct timeval *p)
	if delay == time_forever
		return NULL
	 else
		rtime_to_timeval(delay, p)
		return p

date_rfc1123_init()
	setlocale(LC_TIME, "POSIX")
	Putenv("TZ=GMT")
	tzset()

char *date_rfc1123(time_t t)
	static char date[32]
	static char maxdate[32]
	static time_t maxtime = -1
	if t == maxtime
		return maxdate
	char *d = date
	if t > maxtime
		maxtime = t
		d = maxdate
	strftime(d, sizeof(date), "%a, %d %b %Y %H:%M:%S GMT", gmtime(&t))
	return d

# NOTE can use timeradd etc when necessary.  BSD.

## this delay loop shite might work in the kernel, it doesn't work here!
#
#num loops_per_sec
#
#unsigned long delay_loop_init_count = 0
#
#num delay_loop_init(num secs)
##	set_priority(getpid(), sched_get_priority_max(SCHED_FIFO))
##	Sleep(0.1)
#	sighandler_t sigh_old = Sigact(SIGALRM, catch_signal_delay_loop_init)
#	num t0 = rtime()
#	Ualarm(secs)
##	unsigned long loops = ((unsigned long)-1)
##	unsigned long loops = 300000000
#	unsigned long loops = 1000000000
#	delay_loop(loops)
#	num t1 = rtime()
#	loops -= delay_loop_init_count
#	loops_per_sec = loops / (t1-t0)
#	Sigact(SIGALRM, sigh_old)
#	warn("delay_loop_init: %d loops, %f secs, %f loops_per_sec", loops, t1-t0, loops_per_sec)
#	return loops_per_sec
#
#void catch_signal_delay_loop_init(int sig)
#	use(sig)
#	delay_loop_init_count = delay_loop_d0
#	delay_loop_stop()
#
#volatile unsigned long delay_loop_d0
#
#__attribute__((__noinline__)) delay_loop(unsigned long loops)
#	if loops
#		register volatile unsigned long delay_loop_d0 = loops
#		do
#			--delay_loop_d0
#		 while delay_loop_d0 != 0
#
#delay_loop_stop()
#	delay_loop_d0 = 1
#
#delay_loop_sleep(num secs)
#	delay_loop(secs * loops_per_sec)
