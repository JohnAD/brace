use gr
export m

use al

use sphere
# for zoom, r
export sectors
use draw_basic

# ----- drawing sectors, parallels and meridians -----

draw_sector_grid(int level)
	int rows_equator_to_pole = 1<<level
	num delta_latitude = pi/2 / rows_equator_to_pole
	for int row=0 ; row<rows_equator_to_pole ; ++row
		num latitude = row * delta_latitude
		draw_parallel(latitude)
		if row>0
			draw_parallel(-latitude)
		int ew_divisions = sectors_in_row(level, row)
		num delta_longitude = 2*pi / ew_divisions
		for int coln=0 ; coln<ew_divisions ; ++coln
			num longitude = coln * delta_longitude
			draw_meridian_arc(longitude, latitude, latitude+delta_latitude)
			draw_meridian_arc(longitude, -latitude, -latitude-delta_latitude)

draw_parallel(num latitude)
	draw_parallel_arc(latitude, 0, 2*pi)

draw_parallel_arc(num latitude, num ew0, num ew1)
	if ew0 > ew1
		return draw_parallel_arc(latitude, ew1, ew0)
	num r1 = cos(latitude)
	if r1 == 0
		point(0, latitude)
	else
		num max_da = calc_dotted_line_da() / r1
		int n = int(ceil((ew1-ew0)/max_da))
		num da = (ew1-ew0)/n
		for int i=0 ; i<=n ; ++i
			num longitude = i*da + ew0
			plot_point_angle3(angle3(latitude, longitude))

draw_meridian(num longitude)
	draw_meridian_arc(longitude, 0, 2*pi)

draw_meridian_arc(num longitude, num ns0, num ns1)
	if ns1 < ns0
		return draw_meridian_arc(longitude, ns1, ns0)
	num max_da = calc_dotted_line_da()
	int n = int(ceil((ns1-ns0)/max_da))
	num da = (ns1-ns0)/n
	for int i=0 ; i<=n ; ++i
		num latitude = i*da + ns0
		plot_point_angle3(angle3(latitude, longitude))

int pixels_per_dot = 4

num calc_dotted_line_da()
	return asin(pixels_per_dot/2.0 / (zm*r))*2

draw_great_circle()
	.

draw_great_circle_arc()
	.

draw_sector_bounds(sector_bounds &b)
	draw_parallel_arc(b.south, b.west, b.east)
	draw_parallel_arc(b.north, b.west, b.east)
	draw_meridian_arc(b.west, b.south, b.north)
	draw_meridian_arc(b.east, b.south, b.north)
