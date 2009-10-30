#!/lang/b
use b

cstr version = "1.0"

cstr description = "install - Sam Watkins, 2009"

cstr usage[] =
	"[-m=mode] [file...] directory",
	"--help",
	NULL

cstr options[][3] =
	{ "V", "version",   "" },
	{ "v", "verbose",   "" },
	{ "m", "mode",      "set mode" },
	{ "d", "directory", "create directories" },
	{ NULL, NULL, NULL }

opts *O

Main()
	O = get_options(options)
	long mode = 0755
	if opt("verbose")
		is_verbose = 1
	if opt("mode")
		cstr mode_str = opt("mode")->arg[0]
		if !mode_str
			error("missing mode")
		mode = STRTOL(mode_str, 8)
	if opt("directory")
		eacharg(dir)
			Verbose("mkdirs  %s", dir)
			Mkdirs(dir)
	 else
		rargs(cstr, target)
		Mkdirs(target)
		eacharg(file)
			Verbose("install %s %s", file, target)
			cstr tmp = Strdup(file)
			cstr dest = path_cat(target, base_name(tmp))
			remove(dest)
			cp(file, dest)
			Chmod(dest, mode)
			Free(dest) ; Free(tmp)
