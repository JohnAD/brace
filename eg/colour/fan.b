#!/lang/b
use b
use lib_extra.b

rgb_colour fan_colours[12]
num fan_angle[12]
int fan_n = 0

Main()
	int size = atoi(Getenv("size", "300"))
#	int span = atof(Getenv("span", "2"))
	num fan_step = atof(Getenv("step", "1"))
	num black = atof(Getenv("black", "0"))
	num white = atof(Getenv("white", "0"))
	num bright = atof(Getenv("bright", "1"))
	space(size, size)
	zoom(size/2-10)
	num r = 1
	gr_fast()

	fan_colours_init()

	num max_r = 0
	num max_g = 0
	num max_b = 0

	for(i0, 0, fan_n)
		int i1 = (i0+1) % fan_n
		Sayf("i0 %d  i1 %d", i0, i1)

		num a0 = fan_angle[i0]
		num a1 = fan_angle[i1]
		rgb_colour colour_0 = fan_colours[i0]
		rgb_colour colour_1 = fan_colours[i1]
		if a1 < a0
			a1 += 12
		num A = a1-a0
		Sayf(" a0 %f  a1 %f  A %f", a0, a1, A)

		num a = a0-fan_step/2
		move(X, Y)
		for a = a0 ; a < a1-fan_step/2 ;
			num da = a - a0
			Sayf("  a %f  da %f", a, da)
#			circular_blend(x, y, A, da)
			 # should we use A==3 (right angle) ?
			 # even though the primary colours aren't at
			 # right angles around the circle?
			 # because they are effectively different dimensions?
			 # in that case should use:
#			circular_blend(x, y, 3, da/A*3)
			 # EXPERIMENT :)
			 # might also be, like  4  ->  3  (120 -> 90)
#			circular_blend(x, y, A*3.0/4.0, da*3.0/4.0)
#			circular_blend(x, y, A/2, da/2)
##			circular_blend(x, y, span, da*span/A)
			num x, y
			circular_blend(x, y, da/A, A)
#			circular_blend(x, y, A*span/4.0, da*span/4.0)
#			circular_blend(x, y, 3, da*3/A)
#			circular_blend(x, y, 4, da*4/A)
#			circular_blend(x, y, 5, da*5/A)
#			linear_blend(x, y, A, da)

			num red = x*colour_0.red + y*colour_1.red
			num green = x*colour_0.green + y*colour_1.green
			num blue = x*colour_0.blue + y*colour_1.blue
			blacken()
			whiten()
			brighten()

			if red > max_r
				max_r = red
			if green > max_g
				max_g = green
			if blue > max_b
				max_b = blue

			Sayf("   r %.3f  g %.3f  b %.3f", red, green, blue)

			rgb(red, green, blue)
			move(0, 0)
			a += fan_step/2
			triangle(X, Y)
			a += fan_step/2

	Sayf("max r: %f", max_r)
	Sayf("max g: %f", max_g)
	Sayf("max b: %f", max_b)

	Sayf("could brighten by %f", 1.0/nmax(max_r, max_g, max_b))

def X Sin(a)*r
def Y Cos(a)*r

fan_colours_init()
#	repeat
#		FILE *f = freopen("./colours", "r", stdin)
#		if f != NULL
#			break
	freopen("./fan_colours", "r", stdin)  # FIXME
	
	int i = 0
	read_tsv(red_, green_, blue_, angle_)
		if i == 12
			error("too many lines in colours file!")
		num red = atof(red_)
		num green = atof(green_)
		num blue = atof(blue_)
		num angle = atof(angle_)
		
		fan_colours[i].red = red
		fan_colours[i].green = green
		fan_colours[i].blue = blue
		fan_angle[i] = angle
		
		++i
	
	fan_n = i

def trig_unit lun

def brighten()
	brighten(red)
	brighten(green)
	brighten(blue)
def brighten(x)
	x *= bright


# TODO brightness is like away from black,
#      whiten is like fade to white.
#  instead, use brightness (away from black), contrast (away from white)  ??
#  doesn't make much sense to go to or away from white,
#  as white is theoretically unlimited brightness
#

def linear_blend(x, y, A, a)
	num x = 1-a/A
	num y = 1-x
