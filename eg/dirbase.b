#!/lang/b
use b

Main()
	if args != 1
		usage("pathname")
	dirbasename(strdup(arg[0]), dir, base)
	Say(dir)
	Say(base)
