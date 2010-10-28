export m
# we export it, because `real' is used in the exported types and functions
# (`real' will appear in the autogenerated header file)

struct vec3
	num x, y, z
	vec3() : x(0), y(0), z(0) {}
	vec3(num x, num y, num z) : x(x), y(y), z(z) {}

struct angle3
	num latitude, longitude
	angle3() : latitude(0), longitude(0) {}
	angle3(num latitude, num longitude) : latitude(latitude), longitude(longitude) {}

angle3_to_vec3(const angle3 &a, vec3 &v)
	num r1
	v.y = sin(a.latitude)
	r1 = cos(a.latitude)
	v.z = r1 * cos(a.longitude)
	v.x = r1 * sin(a.longitude)

num vec3_length(const vec3 &v)
	return sqrt(v.x*v.x + v.y*v.y + v.z*v.z)

vec3_to_angle3(const vec3 &v, angle3 &a)
	num r = vec3_length(v)
	a.latitude = asin(v.y/r)
	a.longitude = atan2(v.x/r, v.z/r)
	# my longitudes go from 0 to 2*pi
	# if you don't like it, bad luck!
	if a.longitude < 0
		a.longitude += 2*pi

x_y_rot(num &x, num &y, num a)
	num x1, y1
	num s = sin(a)
	num c = cos(a)
	x1 = c * x - s * y
	y1 = s * x + c * y
	x = x1 ; y = y1

vec3_rot_z(vec3 &v, num a)
	x_y_rot(v.x, v.y, a)

vec3_rot_x(vec3 &v, num a)
	x_y_rot(v.y, v.z, a)

vec3_rot_y(vec3 &v, num a)
	x_y_rot(v.z, v.x, a)

# TODO fix this to be a proper transform (point above, north point)
# and write functions to move up, down, left, right relative to the current view, etc.
num latitude = 0
num longitude = 0
num spin = 0

# radius of the world, in pixels!
num r = 290
num zm = 1

viewpoint_transform(vec3 &v)
	vec3_rot_y(v, -longitude)
	vec3_rot_x(v, latitude)
	vec3_rot_z(v, spin)