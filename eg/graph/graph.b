# graph editor, by Sam Watkins

# test shapes and diagram ------------------------------------

Point triang_points[] =
	{-2.0, 0.0}, {1.0, 1.0}, {1.0,-1.0}
Shape triang =
	3, triang_points

Point rectangle_points[] =
	{-1.0, -0.5}, {1.0, -0.5}, {1.0, 0.5}, {-1.0, 0.5}
Shape rectangle =
	4, rectangle_points

Point add_points[] =
	{-1.0, 0}, {-0.75, -0.25}, {-0.5, -0.3}, {0, -0.35},
	{0.5, -0.3}, {0.75, -0.25}, {1, 0},
	{0.75, 0.25}, {0.5, 0.3}, {0, 0.35},
	{-0.5, 0.3}, {-0.75, 0.25}
Shape add =
	12, add_points

Node _nodes[] =
	{ .index=0, .name="hello", .shape=&triang, .angle=M_PI/4.0, .scale=1, .o={1.0, 0.5} },
	{ .index=1, .name="world", .shape=&rectangle, .angle=-M_PI/6.0, .scale=1.5, .o={-0.5, -0.8} },
	{ .index=2, .name="addy", .shape=&add, .angle=0.0, .scale=2, .o={-2, 2} },
	{ .index=3, .name="circle", .shape=NULL, .angle=0.0, .scale=1, .o={-2, -2} }

int _n_nodes = array_size(_nodes)

test_diagram()
	int i, j
	Node *node
	for i=0; i<_n_nodes; ++i
		node = new_node()
		j = node->index
		*node = _nodes[i]
		node->index = j

int add_node_i = 0
Node *add_node(int x, int y)
	Node *node = new_node()
	int j
	Point p
	p.x = x; p.y = y
	transform_point(&p, &p, &inverse_viewpoint_transform)
	j = node->index
	*node = _nodes[add_node_i]
	node->index = j
	node->o.x = p.x
	node->o.y = p.y
	calculate_node_transform(node)
	node->region = NULL
	draw_node(node, True)
	add_node_i = (add_node_i+1) % _n_nodes
	return node

Arc *add_arc(Node *n0, Node *n1)
	Arc *arc
	arc = new_arc(n0->index, n1->index)
	draw_arc(arc)
	return arc

# viewpoint --------------------------------------------------

unsigned int window_width = 400, window_height = 300

double viewpoint_angle = 0.0
double viewpoint_scale = 30.0
double viewpoint_x = 0.0
double viewpoint_y = 0.0

double min_node_scale_for_point = 0.25
double min_node_scale_for_outline = 1.0
double min_node_scale_for_label = 15.0
double max_node_scale_to_manipulate = 200.0

Transform viewpoint_transform, inverse_viewpoint_transform

calculate_viewpoint_transform()
	int dx = (int)(window_width/2) + viewpoint_x
	int dy = -(int)(window_height/2) + viewpoint_y
	make_transform(&viewpoint_transform, viewpoint_angle, viewpoint_scale, dx, dy, True)
	make_inverse_transform(&inverse_viewpoint_transform, viewpoint_angle, viewpoint_scale, dx, dy, True)

# ------------------------------------------------------------

calculate_node_transform(Node *node)
	make_transform(&node->transform, node->angle, node->scale, node->o.x, node->o.y, False)

Node *lookup_node(int x, int y)
	VectorIterator i
	Node *node, *best_node = NULL
	double scale, best_scale = max_node_scale_to_manipulate/viewpoint_scale
	boolean match
	vector_iterator_init(nodes, &i)
	while (node = vector_iterator_next(&i)) != NULL
		scale = node->scale
		match = node->shape == NULL ?
		  (x-node->so.x)*(x-node->so.x) + (y-node->so.y)*(y-node->so.y) <=
		    (int)(scale*scale*viewpoint_scale*viewpoint_scale+0.5) :
		  node->region != NULL && XPointInRegion(node->region, x, y)
		if match && best_scale > scale
			best_node = node
			best_scale = scale
	return best_node

# global X data ----------------------------------------------

Display *display
Window window
Colormap colormap
GC gc
XFontStruct *_font
const char *font_name = "-adobe-helvetica-medium-r-normal--11-80-100-100-p-56-iso8859-1"

# interface state --------------------------------------------

XEvent event

int first_keycode, last_keycode
Thunk *key_handlers

# the main program -------------------------------------------

int main()
	Window root
#	XColor color
	XGCValues values
	int screen_number
	long black, white
	VectorIterator i
	Node *node

	structure_init()
	test_diagram()

	vector_iterator_init(nodes, &i)
	while (node = vector_iterator_next(&i)) != NULL
		calculate_node_transform(node)
		node->region = NULL

	calculate_viewpoint_transform()

	if (display = XOpenDisplay(NULL)) == NULL
		error("cannot open display")

	XDisplayKeycodes(display, &first_keycode, &last_keycode)
	key_handlers = Calloc(last_keycode-first_keycode+1, sizeof(Thunk))
	set_key_handler(XStringToKeysym("Q"), quit)
	set_key_handler(XStringToKeysym("M"), motion_mode)
	set_key_handler(XStringToKeysym("S"), structure_mode)

	screen_number = DefaultScreen(display)
	white = WhitePixel(display, screen_number)
	black = BlackPixel(display, screen_number)
	colormap = DefaultColormap(display, screen_number)
	if XAllocNamedColor(display, colormap, "red", &color, &color)
		red = color.pixel
	else
		red = white

	if (_font = XLoadQueryFont(display, font_name)) == NULL
		error("cannot load font")

	gc = DefaultGC(display, screen_number)
	values.function = GXxor
	values.foreground = white^black
	values.cap_style = CapNotLast
	values.line_width = 0
	values.font = _font->fid
	XChangeGC(display, gc, GCFunction|GCForeground|GCCapStyle|GCLineWidth|GCFont, &values)

	root = DefaultRootWindow(display)
	window = XCreateSimpleWindow(display, root, 0, 0, window_width, window_height, 0, white, black)
	XSelectInput(display, window, ExposureMask|ButtonPressMask|ButtonReleaseMask|ButtonMotionMask|KeyPressMask|StructureNotifyMask)
	XMapWindow(display, window)

	motion_mode()
	event_loop()

	# this is unreachable
	exit(1)

# finalisation -----------------------------------------------

quit()
	free(key_handlers)
	XUnmapWindow(display, window)
#	XFree(keyboard_map)
	XFreeColors(display, colormap, (unsigned long *)&red, 1, 0)
	XFreeFont(display, _font)
	XDestroyWindow(display, window)
	XCloseDisplay(display)
	exit(0)

# key handlers -----------------------------------------------

set_key_handler(KeySym keysym, void (*handler)())
	int keycode = XKeysymToKeycode(display, keysym)
	key_handlers[keycode - first_keycode] = handler

command_keyboard(int keycode, int state)
	int shift = state & ShiftMask ? 1 : 0
	Thunk handler = key_handlers[keycode-first_keycode]
	if handler != NULL
		(*handler)()
	else
		warn("unhandled keypress: %s", XKeysymToString(XKeycodeToKeysym(display, keycode, shift)))

# modes ------------------------------------------------------

ignore(int x, int y)
	use(x) ; use(y)

Controller *controller

ButtonController
 ignore_button = { ignore, ignore, ignore },
 move_button = { move_press, move_motion, ignore },
 rotate_button = { rotate_press, rotate_motion, ignore },
 scale_button = { scale_press, scale_motion, ignore },
 add_node_button = { add_node_press, move_motion, ignore },
 add_arc_button = { add_arc_press, add_arc_motion, add_arc_release },
 delete_button = { delete_press, delete_motion, ignore }

Controller
 motion_controller = { {&move_button, &rotate_button, &scale_button}, command_keyboard },
 structure_controller = { {&add_node_button, &add_arc_button, &delete_button}, command_keyboard }

motion_mode()
	Say("motion mode")
	controller = &motion_controller

structure_mode()
	Say("structure mode")
	controller = &structure_controller

# event dispatch loop ----------------------------------------
# TODO select only events relevant to current mode
#			(e.g. not motion unless needed)

button_event(int button, int type, int x, int y)
	if button >= 1 && button <= 3
		ButtonController *bc = controller->button[button-1]
		((*bc)[type])(x, y)
	else
		warn("unknown button %d", button)

event_loop()
	uint button = 0
	while 1
		XNextEvent(display, &event)
		switch event.type
			case Expose:
				Sayf("expose event - count: %d", event.xexpose.count)
				if event.xexpose.count == 0
					redraw(True, True)
				break
			case ConfigureNotify:
				configure_notify()
				break
			case ButtonPress:
				if button != 0
					warn("press %d then press %d - latter ignored\n", button, event.xbutton.button)
				else
					button = event.xbutton.button
					button_event(button, 0, event.xbutton.x, event.xbutton.y)
				break
			case MotionNotify:
				# We skip all but the most recent motion event.
				# This might be a bit dodgy, we could skip past a
				# release/press pair...
				while XCheckTypedEvent(display, MotionNotify, &event)
				button_event(button, 1, event.xmotion.x, event.xmotion.y)
				break
			case ButtonRelease:
				if button == 0
					warn("no press then release b%d - release ignored", button, event.xbutton.button)
				else if event.xbutton.button != button
					warn("press b%d then release b%d - release ignored", button, event.xbutton.button)
				else
					button_event(button, 2, event.xbutton.x, event.xbutton.y)
					button = 0
				break
			case KeyPress:
				(*controller->keyboard)(event.xkey.keycode, event.xkey.state)
				break
			case MapNotify:
			case UnmapNotify:
			case ReparentNotify:
				break
			default:
				warn("unhandled event, type: 0x%04x\n", event.type)
				break
	# this is unreachable

# redrawing --------------------------------------------------

redraw(boolean moved, boolean clear)
	VectorIterator i
	Node *node; Arc *arc
#	Say("redrawing")
	if clear
		XClearWindow(display, window)
	vector_iterator_init(nodes, &i)
	while (node = vector_iterator_next(&i)) != NULL
		draw_node(node, moved)
	vector_iterator_init(arcs, &i)
	while (arc = vector_iterator_next(&i)) != NULL
		draw_arc(arc)

draw_node(Node *node, boolean moved)
	XPoint *points
	Shape *shape
	Transform trans
	boolean is_polygon = node->shape != NULL
	double node_scale = node->scale * viewpoint_scale

	if moved
		Point p
		transform_point(&node->o, &p, &viewpoint_transform)
		round_point(&p, &node->so)

	if node_scale < min_node_scale_for_outline
		if is_polygon
			if node->region != NULL
				XDestroyRegion(node->region)
			node->region = NULL
		if node_scale >= min_node_scale_for_point
			XDrawPoint(display, window, gc, node->so.x, node->so.y)
	else # draw the node outline
		if is_polygon
			compose_transform(&viewpoint_transform, &node->transform, &trans)

			shape = transform_shape(node->shape, NULL, &trans)
			points = round_shape(shape, NULL)

			if moved
				if node->region != NULL
					XDestroyRegion(node->region)
				node->region = XPolygonRegion(points, shape->n_points+1, WindingRule)

			XDrawLines(display, window, gc, points, shape->n_points+1, CoordModeOrigin)
		else # circle
			unsigned int r = (int)(node->scale * viewpoint_scale + 0.5)

			XDrawArc(display, window, gc, node->so.x-r, node->so.y-r, r*2, r*2, 0, 64*360)

		if node_scale >= min_node_scale_for_label
			int width, dy
			char *str = node->name
			int len = strlen(node->name)
			width = XTextWidth(_font, str, len)
			dy = (_font->ascent - _font->descent) / 2
			XDrawString(display, window, gc, node->so.x-width/2, node->so.y+dy, str, len)

draw_arc(Arc *arc)
	Node *n0 = vector_ref(nodes, arc->from), *n1 = vector_ref(nodes, arc->to)
	
	XDrawLine(display, window, gc, n0->so.x, n0->so.y, n1->so.x, n1->so.y)

draw_node_and_arcs(Node *node, boolean moved)
	draw_node(node, moved)
	for_each_arc_to_or_from(node, draw_arc)

draw_rubber_band(int x0, int y0, int x1, int y1)
	XDrawLine(display, window, gc, x0, y0, x1, y1)

# recentering when the window is resized ---------------------

configure_notify()
	int _x, _y
	Window _root
	unsigned int _border, _depth, new_width, new_height

	Say("configure notify")

	XGetGeometry(display, window, &_root, &_x, &_y, &new_width, &new_height, &_border, &_depth)

	if new_width != window_width || new_height != window_height
		window_width = new_width; window_height = new_height
		calculate_viewpoint_transform()
		redraw(True, True)

# include files ----------------------------------------------

export shape structure control
use vector

export gr util
use io m error cstr alloc

use stdlib.h unistd.h
