export unistd.h stdarg.h signal.h
use sys/wait.h string.h sched.h pwd.h
export buffer types
use error cstr vec util

use sys/wait.h

typedef void (*sighandler_t)(int)

pid_t Fork()
	pid_t pid = fork()
	if pid == -1
		failed("fork")
	return pid

# TODO cope with interrupted system calls universally, aargh

pid_t Waitpid(pid_t pid, int *status, int options)
	pid_t r_pid
	repeat
		r_pid = waitpid(pid, status, options)
		if r_pid == -1
			if errno != EINTR
				failed("waitpid")
		else
			return r_pid

def Waitpid(pid) Waitpid(pid, NULL, 0)


# TODO should block SIGCHLD? etc
# Systemv is an _emulated_ system, doesn't call system(3),
# doesn't use the shell
# not any more! now it does call system() in the interests of portability,
# and is in the common process.b  Here's the old version:

#int Systemv(const char *filename, char *const argv[])
#	pid_t pid
#	pid = Fork()
#	if pid == 0
#		Execvp(filename, argv)
#	int status
#	Waitpid(pid, &status, 0)
#	if WIFEXITED(status)
#		return WEXITSTATUS(status)
#	return -1

typedef struct sched_param sched_param

Sched_setscheduler(pid_t pid, int policy, const sched_param *p)
	if sched_setscheduler(pid, policy, p) == -1
		failed("sched_setscheduler")

set_priority(pid_t pid, int priority)
	decl(param, sched_param)
	bzero(param)
	param->sched_priority = priority
	Sched_setscheduler(pid, SCHED_FIFO, param)

cstr whoami()
	return strdup(Getpwuid(geteuid())->pw_name)

typedef struct passwd passwd
passwd *Getpwuid(uid_t uid)
	struct passwd *rv = getpwuid(uid)
	if rv == NULL
		failed("getpwuid")
	return rv

passwd *Getpwnam(const char *name)
	struct passwd *rv = getpwnam(name)
	if rv == NULL
		failed("getpwnam")
	return rv

def ignore_pipe()
	Signal(SIGPIPE, SIG_IGN)
def ignore_hup()
	Signal(SIGHUP, SIG_IGN)

def system_quote sh_quote
