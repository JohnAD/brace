# cow - copy-on-write

# cow copies read-only files having multiple hard-links
# when they are opened for writing; it is implemented as
# an LD_PRELOAD wrapper for:
#   open, creat, fopen, freopen, open64, creat64, fopen64, freopen64
# Hopefully that's all it needs to deal with!

# cow is free software, placed in the public domain by Sam Watkins, 2004, 2005

use sys/types.h
use sys/stat.h
use fcntl.h
use stdarg.h
use unistd.h
use string.h
use stdlib.h
use stdio.h

# if a file exists, is regular, and has more than 1 hard link to it,
# we try to copy it; returns 0 on success

int cow(const char *path)
	struct stat s
	if stat(path, &s) == 0 && S_ISREG(s.st_mode) && s.st_nlink > 1
		int len = strlen(path)
		char *tmp = malloc(len + 7)
		if tmp == NULL
			return -1
		strcpy(tmp, path)
		strcat(tmp, ".__cow")
		if copy(path, tmp, s.st_mode & 0777) != 0
			free(tmp) ; return -1
		if rename(tmp, path) != 0
			unlink(tmp) ; free(tmp) ; return -1
		free(tmp)
	return 0

int copy(const char *from, const char *to, int mode)
	int in, out
	char buf[1024]
	int r, wtot, w
	
	in = unwrap(open)(from, O_RDONLY)
	if in == -1
		return -1
	out = unwrap(open)(to, O_WRONLY | O_CREAT | O_EXCL, mode)
	if out == -1
		close(in) ; return -1
	repeat
		r = read(in, buf, sizeof(buf))
		if r == -1
			close(out) ; close(in) ; return -1
		if r == 0
			break
		wtot = 0
		repeat
			w = write(out, buf, r)
			if w == -1
				close(out) ; close(in) ; return -1
			wtot += w
			if wtot == r
				break
	close(out) ; close(in)
	return 0

# here are the functions that test if we are opening a file to write
# they return 0 on success

int open_cow(const char *path, int flags)
	if flags & (O_WRONLY | O_RDWR | O_TRUNC)
		return cow(path)
	return 0

int fopen_cow(const char *path, const char *mode)
	if *mode == 'w' || *mode == 'a' || mode[1] == '+' || \
	  (*mode == 'r' && (mode[1] == '+' || \
	   (mode[1] == 'b' && mode[2] == '+')))
		return cow(path)
	return 0

# here are the wrappers for the libc open-like functions
# I hope I didn't miss any!

wrap int open(const char *path, int flags, ...)
	if open_cow(path, flags) != 0
		return -1
	if flags & O_CREAT
		va_list arg_list
		mode_t mode
		va_start(arg_list, flags)
		mode = va_arg(arg_list, mode_t)
		va_end(arg_list);
		return unwrapped(path, flags, mode)
	else
		return unwrapped(path, flags)

wrap int creat(const char *path, mode_t mode)
	if cow(path) != 0
		return -1
	return unwrapped(path, mode)

wrap FILE* fopen(const char *path, const char *mode)
	if fopen_cow(path, mode) != 0
		return NULL
	return unwrapped(path, mode)

wrap FILE* freopen(const char *path, const char *mode, FILE *stream)
	if fopen_cow(path, mode) != 0
		return NULL
	return unwrapped(path, mode, stream)

# these large-file wrappers are identical to above, except in name

wrap int open64(const char *path, int flags, ...)
	if open_cow(path, flags) != 0
		return -1
	if flags & O_CREAT
		va_list arg_list
		mode_t mode
		va_start(arg_list, flags)
		mode = va_arg(arg_list, mode_t)
		va_end(arg_list);
		return unwrapped(path, flags, mode)
	else
		return unwrapped(path, flags)

wrap int creat64(const char *path, mode_t mode)
	if cow(path) != 0
		return -1
	return unwrapped(path, mode)

wrap FILE* fopen64(const char *path, const char *mode)
	if fopen_cow(path, mode) != 0
		return NULL
	return unwrapped(path, mode)

wrap FILE* freopen64(const char *path, const char *mode, FILE *stream)
	if fopen_cow(path, mode) != 0
		return NULL
	return unwrapped(path, mode, stream)
