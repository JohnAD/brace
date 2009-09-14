#!/lang/b
use b

Main()
	if args
		usage("< file")
	let(lines, slurp_lines())
	int n = veclen(lines)
	for(i, 0, n-1)
		int j = randi(i, n)
		cstr *a = v(lines, i)
		cstr *b = v(lines, j)
		swap(*a, *b)
	for_vec(l, lines, cstr)
		Say(*l)
