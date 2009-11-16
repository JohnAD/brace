export signal.h process.h
use Windows.h
 # for getpid
export types
use util process

int sig_execfailed = 0

def execl _execl
def execle _execle
def execlp _execlp
def execlpe _execlpe
def execv(path, argv) _execv(path, (const char* const*)argv)
def execve(path, argv, envp) _execve(path, (const char* const*)argv, (const char* const*)envp)
def execvp(file, argv) _execvp(file, (const char* const*)argv)
def execvpe(file, argv, envp) _execvpe(file, (const char* const*)argv, (const char* const*)envp)

def spawnl _spawnl
def spawnle _spawnle
def spawnlp _spawnlp
def spawnlpe _spawnlpe
def spawnv _spawnv
def spawnve _spawnve
def spawnvp _spawnvp
def spawnvpe _spawnvpe

def system_quote cmd_quote

def ignore_pipe()
	.
def ignore_hup()
	.

def WIFEXITED(status) 1
def WIFSIGNALED(status) 0
def WTERMSIG(status) 0
def WEXITSTATUS(status) status
def SIGCHLD -1

sighandler_t sigact(int signum, sighandler_t handler, int sa_flags)
	use(sa_flags)
	return signal(signum, handler)

# these will be ignored in windows:

def SA_NOCLDSTOP 1
def SA_RESTART 0x10000000
def SA_INTERRUPT 0x20000000

exit_exec_failed()
	Exit(exit__execfailed)

Sigdfl_all()
	each(i, SIGABRT, SIGFPE, SIGILL, SIGINT, SIGSEGV, SIGTERM)
		sigdfl(i)

def set_child_handler(sigchld_handler)
	.

# TODO can I implement Waitpid?  I think so.

int Child_wait(pid_t pid)
	# TODO
	use(pid)
	return -1
#	Waitpid(pid, &wait__status, 0)
#	wait__status = fix_exit_status(wait__status)
#	return wait__status

pid_t Child_done()
	# TODO
	return -1
	return 0
#	pid_t pid = Waitpid(-1, &wait__status, WNOHANG)
#	if pid
#		wait__status = fix_exit_status(wait__status)
#	return pid

def nochldwait(signum) 0

def _UTSNAME_LENGTH 65

struct utsname
	char sysname[_UTSNAME_LENGTH]
	char nodename[_UTSNAME_LENGTH]
	char release[_UTSNAME_LENGTH]
	char version[_UTSNAME_LENGTH]
	char machine[_UTSNAME_LENGTH]
#	char domainname[_UTSNAME_LENGTH]

int uname(struct utsname *buf)
	strcpy(buf->sysname, "mingw32")
	# TODO fill in the rest!
	buf->nodename[0] = '\0'
	buf->release[0] = '\0'
	buf->version[0] = '\0'
	buf->machine[0] = '\0'
#	buf->domainname[0] = '\0'
	return 0

# TODO
#int gethostname(char *name, size_t len)
#	if strlcpy(name, Getenv("COMPUTERNAME"), len) >= len
#		errno = EINVAL
#		return -1
#	if *name == '\0'
#		GetComputerName
#	return *name == '\0' ? -1 : 0

int kill(pid_t pid, int sig)
	use(sig)
	if pid == getpid()
		Exit()   # a bit dodgy!
	errno = EPERM
	return -1
