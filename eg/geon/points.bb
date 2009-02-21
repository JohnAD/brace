use stdio.h

use m
use error

use poly

poly_angle3 points
poly_vec3 points_v

load_points(const char *pointfile)
	FILE *f = fopen(pointfile, "r")
	repeat
		angle3 a
		vec3 v
		num latitude, longitude
		int err = fscanf(f, "%lf %lf", &latitude, &longitude)
		a.latitude = Rad(latitude) ; a.longitude = Rad(longitude)
		if err == 0
			error("real expected")
		if err == EOF
			break
		points.push_back(a)
		angle3_to_vec3(a, v)
		points_v.push_back(v)
