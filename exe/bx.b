Main()
	if args < 1
		usage("program.b [ arg ... ]")

	if mingw && !*Getenv("MSYSTEM")
		Atexit(hold_term_open)

	volatile cstr br = "br"       # setjmp -> volatile
	volatile cstr langopt = "-b"
	if strncmp(program, "bb", 2) == 0
		br = "bbr"
		langopt = "-bb"
	cstr libb

	int add_to_PATH = 0
	cstr brace = which("brace" EXE)
	if brace == NULL
		if mingw
			brace = strdup("c:\\Program Files\\brace\\bin\\brace.exe")
			add_to_PATH = 1
			if !exists(brace)
				brace = NULL
	if brace == NULL
		error("Please ensure brace is installed and in your PATH.")

	let(brace_bin_dir, dir_name(brace))
	if add_to_PATH
		Putenv(format("PATH=%s%c%s", brace_bin_dir, PATH_sep, Getenv("PATH")))

	let(brace_dir, dir_name(brace_bin_dir))
	let(brace_lib_dir, path_cat(brace_dir, "lib"))
	libb = path_cat(brace_lib_dir, "libb" SO)

	new(libb_stat, Stats, libb)
	if !S_EXISTS(libb_stat->st_mode)
		error("Please ensure libb" SO " is installed.")

	volatile cstr b = strdup(arg[0])
	if mingw
#		if b[1] == ':' && among(b[2], '\\', '/')
#			b[1] = tolower(b[0])
#			b[0] = '/'
		for_cstr(i, b)
			if *i == '\\'
				*i = '/'
	 else
		b = readlinks(b)

	dirbasename(strdup(b), dir, base)

	volatile cstr x = path_tidy(format("%s%c.%s%s", dir, path__sep, base, EXE))
	cstr lockfile = path_tidy(format("%s%c.%s.lock", dir, path__sep, base))
	cstr log = path_tidy(format("%s%c.%s.log", dir, path__sep, base))

	new(b_stat, Stats, b)
	if !S_EXISTS(b_stat->st_mode)
		error("source file %s does not exist!", b)

	new(log_stat, Stats, log)

	# debugging

	if is_env("BX_DEBUG")
		Putenv("DEBUG=1")

	# This try cludgyness is needed so that if an error occurs, the lockfile
	# will still be removed.  Ideally it would be nice if lock() could do
	# that automatically.

	int status = 0

	new(x_stat, Stats, x)
	int need_compile = !S_EXISTS(x_stat->st_mode) || x_stat->st_size == 0 || x_stat->st_mtime < b_stat->st_mtime || x_stat->st_mtime < libb_stat->st_mtime
	if need_compile
		lock(lockfile)
			new(b_stat, Stats, b)
			new(x_stat, Stats, x)
			new(log_stat, Stats, log)
			new(libb_stat, Stats, libb)
			need_compile = !S_EXISTS(x_stat->st_mode) || x_stat->st_size == 0 || x_stat->st_mtime < b_stat->st_mtime || x_stat->st_mtime < libb_stat->st_mtime
			int already_compiled = S_EXISTS(log_stat->st_mode) && b_stat->st_mtime < log_stat->st_mtime && log_stat->st_mtime > libb_stat->st_mtime
			if already_compiled
				error("%s has not been updated, check %s or try: fix %s", b, log, b)
			if need_compile
				try(err)
					do
						if mingw
							status = Systeml(format("sh%s", EXE), br, langopt, b, x, NULL)
						 else
							status = Systeml(br, langopt, b, x, NULL)
					 while status == br_return_again_after_fix

					if status
						error("%s compile failed...", br)
				except(err)
					status = 1

	if status
		Throw()

	# debugging

	if is_env("BX_DEBUG")
		# gdb --args x arg...
		++arg ; --args
		cstr gdb = which("gdb")
		cstr *gdbargs = Nalloc(cstr, args+4)
		gdbargs[0] = gdb
		gdbargs[1] = "--args"
		gdbargs[2] = x
		memmove(gdbargs+3, arg, (args+1)*sizeof(cstr))

		x = gdb
		arg = gdbargs

	# execute

	if mingw
		exit(Systemv(x, arg))
		 # this is "ok" since mingw system returns the actual return value
		 # Execv doesn't wait on mingw?!
	 else
		Execv(x, arg)

def br_return_again_after_fix 123

use process error buffer cstr io alloc main path env time
