#!/lang/b
use b
Main()
	space()
#	long n = 1024*1024 * 2
#	long *lookup = Nalloc(long, 1024*1024 * 2)
#	for(i, 0, n)
#		lookup[i] = (long)sqrt(i)
#	warn("done")
	repeat
		bm_start()
		pixel_type *px = (pixel_type *)pixel(vid, 0, 0)
		long x, y, x2, y2, r2
		for y=-h_2; y<h_2; ++y
			y2 = y * y
			x2 = w_2 * w_2
			r2 = x2 + y2
			for x=-w_2; x<w_2; ++x
				*px++ += r2
				r2 += 2*x + 1
		Paint()
		bm_ps("painted")
typedef long pixel_type

local int rv = 0
def r() rv = ((rv * 12345678) ^ rv) + (rv>>17) + 89356913, rv < 0
