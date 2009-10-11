# event handler ----------------------------------------------

use gr
export types thunk
use alloc time error
use event

XEvent x_event

boolean handle_event_maybe()
	boolean n = XEventsQueued(display, QueuedAfterReading) #QueuedAlready
	if n
		handle_event()
	 else
		gr_flush()
	return n

#handle_event()
#	XNextEvent(display, &x_event)
#	which x_event.type
#	Expose	if x_event.xexpose.count == 0
#			paint()

handle_event()
	XNextEvent(display, &x_event)
#	if x_event.type != NoExpose
#		debug("handling event: %s", event_type_name(x_event.type))
	switch x_event.type
	ClientMessage	.
		if x_event.xclient.message_type == wm_protocols && x_event.xclient.format == 32 && (Atom)x_event.xclient.data.l[0] == wm_delete
			quit(NULL, NULL, &x_event)
		 else
			debug("unhandled %s event: %s", event_type_name(x_event.type), XGetAtomName(display, x_event.xclient.message_type))
		break
	ConfigureNotify	.
		skip_to_last_event(x_event, ConfigureNotify)
		configure_notify()
		break
	Expose	.
	GraphicsExpose	.
		if x_event.xexpose.count == 0
			paint()
		break
	NoExpose	.
		break
	MapNotify	.
		break
	UnmapNotify	.
		break
	ReparentNotify	.
		break

	KeyRelease	.
	KeyPress	.
			gr_event e =
				x_event.type, x_event.xkey.keycode, -1, -1,
				x_event.xkey.state, x_event.xkey.time
			thunk_call(&control->keyboard, &e)
		break

	MotionNotify	.
		# FIXME this is dodgy, we could skip a release/press pair...
		skip_to_last_event(x_event, MotionNotify)
	ButtonPress	.
	ButtonRelease	.
			gr_event e =
				x_event.type, x_event.xbutton.button,
				x_event.xbutton.x, x_event.xbutton.y,
				x_event.xbutton.state, x_event.xkey.time
			thunk_call(&control->mouse, &e)
		break

	else	.
		debug("unhandled %s event", event_type_name(x_event.type))

def skip_to_last_event(x_event, type)
	while XCheckTypedEvent(display, type, &x_event)
		.

# key handlers -----------------------------------------------

num gr_key_auto_repeat_avoidance_delay = 1.99   # XXX X is evil

def n_key_events 2
int key_first, key_last
thunk (*key_handlers)[n_key_events]
char *key_down
thunk key_handler_default
def gr_n_keys key_last-key_first+1

key_handlers_init()
	XDisplayKeycodes(display, &key_first, &key_last)
	key_handlers = (void*)Nalloc(thunk, gr_n_keys*n_key_events)
	key_down = Zalloc(char, gr_n_keys)
	key_handlers_default()

key_handlers_default()
	key_handlers_ignore()
	set_key_handler("Escape", thunk(quit))

key_handlers_ignore()
	for(i, 0, gr_n_keys)
		for(j, 0, n_key_events)
			key_handlers[i][j] = thunk()
	clear_key_handler_default()

void *quit(void *obj, void *a0, void *event)
	use(obj, a0, event)
	gr_exit(0)
	return thunk_yes

def set_key_handler(key_str, handler)
	set_key_handler_(key_str, handler)
def set_key_handler_(key_str, handler)
	set_key_handler_keysym_(XStringToKeysym(key_str), handler)
set_key_handler_keysym_(KeySym keysym, thunk handler)
	each(event_type, KeyPress, KeyRelease)
		set_key_handler_keysym(keysym, event_type, handler)
def set_key_handler(key_str, event_type, handler)
	set_key_handler_keysym(XStringToKeysym(key_str), event_type, handler)
def clear_key_handler(key_str)
	set_key_handler(key_str, thunk())
def clear_key_handler(key_str, event_type)
	set_key_handler(key_str, event_type, thunk())
def clear_key_handler_keysym(keysym)
	set_key_handler_keysym(keysym, thunk())
def clear_key_handler_keysym(key_str, event_type)
	set_key_handler_keysym(key_str, event_type, thunk())

set_key_handler_default(thunk handler)
	key_handler_default = handler
def clear_key_handler_default()
	set_key_handler_default(thunk())

def set_key_handler_keysym(keysym, handler)
	set_key_handler_keysym_(keysym, handler)
set_key_handler_keysym(KeySym keysym, int event_type, thunk handler)
	which event_type
	KeyPress	event_type = 0
	KeyRelease	event_type = 1
	# TODO key repeat = 2  ?
	int keycode = XKeysymToKeycode(display, keysym)
	key_handlers[keycode - key_first][event_type] = handler

void *keyboard_handler(void *obj, void *a0, void *event)
	use(obj);use(a0)
	static int last_release_key = -1, last_release_time = -1
	static num last_release_time_real = -1
	int is_callback = p2i(a0)
	gr_event *e = event
	boolean ignore = 0
	int event_type = 0

	which e->type
	KeyPress	.
		event_type = 0
		if gr_key_auto_repeat == 0 && last_release_key == e->which &&
		  e->time - last_release_time <= (int)gr_key_auto_repeat_avoidance_delay
			ignore = 1
		 eif key_down[e->which-key_first]
			key_event_debug("ignoring %s - key already down: %s", e)
			ignore = 1
		if !ignore
#			debug("setting key down %s", key_string(e->which))
			key_down[e->which-key_first] = 1
		last_release_key = -1

	KeyRelease	.
		event_type = 1
		if !key_down[e->which-key_first]
			key_event_debug("ignoring %s - key not down: %s", e)
			ignore = 1
		boolean push_callback = 0
		if gr_key_auto_repeat == 0
#			debug("gr_key_auto_repeat is off - good!")
			# this is ugly, silly X.
			# XXX it is still not 100% reliable if many keys pressed at once.
			# maybe check KeyRelease with XQueryKeymap :(
			# http://www.ypass.net/blog/2009/06/detecting-xlibs-keyboard-auto-repeat-functionality-and-how-to-fix-it/
			if is_callback
#				debug("keyboard_handler in callback %s %s", key_string(last_release_key), key_string(e->which))
				if last_release_key == -1
					ignore = 1
				 eif rtime()-last_release_time_real <= gr_key_auto_repeat_avoidance_delay/1000.0
#					debug("callback came too soon - will push callback again")
					push_callback = 1
			 else
				push_callback = 1

			if push_callback
#				debug("pushing callback")
				if !is_callback
					last_release_time_real = rtime()
				gr_event_callback *cb = Talloc(gr_event_callback)
				cb->t = thunk(keyboard_handler, NULL, i2p(1))
				cb->e = *e
				cb->time = rtime()
				vec_push(gr_need_delay_callbacks, *cb)
				ignore = 1
		if !ignore
			key_down[e->which-key_first] = 0
#			debug("clearing key down %s", key_string(e->which))
		if !ignore || push_callback
			last_release_key = e->which
			last_release_time = e->time
#		 else
#			debug("ignoring KeyRelease")
		if gr_key_ignore_release
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

key_event_debug(cstr format, gr_event *e)
	cstr key_string = event_key_string(e)
	if key_string != NULL  # ignore unmapped keys
		debug(format, event_type_name(e->type), key_string)

# TODO allow programs to handle all keys (or all typing keys, etc)
# with a single handler function, not one for each key!  and same for mouse


# mouse handlers --------------------------------------------

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
	for(i, mouse_first, mouse_last+1)
		clear_mouse_handler(i)
	clear_mouse_handler_default()

def set_mouse_handler(button, handler)
	set_mouse_handler_(button, handler)
set_mouse_handler_(int button, thunk handler)
	each(event_type, ButtonPress, MotionNotify, ButtonRelease)
		set_mouse_handler(button, event_type, handler)
set_mouse_handler(int button, int event_type, thunk handler)
	which event_type
	ButtonPress	event_type = 0
	ButtonRelease	event_type = 1
	MotionNotify	event_type = 2
	mouse_handlers[button-mouse_first][event_type] = handler
def clear_mouse_handler(button)
	set_mouse_handler(button, thunk())
def clear_mouse_handler(button, event_type)
	set_mouse_handler(button, event_type, thunk())

set_mouse_handler_default(thunk handler)
	mouse_handler_default = handler
def clear_mouse_handler_default()
	set_mouse_handler_default(thunk())

void *mouse_handler(void *obj, void *a0, void *event)
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


# recentering when the window is resized ---------------------

configure_notify()
	int _x, _y
	Window _root
	unsigned int _border, _depth, new_width, new_height

	debug("configure notify")

	XGetGeometry(display, window, &_root, &_x, &_y, &new_width, &new_height, &_border, &_depth)

	if (int)new_width != w || (int)new_height != h
		debug("window resized to %d %d - ignored for now", new_width, new_height)
#		w = new_width; h = new_height
#		calculate_viewpoint_transform()
#		redraw(True, True)

# event type names ---------------------------------------

cstr event_type_name(int type)
	foraryp(i, event_type_names)
		if i->k == type
			return i->v
	return NULL

long2cstr event_type_names[] =
	{ KeyPress, "KeyPress" },
	{ KeyRelease, "KeyRelease" },
	{ ButtonPress, "ButtonPress" },
	{ ButtonRelease, "ButtonRelease" },
	{ MotionNotify, "MotionNotify" },
	{ EnterNotify, "EnterNotify" },
	{ LeaveNotify, "LeaveNotify" },
	{ FocusIn, "FocusIn" },
	{ FocusOut, "FocusOut" },
	{ KeymapNotify, "KeymapNotify" },
	{ Expose, "Expose" },
	{ GraphicsExpose, "GraphicsExpose" },
	{ NoExpose, "NoExpose" },
	{ VisibilityNotify, "VisibilityNotify" },
	{ CreateNotify, "CreateNotify" },
	{ DestroyNotify, "DestroyNotify" },
	{ UnmapNotify, "UnmapNotify" },
	{ MapNotify, "MapNotify" },
	{ MapRequest, "MapRequest" },
	{ ReparentNotify, "ReparentNotify" },
	{ ConfigureNotify, "ConfigureNotify" },
	{ ConfigureRequest, "ConfigureRequest" },
	{ GravityNotify, "GravityNotify" },
	{ ResizeRequest, "ResizeRequest" },
	{ CirculateNotify, "CirculateNotify" },
	{ CirculateRequest, "CirculateRequest" },
	{ PropertyNotify, "PropertyNotify" },
	{ SelectionClear, "SelectionClear" },
	{ SelectionRequest, "SelectionRequest" },
	{ SelectionNotify, "SelectionNotify" },
	{ ColormapNotify, "ColormapNotify" },
	{ ClientMessage, "ClientMessage" },
	{ MappingNotify, "MappingNotify" },

cstr event_key_string(gr_event *e)
	int shift = e->state & ShiftMask && 1
	return key_string(e->which, shift)

def key_string(keycode) key_string(keycode, 0)
cstr key_string(int keycode, boolean shift)
	return XKeysymToString(XKeycodeToKeysym(display, keycode, shift))
