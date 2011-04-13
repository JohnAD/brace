use gr

use al
export map

export sphere
export poly

using namespace std

poly_vec3_vp_clip_and_fill(poly_vec3 poly)
	# this doesn't yet check if a polygon that has no visible points
	# nevertheless contains the whole visible hemisphere
	
	for_each(poly, viewpoint_transform)
	
	in_angle_to_arc_t in_angle_to_arc
	
	vec3 v, v0, prev_v
	v0 = poly[0]
	
	bool first_point_visible = v0.z >= 0
	bool visible = first_point_visible
	
	poly_vec3::const_iterator p = poly.begin()+1
	poly_vec3::const_iterator end = poly.end()
	
	int first_exit = -1
	num first_exit_a = -1
	int last_entry = -1
	num last_entry_a = -1
	
	bool first = true
	int i = 1
	prev_v = v0
	while p != end
		v = *p
		if !visible && v.z >= 0
			# entry
			last_entry = i
			last_entry_a = angle_of_cross_point(prev_v, v)
			#debug("in %f\n", deg(last_entry_a))
			visible = true
			first = false
		eif visible && v.z < 0
			# exit
			num a = angle_of_cross_point(prev_v, v)
			#debug("out %f\n", deg(a))
			if first
				first_exit = i
				first_exit_a = a
			else
				# we have an arc!
				clip_to_hemisphere_arc s = { last_entry, i, a }
				in_angle_to_arc[last_entry_a] = s
				#debug("seg[%f] = { %d %d %f }\n", deg(last_entry_a), s.from, s.to, deg(s.to_angle))
			visible = false
		++p; ++i; prev_v = v
	
	if !visible && first_point_visible
		# entry
		last_entry_a = angle_of_cross_point(prev_v, v0)
		#debug("*in %f\n", deg(last_entry_a))
		clip_to_hemisphere_arc s = { 0, first_exit, first_exit_a }
		in_angle_to_arc[last_entry_a] = s
		#debug("*1 seg[%f] = { %d %d %f }\n", deg(last_entry_a), s.from, s.to, deg(s.to_angle))
	eif visible && !first_point_visible
		# exit
		num a = angle_of_cross_point(prev_v, v0)
		#debug("*out %f\n", deg(a))
		clip_to_hemisphere_arc s = { last_entry, 0, a }
		in_angle_to_arc[last_entry_a] = s
		#debug("*2 seg[%f] = { %d %d %f }\n", deg(last_entry_a), s.from, s.to, deg(s.to_angle))
	eif visible && first_point_visible && !first
		# add the first/last arc
		#debug("*f/l seg\n")
		clip_to_hemisphere_arc s = { last_entry, first_exit, first_exit_a }
		in_angle_to_arc[last_entry_a] = s
		#debug("*3 seg[%f] = { %d %d %f }\n", deg(last_entry_a), s.from, s.to, deg(s.to_angle))
	
	polygon render_poly
	
	if in_angle_to_arc.size() == 0
		# no crossings! easy!
		#debug("no crossings!\n")
		if first_point_visible
			polygon_init(&render_poly, poly.size())
			add_poly_arc_to_polygon(render_poly, poly, 0, 0)
			polygon_fill(&render_poly)
			polygon_end(&render_poly)
	else
		# hoho, figure out what polygons to render
		#debug("crossings!!!\n")
		do
			polygon_init(&render_poly, poly.size())
			# start at an `in'
			in_angle_to_arc_t::iterator i
			i = in_angle_to_arc.begin()
			num begin_angle = i->first
			num from_angle = begin_angle
			
			clip_to_hemisphere_arc &s = i->second
			int from = s.from
			int to = s.to
			num to_angle = s.to_angle
			
			repeat
				# trace this arc
				#debug("add seg: %f -> %f\n", deg(from_angle), deg(to_angle))
				add_poly_arc_to_polygon(render_poly, poly, from, to)
				
				# find the next `in', anticlockwise around the circle, from this `out'
				i = in_angle_to_arc.lower_bound(to_angle)
				if i == in_angle_to_arc.end()
					i = in_angle_to_arc.begin()
				from_angle = i->first
				
				# so from_angle > to_angle (more anticlockwise)
				
				# trace the circular arc
				#debug("add arc: %f -> %f\n", deg(to_angle), deg(from_angle))
				add_circle_arc_to_polygon(render_poly, to_angle, from_angle)
				# these args are deliberately backwards; to_angle is
				# the to_angle of the previous poly_arc, and from_angle
				# is the from_angle of the next poly_arc.  Confusing, huh?
				
				# is it the one we started from?
				if from_angle == begin_angle
					in_angle_to_arc.erase(i)
					# we're done!
					break
				
				s = i->second
				from = s.from
				to = s.to
				to_angle = s.to_angle
				
				in_angle_to_arc.erase(i)
			
			polygon_fill(&render_poly)
			polygon_end(&render_poly)
		while in_angle_to_arc.size()
	
	#debug("\n")

typedef map<num, clip_to_hemisphere_arc> in_angle_to_arc_t

struct clip_to_hemisphere_arc
	int from
	int to
	num to_angle

add_poly_arc_to_polygon(polygon &render_poly, const poly_vec3 &arc, int from, int to)
	# how to get the iterator that points to the n'th item in poly ??  grrr STL!!
	# damn it, I'll just deref the numbers.
	# modular integer (and real, for angles) types would be useful, wouldn't they?
	int i = from
	int size = arc.size()
	do
		const vec3 &v = arc[i]
		polygon_point(&render_poly, v.x, v.y)
		++i
		if i == size
			i = 0
	while i != to

add_circle_arc_to_polygon(polygon &render_poly, num from_angle, num to_angle)
	# we're going anti-clockwise around the circle...
	
	# could calc this outside the func, only changes when zoom changes
	num max_da = calc_max_da()
	
	if to_angle < from_angle
		to_angle += 2*pi
	num full_da = to_angle - from_angle
	
	num da = full_da / ceil(full_da / max_da)
	num da_error = da / 10000.0
	
	num a = from_angle
	
	#debug("  add arc: %f -> %f step %f\n", deg(from_angle), deg(to_angle), deg(da))
	#debug("  add arc: max_da = %f\n", max_da)
	#debug("  add arc: full_da = %f\n", full_da)
	#debug("  add arc: da = %f\n", da)
	#debug("  add arc: da_error = %f\n", da_error)
	
	int c = 0
	while a-da_error < to_angle
		polygon_point(&render_poly, cos(a), sin(a))
		c++
		a += da
	#debug("  add arc: added %d points\n", c)

num angle_of_cross_point(vec3 &v0, vec3 &v1)
	num dx = v1.x-v0.x
	num dy = v1.y-v0.y
	num dz = v1.z-v0.z
	num d0z = 0-v0.z
	num f = d0z / dz
	num cpx = v0.x + dx*f
	num cpy = v0.y + dy*f
	return atan2(cpy, cpx)

num acceptable_deviation_from_arc_pixels = 0.1

# FIXME doesn't have access to zoom or r
num calc_max_da()
	# find a such that: R - cos(a/2) = acceptable_deviation_from_arc_pixels
	return acos(1-acceptable_deviation_from_arc_pixels/(zm*r))*2
	# this seems a bit rough now; maybe I should have kept using the old way!
	#int max_pixels_per_segment = 2
	#return asin(max_pixels_per_segment/2.0 / (zoom*r))*2
