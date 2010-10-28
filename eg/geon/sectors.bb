export m

export sphere

# ----- sector bounds -----

struct sector_id
	int level, row, cell
	# row ranges from 0 (north of equator) to 2^level-1 (near north pole)
	# and from -1 (south of equator) to -2^level (near south pole)
	# cell ranges from 0 (east of grenwich) to sectors_in_row(level, row)

struct sector_bounds
	num west, east, south, north

# TODO make sure calc_sector_bounds, etc are as accurate as possible

calc_sector_bounds(const sector_id &id, sector_bounds &b)
	# this is a bit more complex because I need to be sure that the boundaries of the
	# sectors near ew == 0 (and at the poles) are exactly right
	int sector_rows_eq_to_pole = 1<<id.level
	num delta_latitude = pi/2 / sector_rows_eq_to_pole
	int n = sectors_in_row(id.level, id.row)
	num delta_longitude = 2*pi / n
	if id.row == -sector_rows_eq_to_pole
		b.south = -pi/2
	else
		b.south = id.row * delta_latitude
	if id.row == sector_rows_eq_to_pole-1
		b.north = pi/2
	else
		b.north = b.south + delta_latitude
	b.west = id.cell * delta_longitude
	if id.cell == n-1
		b.east = 2*pi
	else
		b.east = b.west + delta_longitude

int sector_rows(int level)
	return 1<<(level+1)

int sector_rows_eq_to_pole(int level)
	return 1<<level

num sector_row_height(int level)
	return pi/2 / sector_rows_eq_to_pole(level)

num sector_width(int level, int row)
	int n = sectors_in_row(level, row)
	return 2*pi / n

# TODO calc all this stuff together, not in separate functions...?

int sectors_in_row(int level, int row)
	if row < 0
		row = -1 - row
	num delta_latitude = sector_row_height(level)
	num latitude = row * delta_latitude
	num circ = 2*pi * cos(latitude+delta_latitude/2)
	# divide the parallel by a power of 2 to get the dew*circ (width of sector) closest to dns (height of sector)
	# note: dns*.75 <= dew*circ < dns*1.5
	#   so number of divisions is 2^(floor(log2(circ/(dns*.75))))
	int ew_divisions = 1<<int(log(circ/(delta_latitude*.75))/log(2.0)+1e-9)
	return ew_divisions

which_sector(const angle3 &a, sector_id &s)
	# s.level must be set before calling this.
	# it sets s.row and s.cell
	
	# the angle must be normalized; ns in [-90, 90], ew in [0, 360)
	int rows_eq_to_pole = sector_rows_eq_to_pole(s.level)
	num delta_latitude = sector_row_height(s.level)
	s.row = int(floor(a.latitude / delta_latitude))
	if s.row == rows_eq_to_pole
		# north pole
		--s.row
	num delta_longitude = sector_width(s.level, s.row)
	s.cell = int(a.longitude / delta_longitude)

# maybe I should store angles in the range ns [-0.25, 0.25], ew [0, 1) or similar
# so that the sector bounds are exact floating point values ?

# each point is only in one sector;
# the north pole (normalized to (+90,0) is in sector 0 of the northmost row,
# the south pole (normalized to (-90,0) is in sector 0 of the southmost row.
bool point_in_sector(const angle3 &p, const sector_bounds &b)
	if p.latitude == pi/2
		return b.west == 0 && b.north == pi/2
	if p.latitude == -pi/2
		return b.west == 0 && b.south == -pi/2
	return p.longitude >= b.west && p.longitude < b.east && p.latitude >= b.south && p.latitude < b.north
