export errno.h setjmp.h
use stdio.h stdarg.h stdlib.h
use main buffer util path env
export vec hash thunk

export error

def debug warn
#def debug void

int exit__error = 125
int exit__fault = 124

# warning: because sigsetjmp is a lot slower than setjmp I have changed to using setjmp
# This means that the signal mask might be wrong after an exception, have to be careful about that.
# I could make an option to use sigsetjmp in some cases.
# perf:  sigsetjmp = 0.7ms  setjmp = 0.025ms  28X faster

# Generally, a function that outputs error messages etc should not generate new
# errors (for fear of an infinite loop). That's also the case for warnings,
# because many error printing functions call a warning function to print the
# message.

# Anything that outputs on stderr should flush stdout first and stderr after.
# On mingw, stderr is not automatically flushed. Maybe that can be configured?

# TODO or, use try and fatal to handle errors in error routines?

error(const char *format, ...)
	New(b, buffer)
	va_list ap
	va_start(ap, format)
	Vsprintf(b, format, ap)
	va_end(ap)
	buffer_add_nul(b)
	buffer_squeeze(b)
	Throw(buffer_get_start(b), 0, NULL)

serror(const char *format, ...)
	int no = errno
	New(b, buffer)
	va_list ap
	va_start(ap, format)
	Vsprintf(b, format, ap)
	va_end(ap)
	Sprintf(b, ": %s", Strerror(no))
	buffer_add_nul(b)
	buffer_squeeze(b)
	Throw(buffer_get_start(b), no, NULL)

warn(const char *format, ...)
	format_add_nl(format1, format)
	va_list ap
	va_start(ap, format)
	fflush(stdout)
	vfprintf(stderr, format1, ap)
	va_end(ap)
	fflush(stderr)  # mingw doesn't autoflush stderr

failed(const char *funcname)
	serror("%s failed", funcname)

# I think this 2 arg version isn't used
failed2(const char *funcname, const char *errmsg)
	serror("%s failed: %s", funcname, errmsg)
failed3(const char *funcname, const char *msg1, const char *msg2)
	serror("%s failed: %s, %s", funcname, msg1, msg2)

def failed(funcname, errmsg)
	failed2(funcname, errmsg)

def failed(funcname, msg1, msg2)
	failed3(funcname, msg1, msg2)

def failed0(funcname)
	error("%s failed", funcname)

def failed0(funcname, errmsg)
	error("%s failed: %s", funcname, errmsg)

def failed0(funcname, msg1, msg2)
	error("%s failed: %s, %s", funcname, msg1, msg2)

warn_failed(const char *funcname)
	swarning("%s failed", funcname)

swarning(const char *format, ...)
	va_list ap
	va_start(ap, format)
	fflush(stdout)
	Vfprintf(stderr, format, ap)
	va_end(ap)
	fprintf(stderr, ": ")
	Perror(NULL)
	fflush(stderr)

# hexdump from util is better, but this is ok for single-line stuff
memdump(const char *from, const char *to)
	Fflush(stdout)
	while from != to
		Fprintf(stderr, "%02x ", (const unsigned char)*from)
		++from
	Fprintf(stderr, "\n")
	Fflush(stderr)

# TODO provide a way to disable assertion checking (null macro)
error__assert(int should_be_true, const char *format, ...)
	if !should_be_true
		New(b, buffer)
		va_list ap
		va_start(ap, format)
		Vsprintf(b, format, ap)
		va_end(ap)
		buffer_add_nul(b)
		buffer_squeeze(b)
		Throw(buffer_get_start(b), 0, NULL)

def assert(should_be_true, format) error__assert(should_be_true, format)
def assert(should_be_true, format, a1) error__assert(should_be_true, format, a1)
def assert(should_be_true, format, a1, a2) error__assert(should_be_true, format, a1, a2)
def assert(should_be_true, format, a1, a2, a3) error__assert(should_be_true, format, a1, a2, a3)
def assert(should_be_true, format, a1, a2, a3, a4) error__assert(should_be_true, format, a1, a2, a3, a4)

usage(char *syntax)
	error("usage: %s %s", program, syntax)

# exception handling stuff - including revised versions of error() etc

struct err
	cstr msg
	int no
	void *data
	# add "where" somehow

vec *error_handlers
vec *errors

# TODO add a way to handle errors in coros here

struct error_handler
#	sigjmp_buf *jump
	jmp_buf *jump
	thunk handler
	int err

# TODO
# vec *cleanup_handlers

# Don't know how to do this with return.
# Maybe use "return" that calls cleanup handlers / finally first.
# Use exceptions instead of "return" out of place or goto?

error_init()
	global(error_handlers, vec, error_handler, 16)
	global(errors, vec, err, 16)
	global(extra_error_messages, hashtable, int_hash, (eq_func)int_eq, 101)

def try(h)
	try(h, thunk_null, 1)
def try(h, thunk)
	try(h, thunk, 0)
def try(h, thunk, need_jump)
	state error_handler *h = vec_push(error_handlers)
	h->handler = *thunk
	if need_jump
#		h->jump = Talloc(sigjmp_buf)
		h->jump = Talloc(jmp_buf)
#		h->err = sigsetjmp(*h->jump, 1)
		h->err = setjmp(*h->jump)
	 else
		h->jump = NULL
		h->err = 0
	state int my(stage)
	for my(stage) = 0 ; h->err == 0 ; ++my(stage)
		if my(stage) == 1
			if need_jump
				Free(h->jump)
			vec_pop(error_handlers)
			break
		.

def final()
	.
		.

def except(h)
	if h->err
		.

err *error_add(cstr msg, int no, void *data)
	err *e = vec_push(errors)
	e->msg = msg
	e->no = no
	e->data = data
	return e

def errors() vec_get_size(errors)

def Throw() throw_(NULL)
def Throw(msg) Throw(msg, 0)
def Throw(msg, no) Throw(msg, no, NULL)

Throw(cstr msg, int no, void *data)
	throw_(error_add(msg, no, data))

throw_(err *e)
	if vec_is_empty(error_handlers)
		die_errors(exit__error)
	error_handler *h = vec_top(error_handlers)
	if thunk_not_null(&h->handler)
		if thunk_call(&h->handler, e)
			h->jump = NULL
	if h->jump
		vec_pop(error_handlers)
#		siglongjmp(*h->jump, 1)
		longjmp(*h->jump, 1)

def die_errors() die_errors(1)

die_errors(int status)
	warn_errors()
	if *env("DEBUG")
		abort()
	exit(status)

clear_errors()
	for_vec(e, errors, err)
		Free(e->msg)
		Free(e->data)
	vec_set_size(errors, 0)

def warn_errors(format)
	warn(format)
	warn_errors()
def warn_errors(format, a0)
	warn(format, a0)
	warn_errors()
def warn_errors(format, a0, a1)
	warn(format, a0, a1)
	warn_errors()
def warn_errors(format, a0, a1, a2)
	warn(format, a0, a1, a2)
	warn_errors()
def warn_errors(format, a0, a1, a2, a3)
	warn(format, a0, a1, a2, a3)
	warn_errors()

warn_errors()
	warn_errors_keep()
	clear_errors()

warn_errors_keep()
	for_vec(e, errors, err)
		warn("%s", e->msg)

def debug_errors(format)
	debug(format)
	debug_errors()
def debug_errors(format, a0)
	debug(format, a0)
	debug_errors()
def debug_errors(format, a0, a1)
	debug(format, a0, a1)
	debug_errors()
def debug_errors(format, a0, a1, a2)
	debug(format, a0, a1, a2)
	debug_errors()
def debug_errors(format, a0, a1, a2, a3)
	debug(format, a0, a1, a2, a3)
	debug_errors()

debug_errors()
	debug_errors_keep()
	clear_errors()

debug_errors_keep()
	for_vec(e, errors, err)
		debug("%s", e->msg)

def fault(format)
	fault_(__FILE__, __LINE__, format)
def fault(format, a0)
	fault_(__FILE__, __LINE__, format, a0)
def fault(format, a0, a1)
	fault_(__FILE__, __LINE__, format, a0, a1)
def fault(format, a0, a1, a2)
	fault_(__FILE__, __LINE__, format, a0, a1, a2)
def fault(format, a0, a1, a2, a3)
	fault_(__FILE__, __LINE__, format, a0, a1, a2, a3)
def fault(format, a0, a1, a2, a3, a4)
	fault_(__FILE__, __LINE__, format, a0, a1, a2, a3, a4)

int throw_faults = 0

fault_(char *file, int line, const char *format, ...)
	file = best_path_main(Strdup(file))
	New(b, buffer)
	Sprintf(b, "%s:%d: ", file, line)
	va_list ap
	va_start(ap, format)
	Vsprintf(b, format, ap)
	va_end(ap)
	buffer_add_nul(b)
	buffer_squeeze(b)
	if throw_faults
		Throw(buf0(b), 0, NULL)
	 else
		error_add(buf0(b), 0, NULL)
		die_errors(exit__fault)

hashtable *extra_error_messages

add_error_message(int errnum, cstr message)
	int *_errnum = Malloc(sizeof(int))
	*_errnum = errnum
	hashtable_add(extra_error_messages, _errnum, message)

cstr Strerror(int errnum)
	key_value *kv = hashtable_lookup(extra_error_messages, &errnum)
	if kv == NULL
		return strerror(errnum)
	 else
		return kv->value

Perror(const char *s)
	cstr msg = Strerror(errno)
	if s
		warn("%s: %s", s, msg)
	 else
		warn("%s", msg)

# "bash" runs all the code in the block, ignoring errors
# (any errors are still collected)
# This is not related to the shell "bash"!

def bash(h)
	try(h, thunk_error_ignore, 0)

def bash_warn(h)
	try(h, thunk_error_warn, 0)

def bash_keep(h)
	try(h, thunk_null, 0)

thunk _thunk_error_warn = { error_warn, NULL, NULL }
thunk *thunk_error_warn = &_thunk_error_warn

void *error_warn(void *obj, void *common_arg, void *er)
	use(obj) ; use(common_arg)
	fflush(stdout)
	fprintf(stderr, "%s\n", ((err*)er)->msg)
	fflush(stderr)
	vec_pop(errors)
	return thunk_yes

thunk _thunk_error_ignore = { error_ignore, NULL, NULL }
thunk *thunk_error_ignore = &_thunk_error_ignore

void *error_ignore(void *obj, void *common_arg, void *er)
	use(obj) ; use(common_arg) ; use(er)
	vec_pop(errors)
	return thunk_yes
