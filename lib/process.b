use stdlib.h
export types buffer
use error cstr vec
use process

# magic exit code, semi-consistent with bash
# bash distinguishes not found (127) and if the file was found but not
# executable (126). We return 127 in case of any exec error.

int exit__execfailed = 127
int status__execfailed = 512 + 127

boolean exec__warn_fail = 1

Atexit(void (*function)(void))
	if atexit(function) != 0
		failed("atexit")

def exit() exit(0)

# TODO maybe I could raise() a signal to kill the process with thereby a
# non-normal exit status in case of not being able to exec the child process?
# I would like to be able to return the errno from exec to the parent, too.

Execv(const char *path, char *const argv[])
	execv(path, argv)
	if exec__warn_fail
		warn_failed("execv")
	exit_exec_failed()

Execvp(const char *file, char *const argv[])
	execvp(file, argv)
	if exec__warn_fail
		warn_failed("execvp")
	exit_exec_failed()

Execve(const char *filename, char *const argv[], char *const envp[])
	execve(filename, argv, envp)
	if exec__warn_fail
		warn_failed("execve")
	exit_exec_failed()

# XXX TODO use local, not static?
static vec exec_argv
static int exec_argv_init = 0

# XXX shouldn't have to specify void
static void exec_argv_do_init()
	vec_init(&exec_argv, cstr, 10)
	exec_argv_init = 1

Execl(const char *path, ...)
	if !exec_argv_init
		exec_argv_do_init()
	exec_argv.size = 0
	va_list ap
	va_start(ap, path)
	repeat
		char *arg = va_arg(ap, char *)
		*(char **)vec_push(&exec_argv) = arg
		if arg == NULL
			break
	va_end(ap)
	Execv(path, (char *const *)exec_argv.b.start)

# TODO macros to simplify common varargs usage?
# TODO macros!

Execlp(const char *path, ...)
	if !exec_argv_init
		exec_argv_do_init()
	exec_argv.size = 0
	va_list ap
	va_start(ap, path)
	repeat
		char *arg = va_arg(ap, char *)
		*(char **)vec_push(&exec_argv) = arg
		if arg == NULL
			break
	va_end(ap)
	Execvp(path, (char *const *)exec_argv.b.start)

Execle(const char *path, ...)
	# and char *const envp[]
	if !exec_argv_init
		exec_argv_do_init()
	exec_argv.size = 0
	va_list ap
	va_start(ap, path)
	repeat
		char *arg = va_arg(ap, char *)
		*(char **)vec_push(&exec_argv) = arg
		if arg == NULL
			break
	char *const *envp = va_arg(ap, char *const *)
	va_end(ap)
	Execve(path, (char *const *)exec_argv.b.start, envp)

# as usual, you should set to->size to 0 first
sh_quote(const char *from, buffer *to)
	char c
	int i = buffer_get_size(to)
	repeat
		c = *from
		if c == '\0'
			break
		if (c >= 'A' && c <= 'Z') ||
		 (c >= 'a' && c <= 'z') ||
		 (c >= '0' && c <= '9') ||
		 strchr("-_./", c) != NULL
			# doesn't need escaping
			buffer_set_size(to, i+1)
			to->start[i] = c
			++i
		 eif c == '\n'
			buffer_set_size(to, i+3)
			to->start[i] = '"'
			to->start[i+1] = c
			to->start[i+2] = '"'
			i += 3
		 else
			buffer_set_size(to, i+2)
			to->start[i] = '\\'
			to->start[i+1] = c
			i += 2
		++from
	buffer_nul_terminate(to)

# as usual, you should set to->size to 0 first
cmd_quote(const char *from, buffer *to)
	let(quote, strchr(from, ' ') != NULL)
	if quote
		buffer_cat_char(to, '"')
	buffer_cat_cstr(to, (cstr)from)
	if quote
		buffer_cat_char(to, '"')
	buffer_nul_terminate(to)

# System - this only fails with an error if it can't exec the subprocess, not
# if the subprocess itself returns an error code
int System(const char *s)
	int status = system(s)
	if status == -1
		failed("system")
	if WIFEXITED(status)
		return WEXITSTATUS(status)
	return -1

int Systemf(const char *format, ...)
	collect(Vsystemf, format)

# SYSTEM, SYSTEMF - this one fails if the subprocess fails

SYSTEM(const char *s)
	if System(s)
		failed("system", s)

SYSTEMF(const char *format, ...)
	collect_void(VSYSTEMF, format)

VSYSTEMF(const char *format, va_list ap)
	int rv = Vsystemf(format, ap)
	if rv
		failed("system")

# TODO rename buffer to string??
# but would conflict with C++ standard.  buffer is ok

int Vsystemf(const char *format, va_list ap)
	static buffer b
	static int init = 0
	if !init
		buffer_init(&b, 32)
		init = 1
	buffer_clear(&b)
	Vsprintf(&b, format, ap)
	return System(b.start)

sighandler_t Signal(int signum, sighandler_t handler)
	sighandler_t rv = signal(signum, handler)
	if rv == SIG_ERR
		failed("signal")
	return rv

def ignore_ctrl_c()
	Sigign(SIGINT)

def allow_ctrl_c()
	Sigdfl(SIGINT)

int Systema(const char *filename, char *const argv[])
	new(b, buffer, 256)
	system_quote(filename, b)
	while (*argv) {
		buffer_cat_char(b, ' ')
		system_quote(*argv, b)
		++argv
	}
	cstr command = buffer_to_cstr(b)
#	warn("command: %s", command)
	let(rv, System(command))
	buffer_free(b)
	return rv

int Systemv(const char *filename, char *const argv[])
	# the filename is repeated in argv[0] - so skip it
	return Systema(filename, argv+1)

# note: for Systeml, unlike exec, and unlike Systemv, the
# filename is not repeated

int Systeml(const char *filename, ...)
	if !exec_argv_init
		exec_argv_do_init()
	exec_argv.size = 0
	*(const char **)vec_push(&exec_argv) = filename
	va_list ap
	va_start(ap, filename)
	repeat
		char *arg = va_arg(ap, char *)
		*(char **)vec_push(&exec_argv) = arg
		if arg == NULL
			break
	va_end(ap)
	return Systemv(filename, (char *const *)exec_argv.b.start)

def Systeml(filename) Systeml(filename, NULL)

cstr cmd(cstr c)
	FILE *f = Popen(c, "r")
	cstr rv = buffer_to_cstr(fslurp(f))
	Pclose(f)
	return rv

# This sigact / Sigact is equivalent to signal but uses the more stable
# sigaction call. The signal will be blocked during the handler.
# It is also implemented (just using signal) for non-unix systems i.e. mingw.

sighandler_t Sigact(int signum, sighandler_t handler, int sa_flags)
	sighandler_t rv = sigact(signum, handler, sa_flags)
	if rv == SIG_ERR
		failed("sigact")
	return rv

# Sigact with two args sets a signal handler, system calls will be restarted.
# Sigintr sets a signal handler, system calls will be interrupted.
# You probably want to use Sigintr for SIGALRM.

def sigact(signum, handler) sigact(signum, handler, SA_RESTART|nochldwait(signum))
def sigintr(signum, handler) sigact(signum, handler, SA_INTERRUPT|nochldwait(signum))
def Sigact(signum, handler) Sigact(signum, handler, SA_RESTART|nochldwait(signum))
def Sigintr(signum, handler) Sigact(signum, handler, SA_INTERRUPT|nochldwait(signum))
def sigign(signum) sigact(signum, SIG_IGN, 0)
def sigdfl(signum) sigact(signum, SIG_DFL, 0)
def Sigign(signum) Sigact(signum, SIG_IGN, 0)
def Sigdfl(signum) Sigact(signum, SIG_DFL, 0)

def sigget(signum) sigact(signum, NULL, 0)
def Sigget(signum) Sigact(signum, NULL, 0)

Raise(int sig)
	if raise(sig)
		failed("raise")

void catch_signal_null(int sig)
	use(sig)

int wait__status

def Child_wait() Child_wait(-1)

int fix_exit_status(int status)
	if WIFEXITED(status)
		status = WEXITSTATUS(status)
		if !sig_execfailed && status == exit__execfailed
			status = status__execfailed
	 eif WIFSIGNALED(status)
		status = 256 + 128 + WTERMSIG(status)
		if sig_execfailed && status == 256 + 128 + sig_execfailed
			status = status__execfailed
	 else
		fault("unknown exit status %d - perhaps child stop/cont.\nSet your SIGCHLD handler with Sigact or Sigintr to avoid this.", status)
	return status

def status_normal(status) status >= 0 && status < 256 && (sig_execfailed || status != exit__execfailed)
def status_signal(status) status >= 384 && status < 512 ? status - 384 : 0
def status_execfailed(status) status == status__execfailed

def Child_status() wait__status

hold_term_open()
	warn("\ndone, press enter to close the terminal")
	new(b, buffer)
	Freadline(stderr, b)
