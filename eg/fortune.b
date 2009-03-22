#!/lang/b
use b

Main()
	let(n, 1)
	cstr choice = NULL
	eachline(l)
		if Randi(n) == 0
			Free(choice)
			choice = strdup(l)
		++n
	if choice
		Say(choice)
