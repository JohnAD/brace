export unistd.h stdarg.h signal.h pwd.h grp.h shadow.h sched.h sys/wait.h sys/utsname.h crypt.h
use string.h
export buffer types
use error cstr vec util sym

use process

#int sig_execfailed = 64
int sig_execfailed = SIGUSR2
# A process in brace should not otherwise be terminated by SIGUSR2.
# If that is a problem, the program can set sig_execfailed to 64 or something.

typedef void (*sighandler_t)(int)

pid_t Fork()
	if process__fork_fflush
		Fflush_all()
	pid_t pid = fork()
	if pid == -1
		failed("fork")
	 eif pid == 0
		process__forked = 1
	return pid

# TODO cope with interrupted system calls universally, aargh
# This Waitpid restarts in the case of an interrupted system call.

pid_t Waitpid(pid_t pid, int *status, int options)
	pid_t r_pid
	repeat
		r_pid = waitpid(pid, status, options)
		if r_pid == -1
			if errno != EINTR
				failed("waitpid")
		else
			return r_pid

int Child_wait(pid_t pid)
	Waitpid(pid, &wait__status, 0)
	wait__status = fix_exit_status(wait__status)
	return wait__status

pid_t Child_done()
	pid_t pid = Waitpid(-1, &wait__status, WNOHANG)
	if pid
		wait__status = fix_exit_status(wait__status)
	return pid

# This Waitpid can return -1 in case of an interrupted system call

pid_t Waitpid_intr(pid_t pid, int *status, int options)
	pid_t r_pid = waitpid(pid, status, options)
	if r_pid == -1 && errno != EINTR
		failed("waitpid")
	return r_pid

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
	return Strdup(Getpwuid(geteuid())->pw_name)

def ignore_pipe()
	Sigign(SIGPIPE)
def ignore_hup()
	Sigign(SIGHUP)

def system_quote sh_quote

# FIXME should update this stuff when call setuid or something,
# or don't use it at all.
uid_t uid_root = 0
int myuid = -1
int mygid = -1
def Getuid() (uid_t)(myuid != -1 ? myuid : (myuid = getuid()))
def Getgid() (gid_t)(mygid != -1 ? mygid : (mygid = getgid()))

int auth(user *u, cstr pass)
	return auth_pw((passwd *)u, pass)
int auth_pw(passwd *pw, cstr pass)
	char *x = pw->pw_passwd
	char salt[64]
	char *dollar = strrchr(x, '$')
	if !dollar
		return 0
	int l = dollar - x
	assert(l < (int)sizeof(salt), "auth: salt too long")
	strlcpy(salt, x, l+1)
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
def Seteuidgid_via_root(pw)
	Seteuidgid_root()
	Seteuidgid(pw)
def Setuidgid(uid, gid)
	Setgid(gid) ; Setuid(uid)
def Setuidgid(pw)
	Setuidgid(pw->pw_uid, pw->pw_gid)
def Setuidgid_via_root(pw)
	Seteuidgid_root()
	Setuidgid(pw)

def Setgroups(user)
	Setgroups(user->n_groups, user->gids)

Setgroups(size_t size, const gid_t *list)
	if setgroups(size, list)
		failed("setgroups")

def Setuser(user)
	Setgroups(user)
	Seteuidgid(user)

def Setuser_root()
	Seteuidgid_root()
	Setgroups(0,NULL)
def Setuser_via_root(user)
	Setuser_root()
	Setuser(user)

typedef struct passwd passwd
typedef struct spwd spwd
typedef struct group group

struct user
	char *pw_name
	char *pw_passwd
	uid_t pw_uid
	gid_t pw_gid
	char *pw_gecos
	char *pw_dir
	char *pw_shell
	long n_groups
	char **groups
	gid_t *gids
	long n_members
	char **members
	uid_t *mids

int passwd_n_buckets = 1009

hashtable *load_users()
	sym_init()
	New(ht, hashtable, cstr_hash, cstr_eq, passwd_n_buckets)
	passwd *p
	while (p = Getpwent())
		user *u = passwd_to_user(p)
		put(ht, u->pw_name, u)
	spwd *s
	while (s = Getspent())
		user *u = get(ht, s->sp_namp)
		Free(u->pw_passwd)
		u->pw_passwd = Strdup(s->sp_pwdp)
	endspent()
	group *g
	while (g = Getgrent())
		user *u = get(ht, g->gr_name)
		if !u  # there must be a user for each group
			continue
		char **p = g->gr_mem
		while *p
			++u->n_members
			++p
		u->members = Nalloc(char *, u->n_members)
		u->mids = Nalloc(uid_t, u->n_members)
		char **member = u->members
		gid_t *mid = u->mids
		p = g->gr_mem
		while *p
			user *m = get(ht, *p)
			++m->n_groups
			*member++ = sym(*p)
			*mid++ = m->pw_uid
			++p
	endgrent()
	setpwent()
	while (p = Getpwent())
		user *u = get(ht, p->pw_name)
		u->groups = Nalloc(char *, u->n_groups)
		u->gids = Nalloc(gid_t, u->n_groups)
		u->n_groups = 0
	setpwent()
	while (p = Getpwent())
		user *u = get(ht, p->pw_name)
		int i = 0
		for ; i<u->n_members ; ++i
			user *m = get(ht, u->members[i])
			m->groups[m->n_groups] = u->pw_name
			m->gids[m->n_groups] = u->pw_gid
			++m->n_groups
	endpwent()
	return ht

#passwd *passwd_dup(passwd *_p)
#	passwd *p = Talloc(passwd)
#	*p = *_p
#	p->pw_name = Strdup(p->pw_name)
#	p->pw_passwd = Strdup(p->pw_passwd)
#	p->pw_gecos = Strdup(p->pw_gecos)
#	p->pw_dir = Strdup(p->pw_dir)
#	p->pw_shell = Strdup(p->pw_shell)
#	return p

#passwd_free(passwd *p)
#	Free(p->pw_name)
#	Free(p->pw_passwd)
#	Free(p->pw_gecos)
#	Free(p->pw_dir)
#	Free(p->pw_shell)
#	Free(p)

user *passwd_to_user(passwd *p)
	user *u = Talloc(user)
	*(passwd*)u = *p
	u->pw_name = sym(p->pw_name)
	u->pw_passwd = Strdup(p->pw_passwd)
	u->pw_gecos = Strdup(p->pw_gecos)
	u->pw_dir = Strdup(p->pw_dir)
	u->pw_shell = sym(p->pw_shell)
	u->n_groups = 0
	u->groups = NULL
	u->gids = NULL
	u->n_members = 0
	u->members = NULL
	u->mids = NULL
	return u

user_free(user *u)
#	Free(u->pw_name)
	Free(u->pw_passwd)
	Free(u->pw_gecos)
	Free(u->pw_dir)
#	Free(u->pw_shell)
	Free(u->members)
	Free(u->mids)
	Free(u)

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

struct group *Getgrent()
	struct group *rv
	errno = 0
	rv = getgrent()
	if !rv && errno
		failed("getgrent")
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

sighandler_t sigact(int signum, sighandler_t handler, int sa_flags)
	struct sigaction act, oldact
	act.sa_handler = handler
	sigemptyset(&act.sa_mask)
	act.sa_flags = sa_flags
	if sigaction(signum, &act, &oldact) < 0
		return SIG_ERR
	return oldact.sa_handler

Sigprocmask(int how, const sigset_t *set, sigset_t *oldset)
	if sigprocmask(how, set, oldset)
		failed("sigprocmask")

sigset_t Sig_defer(int signum)
	return Sig_mask(signum, 1)

sigset_t Sig_pass(int signum)
	return Sig_mask(signum, 0)

sigset_t Sig_mask(int signum, int defer)
	sigset_t set
	sigset_t oldset
	sigemptyset(&set)
	sigaddset(&set, signum)
	Sigprocmask(defer ? SIG_BLOCK : SIG_UNBLOCK, &set, &oldset)
	return oldset

sigset_t Sig_setmask(sigset_t *set)
	sigset_t oldset
	Sigprocmask(SIG_SETMASK, set, &oldset)
	return oldset

sigset_t Sig_getmask()
	sigset_t oldset
	Sigprocmask(SIG_SETMASK, NULL, &oldset)
	return oldset

# TODO define SA_INTERRUPT = 0 for unix systems that don't provide it.

# TODO Sigsuspend, Sigwait

Sigsuspend(const sigset_t *mask)
	if sigsuspend(mask) < 0 && errno != EINTR
		failed("sigsuspend")

# This was some code using Sigsuspend, it's not needed, because raise doesn't
# return until after the signal was handled / delivered.  It makes sense if the
# call to "raise" is removed.
#
#	let(mask, Sig_defer(sig_execfailed))
#	Sigdfl(sig_execfailed)
#	Sigdelset(&mask, sig_execfailed)
#	raise(sig_execfailed)
#	Sigsuspend(&mask)

int Sigwait(const sigset_t *mask)
	int sig
	sigwait(mask, &sig)
	return sig

Nice(int inc)
	errno = 0
	if nice(inc) == -1 && errno
		failed("nice")

Sched_yield()
	if sched_yield() < 0
		failed("sched_yield")

def SH_QUIET "exec 2>/dev/null; "

exit_exec_failed()
	if sig_execfailed
		Sigdfl(sig_execfailed)
		Sig_pass(sig_execfailed)
		Raise(sig_execfailed)

	Exit(exit__execfailed)

Sigdfl_all()
	for(i, 1, SIGRTMAX+1)
		if among(i, SIGKILL, SIGSTOP) || (i>=32 && i<SIGRTMIN)
			continue
		sigdfl(i)

def set_child_handler(sigchld_handler)
	Sigact(SIGCHLD, sigchld_handler)

def nochldwait(signum) signum == SIGCHLD ? SA_NOCLDSTOP : 0
