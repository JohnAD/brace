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

	num a = -fan_step/2
	move(X, Y)
	for a = 0 ; a < 12-fan_step/2 ;
		num red = 0
		num green = 0
		num blue = 0
		for(i, 0, fan_n)
			num power = (Cos(a - fan_angle[i])+1)/2
			rgb_colour c = fan_colours[i]
			red += c.red * power
			green += c.green * power
			blue += c.blue * power

		Sayf("a %f  r %.3f  g %.3f  b %.3f", a, red, green, blue)

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
