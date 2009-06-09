use stdlib.h
use error util
export types

extern char **environ

#TODO error handler support, i.e. a longjmp to an error handler if there is one

char *env__required = (char *)-1

# TODO change to use regular opt_err instead of env__required etc

char *Getenv(const char *name, char *_default)
	char *value = getenv(name)
	if value == NULL
		if _default == env__required
			error("missing required env arg: %s\n", name)
		value = _default
	return value

def Getenv(name) Getenv(name, "")

def Getenv_or_null(name) Getenv(name, NULL)
def Getenv_required(name) Getenv(name, env__required)

def env(name) Getenv(name)
def env(name, _default) Getenv(name, _default)

boolean is_env(const char *name)
	return *Getenv(name, "")

Putenv(char *string)
	if putenv(string) != 0
		failed("putenv")

dump_env()
	for_env_raw(e)
		Sayf("%s", e)

def for_env_raw(e)
	let(my(p), environ)
	for ; my(p) && *my(p); ++my(p)
		let(e, *my(p))

def for_env(k)
	for_env(k, my(v))
def for_env(k, v)
	for_env_raw(k)
		let(v, strchr(k, '='))
		if !v
			error("bad environment varaible >%s<", k)
		*v = '\0'
		++v
