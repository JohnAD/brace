using namespace std

export vector
use al

export sphere

typedef vector<angle3> poly_angle3
typedef vector<vec3> poly_vec3

poly_angle3_to_poly_vec3(const poly_angle3 &poly_a, poly_vec3 &poly_v)
	mapp(poly_a, poly_v, angle3_to_vec3)

poly_vec3_viewpoint_transform(poly_vec3 &poly_v)
	for_each(poly_v, viewpoint_transform)
