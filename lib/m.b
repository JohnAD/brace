export math.h stdlib.h limits.h
export types util time
use process
use m

Def trig_unit rad
# Def trig_unit deg
# TODO: trig01, trig_neg1_to_1, grad

const double pi = M_PI
const double e = M_E

def Rad(a) deg2rad(a)
def deg2rad(a) a * pi / 180.0

#num deg2rad(num a)
#	return a * pi / 180.0

def Deg(a) rad2deg(a)
def rad2deg(a) a * 180.0 / pi

#num rad2deg(num a)
#	return a * 180.0 / pi

Def angle_360 trig_unit^^_360
Def angle_180 trig_unit^^_180
Def angle_90 trig_unit^^_90
Def angle_60 trig_unit^^_60
Def angle_30 trig_unit^^_30

def rad_360 2*pi
def rad_180 pi
def rad_90 pi/2
def rad_60 pi/3
def rad_45 pi/4
def rad_30 pi/6

def deg_360 360.0
def deg_180 180.0
def deg_90 90.0
def deg_60 60.0
def deg_45 45.0
def deg_30 30.0

def Sin(a) sin(angle2rad(a))
def Cos(a) cos(angle2rad(a))
def Tan(a) tan(angle2rad(a))

def Acos(x) rad2angle(acos(x))
def Asin(y) rad2angle(asin(y))
def Atan(m) rad2angle(atan(m))
def Atan2(y, x) rad2angle(atan2(y, x))

# todo: once macro-closures are working, change to sin, cos, tan...

# todo can also have an dynamic2rad, so can change settings in mid program.
# Actually, you could change settings mid program with local macros!

int sgn(num x)
	if x < 0
		return -1
	if x > 0
		return 1
	return 0

num nmin(num x, num y)
	if x < y
		return x
	return y

num nmax(num x, num y)
	if x > y
		return x
	return y

int imin(int x, int y)
	if x < y
		return x
	return y

int imax(int x, int y)
	if x > y
		return x
	return y

def nmax(x, y, z) nmax(nmax(x, y), z)
def imax(x, y, z) imax(imax(x, y), z)

def sqr(x) x*x

# use hypot instead
#real pythag(real x, real y)
#	return sqrt(x*x + y*y)
num notpot(num hypotenuse, num x)
	return sqrt(sqr(hypotenuse) - sqr(x))

def Randint(max) (int)(max*(double)Rand())
#int Randint(int max)
#	return (int)max*(double)Rand()
def Randint(min, max) Randint(max-min)+min

def Rand() (num)random()/RAND_MAX
# FIXME is this enough precision for a double?  I guess not?
#num Rand()
#	# FIXME is this enough precision for a double?  I guess not?
#	return ((num)random())/RAND_MAX
def Rand(max) Rand()*max
def Rand(min, max) Rand(max-min)+min
def toss() Rand()>0.5

seed()
	int s = (int)((rmod(rtime()*1000, pow(2, 32)))) ^ (getpid()<<16)
	seed(s)
def seed(s) srandom(s)

# TODO remap to Mod ?
int mod(int i, int base)
	if i < 0
		return base - 1 - (-1 - i) % base
	else
		return i % base

int Div(int i, int base)
	if i>=0
		return i/base
	return -((-i-1)/base + 1)

def mod_fast(ans, i, base)
	int my(_i) = i
	int my(_b) = base
	if my(_i) >= 0
		ans = my(_i)%my(_b)
	 else
		ans = my(_b)-1 - (-1-my(_i))%my(_b)

num rmod(num r, num base)
	int d = rdiv(r, base)
	return r - d * base

def rmod_fast(num m, num r, num base)
	num my(_r) = r
	num my(_b) = base
	m = my(_r) - rdiv(my(_r), my(_b)) * my(_b)

def rdiv(r, base) floor(r / base)

# typedef real vec2[2]
# typedef real vec3[3]
# 
# vec2 unit2(real a)
# 	vec2 v
# 	v[0] = cos(a)
# 	v[1] = sin(a)
# 
# def Unit2(a) unit2(deg2rad(a)

num dist(num x0, num y0, num x1, num y1)
	return hypot(x1-x0, y1-y0)

def rad2rad Id
def deg2deg Id

Def angle2rad trig_unit^^2^^rad
Def angle2deg trig_unit^^2^^deg
Def rad2angle rad2^^trig_unit
Def deg2angle deg2^^trig_unit
  # !! how awesome !!
  # TODO allow token pasting in normal parsage too
  #   think about when it's done

def polar_to_rec(x0, y0, a, r, x1, y1)
	let(x1, Cos(a)*r + x0)
	let(y1, Sin(a)*r + y0)

def avg(x) x
def avg(x, y) (x+y)/2.0
def avg(x, y, z) (x+y+z)/3.0

def avg(a0, a1, a2, a3) (a0 + a1 + a2 + a3)/4.0
def avg(a0, a1, a2, a3, a4) (a0 + a1 + a2 + a3 + a4)/5.0
def avg(a0, a1, a2, a3, a4, a5) (a0 + a1 + a2 + a3 + a4 + a5)/6.0
def avg(a0, a1, a2, a3, a4, a5, a6) (a0 + a1 + a2 + a3 + a4 + a5 + a6)/7.0
def avg(a0, a1, a2, a3, a4, a5, a6, a7) (a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7)/8.0
def avg(a0, a1, a2, a3, a4, a5, a6, a7, a8) (a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8)/9.0
def avg(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) (a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9)/10.0

num double_or_nothing(num factor)
	# this returns 1, 2, 4, 1/2, 1/4 only (the closest)
	return pow(2, floor(log(factor)/log(2)+.5))

divmod(int i, int base, int *div, int *_mod)
	*div = Div(i, base)
	*_mod = mod(i, base)

divmod_range(int i, int low, int high, int *div, int *_mod)
	i -= low
	divmod(i, high-low, div, _mod)
	*_mod += low

rdivmod(num r, num base, num *div, num *_mod)
	*div = rdiv(r, base)
	*_mod = rmod(r, base)

rdivmod_range(num r, num low, num high, num *div, num *_mod)
	r -= low
	rdivmod(r, high-low, div, _mod)
	r += low

def xor(a, b) (a&&1)^(b&&1)

def tinynum 1e-12
def bignum INFINITY

Def sincos(a, r) sin(a) * r, cos(a) * r
Def SinCos(a, r) Sin(a) * r, Cos(a) * r

def rand_angle_unsigned() Rand(angle_360)

def rand_angle_signed() Rand(-angle_180, angle_180)

def rand_angle() rand_angle_signed()

num clamp(num x, num min, num max)
	return x < min ? min : x > max ? max : x

int iclamp(int x, int min, int max)
	return x < min ? min : x > max ? max : x

def Floor(x) (int)(x+tinynum)
def num_eq(a, b) fabs(b-a)<tinynum

num spow(num b, num e)
	if b >= 0
		return pow(b, e)
	 else
		return -pow(-b, e)
def ssqrt(b) spow(b, 0.5)
def ssqr(b) spow(b, 2)

# FIXME this is inefficient, and anyway if using this method should have varargs macros!
def max(a0) a0
def max(a0, a1) nmax(a0, a1)
def max(a0, a1, a2) max(max(a0, a1), a2)
def max(a0, a1, a2, a3) max(max(a0, a1, a2), a3)
def max(a0, a1, a2, a3, a4) max(max(a0, a1, a2, a3), a4)
def max(a0, a1, a2, a3, a4, a5) max(max(a0, a1, a2, a3, a4), a5)
def max(a0, a1, a2, a3, a4, a5, a6) max(max(a0, a1, a2, a3, a4, a5), a6)
def max(a0, a1, a2, a3, a4, a5, a6, a7) max(max(a0, a1, a2, a3, a4, a5, a6), a7)
def max(a0, a1, a2, a3, a4, a5, a6, a7, a8) max(max(a0, a1, a2, a3, a4, a5, a6, a7), a8)
def max(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) max(max(a0, a1, a2, a3, a4, a5, a6, a7, a8), a9)
