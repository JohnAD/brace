#!/lang/b

# export OPTIMIZE=1

Main()
	gr_fast()
	space()
#	space(1280, 800)

	if !vid
		error("xshm pixmaps are not working")

	qmath_init()

	bm_enabled = 0

	bm_start()

	bm("got image")

	if depth == 16
		pretty(short)
	 eif depth > 16
		pretty(long)

	gr_free()


def pretty(pixel_type)
	int da = 0
	int dr = 0

	repeat
		pixel_type *px = (pixel_type *)pixel(vid, 0, 0)
		da+=2

		int y
		for y=h_2-1; y>=-h_2; --y
			int r2 = w_2*w_2 + y*y
			for(x, -w_2, w_2)
				int a

				num s, atn
				qSin(s, r2/100.0+dr)
				qAtan2(atn, y, x)
				mod_fast(a, atn+s*50+da, 360)

				*px++ = rb[a]

				r2 += 2*x+1   # maintain r2 = x*x+y*y

		bm("calc done")
#		csleep(0.15)
		Paint()
		bm("painted")
		bm_start()

def screen_trans fast

use b
