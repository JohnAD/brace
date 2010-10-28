export types

def path__sep '/'
def path__is_sep(c) c == '/'
def path__sep_cstr "/"
def path__root_before_sep ""
def path__root "/"
def PATH_sep ':'
def EXE ""
def SO ".so"

boolean path_is_abs(cstr path)
	return path__is_sep(path[0])
