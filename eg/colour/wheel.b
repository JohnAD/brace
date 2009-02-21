#!/lang/b

Main()
	int size = atoi(Getenv("size", "400"))
	# NOTE for brace, always use env vars for real options
	# (as opposed to standard arguments)
	# have a "clear env" function, that clears all but standard env
	# vars.  also for brace?  was in BASIC   :D  yes with namespaces
	# Can clear to a certain previous LEVEL, e.g. base, or before a
	# block, etc.  and undo assignments / masking
	#   (e.g. drawing tree, GL context, modulation in music, etc)

	space(size, size)
	
	num r = h_2 - 10

	gr_fast()
	
	clear()
	num a = -5.5
	move(X, Y)
	
	#  red tang orang yello lime green aqua sky blue indigo purpl pink
	#  -5  -4   -3    -2    -1   0     1    2   3    4      5     6
	#  so  lo   la    ta    ti   do    ro   re  me   mi     fa    fo/sa
	#  (   {    [     <     /    o     \    >   ]    }      )     x    
	
	for a = -5 ; a < 6.5 ;
		rainbow(a)
		
		move(0, 0)
		a+=0.5
		triangle(X, Y)
		a+=0.5
	
	paint()

def rainbow(a) rainbow_(a)  # rad2lun(angle2rad(a))
colour rainbow_(num a)
	# this angle must be measured in lunes!
	# or could do rad2lun(ang2rad(a)) but don't bother, yet
	#  I wonder if there is a nice trig-like series for sine(a*6/pi)  ?

	# there are three primaries red, green blue
	# and the three ranges between them.

	# for example every colour between red and green contains NO blue

	# the monitor of course should be tuned so white is white,
	# black is black and and grey is grey.
	# now to produce the rest of the colours :)

	# the range is from red, to pink-almost-red-again  :)

#	a = rmod(a, -5, 7)  # from [-5, 7)  # TODO 
	a = rmod(a, -5, 7)  # from [-5, 7)  # TODO 
	
	num a_r = rmod(a + 5, -6, 6)
	num a_g = rmod(a, -6, 6)
	num a_b = rmod(a - 4, -6, 6)

	return rgb((Cos(a_r)+1)/2, (Cos(a_g)+1)/2, (Cos(a_b)+1)/2)

#	if a == -5  # red
#		return rgb(1, 0, 0)
#	if a == 0  # green
#		return rgb(0, 1, 0)
#	if a == 4   # indigo
#		return rgb(0, 0, 1)

	if a > -5 && a < 0
		#  (red) tang orang yellow lime (green)
		solve_colour(r, g, a-(-5), 0-a)
		return rgb(r, g, 0)

	if a > 0 && a < 4
		#  (green) aqua sky blue (indigo)
		solve_colour(g, b, a, 4-a)
		return rgb(0, g, b)

	if a > 4 && a < 7
		#  (green) aqua sky blue (indigo)
		solve_colour(b, r, a-4, 7-a)
		return rgb(r, 0, b)

	bug("rainbow: a = %f !in [-5, 7) ?", a)
	exit(1)  # keep gcc happy
	  # FIXME do bug, error, etc as macros that exit in the caller?

void bug(const char *format, ...)
	va_list ap
	va_start(ap, format)
	fprintf(stderr, "bug in ")
	vfprintf(stderr, format, ap)
	va_end(ap)
	fprintf(stderr, "\n")
	exit(1)

def solve_colour(i0, i1, a0, a1)
	num my(a) = a0 + a1
	# to solve:  a0 * i0 == a1 * i1
	# and:       Cos(a0) * i0 + Cos(a1) * i1 == 1
	linear(i0, i1, 0, a0, -a1, 1, Cos(a0/my(a) * 3), Cos(a1/my(a) * 3))
	# the first equation is for colour balance (hue)
	#   e.g. orange: 1*i0 = 4*i1   ;   Cos(1)*i0 + Cos(4)*i1 = 1
	# the second for intensity (value)
	warn("solve_colour: a:%f a0:%f a1:%f -> i0:%f i1:%f", a, a0, a1, i0, i1)

def linear(x, y, a, b, c, d, e, f)
	# a  =  b*x + c*y
	# d  =  e*x + f*y
	num x, y
	if b != 0
	 	linear_(x, y, a, b, c, d, e, f)
	 else
		linear_(y, x, a, c, b, d, f, e)

# linear_ should be a func returning two values,
# make it nice to do that in brace..
def linear_(x, y, a, b, c, d, e, f)
	# assume b != 0  --  also if f*b - c*e == 0  we're in trouble :)
	# x  =  a-c*y / b   # b != 0   else  swap x y, etc
	# d  =  e*(a-c*y / b) + f*y
	# d - e*a/b  =  -e*c*y/b + f*y
	# d*b - e*a  =  (-e*c + f*b) * y
	num my(under) = f*b - c*e
	if my(under) == 0
		error("linear failed: parallel")
	y = (d*b - a*e) / my(under)
	x = a - (c*y / b)

def X Sin(a)*r
def Y Cos(a)*r

def whiten(x)
	x = 1 - (1-x)*(1-white)
def blacken(x)
	x = x*(1-black)
def whiten()
	whiten(red)
	whiten(green)
	whiten(blue)
def blacken()
	blacken(red)
	blacken(green)
	blacken(blue)

def trig_unit lun

use b
use lib_extra.b
