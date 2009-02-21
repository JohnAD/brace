export types buffer
use error cstr vec
use process

Execv(const char *path, char *const argv[])
	execv(path, argv)
	failed("execv")

Execvp(const char *file, char *const argv[])
	execvp(file, argv)
	failed("execvp")

Execve(const char *filename, char *const argv[], char *const envp[])
	execve(filename, argv, envp)
	failed("execvp")

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
	int rv
	va_list ap
	va_start(ap, format)
	rv = Vsystemf(format, ap)
	va_end(ap)
	return rv

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
	Signal(2, SIG_IGN)

def allow_ctrl_c()
	Signal(2, SIG_DFL)

int Systemv(const char *filename, char *const argv[])
	# the filename is repeated in argv[0] - so skip it
	++argv;
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
