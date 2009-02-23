use b
Main()
	boolean cplusplus = 0
	cstr lang = "b"
	cstr dotb = ".b"
	if strncmp(program, "bb", 2) == 0
		cplusplus = 1
		lang = "bb"
		dotb = ".bb"

	new(b, buffer, 256)
	int fd = Temp(b, "b1_", dotb)
	cstr file = buffer_to_cstr(b)
	FILE *f = Fdopen(fd, "w")
	Fsayf(f, "#!/lang/%s", lang)
	Fsayf(f, "use b")
	if cplusplus
		Fsayf(f, "using namespace std")
		Fsayf(f, "use iostream")
	Fsayf(f, "Main()")
	if args > 0
		Fsayf(f, "\t%s", arg[0])
		++arg ; --args
	 else
		eachline(l)
			Fsayf(f, "\t%s", l)
	Fclose(f)
	cx(file)
	int status = Systema(file, arg)
	Remove(file)
	dirbasename(file, dir, base)
	Systemf("rm %s/.%s*", dir, base)
	return status
