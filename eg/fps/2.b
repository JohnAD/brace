#!/lang/b
use b
Main()
	space()
#	long n = 1024*1024 * 2
#	long *lookup = Nalloc(long, 1024*1024 * 2)
#	for(i, 0, n)
#		lookup[i] = (long)sqrt(i)
#	warn("done")
	if depth == 16
		fps2(short)
	 else
		fps2(long)

def fps2(pixel_type)
	num a = -60
	int c = 0
	repeat
		int xb = Sin(a*2) * 500 + 200
		int yb = Cos(a*3) * 500 + 100
		bm_start()
		pixel_type *px = (pixel_type *)pixel(vid, 0, 0)
#		px += Randi(w*h)
#		*px = x
#		memset(px, x, w*h*sizeof(pixel_type))
		long x, y, x2, y2, r2
		long x2b, y2b, r2b
		for y=-h_2; y<h_2; ++y
			y2 = y * y
			x2 = w_2 * w_2
			r2 = x2 + y2
			y2b = (y+yb) * (y+yb)
			x2b = (w_2+xb) * (w_2+xb)
			r2b = x2b + y2b
			for x=-w_2; x<w_2; ++x
#				long r = lookup[r2]
#				long rb = lookup[r2b]
				#x2 = x * x
#				r2 = x2 + y2
				*px = (*px + r2) ^ (*px + r2b)
				++px
#				*px++ += r2
#				*px++ += 100*r2 / (r2b ? r2b : 1) + 100*r2b / (r2 ? r2 : 1) + r2 + r2b
				r2 += 2*x + 1
				r2b += 2*(x-xb) + 1
#			x += r() + r() + r()
		if c++ > 100
			a += 0.1
		Paint()
#		asleep(1)
		bm_ps("painted")

local int rv = 0
def r() rv = ((rv * 12345678) ^ rv) + (rv>>17) + 89356913, rv < 0

def trig_unit deg
