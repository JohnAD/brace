use stdlib.h
export types buffer
use error cstr vec
use process

# maybe rename process.b -> system.b ?

# magic exit code, semi-consistent with bash
# bash distinguishes not found (127) and if the file was found but not
# executable (126). We return 127 in case of any exec error.

int exit__execfailed = 127
int status__execfailed = 512 + 127

boolean process__forked = 0
boolean process__fork_fflush = 1
boolean process__exit_fflush = 1

boolean exec__warn_fail = 1

Atexit(void (*function)(void))
	if atexit(function) != 0
		failed("atexit")

def exit() exit(0)

void Exit(int status)
	if process__forked
		if process__exit_fflush
			Fflush_all()
		_Exit(status)
	exit(status)

def Exit() Exit(0)

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
	collect_void(Vexecl, path)

Vexecl(const char *path, va_list ap)
	if !exec_argv_init
		exec_argv_do_init()
	vec_clear(&exec_argv)
	repeat
		char *arg = va_arg(ap, char *)
		if arg == NULL
			break
		*(char **)vec_push(&exec_argv) = arg
	Execv(path, (char *const *)vec_to_array(&exec_argv))

# TODO macros to simplify common varargs usage?
# TODO macros!

Execlp(const char *file, ...)
	collect_void(Vexeclp, file)

Vexeclp(const char *file, va_list ap)
	if !exec_argv_init
		exec_argv_do_init()
	vec_clear(&exec_argv)
	repeat
		char *arg = va_arg(ap, char *)
		if arg == NULL
			break
		*(char **)vec_push(&exec_argv) = arg
	Execvp(file, (char *const *)vec_to_array(&exec_argv))

Execle(const char *path, ...)
	collect_void(Vexecle, path)

Vexecle(const char *path, va_list ap)
	# and char *const envp[]
	if !exec_argv_init
		exec_argv_do_init()
	vec_clear(&exec_argv)
	repeat
		char *arg = va_arg(ap, char *)
		if arg == NULL
			break
		*(char **)vec_push(&exec_argv) = arg
	char *const *envp = va_arg(ap, char *const *)
	Execve(path, (char *const *)vec_to_array(&exec_argv), envp)

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

boolean system_verbose = 0

# System - this only fails with an error if it can't exec the subprocess, not
# if the subprocess itself returns an error code

int System(const char *s)
	if system_verbose
		warn(s)
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


int Systema_q(boolean quote, const char *filename, char *const argv[])
	new(b, buffer, 256)
	system_quote_check_uq(quote, filename, b)
	while (*argv) {
		buffer_cat_char(b, ' ')
		system_quote_check_uq(quote, *argv, b)
		++argv
	}
	cstr command = buffer_to_cstr(b)
#	warn("command: %s", command)
	let(rv, System(command))
	buffer_free(b)
	uq_clean()
	return rv

def Systema(filename, argv) Systema_q(1, filename, argv)

def Systemau(filename, argv) Systema_q(0, filename, argv)

system_quote_check_uq(boolean quote, const char *s, buffer *b)
	if quote && !is_uq(s)
		system_quote(s, b)
	 else
	 	buffer_cat_cstr(b, s)

int Systemv_q(boolean quote, const char *filename, char *const argv[])
	# the filename is repeated in argv[0] - so skip it
	return Systema_q(quote, filename, argv+1)

def Systemv(filename, argv) Systemv_q(1, filename, argv)

def Systemvu(filename, argv) Systemv_q(0, filename, argv)

# note: for Systeml, unlike exec, and unlike Systemv, the
# filename is not repeated

int Systeml__q(boolean quote, const char *filename, ...)
	collect(Vsysteml_q, quote, filename)

int Systeml_(const char *filename, ...)
	collect(Vsysteml, filename)

int Systemlu_(const char *filename, ...)
	collect(Vsystemlu, filename)

int Vsysteml_q(boolean quote, const char *filename, va_list ap)
	if !exec_argv_init
		exec_argv_do_init()
	vec_clear(&exec_argv)
	*(const char **)vec_push(&exec_argv) = filename
	repeat
		char *arg = va_arg(ap, char *)
		if arg == NULL
			break
		*(char **)vec_push(&exec_argv) = arg
	return Systemv_q(quote, filename, (char *const *)vec_to_array(&exec_argv))

def Vsysteml(filename, ap) Vsysteml_q(1, filename, ap)

def Vsystemlu(filename, ap) Vsysteml_q(0, filename, ap)

def Systeml(filename) Systeml_(filename, NULL)
def Systeml(filename, a0) Systeml_(filename, a0, NULL)
def Systeml(filename, a0, a1) Systeml_(filename, a0, a1, NULL)
def Systeml(filename, a0, a1, a2) Systeml_(filename, a0, a1, a2, NULL)
def Systeml(filename, a0, a1, a2, a3) Systeml_(filename, a0, a1, a2, a3, NULL)
def Systeml(filename, a0, a1, a2, a3, a4) Systeml_(filename, a0, a1, a2, a3, a4, NULL)
def Systeml(filename, a0, a1, a2, a3, a4, a5) Systeml_(filename, a0, a1, a2, a3, a4, a5, NULL)
def Systeml(filename, a0, a1, a2, a3, a4, a5, a6) Systeml_(filename, a0, a1, a2, a3, a4, a5, a6, NULL)
def Systeml(filename, a0, a1, a2, a3, a4, a5, a6, a7) Systeml_(filename, a0, a1, a2, a3, a4, a5, a6, a7, NULL)

def Systeml_q(quote, filename) Systeml__q(quote, filename, NULL)
def Systeml_q(quote, filename, a0) Systeml__q(quote, filename, a0, NULL)
def Systeml_q(quote, filename, a0, a1) Systeml__q(quote, filename, a0, a1, NULL)
def Systeml_q(quote, filename, a0, a1, a2) Systeml__q(quote, filename, a0, a1, a2, NULL)
def Systeml_q(quote, filename, a0, a1, a2, a3) Systeml__q(quote, filename, a0, a1, a2, a3, NULL)
def Systeml_q(quote, filename, a0, a1, a2, a3, a4) Systeml__q(quote, filename, a0, a1, a2, a3, a4, NULL)
def Systeml_q(quote, filename, a0, a1, a2, a3, a4, a5) Systeml__q(quote, filename, a0, a1, a2, a3, a4, a5, NULL)
def Systeml_q(quote, filename, a0, a1, a2, a3, a4, a5, a6) Systeml__q(quote, filename, a0, a1, a2, a3, a4, a5, a6, NULL)
def Systeml_q(quote, filename, a0, a1, a2, a3, a4, a5, a6, a7) Systeml__q(quote, filename, a0, a1, a2, a3, a4, a5, a6, a7, NULL)

def Systemlu(filename) Systemlu_(filename, NULL)
def Systemlu(filename, a0) Systemlu_(filename, a0, NULL)
def Systemlu(filename, a0, a1) Systemlu_(filename, a0, a1, NULL)
def Systemlu(filename, a0, a1, a2) Systemlu_(filename, a0, a1, a2, NULL)
def Systemlu(filename, a0, a1, a2, a3) Systemlu_(filename, a0, a1, a2, a3, NULL)
def Systemlu(filename, a0, a1, a2, a3, a4) Systemlu_(filename, a0, a1, a2, a3, a4, NULL)
def Systemlu(filename, a0, a1, a2, a3, a4, a5) Systemlu_(filename, a0, a1, a2, a3, a4, a5, NULL)
def Systemlu(filename, a0, a1, a2, a3, a4, a5, a6) Systemlu_(filename, a0, a1, a2, a3, a4, a5, a6, NULL)
def Systemlu(filename, a0, a1, a2, a3, a4, a5, a6, a7) Systemlu_(filename, a0, a1, a2, a3, a4, a5, a6, a7, NULL)


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

call_sighandler(sighandler_t h, int sig)
	if h == SIG_DFL
		Sigdfl(sig)
		kill(getpid(), sig)
	 eif h != SIG_IGN
		h(sig)

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
	Freadline(b, stdin)

#sunos doesn't like: typedef struct utsname utsname

Uname(struct utsname *buf)
	if !uname(buf)
		failed("uname")



# unquoting, this seems a bit ugly!
# This is used by Systema, and could also be used for html.
# The same idea could be generalized to arbitrary annotations.

vec struct__uq_vec
vec *uq_vec = NULL

uq_init()
	uq_vec = &struct__uq_vec
	init(uq_vec, vec, cstr, 16)

cstr uq(const char *s)
	if !uq_vec
		uq_init()
	char *s1 = Strdup(s)
	vec_push(uq_vec, s1)
	return s1

boolean is_uq(const char *s)
	if uq_vec
		for_vec(i, uq_vec, cstr)
			if *i == s
				return 1
	return 0

uq_clean()
	if uq_vec
		for_vec(i, uq_vec, cstr)
			Free(*i)
		vec_clear(uq_vec)


# q(), this may be a better way than using uq() !

vec struct__q_vec
vec *q_vec = NULL

q_init()
	q_vec = &struct__q_vec
	init(q_vec, vec, cstr, 16)

cstr q(const char *s)
	if !q_vec
		q_init()
	new(b, buffer, 128)
	system_quote(s, b)
	cstr q = buffer_to_cstr(b)
	vec_push(q_vec, q)
	return q

q_clean()
	if q_vec
		for_vec(i, q_vec, cstr)
			Free(*i)
		vec_clear(q_vec)

cstr qq(cstr s)
	new(b, buffer, PATH_MAX)
	buffer_cat_char(b, '"')
	sh_quote(s, b)
	buffer_cat_char(b, '"')
	return buffer_to_cstr(b)

cstr x(cstr command)
	FILE *s = Popen(command, "r")
	cstr rv = buffer_to_cstr(fslurp(s))
	Pclose(s)
	return rv

 # TODO similar with argument escaping and/or formatting etc.

sh_unquote(cstr s)
	char *o = s
	while *s
		if *s == '\\'
			++s
		*o++ = *s++
	*o = '\0'

char *sh_unquote_full(cstr s)
	char *o = s
	while *s
		if *s == '\''
			while *s != '\''
				*o++ = *s++
			++s
		 eif *s == '\"'
			while *s != '\"'
				if *s == '\\'
					++s
				*o++ = *s++
			++s
		 eif isspace(*s)
			# this will separate args with \0
			*o++ = '\0'
			++s
		 else
			if *s == '\\'
				++s
			*o++ = *s++
	*o = '\0'
	return o
