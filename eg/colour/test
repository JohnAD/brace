#!/lang/b
use b
use lib_extra.b

Main()
	space(600, 600)
	zoom(290)
	 # TODO default zoom is that a circle fits in space with a small margin??
	num A = 5
	num x0 = 0.3
	num y0 = 0
	num x1 = -Cos(A)/5  # are cos and sin misnamed (cos,integration primary?)
	num y1 = Sin(A)/2

	gr_fast()

	repeat
		clear()
		
		line(0, 0, x0, y0)
		line(0, 0, x1, y1)
		cyan()
		for(a, 0, A+1)  # TODO inclusive/exclusive for?  sane range objects?
			circular_blend(x, y, a/A, A)
			Sayf("%f %f", x*x0 + y*x1, x*y0 + y*y1)
			dot(x*x0 + y*x1, x*y0 + y*y1, 4*a_pixel)

		paint()

		x0 += rand(-1, 1) * a_pixel
		y0 += rand(-1, 1) * a_pixel
		x1 += rand(-1, 1) * a_pixel
		y1 += rand(-1, 1) * a_pixel

def dot(x, y)
	point(x, y)

def trig_unit lun
