use stdlib.h
use error util
export types
use env

# FIXME these aren't in mingw, they are less standard apparently
# I should implement setenv at least for mingw.
# unsetenv can be implemented with putenv too.
# clearenv might be done with environ = NULL ?

# TODO Setenvf (or just use Putenv with format)

Setenv(const char *name, const char *value, int overwrite)
	if setenv(name, value, overwrite) != 0
		failed("setenv")

def Setenv(name, value)
	Setenv(name, value, 1)

Unsetenv(const char *name)
	unsetenv(name)

Clearenv()
	if clearenv() != 0
		failed("clearenv")

# re-implement clearenv for openbsd, windows
# FIXME mingw will need unsetenv too?

#def clearenv() clear_env()

# is this okay?
#int clear_env(void)
#	environ = NULL

int clear_env(void)
	new(k, buffer, 256)
	while *environ
		char *equals = strchr(*environ, '=')
		buffer_clear(k)
		if !equals
			buffer_cat_cstr(k, *environ)
		 else
			buffer_cat_str(k, new_str(*environ, equals))
		Say(buffer_get_start(k))
#		unsetenv(k)
	buffer_free(k)
	return 0

