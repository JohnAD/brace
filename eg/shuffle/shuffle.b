#!/lang/b
use b
Main()
	if args
		usage("< file")
	let(lines, slurp_lines())
	int n = lines->size
	for_vec(i, lines, cstr)
		swap(*i, i[randi(n--)])
		Say(*i)
