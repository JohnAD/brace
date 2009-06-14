use m path error io net env vio sym
export cstr hash

use main

int argc
int args
char **argv
char **envp
char *program_full
char *program_real
char *program
char *program_dir
char **arg
char *main_dir

def Main()
	main(int main__argc, char *main__argv[], char *main__envp[])
		main__init(main__argc, main__argv, main__envp)

main__init(int _argc, char *_argv[], char *_envp[])
	argc = _argc
	argv = _argv
	envp = _envp
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

def opt(opt) optlast(opt)
def optc(opt) optc(O, opt)
def optlast(opt) optlast(O, opt)
def opt1st(opt) opt1st(O, opt)
def optv(opt) optv(O, opt)

def opt(O, opt) optlast(opt)
def optc(O, opt) mgetc(&O->h, opt)
def optlast(O, opt) mgetlast(&O->h, opt)
def opt1st(O, opt) mget1st(&O->h, opt)
def optv(O, opt) mget(&O->h, opt)

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

opts *get_options(cstr options[][2])
	new(short_ht, hashtable, cstr_hash, cstr_eq, 257)

	if options
		kv_cstr_to_hashtable(options, short_ht)

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
