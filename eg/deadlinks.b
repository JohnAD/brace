#!/lang/b

use b

Main()
	find_main(f, s)
		if S_ISLNK(s->st_mode) && readlinks(f, ERRCODE) == NULL
			Say(f)
