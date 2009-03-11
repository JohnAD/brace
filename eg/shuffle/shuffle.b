#!/lang/b
use b
Main()
	if args
		usage("< file")
	let(lines, slurp_lines())
	int n = veclen(lines)
	for_vec(i, lines, cstr)
		swap(*i, i[Randi(n--)])
		Say(*i)
