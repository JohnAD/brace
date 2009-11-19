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

