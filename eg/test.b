#!/lang/b
use b

Main()
	new(input, circbuf, 64)
	circbuf_cat_cstr(input, "hello this is a test\nfuck I am in a bad mood\n")
#	new(output, circbuf, 10)
	cb_io(input, input)
		repeat(9000)	
			let(l, rl())
#			warn("after rl")
#			circbuf_dump(input)
			sf("[%s]", l)
#			warn("after sf")
#			circbuf_dump(input)

	circbuf_tidy(input)
	circbuf_nul_terminate(input)

	sf("<%s>", cbuf0(input))

circbuf_dump(FILE *stream, circbuf *b)
	Fprintf(stream, "circbuf: %08x %08x %08x %08x:\n", b->data, b->size, b->space, b->start)
	hexdump(stream, b->data, b->data + b->space)

def circbuf_dump(b)
	circbuf_dump(stderr, b)
