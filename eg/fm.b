#!/lang/b
use b

num Fc, Fd, dt, t1

num message(num t)
	return sin(3 * 2*pi*t)

Main()
	paper(1024, 500)
	gr_fast()

	Fc = 20
	Fd = 10
	t1 = 1
	dt = t1 / w

	num integral_m = 0             # initial value
	for(t, 0.0, t1, dt)
		num m = message(t)
		integral_m += m * dt   # simplest numerical integration
		num y = cos(2*pi*(Fc*t + Fd*integral_m))
		curve(t * w/t1 - w_2, y * h_2 / 2)
	paint()

