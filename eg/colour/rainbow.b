#!/lang/b

Main()
	paper(640, 480)
#	rb_green_power = 1
	gr_fast()

	dt = angle2rad(1)

	num r = 480/2*.9
	num a = 0

	spectrum()
#	cycle()


def cycle()
	repeat
		spectrum()
		num power
#		spin()
		pulse_spin(red)
		pulse_spin(green)
		pulse_spin(blue)

def X Sin(a)*r
def Y Cos(a)*r
  # these REALLY want to be local macros!

def spectrum()
	move(X, Y)
	for a = 0 ; a<360.5 ; ++a
		rainbow(a+0.5)
		move(0, 0)
		triangle(X, Y)
	paint()
	sleep(0.01)

def rainbow(a) _rainbow(angle2rad(a))
colour _rainbow(num a)
	num r = rb_power_1(a-rb_red_angle)
	num g = rb_power_1(a-rb_green_angle)
	num b = rb_power_1(a-rb_blue_angle)
#	num g = rb_green_power * (cos(a-rb_green_angle)+1)/2
#	num b = rb_blue_power * (cos(a-rb_blue_angle)+1)/2
#	r = pow(r, 1)
#	g = pow(g, 1)
#	b = pow(b, 1)
	return rgb(r, g, b)

num rb_power_1(num a)
	return (cos(a)+1)/2

num rb_power_2(num a)
	# constraints:
	#     0 -> 1
	# at 60 -> sqrt(2)
	# +-120 -> 0       and thereafter
	if a > pi
		a -= 2*pi
	num p = cos(a * 3.0/4.0)
	if p <= 0
		return 0
	return p

num rb_power_3(num a)
	# constraints:
	#     0 -> 1
	# at 60 -> 1
	# +-120 -> 0       and thereafter
	if a > pi
		a -= 2*pi

	if fabs(a) < deg2rad(60)
		return 1

	a = fsgn(a)*(fabs(a)-deg2rad(60))

	if fabs(a) >= deg2rad(60)
		return 0

	num p = cos(a * 180.0/60.0) / 2.0 + 0.5

	return p

num dt

def spin()
	rb_red_angle += 1.6*dt
	rb_green_angle += 2*dt
	rb_blue_angle += 1*dt

def pulse(which)
	for power=0; power < 360.1; power += 5
		rb_^^which^^_power = (Cos(power)+1)/2 * 0.8
		spectrum()

def pulse_spin(which)
	pulse(which)
		spin()

def trig_unit deg

# move to m.b
num fsgn(num x)
	if x == 0.0
		return 0.0
	if x < 0.0
		return -1.0
	return 1.0

use main
use m
use gr
use error
use time
use io
