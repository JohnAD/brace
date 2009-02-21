#!/lang/b
use b
Main()
	new(v, vec, num, 200)
	eachline(l)
		vec_push(v, (num)atof(l))

	nl()
	
	int n = vec_get_size(v)
	Sayf("n: %d", n)

	num av = 0
	.
		for(i, 0, n)
			av += *(num *)vec_element(v, i)
		av /= n
	Sayf("average: %f", av)

	num sd = 0
	.
		for(i, 0, n)
			sd += sqr(*(num *)vec_element(v, i) - av)
		sd = sqrt(sd / n)
	Sayf("sd: %f", sd)

	nl()

	num max = -bignum
	num min = bignum
	.
		for(i, 0, n)
			num n = *(num *)vec_element(v, i)
			if n < min
				min = n
			if n > max
				max = n
	Sayf("min: %f", min)
	Sayf("max: %f", max)

	nl()

	int count_1sd = 0
	int count_2sd = 0
	int count_outside_2sd = 0
	.
		for(i, 0, n)
			num n = *(num *)vec_element(v, i)
			if n >= av - sd && n <= av + sd
				++count_1sd
			if n >= av - 2*sd && n < av + 2*sd
				++count_2sd
			if n < av - 2*sd || n > av + 2*sd
				++count_outside_2sd
	Sayf("within 1sd: %0.2f%%", count_1sd / (num)n * 100)
	Sayf("within 2sd: %0.2f%%", count_2sd / (num)n * 100)
	Sayf("outside 2sd: %0.2f%%", count_outside_2sd / (num)n * 100)

	nl()
