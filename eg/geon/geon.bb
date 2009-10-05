# are all of these headers used here now?

use stdio.h

use main
use gr
use m
use error
use time

use al
use vector

use sphere
use poly
export regions
use debug
use clip_and_draw
use clip_and_fill
use palette
use draw_basic
use points
use clip_region_to_sector
use draw_clipped_arcs
use draw_sectors

# maybe should ALWAYS add using namespace std and using namespace __gnu_cxx to brace c++ ??

int window_width = 1024
int window_height = 768
num window_radius

int focus_region = -1

Main()
	num delta_latitude, delta_longitude, delta_spin, dfac_zoom
	num delay = 0
	int level, row, cell
	
	if argc != 14
		error("syntax: geon ns ew rot zoom dns dew drot fzoom delay focus_region level row cell")
	latitude = Rad(atof(argv[1]))
	longitude = Rad(atof(argv[2]))
	spin = Rad(atof(argv[3]))
	zm = atof(argv[4])
	delta_latitude = Rad(atof(argv[5]))
	delta_longitude = Rad(atof(argv[6]))
	delta_spin = Rad(atof(argv[7]))
	dfac_zoom = atof(argv[8])
	delay = atof(argv[9])
	focus_region = atoi(argv[10])
	level = atoi(argv[11])
	row = atoi(argv[12])
	cell = atoi(argv[13])
	
	load_and_convert_regions("data/regions")
	load_points("data/points")
	
#	paper(window_width, window_height)
	paper()
	window_radius = hypot(window_width/2, window_height/2)
	load_palette("data/palette")
	zoom(r*zm)
	
	bool display_focus = focus_region >= 0 && (unsigned int)focus_region < regions.size()
	if display_focus
		latitude = regions[focus_region].points_a[0].latitude
		longitude = regions[focus_region].points_a[0].longitude
		#debug("%f\n", deg(ns))
		#debug("%f\n", deg(ew))
	
	sector_id focus_sector_id = { level, row, cell }
	sector_bounds focus_sector_bounds
	bool display_focus_sector = level >= 0 && cell >= 0
	# row can be < 0
	
	region_sector_containment containment
	vector<clip_to_sector_arc> clipped_arcs
	
	if display_focus_sector
		calc_sector_bounds(focus_sector_id, focus_sector_bounds)
		clip_region_to_sector(regions[0].points_a, focus_sector_bounds, containment, clipped_arcs)
		latitude = (focus_sector_bounds.south + focus_sector_bounds.north) / 2
		longitude = (focus_sector_bounds.west + focus_sector_bounds.east) / 2
	
	repeat
		#debug("%f %f %f", deg(ns), deg(ew), deg(rot))
		
		num pixel = 1/(r*zm)
		if r*zm < window_radius + 10*pixel
			bg(col_space)
			clear()
			col(col_sea)
			disc(0, 0, 1-pixel)
		else
			bg(col_sea)
			clear()
		for_each(regions, fill_region)
		if display_focus
			col(col_focus)
#			poly_vec3_vp_clip_and_draw(regions[focus_region].points_v)
		if level >= 0
			col(col_grid)
			draw_sector_grid(level)
		col(col_point)
		draw_points(points_v)
		# draw the equator
		#draw_parallel(0)
		if display_focus_sector
			# draw the focus sector
			draw_sector_bounds(focus_sector_bounds)
			draw_clipped_arcs(regions[focus_region].points_v, clipped_arcs)
		# this was supposed to trim the mess at the edge of the circle,
		# and make it unnecessary to use `clear()' - but I prefer the other way
		# maybe I'll try to do it properly one day!
		#colc(col_space)
		##rgb(1, 1, 1)
		#circle(0, 0, 1)
		#circle(0, -pixel, 1)
		#circle(0, pixel, 1)
		#circle(-pixel, 0, 1)
		#circle(pixel, 0, 1)
		
		paint()
		
		if delay < 0
			break
		Rsleep(delay)
		
		latitude += delta_latitude
		longitude += delta_longitude
		spin += delta_spin
		
		zm *= dfac_zoom
		zoom(r*zm)
	
	event_loop()
	return 0

fill_region(region &r)
	if r.type == LAND
		col(col_land)
	eif r.type == LAKE
		col(col_lake)
	else
		error("unknown region type %d", (int)r.type)
	poly_vec3_vp_clip_and_fill(r.points_v)
