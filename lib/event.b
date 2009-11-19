export types error thunk gr event

struct gr_event
	int type  # KeyPress, ButtonPress, ButtonRelease, MotionNotify
	int which
	int x, y
	int state
	long time

boolean gr_key_ignore_release = 0
boolean gr_key_auto_repeat = 0

# controller -------------------------------------------------

controller *control = &control_normal

struct controller
	thunk keyboard
	thunk mouse

controller control_null, control_normal

control_init()
	control_null = (controller){ thunk(), thunk() }
	control_normal = (controller){ thunk(key_handler_main), thunk(mouse_handler_main) }
	key_handlers_init()
	mouse_handlers_init()

control_default:
	key_handlers_default()
	mouse_handlers_default()

control_ignore:
	key_handlers_ignore()
	mouse_handlers_ignore()

# event handler ----------------------------------------------

event_handler_init()
	init(gr_need_delay_callbacks, vec, gr_event_callback, 4)
	control_init()

event_loop()
	while !gr_done
		handle_events(1)
		# FIXME it was busy waiting!  whoops.  (fixed)
		# select for next event / other IO events / timeout
		# include need_delay_callbacks in timeouts
		# allow to work with scheduler / coros, but don't depend on coros..?

# FIXME maybe have a wait_for_events() function instead of that boolean?  or a config variable?

int handle_events(boolean wait_for_event)
#	warn("handle_events wait: %d", wait_for_event)
	int n = gr_call_need_delay_callbacks()
	while !gr_done && handle_event_maybe(wait_for_event)
		++n
		wait_for_event = 0
	return n

boolean handle_event_maybe(boolean wait_for_event)
	int n = events_queued(wait_for_event)
	if n
		handle_event()
	 else
		gr_flush()
	return n

# this is to hack around dodgy X auto-repeat -----------------

num gr_need_delay_callbacks_sleep = 0.001   # 1 ms
vec struct__gr_need_delay_callbacks,
 *gr_need_delay_callbacks = &struct__gr_need_delay_callbacks

struct gr_event_callback
	thunk t
	gr_event e
	num time

int gr_call_need_delay_callbacks()
	int n = 0
	size_t old_size = veclen(gr_need_delay_callbacks)
	for_vec(i, gr_need_delay_callbacks, gr_event_callback)
		if thunk_call(&i->t, &i->e)
			++n
	vec_shift(gr_need_delay_callbacks, old_size)
	return n

# simple input functions -------------------------------------

int gr_getc_char
int gr_getc()
	gr_getc_char = -1
	thunk old_handler = key_handler_default
	key_handler_default = thunk(gr_getc_handler)
	while gr_getc_char < 0
		handle_events(1)
	key_handler_default = old_handler
	return gr_getc_char

void *gr_getc_handler(void *obj, void *a0, void *event)
	use(obj, a0)
	gr_event *e = event
	if e->type == KeyPress
		gr_getc_char = e->which
	return thunk_yes

# key handlers -----------------------------------------------

def n_key_events 2
int key_first, key_last
thunk (*key_handlers)[n_key_events]
char *key_down
thunk key_handler_default
def gr_n_keys key_last-key_first+1

key_handlers_init()
	XDisplayKeycodes(display, &key_first, &key_last)
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
	return XKeysymToKeycode(display, XStringToKeysym(keystr)) - key_first
int keysym_ix(KeySym keysym)
	return XKeysymToKeycode(display, keysym) - key_first

int key_event_type_ix(int event_type)
	which event_type
	KeyPress	event_type = 0
	KeyRelease	event_type = 1
	else	error("unknown key event type: %d = %s", event_type, event_type_name(event_type))
	return event_type

void *key_handler_main(void *obj, void *a0, void *event)
	use(obj);use(a0)
	int is_callback = p2i(a0)
	use(is_callback)
	gr_event *e = event
	boolean ignore = 0
	int event_type = 0

	which e->type
	KeyPress	.
		event_type = 0
		ignore = gr_key_avoid_auto_repeat_press(e)
		if !ignore && key_down[e->which-key_first]
			key_event_debug("ignoring %s - key already down: %s", e)
			ignore = 1
		if !ignore
#			debug("setting key down %s", key_string(e->which))
			key_down[e->which-key_first] = 1
		warn("KeyPress: %d %s", e->which, key_string(e->which))

	KeyRelease	.
		event_type = 1
		if !key_down[e->which-key_first]
			key_event_debug("ignoring %s - key not down: %s", e)
			ignore = 1
		ignore = gr_key_avoid_auto_repeat_release(e, is_callback)
		if !ignore
			key_down[e->which-key_first] = 0
#			debug("clearing key down %s", key_string(e->which))
#		 else
#			debug("ignoring KeyRelease")
		if gr_key_ignore_release
			ignore = 1
		warn("KeyRelease: %d %s", e->which, key_string(e->which))

	if !ignore && XKeycodeToKeysym(display, e->which, e->state & ShiftMask && 1) == NoSymbol
		ignore = 1

	if ignore
		return thunk_yes

	thunk *handler = &key_handlers[e->which-key_first][event_type]
	void *rv = thunk_call(handler, e)
	if !rv
		rv = thunk_call(&key_handler_default, e)
	if !rv
		key_event_debug("unhandled %s: %s", e)
	return rv

cstr event_key_string(gr_event *e)
	int shift = e->state & ShiftMask && 1
	return key_string(e->which, shift)

key_event_debug(cstr format, gr_event *e)
	use(format)
	cstr key_string = event_key_string(e)
	if key_string != NULL  # ignore unmapped keys
		debug(format, event_type_name(e->type), key_string)

def key_string(keycode) key_string(keycode, 0)
cstr key_string(int keycode, boolean shift)
	return XKeysymToString(XKeycodeToKeysym(display, keycode, shift))


# TODO (DONE?) allow programs to handle all keys (or all typing keys, etc)
# with a single handler function, not one for each key!  and same for mouse


# mouse handlers --------------------------------------------

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
	use(obj);use(a0)
	static int button = 0
	gr_event *e = event
	boolean ok = 0
	int event_type = 0
	which e->type
	ButtonPress	.
		event_type = 0
		if button != 0
			debug("press %d then press %d - reset", button, e->which)
			button = 0
		 else
			button = e->which
			ok = 1
	ButtonRelease	.
		event_type = 1
		if button == 0
			debug("no press then release b%d - reset", e->which)
		 eif e->which != button
			debug("press b%d then release b%d - reset", button, e->which)
		 else
			ok = 1
		button = 0
	MotionNotify	.
		event_type = 2
		if button == 0
			debug("no press then drag b%d - reset", e->which)
		 else
			e->which = button
			ok = 1
	if ok && e->type != MotionNotify && !tween(e->which, mouse_first, mouse_last)
		debug("unhandled %s: b%d unknown", event_type_name(e->type), e->which)
		return thunk_no
	if ok
		thunk *handler = &mouse_handlers[e->which-mouse_first][event_type]
		void *rv = thunk_call(handler, e)
		if !rv
			rv = thunk_call(&mouse_handler_default, e)
		if !rv
			debug("unhandled %s: b%d", event_type_name(e->type), e->which)
		return rv
			
	return thunk_yes  # ignored ~= handled

# event type names ---------------------------------------

cstr event_type_name(int type)
	foraryp(i, event_type_names)
		if i->k == type
			return i->v
	return NULL
