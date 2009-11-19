# event handler ----------------------------------------------

use gr
export types thunk
use alloc time error
use event

XEvent x_event

int events_queued(boolean wait_for_event)
	# XXX this gets the message and removes it from the queue on mingw
#	return XEventsQueued(display, QueuedAfterReading)
#	warn("events_queued: wait_for_event = %d", wait_for_event)
#	int n = XEventsQueued(display, wait_for_event||can_read(x11_fd) ? QueuedAfterReading : QueuedAlready)
	int n = XEventsQueued(display, QueuedAlready)
#	warn("   = %d", n)
	if !n:
#		warn("  selecting...")
		num timeout = wait_for_event && !veclen(gr_need_delay_callbacks) ? time_forever : 0
		gr_flush()
		if can_read(x11_fd, timeout):
#			warn("  reading...")
			n = XEventsQueued(display, QueuedAfterReading)
#			warn("  n = %d", n)
	return n
		# is can_read necessary?

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

	KeyPress	.
	KeyRelease	.
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

def gr_key_avoid_auto_repeat_delay 1.99   # in ms  XXX X is evil

int gr_key_last_release_key = -1, gr_key_last_release_time = -1
num gr_key_last_release_time_real = -1

boolean gr_key_avoid_auto_repeat_press(gr_event *e)
	boolean ignore =  gr_key_auto_repeat == 0 && gr_key_avoid_auto_repeat_delay && last_release_key == e->which &&
	  e->time - last_release_time <= (int)gr_key_avoid_auto_repeat_delay
	last_release_key = -1
	return ignore

boolean gr_key_avoid_auto_repeat_release(gr_event *e, boolean is_callback)
	boolean push_callback = 0
	if gr_key_auto_repeat == 0 && gr_key_avoid_auto_repeat_delay
#			debug("gr_key_auto_repeat is off - good!")
		# this is ugly, silly X.
		# XXX it is still not 100% reliable if many keys pressed at once.
		# maybe check KeyRelease with XQueryKeymap :(
		# http://www.ypass.net/blog/2009/06/detecting-xlibs-keyboard-auto-repeat-functionality-and-how-to-fix-it/
		if is_callback
#				debug("key_handler_main in callback %s %s", key_string(last_release_key), key_string(e->which))
			if last_release_key == -1
				ignore = 1
			 eif rtime()-last_release_time_real <= gr_key_avoid_auto_repeat_delay/1000.0
#					debug("callback came too soon - will push callback again")
				push_callback = 1
		 else
			push_callback = 1

		if push_callback
#				debug("pushing callback")
			if !is_callback
				last_release_time_real = rtime()
			gr_event_callback *cb = Talloc(gr_event_callback)
			cb->t = thunk(key_handler_main, NULL, i2p(1))
			cb->e = *e
			cb->time = rtime()
			vec_push(gr_need_delay_callbacks, *cb)
			ignore = 1
		if !ignore || push_callback
			last_release_key = e->which
			last_release_time = e->time


# mouse handlers --------------------------------------------

# (this is generic)


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
