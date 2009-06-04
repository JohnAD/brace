export curses.h
export stdarg.h
use io util

# This curses wrapper is massively incomplete!  :)

# TODO NEED generic failure wrapper generating macros!!  should the wrappers
# themselves be functions or macros?  maybe each could be both!  lol
# I guess that's actually doable to some extent if we let brace make args
# pass-by-ref transparently.  hmmm maybe silly though

# An idea for brace IO - should always use the same functions,
# i.e. say, print, input, clear, but with selectable backend, of
# (stdio, curses, gr, string...).  That would be rather nice.
# also gr should have selectable backend too, e.g. X11, win32, postscript,
# libart, ...
# This should be done using macros or (unknown) namespace stuff at compile
# time.  can be different in different scopes.  OO  :)  if want runtime
# choices, use a "switch" backend I guess.  is there some simple way to impl
# these polymorphism dispatch things?  maybe define the function as a func ptr
# instead I guess for that scope.  or could be a func ptr inside a struct using
# "with", or ...  nice :)

WINDOW *Initscr()
	WINDOW *win = initscr()
	if win == NULL
		failed("initscr")
	return win

Endwin()
	if endwin() == ERR  # FIXME possible clobberage
		failed("endwin")

WINDOW *Newwin(int nlines, int ncols, int begin_y, int begin_x)
	WINDOW *rv = newwin(nlines, ncols, begin_y, begin_x)
	if rv == NULL
		failed("newwin")
	return rv

Mvwaddstr(WINDOW *win, int y, int x, const char *str)
	if mvwaddstr(win, y, x, str) == ERR
		failed("mvwaddstr")

Touchwin(WINDOW *win)
	if touchwin(win) == ERR
		failed("touchwin")

Wrefresh(WINDOW *win)
	if wrefresh(win) == ERR
		failed("wrefresh")

Erase()
	if erase() == ERR
		failed("erase")
Werase(WINDOW *win)
	if werase(win) == ERR
		failed("werase")

Clear()
	if clear() == ERR
		failed("clear")
Wclear(WINDOW *win)
	if wclear(win) == ERR
		failed("wclear")

Mvwprintw(WINDOW *win, int y, int x, const char *fmt, ...)
	Wmove(win, y, x)
	collect_void(Vwprintw, win, fmt)
Wprintw(WINDOW *win, const char *fmt, ...)
	collect_void(Vwprintw, win, fmt)
Vwprintw(WINDOW *win, const char *fmt, va_list varglist)
	if vwprintw(win, fmt, varglist) == ERR
		failed("vwprintw")

# would rename move to at, for BBC basic and gr compatibility :p
# hmm I need to deal with namespaces and/or linker symbol renaming
# right about real soon now!

#at(int y, int x)
#	move(y, x)

Wmove(WINDOW *win, int y, int x)
	if wmove(win, y, x) == ERR
		failed("wmove")

# can we assume that cc gives strings the same addresses?  if so, we can use
# `foo == "foo" -- but foo can be a macro or macro parameter, i.e. func name..
# maybe the linker doesn't collect multiple copies of strings into one...
# but it should...  maybe does?

int Getch()
	int rv = getch()
	if rv == ERR
		failed("getch")
	return rv

int Wgetch(WINDOW *win)
	int rv = wgetch(win)
	if rv == ERR
		failed("wgetch")
	return rv

Delwin(WINDOW *win)
	if delwin(win) == ERR
		failed("delwin")

WINDOW *Subwin(WINDOW *orig, int nlines, int ncols, int begin_y, int begin_x)
	WINDOW *rv = subwin(orig, nlines, ncols, begin_y, begin_x)
	if rv == NULL
		failed("subwin")
	return rv

Box(WINDOW *win, chtype verch, chtype horch)
	if box(win, verch, horch) == ERR
		failed("box")

Wgetnstr(WINDOW *win, char *str, int n)
	if wgetnstr(win, str, n) == ERR
		failed("wgetnstr")  # FIXME timeouts?

Wborder(WINDOW *win, chtype ls, chtype rs, chtype ts, chtype bs, chtype tl, chtype tr, chtype bl, chtype br)
	if wborder(win, ls, rs, ts, bs, tl, tr, bl, br) == ERR
		failed("wborder")
