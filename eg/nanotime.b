#!/lang/b
# LDFLAGS=-lrt

use b
use time.h
Main()
	struct timespec ts
	repeat
		clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts)
		# unfortunately this makes a syscall and takes more than 1 microsecond

		Sayf("%d.%09d", ts.tv_sec, ts.tv_nsec)
#		num t = ts_to_rtime(&ts)
#		Sayf("%0.9f", t)

def ts_to_rtime(ts) (num)ts->tv_sec + ts->tv_nsec / 1e9
