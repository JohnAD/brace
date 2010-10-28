export vector

export poly
export clip_region_to_sector

use gr

# ----- drawing clipped arcs -----

draw_clipped_arcs(poly_vec3 &poly, vector<clip_to_sector_arc> &clipped_arcs)
	colour red = rgb(1, 0, 0)
	colour white = rgb(1, 1, 1)
	vector<clip_to_sector_arc>::const_iterator p = clipped_arcs.begin()
	vector<clip_to_sector_arc>::const_iterator end = clipped_arcs.end()
	for ; p != end ; ++p
		const clip_to_sector_arc &arc = *p
		int i = arc.from
		vec3 v = poly[i]
		viewpoint_transform(v)
		col(white)
		move(v.x, v.y)
		int n = poly.size()
		do
			++i
			if i >= n
				i = 0
			vec3 v = poly[i]
			viewpoint_transform(v)
			draw(v.x, v.y)
		while i != arc.to
		
		# red dots, for debug:
		col(red)
		i = arc.from
		repeat
			vec3 v = poly[i]
			viewpoint_transform(v)
			point(v.x, v.y)
			if i == arc.to
				break
			++i
			if i >= n
				i = 0
