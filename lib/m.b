export math.h stdlib.h limits.h float.h
export types util time
use process
use m

#Def trig_unit rad
Def trig_unit deg
# TODO: trig01, trig_neg1_to_1, grad

const num pi = M_PI
const num pi2 = M_PI * 2
const num e = M_E

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

long lmin(long x, long y)
	if x < y
		return x
	return y

int imax(int x, int y)
	if x > y
		return x
	return y

long lmax(long x, long y)
	if x > y
		return x
	return y

def nmax(x, y, z) nmax(nmax(x, y), z)
def imax(x, y, z) imax(imax(x, y), z)
def lmax(x, y, z) lmax(lmax(x, y), z)

def sqr(x) x*x

# use hypot instead
#real pythag(real x, real y)
#	return sqrt(x*x + y*y)
num notpot(num hypotenuse, num x)
	return sqrt(sqr(hypotenuse) - sqr(x))

#def randi() (long)(random() & 0x7fffffff)
def randi() random()
def randi(max) (int)(max*Rand())
def randi(min, max) randi(max-min)+min

long Randi(long min, long max)
	return random() / ((1U<<31) / (max - min)) + min
def Randi(max) Randi(0, max)
def Randi() randi()

def RANDOM_TOP (1UL<<31)
def RANDOM_MAX RANDOM_TOP-1
def RANDI_TOP RANDOM_TOP
def RANDI_MAX RANDOM_MAX
def RANDL_TOP (unsigned long long int)RANDI_TOP*RANDI_TOP
def RANDL_MAX (unsigned long)RANDL_TOP-1

def randl() (long long int)random()*RANDI_TOP+random()
  # not full 64 bit positive, only 62 bits!

def Rand() (num)((long double)randl()/RANDL_TOP)
def Rand(max) Rand()*max
def Rand(min, max) Rand(max-min)+min
#def toss() Rand()>0.5
def toss() randi() > RANDI_MAX/2
# TODO speed up some other rand functions like with toss

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

long lclamp(long x, long min, long max)
	return x < min ? min : x > max ? max : x

def byte_clamp(x) iclamp(x, 0, 255)
def byte_clamp_top(x) (int x)&0xFF
def n_to_byte(x) byte_clamp((int)(x*256))
def n_to_byte_top(x) (int)(x*256)&0xFF

def Floor(x) (int)(x+tinynum)

def num_eq(a, b) fabs(b-a)<tinynum
def num_lt(a, b) a<b-tinynum
def num_le(a, b) a<b+tinynum
def num_gt(a, b) a>b+tinynum
def num_ge(a, b) a>b-tinynum
def num_ne(a, b) !num_eq(a, b)

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

def rand_normal(av, sd) rand_normal()*sd+av

num rand_normal()
	num U = Rand()
	num V = Rand()
	num X = sqrt(-2 * log(U)) * cos(2*pi*V)
#	num Y = sqrt(-2 * log(V)) * sin(2*pi*U)
	return X

def ln(x) log(x)

# rand_normal uses the box-mueller method, from:
# http://en.wikipedia.org/wiki/Normal_distribution#Generating_values_for_normal_random_variables
# The Ziggurat method is faster, I could try that later.

num blend(num i, num x0, num x1)
	return (x1-x0)*i + x0

def Abs(a) a >= 0 ? a : -a
def iabs(a) Abs(a)  # compat: TODO remove

struct pointi1
	int x[1]
struct pointi2
	int x[2]
struct pointi3
	int x[3]
struct pointn1
	num x[1]
struct pointn2
	num x[2]
struct pointn3
	num x[3]


def sin_cos(s, c, a):
	s = sin(a)
	c = cos(a)

def Sin_Cos(s, c, a):
	s = Sin(a)
	c = Cos(a)

def sin_cos(s, c, a, r):
	s = sin(a) * r
	c = cos(a) * r

def Sin_Cos(s, c, a, r):
	s = Sin(a) * r
	c = Cos(a) * r


struct affine2d:
	num x[6]

affine2d_id(affine2d *m):
	*m = (affine2d){{ 1,0, 0,1, 0,0 }}

affine2d_tlt(affine2d *m, num x, num y):
	*m = (affine2d){{ 1,0, 0,1, x,y }}

affine2d_rot(affine2d *m, num a):
	num s, c
	sin_cos(s, c, a)
	*m = (affine2d){{ c,s, -s,c, 0,0 }}

affine2d_rot_tlt(affine2d *m, num a, num x, num y):
	num s, c
	sin_cos(s, c, a)
	*m = (affine2d){{ c,s, -s,c, x,y }}

affine2d_mul(affine2d *o, affine2d *a_, affine2d *b_):
	num *a = a_->x, *b = b_->x
	*o = (affine2d){{
	 a[0]*b[0] + a[1]*b[2], a[0]*b[1] + a[1]*b[3],
	 a[2]*b[0] + a[3]*b[2], a[2]*b[1] + a[3]*b[3],
	 a[4]*b[0] + a[5]*b[2] + b[4], a[4]*b[1] + a[5]*b[3] + b[5] }}

def affine2d_apply(x_, y_, x, y, m_):
	affine2d_apply_(x_, y_, x, y, m_, my(m))
def affine2d_apply_(x_, y_, x, y, m_, m):
	num *m = m_->x
	let(my(x__), m[0] * x + m[2] * y + m[4])
	y_ = m[1] * x + m[3] * y + m[5]
	x_ = my(x__)


struct affine3d:
	num x[12]

affine3d_id(affine3d *m):
	*m = (affine3d){{ 1,0,0, 0,1,0, 0,0,1, 0,0,0 }}

affine3d_tlt(affine3d *m, num x, num y, num z):
	*m = (affine3d){{ 1,0,0, 0,1,0, 0,0,1, x,y,z }}

affine3d_rot_z(affine3d *m, num a):
	num s, c
	sin_cos(s, c, a)
	*m = (affine3d){{ c,s,0, -s,c,0, 0,0,1, 0,0,0 }}

affine3d_rot_x(affine3d *m, num a):
	num s, c
	sin_cos(s, c, a)
	*m = (affine3d){{ 1,0,0, 0,c,s, 0,-s,c, 0,0,0 }}

affine3d_rot_y(affine3d *m, num a):
	num s, c
	sin_cos(s, c, a)
	*m = (affine3d){{ c,0,-s, 0,1,0, s,0,c, 0,0,0 }}

affine3d_mul(affine3d *o, affine3d *a_, affine3d *b_):
	num *a = a_->x, *b = b_->x
	*o = (affine3d){{
	 a[0]*b[0] + a[1]*b[3] + a[2]*b[6], a[0]*b[1] + a[1]*b[4] + a[2]*b[7], a[0]*b[2] + a[1]*b[5] + a[2]*b[8],
	 a[3]*b[0] + a[4]*b[3] + a[5]*b[6], a[3]*b[1] + a[4]*b[4] + a[5]*b[7], a[3]*b[2] + a[4]*b[5] + a[5]*b[8],
	 a[6]*b[0] + a[7]*b[3] + a[8]*b[6], a[6]*b[1] + a[7]*b[4] + a[8]*b[7], a[6]*b[2] + a[7]*b[5] + a[8]*b[8],
	 a[9]*b[0] + a[10]*b[3] + a[11]*b[6] + b[9], a[9]*b[1] + a[10]*b[4] + a[11]*b[7] + b[10], a[9]*b[2] + a[10]*b[5] + a[11]*b[8] + b[11] }}

def affine3d_apply(x_, y_, z_, x, y, z, m_):
	affine3d_apply_(x_, y_, z_, x, y, z, m_, my(m))
def affine3d_apply_(x_, y_, z_, x, y, z, m_, m):
	num *m = m_->x
	let(my(x__), m[0] * x + m[3] * y + m[6] * z + m[9])
	let(my(y__), m[1] * x + m[4] * y + m[7] * z + m[10])
	z_ = m[2] * x + m[5] * y + m[8] * z + m[11]
	x_ = my(x__)
	y_ = my(y__)

