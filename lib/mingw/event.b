use event

typedef int KeySym

def KeyPress 2
def KeyRelease 3
def ButtonPress 4
def ButtonRelease 5
def MotionNotify 6

int events_queued(boolean wait_for_event)
	return 1  # FIXME

##	return XEventsQueued(display, QueuedAfterReading)
##	warn("events_queued: wait_for_event = %d", wait_for_event)
##	int n = XEventsQueued(display, wait_for_event||can_read(x11_fd) ? QueuedAfterReading : QueuedAlready)
#	int n = XEventsQueued(display, QueuedAlready)
##	warn("   = %d", n)
#	if !n:
##		warn("  selecting...")
#		num timeout = wait_for_event && !veclen(gr_need_delay_callbacks) ? time_forever : 0
#		gr_flush()
#		if can_read(x11_fd, timeout):
##			warn("  reading...")
#			n = XEventsQueued(display, QueuedAfterReading)
##			warn("  n = %d", n)
#	return n
#		# is can_read necessary?

boolean handle_event_maybe(boolean wait_for_event)
	int n = events_queued(wait_for_event)
	if n
		handle_event()
	 else
		gr_flush()
	return n

handle_event()
	# XXX FIXME XXX this is BAD as it is a busy-wait loop...
	if PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)
		if msg.message == WM_QUIT
			gr_done = 1
		else
			TranslateMessage(&msg)
			DispatchMessage(&msg)
	else
		.
	# TODO other event types


# key handlers -----------------------------------------------

# FIXME a lot of this is common

def n_key_events 2
int key_first, key_last
thunk (*key_handlers)[n_key_events]
char *key_down
thunk key_handler_default
def gr_n_keys key_last-key_first+1

key_handlers_init()
#	XDisplayKeycodes(display, &key_first, &key_last)
	key_first = 0 ; key_last = 255   # FIXME
	key_handlers = (void*)Nalloc(thunk, gr_n_keys*n_key_events)
	key_down = Zalloc(char, gr_n_keys)
	key_handlers_default()

cstr quit_key = "Escape"

key_handlers_default()
	key_handlers_ignore()
	key_handler(quit_key, KeyPress) = thunk(quit)

key_handlers_ignore()
	for(i, 0, gr_n_keys)
		for(j, 0, n_key_events)
			key_handlers[i][j] = thunk()
	key_handler_default = thunk()

void *quit(void *obj, void *a0, void *event)
	use(obj, a0, event)
	gr_exit(0)
	return thunk_yes

def key_handler(keystr, event_type) key_handlers[keystr_ix(keystr)][key_event_type_ix(event_type)]
def key_handler_keysym(keysym, event_type) key_handlers[keysym_ix(keystr)][key_event_type_ix(event_type)]

int keystr_ix(cstr keystr)
	use(keystr)
	return 0  # FIXME
#	return XKeysymToKeycode(display, XStringToKeysym(keystr)) - key_first
int keysym_ix(KeySym keysym)
	use(keysym)
	return 0  # FIXME
#	return XKeysymToKeycode(display, keysym) - key_first

int key_event_type_ix(int event_type)
	which event_type
	KeyPress	event_type = 0
	KeyRelease	event_type = 1
	else	error("unknown key event type: %d = %s", event_type, event_type_name(event_type))
	return event_type


void *key_handler_main(void *obj, void *a0, void *event)
	use(obj,a0,event)
	# TODO
	return thunk_yes

# mouse handlers --------------------------------------------

# FIXME a lot of this is common =
# TODO move part to main event.b

def n_mouse_events 3
def mouse_first 1
def mouse_last 3
def gr_n_mouse_buttons mouse_last-mouse_first+1
thunk mouse_handlers[gr_n_mouse_buttons][n_mouse_events]
thunk mouse_handler_default

mouse_handlers_init()
	mouse_handlers_default()

mouse_handlers_default()
	mouse_handlers_ignore()

mouse_handlers_ignore()
	for(i, 0, gr_n_mouse_buttons)
		for(j, 0, n_mouse_events)
			mouse_handlers[i][j] = thunk()
	mouse_handler_default = thunk()

def mouse_handler(button, event_type) mouse_handlers[button-mouse_first][mouse_event_type_ix(event_type)]

int mouse_event_type_ix(int event_type)
	which event_type
	ButtonPress	event_type = 0
	ButtonRelease	event_type = 1
	MotionNotify	event_type = 2
	else	error("unknown mouse event type: %d = %s", event_type, event_type_name(event_type))
	return event_type

void *mouse_handler_main(void *obj, void *a0, void *event)
	use(obj,a0,event)
	# TODO
	return thunk_yes

