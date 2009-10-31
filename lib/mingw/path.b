export types
use cstr

def path__sep '\\'
def path__is_sep(c) c == '\\' || c == '/'
def path__sep_cstr "\\"
def path__root_before_sep ""
def path__root "\\"
def PATH_sep ';'
def EXE ".exe"
def SO ".dll"

fix_path(cstr p)
#	if p[1] == ':' && among(p[2], '\\', '/')
#		p[1] = tolower((unsigned char)p[0])
#		p[0] = '/'
	for_cstr(i, p)
		if *i == '\\'
			*i = '/'

boolean path_is_abs(cstr path)
	return path__is_sep(path[0]) ||
	  (isalpha(path[0]) && path[1] == ':' && path__is_sep(path[2]))
