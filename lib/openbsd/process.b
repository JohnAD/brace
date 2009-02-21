use error
use sched.h

int sched_setscheduler(pid_t pid, int policy, const struct sched_param *p)
	warn("sched_setscheduler is not implemented for OpenBSD")
	errno = EINVAL
	return -1
