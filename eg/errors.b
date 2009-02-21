#!/lang/b

use b

Main()
	warn("\npart 1 - bash - ignores errors - will not use except\n")

	bash(e)
		error("ignore an error")
		fault("ignore another error")

	warn_errors("no errors will be printed")

	warn("\npart 2 - bash_warn - try with a handler - will not longjmp / use except\n")

	bash_warn(e1)
		error("warn an error")
		fault("warn another error")

	warn("\npart 3 - bash_keep - keep the errors to print later\n")

	bash_keep(e2)
		error("warn an error")
		fault("warn another error")

	if errors()
		warn_errors("there were %d errors:", errors())

	warn("\npart 4 - try - this is the most useful sort of error handler\n")

	try(a)
		try(b)
			error("first error")
		 except(b)
			warn("there was an error")
			warn_errors()
			clear_errors()
			for(a, 1, 5)
				warn("%d keep going", a)
				if a % 3 == 0 && toss()
					error("multiple of 3 and 'heads'!")
	 final()
		warn("this happens, fail or not")
	 except(a)
		warn("in try-else block")
		fault("a fake programming error!")
