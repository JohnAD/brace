typedef void (*EventHandler)(int x, int y)
typedef EventHandler ButtonController[3]

struct Controller
	ButtonController *button[3]
	void (*keyboard)(int keycode, int state)


Node *node
double drag_x, drag_y, drag_scale
double drag_angle, old_angle, old_scale

static void start_move_node(int x, int y)

# delete -----------------------------------------------------

delete_press(int x, int y)
	node = lookup_node(x, y)
	if node != NULL
		delete_node(node)

delete_motion(int x, int y)
	node = lookup_node(x, y)
	if node != NULL
		delete_node(node)

# add node ------------------------------------------------

add_node_press(int x, int y)
	node = add_node(x, y)
	start_move_node(x, y)

# add arc ----------------------------------------------------

add_arc_press(int x, int y)
	node = lookup_node(x, y)
	if node != NULL
		drag_x = x
		drag_y = y
		draw_rubber_band(node->so.x, node->so.y, x, y)

add_arc_motion(int x, int y)
	if node != NULL
		draw_rubber_band(node->so.x, node->so.y, drag_x, drag_y)
		draw_rubber_band(node->so.x, node->so.y, x, y)
		drag_x = x; drag_y = y

add_arc_release(int x, int y)
	if node != NULL
		Node *node1 = lookup_node(x, y)
		draw_rubber_band(node->so.x, node->so.y, drag_x, drag_y)
		if node1 != NULL
			add_arc(node, node1)

# move -------------------------------------------------------

static void start_move_node(int x, int y)
	Point p
	p.x = x; p.y = y
	transform_point(&p, &p, &inverse_viewpoint_transform)
	drag_x = node->o.x - p.x
	drag_y = node->o.y - p.y

move_press(int x, int y)
	if (node = lookup_node(x, y)) != NULL
		start_move_node(x, y)
	else
		drag_x = viewpoint_x - x
		drag_y = viewpoint_y + y

move_motion(int x, int y)
	if node != NULL
		Point p
		p.x = x; p.y = y
		transform_point(&p, &p, &inverse_viewpoint_transform)
		draw_node_and_arcs(node, False)
		node->o.x = p.x + drag_x
		node->o.y = p.y + drag_y
		calculate_node_transform(node)
		draw_node_and_arcs(node, True)
	else
#		redraw(False, False)
		viewpoint_x = drag_x + x
		viewpoint_y = drag_y - y
		calculate_viewpoint_transform()
#		redraw(True, False)
		redraw(True, True)

# rotate -----------------------------------------------------

rotate_press(int x, int y)
	if (node = lookup_node(x, y)) != NULL
		drag_angle = node->angle - -atan2(y-node->so.y, x-node->so.x)
	else
		old_angle = viewpoint_angle
		drag_angle = -atan2(y-(double)(window_height/2), x-(double)(window_width/2))
		drag_x = viewpoint_x
		drag_y = viewpoint_y

rotate_motion(int x, int y)
	double angle
	if node != NULL
		draw_node(node, False)
		angle = -atan2(y-node->so.y, x-node->so.x)
		node->angle = angle + drag_angle
		calculate_node_transform(node)
		draw_node(node, True)
	else
		double sina, cosa
#		redraw(False, False)
		angle = -atan2(y-(double)(window_height/2), x-(double)(window_width/2)) - drag_angle
		viewpoint_angle = old_angle + angle
		sina = sin(angle); cosa = cos(angle)
		viewpoint_x = drag_x * cosa - drag_y * sina
		viewpoint_y = drag_x * sina + drag_y * cosa
		calculate_viewpoint_transform()
#		redraw(True, False)
		redraw(True, True)

# scale ------------------------------------------------------

scale_press(int x, int y)
	if (node = lookup_node(x, y)) != NULL
		double dx = x-node->so.x, dy = y-node->so.y,
		  d = sqrt(dx*dx + dy*dy)
		drag_scale = node->scale / (d>0 ? d : 1.0)
	else
		double dx = x-(double)(window_width/2), dy = y-(double)(window_height/2)
		old_scale = viewpoint_scale
		drag_scale = sqrt(dx*dx + dy*dy)
		if drag_scale == 0.0
			drag_scale = 1.0
		drag_x = viewpoint_x
		drag_y = viewpoint_y

scale_motion(int x, int y)
	if node != NULL
		double dx = x-node->so.x, dy = y-node->so.y, factor = sqrt(dx*dx + dy*dy)
		if factor == 0.0
			factor = 1.0
		draw_node(node, False)
		node->scale = drag_scale * factor
		calculate_node_transform(node)
		draw_node(node, True)
	else
		double dx = x-(double)(window_width/2), dy = y-(double)(window_height/2), factor = sqrt(dx*dx + dy*dy)
		if factor == 0.0
			factor = 1.0
		factor /= drag_scale
		viewpoint_scale = old_scale * factor
		viewpoint_x = drag_x * factor
		viewpoint_y = drag_y * factor
		calculate_viewpoint_transform()
		redraw(True, True)

# includes ---------------------------------------------------

export graph
use structure shape

use io m
