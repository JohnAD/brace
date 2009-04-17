export vector
export ext/hash_map

export regions

using namespace std
using namespace __gnu_cxx
# for ext/hash_map

# Work In Progress...

# ----- clipping all regions to all sectors at once -----

# clipped_region is different from clip_to_sector_arc in that the relevant points
# are copied, not just referenced; this is more realistic as eventually we will
# send only the data for visible sectors through the wire.
struct clipped_region
	#int id
	#region_type type
	vector<region_arc> arcs

# I don't understand how struct clipped_region can be defined before struct region_arc, but it seems to work!

struct region_arc
	int from, to
	poly_angle3 points_a
	poly_vec3 points_v
	# the number of points in points_a and points_v is to-from+1 (i.e. from and to are included)
	# the points from and to are external to the region, all other points are internal to the region
	# don't worry about sector_side_pos, I think we won't need it

struct sector_regions
	# regions by region_id
	map<int, region_type> regions_containing_sector
	map<int, clipped_region> regions_crossing_sector
	map<int, region> regions_contained_in_sector

hash_map<sector_id, sector_regions, hash_sector_id, eq_sector_id> regions_by_sector

# FIXME this hash function is very dodgy
# Is there some way we can check hash function effectiveness using STL hash tables?
struct hash_sector_id
	size_t operator()(const sector_id &id) const
		return id.level*115 + id.row*97 + id.cell
struct eq_sector_id
	size_t operator()(const sector_id &id0, const sector_id &id1) const
		return id0.level == id1.level && id0.row == id1.row && id0.cell == id1.cell

# this doesn't have to be very fast
clip_regions_to_sectors(int level)
	vector<region>::const_iterator region_begin = regions.begin()
	vector<region>::const_iterator region_end = regions.end()
	vector<region>::const_iterator region_it
	int region_id
	for region_id = 0, region_it=region_begin ; region_it != region_end ; ++region_it, ++region_id
		const region &r = *region_it
		poly_angle3::const_iterator begin = r.points_a.begin()
		poly_angle3::const_iterator end = r.points_a.end()
		poly_angle3::const_iterator it
		int i, first_to, from
		i = 0
		it = begin
		
		angle3 a, prev_a
		sector_id id, id0, prev_id
		sector_bounds b
		poly_angle3 poly_a
		bool first = true
		
		id.level = level
		
		a = *it
		which_sector(a, id)
		calc_sector_bounds(id, b)
		id0 = id
		prev_a = a
		
		++it ; ++i
		while it != end
			a = *it
			if point_in_sector(a, b)
				if first
					.
				else
					poly_a.push_back(a)
			else
				prev_id = id
				which_sector(a, id)
				if first
					first_to = i
					first = false
				else
					# finish an arc
					poly_a.push_back(a)
					# to = i
					sector_regions &sr = regions_by_sector[prev_id]
					clipped_region &cr = sr.regions_crossing_sector[region_id]
					.
				# start an arc
				poly_a.clear()
				poly_a.push_back(prev_a)
				poly_a.push_back(a)
				from = i - 1
		
		if first
			# the whole region is in the one sector (id0)
			.
		else
			# add the points up to `first_to', then add this `first/last' arc
			for i=0 ; i<=first_to ; ++i
				poly_a.push_back(r.points_a[i])



# how on EARTH am I supposed to work out which sectors are completely contained within a region?  Maybe do it top-down, i.e. a sector is contained in a region if its parent is contained, and _might_be_ (so check) if the region crosses its parent.  But this won't work if the parent sector is checking against a simplified region...

# I should check crossings against the smallest sectors, and extrapolate up to the larger sectors

#   each sector needs to know its parent and children
#   a sector may have 3, 4 or 6 children, I think

# once have crossing data, a sector is contained in a region if it doesn't cross it, and it's middle point (to be safe) is in the region

# how to check if a point is in a region?
# - things will get tricky around the poles
# - maybe assume every region is smaller than a hemisphere (i.e. doesn't contain an entire hemisphere), and check against a great-circle going through the point? i.e rotate the point to center stage and check against the new `equator'?
#   or better still, check against a meridian going through the point - then don't have to rotate
#   That'll work for Earth's continents at least!  If we had the sectors working, we could reduce the workload (theoretically), chicken-and-egg
#   actually, this isn't good enough, left->right crossing doesn't mean much on a sphere!
#   Maybe we could do something with polar coordinates, add up delta-angle w.r.t the point and see if it comes (closer) to 360 or 0?  we'd have to flatten the region first, with the point at its center.  And this isn't reliable, either, because the flattened region's back-side might contain the point.
#   How about this - walk from the point in any direction (say towards north pole) until cross the coast.  If the coast is going from right->left (anticlockwise) at the crossing point, the original point must be interior.
#     OK - so how about this - choose a random segment on the coast, find the midpoint of this segment.  Draw a great-circle ray between the test point and this coast point.  Find the closest coast-segment that intersects with this ray (it might be the randomly chosen coast point).  

bool point_in_region(angle3 &a, region &r)
	num longitude = a.longitude
	num latitude = a.latitude
	poly_vec3::const_iterator begin = r.points_v.begin()
	.
	return 0

# make viewpoint not a global and pass as arg? or make level a global?
enumerate_visible_sectors(int level, vector<sector_id> &sectors)
	.

# add args...
merge_sector_regions()
	.
