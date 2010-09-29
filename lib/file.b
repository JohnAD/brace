# XXX this is not included in b.b yet

use cstr io alloc error util path
export cstr

struct file
	cstr path
	cstr dir
	cstr base
	Stats *st
	Lstats *lst
	FILE *stream
	int fd
	int o_flags
	mode_t mode

	cstr dirbase

# path is malloc'd
file_init(file *f, cstr path)
	f->path = path
	f->dirbase = NULL
	f->st = NULL
	f->lst = NULL
	f->stream = NULL
	f->fd = -1
	f->o_flags = O_RDONLY
	 # TODO could copy from a template object, would be faster?

def file_init(f) file_init(f, NULL)

file_free(file *f)
	Free(f->path)
	Free(f->dirbase)
	Free(f->st)
	Free(f->lst)
	if f->stream != NULL
		fclose(f->stream)
	if f->fd != -1
		close(f->fd)

cstr file_get_base(file *f)
	if !f->base
		file_dirbase(f)
	return f->base

cstr file_get_dir(file *f)
	if !f->dir
		file_dirbase(f)
	return f->dir

def need_path()
	assert(f->path != NULL, "file path not defined")

file_dirbase(file *f)
	need_path()
	f->dirbase = Strdup(f->path)
	dirbasename(f->dirbase, dir, base)
	f->dir = dir ; f->base = base

def file_dirbase(f, dir, base)
	file_dirbase(f)
	let(dir, f->dir)
	let(base, f->base)

Stats *file_get_stats(file *f)
	if !f->st
		file_stat(f)
	return f->st

Lstats *file_get_lstats(file *f)
	if !f->lst
		file_lstat(f)
	return f->lst

boolean file_stat(file *f)
	need_path()
	if f->st == NULL
		heap(f->st, Stats)
	init(f->st, Stats, f->path)
	return S_EXISTS(f->st->st_mode)
 # this is dodgy, but should work

boolean file_lstat(file *f)
	need_path()
	if f->lst == NULL
		heap(f->lst, Lstats)
	init(f->lst, Lstats, f->path)
	return S_EXISTS(f->lst->st_mode)
        # should return S_ISLNK() instead?
 # this is dodgy, but should work

# have separate method to set mode, use unix mode to construct stdc mode

#int file_open(file *f, int o_flags, mode_t mode)
#	f->o_flags = o_flags
#	f->mode = mode
#	f->fd = open(f->path, o_flags, mode)
#	return f->fd
#
#file_fd(file *f)
#	if f->fd == -1
#		file_open(f)
#	return f->fd
#
#file_stream(file *f)
#	if f->stream == NULL
#		file_open(f)
#		f->stream = Fdopen(f->fd, mode)
#		f->mode = mode
#	 eif !str_eq(f->mode, mode)
#	 	file_close(f)
