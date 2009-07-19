use stdlib.h
use error util
export types
use env path

# FIXME these aren't in mingw, they are less standard apparently
# I should implement setenv at least for mingw.
# unsetenv can be implemented with putenv too.
# clearenv might be done with environ = NULL ?

Unsetenv(const char *name)
	unsetenv(name)

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

cstr homedir()
	return Getenv("HOME", path__root)
