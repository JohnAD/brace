use m path error io net env vio sym
export cstr hash

use main

int argc
int args
char **argv
char *program_full
char *program_real
char *program
char *program_dir
char **arg
char *main_dir

boolean args_literal = 0
boolean args_list = 0

def Main()
	main(int main__argc, char *main__argv[])
		main__init(main__argc, main__argv)

main__init(int _argc, char *_argv[])
	argc = _argc
	argv = _argv
	vstreams_init()
	error_init()
	main_dir = Getcwd()
	program_full = argv[0]
	if !exists(program_full)
		program_full = Which(program_full)
		# this might fail if PATH was not exported :/
	program_real = readlinks(Strdup(program_full))
	# TODO readlinks?
	dirbasename(Strdup(program_real), d, b)  # this is bogus!  need auto decl
	program_dir = d
	program = b
	if mingw && cstr_ends_with(program, ".exe")
		program[strlen(program)-4] = '\0'
	if program[0] == '.'
		++program
	arg = argv+1
	args = argc - 1
	seed()
	os_main_init()

def shift(n)
	arg += n ; args -= n
def shift()
	shift(1)

# TODO
#namemap
#	main__main main
#	main main__real

# todo module initializers


# options

def opt(name) optlast(name)
def optc(name) optc(O, name)
def optlast(name) optlast(O, name)
def opt1st(name) opt1st(O, name)
def optv(name) optv(O, name)

def opt(O, name) optlast(name)
def optc(O, name) (opt*)mgetc(&O->h, name)
def optlast(O, name) (opt*)mgetlast(&O->h, name)
def opt1st(O, name) (opt*)mget1st(&O->h, name)
def optv(O, name) (opt*)mget(&O->h, name)

struct opts
	vec v
	hashtable h

struct opt
	cstr name
	cstr *arg

#TODO? :

#typedef void (*opt_h)(cstr *arg)

#struct opt
#	cstr opt_short
#	cstr opt_long
#	opt_h h
#	cstr *arg

def opts_init(o) opts_init(o, 257)

opts_init(opts *O, size_t opts_hash_size)
	vec_init(&O->v, opt, 16)
	hashtable_init(&O->h, cstr_hash, cstr_eq, opts_hash_size)

# get_options() modifies its input, both the character data and the actual pointers
# and updates the array arg points at to point at non-option arguments.

def get_options() get_options(NULL)

opts *get_options(cstr options[][3])
	new(short_ht, hashtable, cstr_hash, cstr_eq, 257)

	if options
		table_cstr_to_hashtable(short_ht, options, 3, 0, 1)

	New(O, opts)

	char **p = arg
	char **out = arg
	while *p
		let(i, *p)
		if i[0] != '-' || i[1] == '\0'
			*out++ = *p++
			continue
		if i[1] == '-' && i[2] == '\0'
			++p
			while *p
				*out++ = *p++
			args_literal = 1
			break

		opt *o = vec_push(&O->v)

		boolean short_opt = i[1] != '-'
		if short_opt
			o->name = i + 1
		 	i = o->name + 1
		 else
		 	o->name = i + 2
			i = o->name + strcspn(o->name, "=:")

		o->arg = NULL

		char optargs_type = *i
		*i++ = '\0'

		if short_opt
			cstr name_long = get(short_ht, o->name)
			if name_long
				o->name = name_long
			 else
				o->name = sym(o->name)

		mput(&O->h, o->name, o)

		if optargs_type == '='
			o->arg = Nalloc(cstr, 2)
			if *i != '\0'
				o->arg[0] = i
			 else
				++p
				o->arg[0] = *p
			o->arg[1] = NULL
		 eif optargs_type == ':'
			new(v, vec, cstr, 16)
			if *i != '\0'
				vec_push_cstr(v, i)
			while p[1] && p[1][0] != '-'
				cstr oa = *++p
				# hackery to escape a leading '-' if necessary...
				if oa[0] == '\\'
					++oa
				vec_push_cstr(v, oa)
			o->arg = vec_to_array(v)
		 eif optargs_type != '\0' && short_opt
			# allow to group short options
			*--i = optargs_type
			*--i = '-'
			*p = i
			decl(v, vec)
			array_to_vec(v, p)
			continue
			
		++p

	*out = NULL

	args = out - arg

	if args_literal || args
		args_list = 1

	return O

dump_options(opts *O)
	for_vec(o, &O->v, opt)
		Fprint(stderr, o->name)
		if o->arg
			Fprint(stderr, " =")
			forary_null(j, o->arg)
				Fprintf(stderr, " %s", j)
		nl(stderr)
	nl(stderr)

def version()
	sf("%s version %s", program, version)

def version_description()
	if *description
		sf("%s version %s - %s", program, version, description)
	 else
		version()

def help()
	help_(version, description, usage, options)
help_(cstr version, cstr description, cstr *usage, cstr options[][3])
	version_description()
	say_usage()
	say("options:")

	typeof(&*options) i
	int max_len = 0

	for i = options; (*i)[0]; ++i
		cstr long_opt = (*i)[1]
		int len = strlen(long_opt)
		if len > max_len
			max_len = len

	for i = options; (*i)[0]; ++i
		cstr short_opt = (*i)[0]
		cstr long_opt = (*i)[1]
		cstr desc = (*i)[2]
		if *short_opt
			Sayf("  -%1s  --%-*s  %s", short_opt, max_len, long_opt, desc)
		 else
			Sayf("      --%-*s  %s", max_len, long_opt, desc)

def getargs_(type, a0)
	a0 = cstr_to_^^type(arg[0])
	shift()

def getargs(type)
	.
def getargs(type, a0)
	if args
		getargs_(type, a0)
def getargs(type, a0, a1)
	getargs(type, a0)
	getargs(type, a1)
def getargs(type, a0, a1, a2)
	getargs(type, a0, a1)
	getargs(type, a2)
def getargs(type, a0, a1, a2, a3)
	getargs(type, a0, a1, a2)
	getargs(type, a3)
def getargs(type, a0, a1, a2, a3, a4)
	getargs(type, a0, a1, a2, a3)
	getargs(type, a4)
def getargs(type, a0, a1, a2, a3, a4, a5)
	getargs(type, a0, a1, a2, a3, a4)
	getargs(type, a5)

def Getargs(type)
	.
def Getargs(type, a0)
	if !args
		usage()
	getargs_(type, a0)
def Getargs(type, a0, a1)
	Getargs(type, a0)
	Getargs(type, a1)
def Getargs(type, a0, a1, a2)
	Getargs(type, a0, a1)
	Getargs(type, a2)
def Getargs(type, a0, a1, a2, a3)
	Getargs(type, a0, a1, a2)
	Getargs(type, a3)
def Getargs(type, a0, a1, a2, a3, a4)
	Getargs(type, a0, a1, a2, a3)
	Getargs(type, a4)
def Getargs(type, a0, a1, a2, a3, a4, a5)
	Getargs(type, a0, a1, a2, a3, a4)
	Getargs(type, a5)

def args(type)
	.
def args(type, a0)
	type a0
	Getargs(type, a0)
def args(type, a0, a1)
	args(type, a0)
	args(type, a1)
def args(type, a0, a1, a2)
	args(type, a0, a1)
	args(type, a2)
def args(type, a0, a1, a2, a3)
	args(type, a0, a1, a2)
	args(type, a3)
def args(type, a0, a1, a2, a3, a4)
	args(type, a0, a1, a2, a3)
	args(type, a4)
def args(type, a0, a1, a2, a3, a4, a5)
	args(type, a0, a1, a2, a3, a4)
	args(type, a5)


def getrargs_(type, a0)
	a0 = cstr_to_^^type(arg[--args])

def getrargs(type)
	.
def getrargs(type, a0)
	if args
		getrargs_(type, a0)
def getrargs(type, a0, a1)
	getrargs(type, a0)
	getrargs(type, a1)
def getrargs(type, a0, a1, a2)
	getrargs(type, a0, a1)
	getrargs(type, a2)
def getrargs(type, a0, a1, a2, a3)
	getrargs(type, a0, a1, a2)
	getrargs(type, a3)
def getrargs(type, a0, a1, a2, a3, a4)
	getrargs(type, a0, a1, a2, a3)
	getrargs(type, a4)
def getrargs(type, a0, a1, a2, a3, a4, a5)
	getrargs(type, a0, a1, a2, a3, a4)
	getrargs(type, a5)

def Getrargs(type)
	.
def Getrargs(type, a0)
	if !args
		usage()
	getrargs_(type, a0)
def Getrargs(type, a0, a1)
	Getrargs(type, a0)
	Getrargs(type, a1)
def Getrargs(type, a0, a1, a2)
	Getrargs(type, a0, a1)
	Getrargs(type, a2)
def Getrargs(type, a0, a1, a2, a3)
	Getrargs(type, a0, a1, a2)
	Getrargs(type, a3)
def Getrargs(type, a0, a1, a2, a3, a4)
	Getrargs(type, a0, a1, a2, a3)
	Getrargs(type, a4)
def Getrargs(type, a0, a1, a2, a3, a4, a5)
	Getrargs(type, a0, a1, a2, a3, a4)
	Getrargs(type, a5)

def rargs(type)
	.
def rargs(type, a0)
	type a0
	Getrargs(type, a0)
def rargs(type, a0, a1)
	rargs(type, a0)
	rargs(type, a1)
def rargs(type, a0, a1, a2)
	rargs(type, a0, a1)
	rargs(type, a2)
def rargs(type, a0, a1, a2, a3)
	rargs(type, a0, a1, a2)
	rargs(type, a3)
def rargs(type, a0, a1, a2, a3, a4)
	rargs(type, a0, a1, a2, a3)
	rargs(type, a4)
def rargs(type, a0, a1, a2, a3, a4, a5)
	rargs(type, a0, a1, a2, a3, a4)
	rargs(type, a5)
