use process

# fake shadow passwords, a bit bogus!

struct spwd
	char *sp_namp
	char *sp_pwdp
	long  sp_lstchg
	long  sp_min
	long  sp_max
	long  sp_warn
	long  sp_inact
	long  sp_expire
	unsigned long sp_flag

static spwd struct__spwd_null, *_spwd_null = &struct__spwd_null

struct spwd *getspent()
	return _spwd_null
struct spwd *getspnam(const char *name)
	use(name)
	return _spwd_null
endspent()
	.
