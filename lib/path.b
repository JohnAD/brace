export types util cstr
use alloc vec env

use path  # slight hack?  for the specifics path__sep etc


# possible problem, if f == "/" we get "//foo" :/
# That's a bug in unix!
# path_cat fixes that

cstr path_cat(cstr a, cstr b)
	if cstr_ends_with(a, path__sep_cstr)
		if *b
			return cstr_cat(a, b)
		 else
			return Strndup(a, strlen(a)-1)
	if cstr_eq(a, path__root)
		return cstr_cat(path__root_before_sep, path__sep_cstr, b)
	return cstr_cat(a, path__sep_cstr, b)

def path_cat(a, b, c) path_cat(path_cat(a, b), c)
def path_cat(a, b, c, d) path_cat(path_cat(a, b, c), d)

# this splits a string into dir and base parts.  It modifies its argument.
dirbase dirbasename(cstr path)
	dirbase rv
	let(len, strlen(path))
	if len == 0
		rv.dir = "."
		rv.base = "."
		return rv
	if path__is_sep(path[len-1])
		while len && path__is_sep(path[len-1])
			path[len-1] = '\0' ; --len
		if path[0] == '\0'
			rv.dir = path__root
		 else
			rv.dir = path
		rv.base = "."
		return rv

	let(slash, path+len-2)
	repeat
		if slash < path
			slash = NULL
			break
		if path__is_sep(*slash)
			break
		--slash

	if slash
		*slash = '\0'
		if slash == path
			rv.dir = path__root
		else
			rv.dir = path
		rv.base = slash+1
	else
		rv.dir = "."
		rv.base = path
	return rv

struct dirbase
	cstr dir
	cstr base

def dirbasename(path, dirv, basev)
	let(my(rv), dirbasename(path))
	let(dirv, my(rv).dir)
	let(basev, my(rv).base)

cstr dir_name(cstr path)
	let(rv, dirbasename(path))
	return rv.dir

cstr base_name(cstr path)
	let(rv, dirbasename(path))
	return rv.base

# TODO decent non cstr strings ***
# TODO automatic declaration

# path must be malloc'd, may be freed
# returns malloc'd
cstr path_relative_to(cstr path, cstr origin)
	if cstr_begins_with(path, path__root)
		return path
	origin = Strdup(origin)
	let(dir, dir_name(origin))
	let(_path, Format("%s" path__sep_cstr "%s", dir, path))
	Free(origin)
	Free(path)
	return _path

# malloc'd -> malloc'd
cstr path_tidy(cstr path)
	let(i, path)
	let(o, path)

	boolean o_uppable = 0
	boolean abs = 0

	if *i == '\0'
		error("path_tidy: empty path not valid")

	if path__is_sep(*i)
		*o++ = path__sep ; i++
		abs = 1
	
	repeat
		assert((i == path || path__is_sep(i[-1])) && (o == path || path__is_sep(o[-1])),
		 "borked in path_tidy")

		if path__is_sep(*i)
			++i
		 eif i[0] == '.' && is_slash_or_nul(i[1])
			i += 2
		 else
			boolean dotdot = i[0] == '.' && i[1] == '.' && is_slash_or_nul(i[2])
			if dotdot && o_uppable
				i += 3
				--o_uppable
				do
					--o
				 until(o == path || path__is_sep(o[-1]))
			 eif dotdot && abs
				i += 3
			 else
				assert(!dotdot || (dotdot && !abs && !o_uppable), "borked in path_tidy 2")
				unless(dotdot)
					++o_uppable
				do
					*o++ = *i++
				 until(is_slash_or_nul(i[-1]))
		if i[-1] == '\0'
			break
		 eif o != path
			o[-1] = path__sep

	if (o-path > 1 && path__is_sep(o[-1])) ||
	  (o-path > 0 && o[-1] == '\0')
		--o
	if o == path
		*o++ = '.'
	*o = '\0'

	Realloc(path, o - path + 1)
	return path

# might as well do this for things that "process" their arg:
# TODO rename the main functions to _foo, and these to take thier place
def Path_tidy(path)
	path = path_tidy(path)

def Path_relative_to(path, origin)
	path = path_relative_to(path, origin)
	

# TODO use triple space for indenting continued lines??

def is_slash_or_nul(c) path__is_sep(c) || c == '\0'

# child: malloc'd -> rv
cstr path_under(cstr parent, cstr child)
	cstr e = cstr_begins_with(child, parent)
	if e
		if path__is_sep(*e)
			cstr_chop_start(child, e+1)
			cstr_realloc(child)
			return child
		 eif *e == '\0'
			Free(child)
			return Strdup(".")
	return NULL

# child: malloc'd -> rv
cstr path_under_maybe(cstr parent, cstr child)
	cstr rv = path_under(parent, child)
	if rv == NULL
		rv = child
	return rv

def best_path(path, parent) path_under_maybe(parent, path_tidy(path))
def best_path(path) best_path(path, Getcwd())
def best_path_main(path) best_path(path, main_dir)

boolean path_hidden(cstr p)
	if p[0] == '.' && p[1] == '\0'
		return 0
	while *p != '\0'
		if path__is_sep(*p)
			++p
		 eif *p == '.'
			if path__is_sep(p[1])
				p += 2
			 eif p[1] == '.' && path__is_sep(p[2])
				p += 3
			 else
				return 1
		 else
			while !path__is_sep(*p)
				if *p == '\0'
					return 0
				++p
	return 0

boolean path_hidden_normal(cstr p)
	return path_hidden(p) &&
	 !(p[1] == '\0' || (p[1] == '.' && p[2] == '\0'))

boolean path_has_component(cstr path, cstr component)
	# XXX inefficient
	# XXX if path uses / but component \ for example on win32, it won't work - fix it using path_tidy first
	let(c0, Format(path__sep_cstr "%s" path__sep_cstr, component))
	let(c1, Format(path__sep_cstr "%s", component))
	let(c2, Format("%s" path__sep_cstr, component))
	boolean has = strstr(path, c0) ||
	 cstr_ends_with(path, c1) ||
	 cstr_begins_with(path, c2) ||
	 cstr_eq(path, component)
	Free(c0)
	Free(c1)
	Free(c2)
	return has

# malloc->malloc
def path_to_abs(path) path_to_abs(path, NULL)
cstr path_to_abs(cstr path, cstr cwd)
	if path_is_abs(path)
		return path
	 else
		if !cwd
			cwd = Getcwd()
		cstr path1 = path_tidy(path_cat(cwd, path))
		Free(path)
		return path1

# PATH is vaguely related to paths..!

cstr which(cstr file)
	cstr PATH = Strdup(Getenv("PATH"))
	new(v, vec, cstr, 32)
	splitv(v, PATH, PATH_sep)
	cstr path = NULL
	for_vec(dir, v, cstr)
		path = path_cat(*dir, file)
		if exists(path)
			break
		Free(path)
		 # sets path = NULL again
	vec_free(v)
	Free(PATH)
	return path

cstr Which(cstr file)
	cstr path = which(file)
	if !path
		failed("which", file)
	return path

PATH_prepend(cstr dir)
	PATH_rm(dir)
	cstr new_PATH = Format("%s%c%s", dir, PATH_sep, Getenv("PATH"))
	Setenv("PATH", new_PATH)
	Free(new_PATH)

PATH_append(cstr dir)
	PATH_rm(dir)
	cstr new_PATH = Format("%s%c%s", Getenv("PATH"), PATH_sep, dir)
	Setenv("PATH", new_PATH)
	Free(new_PATH)

PATH_rm(cstr dir)
	cstr PATH = Strdup(Getenv("PATH"))
	new(v, vec, cstr, 32)
	splitv(v, PATH, PATH_sep)
	ssize_t c = veclen(v)
	grep(i, v, cstr, !cstr_eq(*i, dir), void)
	if veclen(v) != c
		cstr new_PATH = joinv(PATH_sep, v)
		Setenv("PATH", new_PATH)
		Free(new_PATH)
	Free(PATH)
