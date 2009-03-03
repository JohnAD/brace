# returns malloc'd
cstr darcs_root()
	new(b, buffer, 256)
	until(exists("_darcs"))
		Getcwd(b)
		if cstr_eq(buffer_to_cstr(b), "/")
			error("not in a darcs repository")
		buffer_clear(b)
		Chdir("..")
	Getcwd(b)
	return buffer_to_cstr(b)

# path malloc'd -> malloc'd
cstr _darcs_path(cstr path, cstr root, cstr cwd)
	let(ref, cstr_cat(cwd, "/"))
	Path_relative_to(path, ref)
	Free(ref)
	path = path_tidy(path)
	path = path_under(root, path)
	unless(path)
		error("path outside repository", path)
	return path

def darcs_path(path, root, cwd)
	path = _darcs_path(path, root, cwd)

def darcs_path(path)
	let(my(dir), Getcwd())
	let(my(root), darcs_root())
	darcs_path(path, my(root), my(dir))
	Free(my(dir))
	Free(my(root))

# TODO fix my!

cstr darcs_exists(cstr darcs_path)
	let(rv, cstr_cat("_darcs/current/", darcs_path))
	return exists(rv) ? rv : NULL

export cstr
use io error util buffer path alloc
