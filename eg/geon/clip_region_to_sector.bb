use vector

export m
use error

export sectors
export sphere
export poly

using namespace std

# ----- clipping to a sector -----

enum sector_side
	E, N, W, S
# in a anti-clockwise order, like the polygons

struct sector_side_pos
	sector_side side
	num pos
# pos == 0 is most-clockwise, pos == (side_length) is most-anticlockwise

struct clip_to_sector_arc
	int from
	int to
	sector_side_pos from_side_pos, to_side_pos
# from and to are indices into the region's points

#struct region_clipped_to_sector
#	# should the region be referenced here?
#	vector<clip_to_sector_arc> arcs

enum region_sector_containment
	REGION_CONTAINS_SECTOR,
	SECTOR_CONTAINS_REGION,
	REGION_OUTSIDE_SECTOR,
	REGION_CROSSES_SECTOR
# use more generic names?

#struct sector_data
#	sector_id id
#	sector_bounds bounds
#	vector<region &> containers
#	vector<region &> contained
#	vector<region_clipped_to_sector> clipped

# NOTE - ew == 0 meridian confusion! :
# if a segment crosses the line ew = 0, e.g.:
#   a0.ew = rad(359)
#   a1.ew = rad(1)
# we need to add 360 to a1.ew or subtract 360 from a0.ew depending if the sector is east or west of grenwich! grrrr

clip_region_to_sector(const poly_angle3 &poly, const sector_bounds &b, region_sector_containment &containment, vector<clip_to_sector_arc> &arcs)
	# currently we don't deal with arc segments that cross in then out of the sector;
	# these will be picked up by the sectors they exit and enter, though.
	#debug("sector bounds:")
	#dump_angle3(angle3(b.south, b.west))
	#dump_angle3(angle3(b.north, b.east))
	
	# TODO - check if the sector is totally contained within the region.
	# If the region contains a pole, this becomes more tricky :)
	
	angle3 a, a0, prev_a
	a0 = poly[0]
	
	bool first_in = point_in_sector(a0, b)
	bool prev_in = first_in
	
	int last_entry = -1
	sector_side_pos last_entry_where
	int first_exit = -1
	sector_side_pos first_exit_where
	sector_side_pos exit_where
	
	poly_angle3::const_iterator p = poly.begin()+1
	poly_angle3::const_iterator end = poly.end()
	
	bool first = true
	int i = 1
	prev_a = a0
	while p != end
		a = *p
		bool in = point_in_sector(a, b)
		if !prev_in && in
			# entry
			#debug("entry: ") ; dump_angle3(prev_a) ; dump_angle3(a) ; debug("\n")
			last_entry = i
			enters_sector_where(b, prev_a, a, last_entry_where)
			prev_in = true
			first = false
		eif prev_in && !in
			# exit
			#debug("exit: ") ; dump_angle3(prev_a) ; dump_angle3(a) ; debug("\n")
			exits_sector_where(b, prev_a, a, exit_where)
			if first
				first_exit = i
				first_exit_where = exit_where
			else
				# we have an arc!
				# these arcs go from and to _external_ points
				clip_to_sector_arc arc = { last_entry-1, i, last_entry_where, exit_where }
				arcs.push_back(arc)
			prev_in = false
		++p ; ++i ; prev_a = a
	
	if !prev_in && first_in
		# entry
		#debug("entry: ") ; dump_angle3(prev_a) ; dump_angle3(a0) ; debug("\n")
		enters_sector_where(b, prev_a, a0, last_entry_where)
		clip_to_sector_arc arc = { i-1, first_exit, last_entry_where, first_exit_where }
		arcs.push_back(arc)
	eif prev_in && !first_in
		# exit
		#debug("exit: ") ; dump_angle3(prev_a) ; dump_angle3(a) ; debug("\n")
		exits_sector_where(b, prev_a, a0, exit_where)
		clip_to_sector_arc arc = { last_entry-1, 0, last_entry_where, exit_where }
		arcs.push_back(arc)
	eif prev_in && first_in && !first
		# add the first/last arc
		clip_to_sector_arc arc = { last_entry-1, first_exit, last_entry_where, first_exit_where }
		arcs.push_back(arc)
	
	# FIXME:
	if arcs.size() == 0
		if first_in
			containment = SECTOR_CONTAINS_REGION
		else
			containment = REGION_OUTSIDE_SECTOR
			# TODO: or could be REGION_CONTAINS_SECTOR
	else
		containment = REGION_CROSSES_SECTOR

exits_sector_where(const sector_bounds &b, const angle3 &a0, const angle3 &a1, sector_side_pos &pos)
	# a0 is known to be (not strictly) inside the sector,
	# and a1 (strictly) outside
	num ns0 = a0.latitude, ew0 = a0.longitude
	num ns1 = a1.latitude, ew1 = a1.longitude
	
	# ew == 0 meridian confusion
	# we assume that segments are "quite short"!
	if b.east == 2*pi
		if ew0 == 0
			ew0 = 2*pi
		if ew1 < pi
			ew1 += 2*pi
	if b.west == 0
		if ew1 > pi
			ew1 -= 2*pi
	
	num delta_latitude = ns1 - ns0
	num delta_longitude = ew1 - ew0
	
	# I'm not smart enough to abstract these four cases today!
	# check E edge
	if ew1 > b.east
		num dew_to_edge = b.east - ew0
		num ns_at_edge = ns0 + delta_latitude/delta_longitude * dew_to_edge
		if ns_at_edge >= b.south && ns_at_edge <= b.north
			pos.side = E
			pos.pos = ns_at_edge - b.south
			return
	# check N edge
	if ns1 > b.north
		num dns_to_edge = b.north - ns0
		num ew_at_edge = ew0 + delta_longitude/delta_latitude * dns_to_edge
		if ew_at_edge >= b.west && ew_at_edge <= b.east
			pos.side = N
			pos.pos = b.east - ew_at_edge
			return
	# check W edge
	if ew1 < b.west
		num dew_to_edge = b.west - ew0
		num ns_at_edge = ns0 + delta_latitude/delta_longitude * dew_to_edge
		if ns_at_edge >= b.south && ns_at_edge <= b.north
			pos.side = W
			pos.pos = b.north - ns_at_edge
			return
	# check S edge
	if ns1 < b.south
		num dns_to_edge = b.south - ns0
		num ew_at_edge = ew0 + delta_longitude/delta_latitude * dns_to_edge
		if ew_at_edge >= b.west && ew_at_edge <= b.east
			pos.side = S
			pos.pos = ew_at_edge
			return
	
	error("exits_sector_where: a1 is inside the sector!")

enters_sector_where(const sector_bounds &b, const angle3 &a0, const angle3 &a1, sector_side_pos &pos)
	exits_sector_where(b, a1, a0, pos)
