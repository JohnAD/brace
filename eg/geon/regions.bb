using namespace std

use stdio.h

export vector

use error

use sphere
export poly

# TODO write out the long/lat regions, this will be the basic data ???

enum region_type
	LAND,
	LAKE,

struct region
	int id
	region_type type
	poly_angle3 points_a
	poly_vec3 points_v

vector<region> regions

load_and_convert_regions(const char *datafile)
	int err
	int n_points, type
	int x, y, z
	
	FILE *regions_file = fopen(datafile, "r")
	if regions_file == NULL
		serror("can't open regions file %s", datafile)
	
	vec3 v
	angle3 a
	region dummy_region
	
	int i = 0
	# TODO brace (or libb): true -> 1, false -> 0
	repeat
		err = fscanf(regions_file, "%d %d", &n_points, &type)
		if err == 0
			error("integer expected")
		if err == EOF
			return
		
		regions.push_back(dummy_region)
		region &r = regions[regions.size()-1]
		r.id = i
		r.type = (region_type)type
		poly_vec3 &poly_v = r.points_v
		poly_angle3 &poly_a = r.points_a
		
		err = fscanf(regions_file, "%d %d %d", &x, &y, &z)
		if err == 0
			error("integer expected")
		if err == EOF
			error("missing first point")
		v.x = x / 30000.0
		v.y = y / 30000.0
		v.z = z / 30000.0
		vec3_to_angle3(v, a)
		poly_a.push_back(a)
		poly_v.push_back(v)
		
		for int c = 1 ; c < n_points ; ++c
			int dx, dy, dz
			fscanf(regions_file, "%d %d %d", &dx, &dy, &dz)
			if err == 0
				error("integer expected")
			if err == EOF
				error("missing delta point")
			x += dx ; y += dy ; z += dz
			# the following skips some data points to make it faster,
			# but UNFORTUNATELY, this may result in self-intersecting polygons :(
			# The `10' can be 2, 3, 4, ...
			#if c % 10 != 0 && c > 3
			#	continue
			v.x = x / 30000.0
			v.y = y / 30000.0
			v.z = z / 30000.0
			vec3_to_angle3(v, a)
			poly_a.push_back(a)
			poly_v.push_back(v)
		++i
	
	fclose(regions_file)
