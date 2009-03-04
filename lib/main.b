use m path cstr error io net env vio

use main

int argc
int args
char **argv
char **envp
char *program_full
char *program
char *program_dir
char **arg
char *main_dir
int mingw

def Main()
	main(int main__argc, char *main__argv[], char *main__envp[])
		main__init(main__argc, main__argv, main__envp)

main__init(int _argc, char *_argv[], char *_envp[])
	argc = _argc
	argv = _argv
	envp = _envp
	mingw = is_env("WINDIR") || is_env("windir")
	vstreams_init()
	error_init()
	main_dir = Getcwd()
	program_full = argv[0]
	dirbasename(Strdup(program_full), d, b)  # this is bogus!  need auto decl
	program_dir = d
	program = b
	if cstr_ends_with(program, ".exe")
		program[strlen(program)-4] = '\0'
	 # for mingw
	if program[0] == '.'
		++program
	arg = argv+1
	args = argc - 1
	seed()
	os_main_init()

# TODO
#namemap
#	main__main main
#	main main__real

# todo module initializers
