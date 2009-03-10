export unistd.h stdarg.h signal.h pwd.h shadow.h
use sys/wait.h string.h sched.h
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

def ignore_pipe()
	Signal(SIGPIPE, SIG_IGN)
def ignore_hup()
	Signal(SIGHUP, SIG_IGN)

def system_quote sh_quote

# FIXME should update this stuff when call setuid or something,
# or don't use it at all.
uid_t uid_root = 0
int myuid = -1
int mygid = -1
def Getuid() (uid_t)(myuid != -1 ? myuid : (myuid = getuid()))
def Getgid() (gid_t)(mygid != -1 ? mygid : (mygid = getgid()))

int auth(passwd *pw, cstr pass)
	char *x = pw->pw_passwd
	char salt[64]
	int l = Strrchr(x, '$') - x
	assert(l < (int)sizeof(salt), "auth: salt too long")
	strncpy(salt, x, l)
	salt[l] = '\0'
#	Sayf("%s %s %s", x, salt, crypt(pass, salt))
	return cstr_eq(x, crypt(pass, salt)) && !cstr_eq(pw->pw_shell, "/bin/false")

def Become(user)
	Become(user, my(p))
def Become(user, p)
	passwd *p = Getpwnam(user)
	if !p
		error("user not found: %s", user)
	become(p)
		.

def become(pw)
	become(pw->pw_uid, pw->pw_gid)
		.

def become(uid, gid)
	post(my(x))
		Seteuid(0)
		Setegid(0)
	pre(my(x))
		Setegid(gid)
		Seteuid(uid)
		.

def Seteuidgid(pw)
	Seteuidgid(pw->pw_uid, pw->pw_gid)
def Seteuidgid(uid, gid)
	Setegid(gid) ; Seteuid(uid)
def Seteuidgid_root()
	Seteuid(0) ; Setegid(0)

typedef struct passwd passwd
typedef struct spwd spwd

hashtable *load_passwd()
	New(ht, hashtable, cstr_hash, (eq_func)cstr_eq, 10007)
	passwd *p
	while (p = Getpwent())
		p = passwd_dup(p)
		put(ht, p->pw_name, p)
	endpwent()
	spwd *s
	while (s = Getspent())
		passwd *p = get(ht, s->sp_namp)
		Free(p->pw_passwd)
		p->pw_passwd = strdup(s->sp_pwdp)
	endspent()
	return ht

passwd *passwd_dup(passwd *_p)
	passwd *p = Talloc(passwd)
	*p = *_p
	p->pw_name = Strdup(p->pw_name)
	p->pw_passwd = Strdup(p->pw_passwd)
	p->pw_gecos = Strdup(p->pw_gecos)
	p->pw_dir = Strdup(p->pw_dir)
	p->pw_shell = Strdup(p->pw_shell)
	return p

passwd_free(passwd *p)
	Free(p->pw_name)
	Free(p->pw_passwd)
	Free(p->pw_gecos)
	Free(p->pw_dir)
	Free(p->pw_shell)
	Free(p)

struct passwd *Getpwent()
	struct passwd *rv
	errno = 0
	rv = getpwent()
	if !rv && errno
		failed("getpwent")
	return rv

struct passwd *Getpwnam(const char *name)
	struct passwd *rv
	errno = 0
	rv = getpwnam(name)
	if !rv && errno
		failed("getpwnam")
	return rv

struct passwd *Getpwuid(uid_t uid)
	struct passwd *rv
	errno = 0
	rv = getpwuid(uid)
	if !rv && errno
		failed("getpwuid")
	return rv

struct spwd *Getspent()
	struct spwd *rv
	errno = 0
	rv = getspent()
	if !rv && errno
		failed("getspent")
	return rv

struct spwd *Getspnam(const char *name)
	struct spwd *rv
	errno = 0
	rv = getspnam(name)
	if !rv && errno
		failed("getspnam")
	return rv

Setuid(uid_t uid)
	if setuid(uid)
		failed("setuid")

Setgid(gid_t gid)
	if setgid(gid)
		failed("setgid")

Seteuid(uid_t euid)
	if seteuid(euid)
		failed("seteuid")

Setegid(gid_t egid)
	if setegid(egid)
		failed("setegid")

Setreuid(uid_t ruid, uid_t euid)
	if setreuid(ruid, euid)
		failed("setreuid")

Setregid(gid_t rgid, gid_t egid)
	if setregid(rgid, egid)
		failed("setregid")


