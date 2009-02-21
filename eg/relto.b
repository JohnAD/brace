#!/lang/b

Main()
	unless(args == 2)
		usage("base rel")

	let(base, arg[0])
	let(rel, strdup(arg[1]))

	let(path, path_relative_to(base, rel))
#	path = path_tidy(path)

	Say(path)

use b
