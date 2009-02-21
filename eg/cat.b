#!/lang/b

Main()
	sched_init()
	new(r, reader)
	new(w, writer)
#	name(r, "reader")
#	name(w, "writer")
	shuttle(sh, cstr, r, out, w, in)

	start(r) ; start(w) ; run()

proc reader()
	port cstr out
	repeat
		cstr c = Input()
		wr(out, c)
		if c == NULL
			break
		yield

proc writer()
	port cstr in
	repeat
		cstr s
		rd(in, s)
		if s == NULL
			break
		Say(s)


use b

shuttle(cstr)
