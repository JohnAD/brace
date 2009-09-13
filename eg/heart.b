#!/lang/b

use b

num hue_edge
num hue_middle

Main()
	hue_middle = 295 # yellow->red
	hue_edge = 110   # pink->light blue
	if args == 2
		hue_middle = atof(arg[0])
		hue_edge = atof(arg[1])

	paper(640, 480, blue)
	rb_green_power = 1

	gr_fast()

	heart(0, 0, 150)

heart(num x, num y, num r)
	origin(x, y)

	struct polygon p_
	struct polygon *p = &p_

	num squash_y = 0.7


	num r0
	num r_growing
	num r0_step = 3
	for r_growing = 0; r_growing <= r ; r_growing++
		for r0=r_growing ; r0>0 ; r0-=r0_step
			rainbow(stretch1(r0, 0, r, hue_middle, hue_edge))

			num x_scale = stretch(r0, r, 0, 1, 1.4)

			num rt3on2 = sqrt(3)/2
			num top_semi_r = r0 / (1 + sqrt(2)/2)
			num top_semi_offset = top_semi_r - r0/2

			num y_up = r0/2
			num y_down = rt3on2*squash_y * r0*2
			num yoff = (y_down - y_up)/2

			polygon_start(p, 100)

			num a
			
			for a=150; a>=90; --a
				polygon_point(p, x_scale*(-r0 + Sin(a)*r0*2), Cos(a)*r0*2*squash_y + yoff)
			for a=90; a>=-45; --a
				polygon_point(p, x_scale*(r0/2 - top_semi_offset + Sin(a)*top_semi_r), Cos(a)*top_semi_r + yoff)
			for a=45; a>=-90; --a
				polygon_point(p, x_scale*(-r0/2 + top_semi_offset + Sin(a)*top_semi_r), Cos(a)*top_semi_r + yoff)
			for a=-90; a>=-150; --a
				polygon_point(p, x_scale*(r0 + Sin(a)*r0*2), Cos(a)*r0*2*squash_y + yoff)

			polygon_fill(p)
			polygon_end(p)
		paint()

def stretch(x, in0, in1, out0, out1) (x-in0)/(in1-in0)*(out1-out0)+out0
def stretch1(x, in0, in1, out0, out1) pow((x-in0)/(in1-in0), 3)*(out1-out0)+out0
