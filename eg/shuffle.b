#!/lang/b
use b

Main()
	new(lines, vec, cstr, 256)
	eachline(s)
		vec_push(lines, strdup(s))
	int n = vec_get_size(lines)
	for(i, 0, n-1)
		int j = Randint(i, n)
		cstr *ei = vec_element(lines, i)
		cstr *ej = vec_element(lines, j)
		swap(*ei, *ej)
	for_vec(line, lines, cstr)
		Say(*line)
