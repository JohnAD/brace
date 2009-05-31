use stdlib.h

use error util alloc cstr
use env

Clearenv()
	environ = NULL

Setenv(const char *name, const char *value, int overwrite)
	if setenv(name, value, overwrite)
		failed("setenv")

int setenv(const char *name, const char *value, int overwrite)
	if overwrite || !getenv(name)
		char *kv = malloc(strlen(name)+strlen(value)+2)
		if !kv
			return -1
		strcpy(kv, name)
		strcat(kv, "=")
		strcpy(kv, value)
		if (putenv(kv) == -1)
			return -1
	return 0

		# XXX this string kv becomes "part of the environment" right?
		# so I can't ever free it?
