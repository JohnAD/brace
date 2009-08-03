#!/lang/b
use b
Main()
	new(noises, vec, cstr, 500)
	Freopen("mcdonald.conf", "r", stdin)
	eachline(line)
		cstr *w = split(line, ' ')
		cstr animal = w[0]
		cstr noise = w[1]
		vec_push(noises, Strdup(noise))
		sf("Old MacDonald had a farm,")
		sf("E-I-E-I-O,")
		sf("And on that farm he had a %s,", animal)
		sf("E-I-E-I-O.")
		back_vec(_n, noises, cstr)
			cstr n = *_n
			sf("With a %s-%s here and a %s-%s there,", n, n, n, n)
			sf("Here-a-%s, there-a-%s, everywhere a %s-%s.", n, n, n, n)
		sf()
	sf("Old MacDonald had a farm,")
	sf("E-I-E-I-O.")

# TODO put in lib

Def back_vec(i, v, type)
	state type *my(end) = (type *)vec0(v)-1
	state type *my(i1) = (type *)vecend(v)-1
	for ; my(i1)!=my(end) ; --my(i1)
		let(i, my(i1))
		.
