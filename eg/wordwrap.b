#!/lang/b

Main()
	if args != 1
		usage("width")
	int width = atoi(arg[0])
	sched_init()
	new(r, reader)
	new(s, splitter)
	new(f, filler, width)
	new(w, writer)
	sh(cstr, r, s)
	sh(cstr, s, f)
	sh(cstr, f, w)

	start(r)
	start(s)
	start(f)
	start(w)
	run()

proc reader()
	port cstr out
	state cstr s
	repeat
		s = Input()
		wr(out, s)
		if s == NULL
			break

proc splitter()
	port cstr in
	port cstr out
	state cstr line
	state cstr rest
	state cstr word
	repeat
		rd(in, line)
		if line == NULL
			break
		rest = line
		while *rest == ' '
			++rest
		if *rest == '\0'
			wr(out, strdup(""))
		else
			while rest != NULL
				while *rest == ' '
					++rest
				if *rest == '\0'
					break
				word = rest
				rest = strchr(rest, ' ')
				if rest == NULL
					wr(out, strdup(word))
					wr(out, strdup(""))
					break
				*rest = '\0'
				++rest
				wr(out, strdup(word))
		Free(line)
	wr(out, NULL)

# TODO get macros to work within coros
# I wanted a macro to write the buffer, like this:
#    buffer_add_nul(b)
#    wr(out, strdup(buffer_get_start(b)))
#    buffer_clear(b)
# but couldn't because the symbol "b" needs to be remapped ...
# can I use local macros to do that remapping?

# TODO some sort of subroutines / states / functions-that-can-yield within coros

proc filler(int width)
	port cstr in
	port cstr out
	state buffer struct__b
	state buffer *b = &struct__b
	state cstr word
	buffer_init(b)

	repeat
		rd(in, word)
		if word == NULL
			if buffer_get_size(b)
				buffer_add_nul(b)
				wr(out, strdup(buffer_get_start(b)))
				buffer_clear(b)
			wr(out, NULL)
			buffer_free(b)
			stop

		eif cstr_is_empty(word)
			buffer_add_nul(b)
			wr(out, strdup(buffer_get_start(b)))
			buffer_clear(b)

		else
			int len = strlen(word)
			if buffer_get_size(b) && (int)buffer_get_size(b) + len > width
				buffer_add_nul(b)
				wr(out, strdup(buffer_get_start(b)))
				buffer_clear(b)
			if buffer_get_size(b)
				buffer_cat_char(b, ' ')
			buffer_cat_cstr(b, word)

proc writer()
	port cstr in
	state cstr s
	repeat
		rd(in, s)
		if s == NULL
			break
		Say(s)
		Free(s)

# REMEMBER - if using wr to write a var, that var MUST be state, not a local var
#    if splitting a string and freeing it, must alloc new strings for the words!

use b

shuttle(cstr)
