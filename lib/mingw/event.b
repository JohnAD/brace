use event

typedef int KeySym

def NoSymbol -1   # XXX check this, is it 0 in X?

def KeyPress 2
def KeyRelease 3
def ButtonPress 4
def ButtonRelease 5
def MotionNotify 6

def ShiftMask 0  # XXX FIXME

int events_queued(boolean wait_for_event)
	# XXX this gets the message and removes it from the queue on mingw
	gr_mingw_debug("events_queued")
	if wait_for_event && !veclen(gr_need_delay_callbacks)
		gr_mingw_debug("GetMessage")
		return GetMessage(&msg, NULL, 0, 0)
	gr_mingw_debug("PeekMessage")
	int n = PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)
	gr_mingw_debug("PeekMessage = %d", n)
	return n

handle_event()
	gr_mingw_debug("handle_event")
	if msg.message == WM_QUIT
		gr_mingw_debug("WM_QUIT")
		quit(NULL, NULL, NULL)
	else
		gr_mingw_debug("Translate/Dispatch")
		TranslateMessage(&msg)
		DispatchMessage(&msg)

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
	# brace's switch / case syntax is pretty bad, ins't it?  :)
	gr_mingw_debug("WndProc")
	int type
	int but
	switch message
	WM_CREATE	.
		gr_mingw_debug("WM_CREATE")
		# TODO?
		break
	WM_CLOSE	.
	WM_DESTROY	.
		gr_mingw_debug("WM_DESTROY")
		PostQuitMessage(0)
		break
	WM_KEYDOWN	type = KeyPress ; key
	WM_KEYUP	type = KeyRelease ; key
#	WM_CHAR	.   # XXX?
key		gr_mingw_debug("WM_KEYDOWN")
#		which wParam
#		VK_ESCAPE	
#			PostQuitMessage(0)
		gr_event e =
			type, wParam, -1, -1,
			lParam, -1
		thunk_call(&control->keyboard, &e)
		break
	WM_MOUSEMOVE	type = MotionNotify ; but = which_but(wParam)
		if but:
			mouse
		break
	WM_LBUTTONDOWN	type = ButtonPress ; but = 1 ; mouse
	WM_LBUTTONUP	type = ButtonRelease ; but = 1 ; mouse
	WM_MBUTTONDOWN	type = ButtonPress ; but = 2 ; mouse
	WM_MBUTTONUP	type = ButtonRelease ; but = 2 ; mouse
	WM_RBUTTONDOWN	type = ButtonPress ; but = 3 ; mouse
	WM_RBUTTONUP	type = ButtonRelease ; but = 3 ; mouse
mouse		.
			gr_event e =
				type, but,
				(short)LOWORD(lParam), (short)HIWORD(lParam),
				wParam, -1
			thunk_call(&control->mouse, &e)
		break
	WM_PAINT	.
		gr_mingw_debug("WM_PAINT")
		PAINTSTRUCT ps
		HDC hdc
		hdc = BeginPaint(hWnd, &ps)
		boolean paint_handle_events_old = paint_handle_events
		paint_handle_events = 0
		Paint()
		paint_handle_events = paint_handle_events_old    # UGH!
		EndPaint(hWnd, &ps)
		break
#	WM_SIZE	.
#		gl_size(LOWORD(lParam), HIWORD(lParam))
# TODO fix & add more, e.g. & especially repaint!
		break
	else	.
		gr_mingw_debug("unknown message type %d", message)
		return DefWindowProc(hWnd, message, wParam, lParam)
	return 0

def which_but(wParam) (wParam & MK_LBUTTON) ? 1 : (wParam & MK_MBUTTON) ? 2 : (wParam & MK_RBUTTON) ? 3 : 0

# key handlers -----------------------------------------------

XDisplayKeycodes(Display *display, int *key_first, int *key_last)
	use(display)
	*key_first = 0
	*key_last = 255

int XStringToKeysym(char *keystr)
	if keystr[0] == '\0':
		error("XStringToKeysym: empty key string")
	if keystr[1] == '\0':
		return keystr[0]
	# FIXME lookup in a hash table
	if cstr_eq(keystr, "Escape"):
		return VK_ESCAPE
	warn("XStringToKeysym: unknown key string %s", keystr)
	return 0

int XKeysymToKeycode(Display *display, KeySym keysym):
	use(display)
	return keysym

int XKeycodeToKeysym(Display *display, KeySym keycode, int shift)
	use(display, shift)
	return keycode
	# TODO add case for shift?

char key_string_static[2]  # FIXME static

char *XKeysymToString(KeySym keysym)
	if keysym == VK_ESCAPE:   # FIXME use X KeySym names, Escape?
		return "Escape"
	key_string_static[0] = keysym
	key_string_static[1] = '\0'
	return key_string_static
	# FIXME lookup in a table I guess, and don't use static

def gr_key_avoid_auto_repeat_press(e) 0
def gr_key_avoid_auto_repeat_release(e, is_callback) 0


# mouse handlers --------------------------------------------

# (this is generic)


# recentering when the window is resized ---------------------

# TODO ?


# event type names ---------------------------------------

# TODO merge with X version?

long2cstr event_type_names[] =
	{ KeyPress, "KeyPress" },
	{ KeyRelease, "KeyRelease" },
	{ ButtonPress, "ButtonPress" },
	{ ButtonRelease, "ButtonRelease" },
	{ MotionNotify, "MotionNotify" },
