use gr
use sphere
export poly

poly_vec3_vp_clip_and_draw(const poly_vec3 &poly)
	poly_vec3::const_iterator begin = poly.begin()
	poly_vec3::const_iterator end = poly.end()
	poly_vec3::const_iterator i
	
	vec3 begin_v, v
	
	int visible = 0
	
	begin_v = *begin
	viewpoint_transform(begin_v)
	if begin_v.z >= 0
		move(begin_v.x, begin_v.y)
		visible = 1
	
	for i=begin+1 ; i!=end ; ++i
		v = *i
		viewpoint_transform(v)
		if v.z >= 0
			if visible
				draw(v.x, v.y)
			else
				move(v.x, v.y)
				visible = 1
		else
			visible = 0
	
	if visible && begin_v.z >= 0
		draw(begin_v.x, begin_v.y)
