#!/lang/b
use b

Main()
	if args != 2
		usage("x-file y-file")
	vec *vx = read_nums(arg[0])
	vec *vy = read_nums(arg[1])

	size_t n = vec_get_size(vx)
	if n != vec_get_size(vy)
		error("vx and vy must be the same length")

	num Exy = 0
	num Ex = 0
	num Ey = 0
	num Ex2 = 0
	num Ey2 = 0
	for int i=0; i<(int)n; ++i
		num x = *(num*)v(vx,i), y = *(num*)v(vy,i)
		Exy += x*y
		Ex += x
		Ey += y
		Ex2 += x*x
		Ey2 += y*y

	Sayf("Exy = %f", Exy)
	Sayf("Ex = %f", Ex)
	Sayf("Ey = %f", Ey)
	Sayf("Ex2 = %f", Ex2)
	Sayf("Ey2 = %f", Ey2)

	nl()

	num r = (n*Exy - Ex*Ey) / sqrt((n*Ex2-Ex*Ex)*(n*Ey2-Ey*Ey))

	Sayf("%f", r)
