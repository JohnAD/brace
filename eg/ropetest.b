#!/lang/b
use rope main cstr

Main()
	let(hello, r(strdup("Hello, World!")))
	let(h2, r(hello, TAB, hello))
	let(h4, r(h2, NL, h2))

	*str_chr(hello.s, ',') = ';'
	str_str(hello.s, s("World")).start[1] = 'u'

	rope_dump(h4)
	nl()
	Say(R(h4))
	nl()
	Sayf("%d", rope_get_size(hello))
	Sayf("%d", rope_get_size(h2))
	Sayf("%d", rope_get_size(h4))
