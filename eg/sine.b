#!/lang/b

Main()
	double pi = 3.1415926535
	Sayf("%f", sin(pi/3))
	Sayf("%f", (*sin)(pi/3))

	double (*sin)(double) = cos
	Sayf("%f", (*sin)(pi/3))

use io m main
