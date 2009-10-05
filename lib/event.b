use gr
export types thunk
export event

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

set_control(controller *c)
	control = c

control_init()
	control_null = (controller){ thunk(), thunk() }
	control_normal = (controller){ thunk(keyboard_handler), thunk(mouse_handler) }
	key_handlers_init()
	mouse_handlers_init()

# event handler ----------------------------------------------

event_handler_init()
	init(gr_need_delay_callbacks, vec, gr_event_callback, 4)
	control_init()

event_loop()
	while !gr_exit
		handle_events()

handle_events()
	gr_call_need_delay_callbacks()
	while handle_event_maybe()

# this is to hack around dodgy X auto-repeat -----------------

vec struct__gr_need_delay_callbacks,
 *gr_need_delay_callbacks = &struct__gr_need_delay_callbacks

struct gr_event_callback
	thunk t
	gr_event e
	num time

gr_call_need_delay_callbacks()
	size_t old_size = veclen(gr_need_delay_callbacks)
	for_vec(i, gr_need_delay_callbacks, gr_event_callback)
		thunk_call(&i->t, &i->e)
	vec_shift(gr_need_delay_callbacks, old_size)
