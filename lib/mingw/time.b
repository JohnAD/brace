# mingw doesn't have nanosleep, gettimeofday, gmtime_r, localtime_r

^define WIN32_LEAN_AND_MEAN
use windows.h

use sys/timeb.h unistd.h

export time.h
use math.h
use stdio.h
use stdlib.h
export sys/time.h
use string.h

export buffer
use error
use util

use time

struct timespec
	time_t tv_sec  # seconds
	long tv_nsec   # nanoseconds

typedef long suseconds_t

int nanosleep(const struct timespec *req, struct timespec *rem)
	Sleep(req->tv_sec * 1e3 + req->tv_nsec / 1e6)
	# TODO could use usleep to achieve greater accuracy,
	# would want to check the remaining time first
	rem->tv_sec = 0
	rem->tv_nsec = 0
	# FIXME check remaining time?
	return 0

int gettimeofday(struct timeval *tv, void *tz)
	use(tz)
	struct _timeb tb
	_ftime(&tb)
	tv->tv_sec = tb.time
	tv->tv_usec = tb.millitm * 1000
	return 0

# gmtime and localtime aren't threadsafe, oh well :)

struct tm *gmtime_r(const time_t *timep, struct tm *result)
	*result = *gmtime(timep)
	return result
struct tm *localtime_r(const time_t *timep, struct tm *result)
	*result = *localtime(timep)
	return result
