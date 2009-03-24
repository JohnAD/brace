use b
# TODO cache the excutables by hash of source code?
Main()
	boolean cplusplus = 0
	cstr lang = "b"
	cstr dotb = ".b"
	if strncmp(program, "bb", 2) == 0
		cplusplus = 1
		lang = "bb"
		dotb = ".bb"

	boolean keep = 0

	if args && cstr_eq(arg[0], "-k")
		keep = 1
		shift()

	new(b, buffer, 256)
	cstr file
	FILE *f
	file = cstr_cat("./b1-prog", dotb)
	f = fopen(file, "w")
	if !f
		int fd = Temp(b, "b1-", dotb)
		file = buffer_to_cstr(b)
		f = Fdopen(fd, "w")
	Fsayf(f, "#!/lang/%s", lang)
	Fsayf(f, "use b")
	if cplusplus
		Fsayf(f, "using namespace std")
		Fsayf(f, "use iostream")
	int first = 1
	if args > 0
		cstr start = arg[0]
		int cont = 1
		while cont
			cstr end = strchr(start, '\n');
			if end
				*end = '\0'
				if end>start && end[-1] == '\r'
					end[-1] = '\0'
			 else
			 	cont = 0
			putline(start)
			start = end+1
		++arg ; --args
	 else
		eachline(l)
			putline(l)
	Fclose(f)
	cx(file)
	int status = Systema(file, arg)
	if !keep
		Remove(file)
		dirbasename(file, dir, base)
		Systemf("rm %s/.%s*", dir, base)
	return status

def putline(l)
	if first
		if cstr_begins_with(l, "use ") || cstr_begins_with(l, "export ")
			Fsay(f, l)
		 else
			Fsayf(f, "Main()")
			first = 0
	if !first
		Fsayf(f, "\t%s", l)
