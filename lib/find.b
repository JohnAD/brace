export path deq

# the handler must free the filename

# typedef void (*find_handler)(cstr filename, lstats *s)
# 
# find(deq *q, find_handler h)
# 	cstr f
# 	while deq_get_size(q)
# 		deq_shift(q, f)
# 		new(buf, lstats, f)
# 		if S_EXISTS(buf->st_mode)
# 			if S_ISDIR(buf->st_mode)
# 				find__its_a_dir(f)
# 			(*h)(f, buf)
# 
# def find__its_a_dir(f)
# 	new(v, vec, cstr)
# 	let(dir, Opendir(f))
# 	repeat
# 		let(ent, Readdir(dir))
# 		if ent == NULL
# 			break
# 		cstr new_f = ent->d_name
# 		unless(cstr_eq(new_f, ".") || cstr_eq(new_f, ".."))
# 			new_f = cstr_cat(f, path__sep_cstr, new_f)
# 			# possible problem, if f == "/" we get "//foo" :/
# 			# That's a bug in unix!
# 			# TODO write & use path_cat
# #			deq_push(v, new_f)
# 			vec_push(v, new_f)
# 	
# 	# I'm not happy with this temporary vec
# 	# -- is there a better way?  could use recursion...  :/
# 	# maybe find shouldn't try to preserve order at all..
# 	# That's reasonable but it's a cop out!
# 	# Could have a rope-like thing for vec/deq, that would be ok.
# 	
# 	while vec_get_size(v)
# 		cstr f
# 		vec_pop(v, f)
# 		deq_unshift(q, f)

# this is a bit bogus, what is a better way to handle closures/methods?
# a "global" this pointer, which can be stored/restored?
#  typedef void (*find__handler)(cstr filename, lstats *s, ...)

# something as big as find as a macro, it's not ideal..
# but the syntax of using it is nice I guess,
# and we can possibly have a way to convert macro-format stuff to functions
# including temporary functions and passing the necessary args, later..

# XXX TODO should free the deq q !

def find(root, f, s)
	find_deq_x(normal, root, f, s)
		.

def find_init(q, root)
	new(q, deq, cstr)
	deq_push(q, root)

def find_deq_x(what, root, f, s)
	find_init(my(q), root)
	find_deq_^^what(my(q), f, s)
		.

def find_deq_normal(q, f, s)
	find_deq(q, f, s)
		.

def find_leaves(root, f, s)
	find_deq_x(leaves, root, f, s)
		.

def find_all(root, f, s)
	find_deq_x(all, root, f, s)
		.

def find_all_leaves(root, f, s)
	find_deq_x(all_leaves, root, f, s)
		.

def find_dirs(root, f, s)
	find_deq_x(dirs, root, f, s)
		.

def find_reg(root, f, s)
	find_deq_x(reg, root, f, s)
		.

def find_lnk(root, f, s)
	find_deq_x(lnk, root, f, s)
		.

# IDEA - non-homogenous deq, queue, etc?  nah!  couldn't do random access..
# not that I ever do anyway yet

def find_deq_1(q, f, s)
	cstr f
	while deq_get_size(q)
		deq_shift(q, f)
		new(s, lstats, f)
		if !S_EXISTS(s->st_mode)   # why wouldn't it exist?? maybe if a bad parameter?
			continue
		.

def find_deq_recurse(q, f, s)
	if S_ISDIR(s->st_mode)
		find__its_a_dir(q, f)

def find_deq_all(q, f, s)
	find_deq_1(q, f, s)
		find_deq_recurse(q, f, s)
		.

def find_deq(q, f, s)
	find_deq_1(q, f, s)
		find_skip_hidden(f)
		find_deq_recurse(q, f, s)
		.

def find_skip_dir(s)
	if S_ISDIR(s->st_mode)
		continue

def find_skip_hidden(f)
	if path_hidden(f)
		continue

def find_only_dir(s)
	if !S_ISDIR(s->st_mode)
		continue

def find_only_reg(s)
	if !S_ISREG(s->st_mode)
		continue

def find_only_lnk(s)
	if !S_ISLNK(s->st_mode)
		continue

def find_deq_leaves(q, f, s)
	find_deq(q, f, s)
		find_skip_dir(s)
		.

def find_deq_all_leaves(q, f, s)
	find_deq_all(q, f, s)
		find_skip_dir(s)
		.

def find_deq_dirs(q, f, s)
	find_deq_all(q, f, s)
		find_only_dir(s)
		.

def find_deq_reg(q, f, s)
	find_deq(q, f, s)
		find_only_reg(s)
		.

def find_deq_lnk(q, f, s)
	find_deq(q, f, s)
		find_only_lnk(s)
		.

# IDEA - for a particular directory, do all files first,
# then do subdirectories.

# we could assume all "find" arguments are directories only,
# or make a separate _find that assumes this

def find__its_a_dir(q, f)
	new(my(v), vec, cstr)
	let(my(dir), Opendir(f))
	repeat
		let(my(ent), Readdir(my(dir)))
		if my(ent) == NULL
			break
		cstr my(new_f) = my(ent)->d_name
		unless(cstr_eq(my(new_f), ".") || cstr_eq(my(new_f), ".."))
			my(new_f) = path_cat(f, my(new_f))
			vec_push(my(v), my(new_f))
	Closedir(my(dir))
	
	while vec_get_size(my(v))
		cstr my(new_f)
		vec_pop(my(v), my(new_f))
		deq_unshift(q, my(new_f))

# I'm not happy with this temporary vec
# -- is there a better way?  could use recursion...  :/
#   *** or a "manual" context stack, yes that's better.  how to do that with coros/process ---->  this is good
# maybe find shouldn't try to preserve order at all..
# That's reasonable but it's a cop out!
# Could have a rope-like thing for vec/deq, that would be ok.

# TOO MUCH "my"  :)

def find_main(f, s)
	new(q, deq, cstr)
	eacharg(a)
		let(b, Strdup(a))
		deq_push(q, b)
	if args == 0
		cstr dot = Strdup(".")
		deq_push(q, dot)
	
	find_deq(q, f, s)
		.

#def find(h)
#	new(my(q), deq, cstr)
#	cstr my(dot) = Strdup(".")
#	deq_push(my(q), my(dot))
#	find(my(q), h)

find_vec(cstr root, vec *v)
	find(root, f, s)
		vec_push(v, f)

find_vec_all(cstr root, vec *v)
	find_all(root, f, s)
		vec_push(v, f)

