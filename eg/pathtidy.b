#!/lang/b
use b

Main()
	if args != 1
		usage("pathname")
	let(path, path_tidy(strdup(arg[0])))
	Say(path)
