export time.h
export sys/time.h
export locale.h
use math.h
use stdio.h
use stdlib.h
use string.h

export buffer
use error util m env

use time

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

# it would be good to have an "automatically declare a temporary
# struct for something to be returned in" feature in NIPL.

typedef struct tm datetime
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

# sleep_step: the first time you call it, it does not sleep, just records sleep_step_last
long double sleep_step_last = 0
boolean sleep_step_debug = 0
sleep_step(long double step)
	long double t = rtime()
	if !sleep_step_last
		# first step
		# try to sync time to the step
		long double t1 = rdiv(t, step)*step+step
		asleep(t1-t)
		sleep_step_last = t1
	 else
		long double dt = t - sleep_step_last
		long double to_sleep = step - dt
		if to_sleep > 0
			asleep(to_sleep)
			sleep_step_last += step
		 else
			# adjust for possible stoppage, etc
			if sleep_step_debug
				warn("sleep_step running late")
			sleep_step_last += rdiv(dt, step)*step
	if sleep_step_debug
		warn("%f %Lf", rtime(), sleep_step_last)

# this asleep (accurate sleep) is still a bit dodgy, e.g. asleep_small probably should vary by machine
# TODO maybe start asleep_small very small, and double it every time asleep fails to be accurate?

long double asleep_small = 0.3
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
			# any other way to do it?
			#sched_yield()
		return t1
	 else
		Sleep(dt-asleep_small)
		long double t2 = rtime()
		long double dt2 = t - t2
		return asleep(dt2, t2)

# todo make a version of asleep that skips the first rtime and takes it as a
# parameter (slightly more efficient), and also returns the time after the
# sleep

# sort of benchmarking stuff

num bm_start = 0
boolean bm_enabled = 1

def bm_start()
	if bm_enabled
		bm_start = rtime()

def bm(s)
	if bm_enabled
		if bm_start == 0
			bm_start()
		num bm_end = rtime()
		warn("%s: %f", s, bm_end-bm_start)

rtime_to_timeval(num rtime, struct timeval *tv)
	tv->tv_sec = (long)rtime
	tv->tv_usec = (long)((rtime - tv->tv_sec) * 1e6)

rtime_to_timespec(num rtime, struct timespec *ts)
	ts->tv_sec = (long)rtime
	ts->tv_nsec = (long)((rtime - ts->tv_sec) * 1e9)

num timeval_to_rtime(struct timeval *tv)
	return (num)tv->tv_sec + tv->tv_usec / 1e6

num timespec_to_rtime(struct timespec *ts)
	return (num)ts->tv_sec + ts->tv_nsec / 1e9

date_rfc1123_init()
	setlocale(LC_TIME, "POSIX")
	Putenv("TZ=GMT")
	tzset()

char *date_rfc1123(time_t t)
	static char date[32]
	strftime(date, sizeof(date), "%a, %d %b %Y %H:%M:%S GMT", gmtime(&t))
	return date
