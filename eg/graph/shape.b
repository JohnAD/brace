struct Point
	double x, y

struct Shape
	int n_points
	Point *points

struct Transform
	double xx, xy, yx, yy, dx, dy

Transform id_trans = { 1.0, 0.0, 0.0, 1.0, 0.0, 0.0 }

int temporary_shape_points = 0
Shape temporary_shape = { 0, NULL }

Shape *get_temporary_shape(int n_points)
	if n_points > temporary_shape_points
		temporary_shape_points *= 2
		if temporary_shape_points < n_points
			temporary_shape_points = n_points
		Realloc(temporary_shape.points, sizeof(Point) * temporary_shape_points)
	temporary_shape.n_points = n_points
	return &temporary_shape

int temporary_xpoints_points = 0
XPoint *temporary_xpoints = NULL

XPoint *get_temporary_xpoints(int n_points)
	if n_points > temporary_xpoints_points
		temporary_xpoints_points *= 2
		if temporary_xpoints_points < n_points
			temporary_xpoints_points = n_points
		Realloc(temporary_xpoints, sizeof(XPoint) * temporary_xpoints_points)
	return temporary_xpoints

transform_point(Point *p0, Point *p1, Transform *trans)
	double p0x = p0->x, p0y = p0->y
	p1->x = p0x * trans->xx + p0y * trans->yx + trans->dx
	p1->y = p0x * trans->xy + p0y * trans->yy + trans->dy

Shape *transform_shape(Shape *src, Shape *dest, Transform *trans)
	int n = src->n_points
	Point *p0 = src->points, *p1
	if dest == NULL
		dest = get_temporary_shape(n)
	p1 = dest->points
	for ; n>0; --n, ++p0, ++p1
		transform_point(p0, p1, trans)
	return dest

round_point(Point *p0, XPoint *p1)
	p1->x = (int)(p0->x+0.5)
	p1->y = (int)(p0->y+0.5)

XPoint *round_shape(Shape *src, XPoint *dest)
	int n = src->n_points
	Point *p0 = src->points
	XPoint *p1
	if dest == NULL
		dest = get_temporary_xpoints(n+1)
	p1 = dest
	for ; n>0; --n, ++p0, ++p1
		round_point(p0, p1)
	*p1 = *dest
	return dest

scale_transform(Transform *src, Transform *dest, double mag)
	dest->xx = src->xx * mag
	dest->xy = src->xy * mag
	dest->yx = src->yx * mag
	dest->yy = src->yy * mag
	dest->dx = src->dx * mag
	dest->dy = src->dy * mag

translate_transform(Transform *src, Transform *dest, double dx, double dy)
	dest->xx = src->xx
	dest->xy = src->xy
	dest->yx = src->yx
	dest->yy = src->yy
	dest->dx = src->dx + dx
	dest->dy = src->dy + dy

make_rotate_transform(Transform *dest, double angle)
	double s = sin(angle), c = cos(angle)
	dest->xx = c
	dest->xy = s
	dest->yx = -s
	dest->yy = c
	dest->dx = 0
	dest->dy = 0

make_transform(Transform *dest, double angle, double scale, double x, double y, boolean flip)
	make_rotate_transform(dest, angle)
	scale_transform(dest, dest, scale)
	translate_transform(dest, dest, x, y)
	if flip
		flip_transform(dest)

make_inverse_transform(Transform *dest, double angle, double scale, double x, double y, boolean flip)
	Transform tmp
	tmp = id_trans
	if flip
		flip_transform(&tmp)
	translate_transform(&tmp, dest, -x, -y)
	scale_transform(dest, dest, 1.0/scale)
	make_rotate_transform(&tmp, -angle)
	compose_transform(&tmp, dest, dest)

flip_transform(Transform *toflip)
	toflip->xy = -toflip->xy
	toflip->yy = -toflip->yy
	toflip->dy = -toflip->dy

compose_transform(Transform *src0, Transform *src1, Transform *dest)
	double xx0 = src0->xx, xx1 = src1->xx, xy0 = src0->xy, xy1 = src1->xy, yx0 = src0->yx, yx1 = src1->yx, yy0 = src0->yy, yy1 = src1->yy, dx0 = src0->dx, dx1 = src1->dx, dy0 = src0->dy, dy1 = src1->dy
	dest->xx = xx0 * xx1 + yx0 * xy1
	dest->xy = xy0 * xx1 + yy0 * xy1
	dest->yx = xx0 * yx1 + yx0 * yy1
	dest->yy = xy0 * yx1 + yy0 * yy1
	dest->dx = xx0 * dx1 + yx0 * dy1 + dx0
	dest->dy = xy0 * dx1 + yy0 * dy1 + dy0

print_transform(Transform *t)
	Sayf("%7.2f %7.2f", t->xx, t->xy)
	Sayf("%7.2f %7.2f", t->yx, t->yy)
	Sayf("%7.2f %7.2f", t->dx, t->dy)

export gr
use m io error alloc
