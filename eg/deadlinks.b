#!/lang/b

use b

Main()
	find_main(f, s)
		if S_ISLNK(s->st_mode) && readlinks(f, OE_ERRCODE) == NULL
			Say(f)
