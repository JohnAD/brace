# numeric for accumulate (!)
use numeric

use al
use gr

export sphere
export poly

poly_vec3_draw(const poly_vec3 &poly)
	poly_vec3::const_iterator begin = poly.begin()
	move(begin->x, begin->y)
	for_each(begin+1, poly.end(), draw_to_vec3)
	draw_to_vec3(*begin)
draw_to_vec3(const vec3 &v)
	draw(v.x, v.y)

poly_vec3_vp_and_draw(const poly_vec3 &poly)
	vec3 v
	poly_vec3::const_iterator begin = poly.begin()
	v = *begin
	viewpoint_transform(v)
	move(v.x, v.y)
	for_each(begin+1, poly.end(), draw_to_vec3_vp)
	draw_to_vec3(v)
	draw(v.x, v.y)
draw_to_vec3_vp(vec3 v)
	viewpoint_transform(v)
	draw(v.x, v.y)

poly_vec3_vp_and_fill(const poly_vec3 &poly)
	polygon p
	polygon_init(&p, poly.size())
	accumulate(poly.begin(), poly.end(), &p, vec3_polygon_accumulator)
	polygon_fill(&p)
	polygon_end(&p)
polygon *vec3_polygon_accumulator(polygon *p, vec3 v)
	viewpoint_transform(v)
	polygon_point(p, v.x, v.y)
	return p

poly_angle3_draw(const poly_angle3 &poly_a)
	poly_vec3 poly_v
	poly_angle3_to_poly_vec3(poly_a, poly_v)
	poly_vec3_viewpoint_transform(poly_v)
	poly_vec3_draw(poly_v)

plot_point(vec3 p)
	viewpoint_transform(p)
	if p.z >= 0
		point(p.x, p.y)

plot_point_angle3(angle3 a3)
	vec3 v3
	angle3_to_vec3(a3, v3)
	plot_point(v3)

draw_points(poly_vec3 &points)
	for_each(points, plot_point)
