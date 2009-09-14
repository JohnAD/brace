use m

def qsincos_n 360
 # must be a multiple of 360
def qatan_n 500

num *_qsin
num *_qcos
num *_qatan

qmath_init()
	_qsin = Nalloc(num, qsincos_n)
	_qcos = Nalloc(num, qsincos_n)
	_qatan = Nalloc(num, qatan_n+1)
	for(i, 0, qsincos_n)
		num a = i*2*pi/qsincos_n
		_qsin[i] = sin(a)
		_qcos[i] = cos(a)
	for(j, 0, qatan_n+1)
		_qatan[j] = atan(j/(num)qatan_n)

def qsin(s, a)
	int my(ang)
	mod_fast(my(ang), a*(qsincos_n/(2*pi)), qsincos_n)
	s = _qsin[my(ang)]

def qSin(s, a)
	qsin(s, angle2rad(a))

def qcos(c, a)
	int my(ang)
	mod_fast(my(ang), a*(qsincos_n/(2*pi)), qsincos_n)
	c = _qcos[my(ang)]

def qCos(c, a)
	qcos(c, angle2rad(a))

def qatan(a, t)
	num my(_t) = t
	if my(_t) > 0
		if my(_t) <= 1
			a = _qatan[(int)(my(_t)*qatan_n)]
		 else
			a = pi/2 - _qatan[(int)(qatan_n/my(_t))]
	 else
		if my(_t) >= -1
			a = -_qatan[(int)(-qatan_n*my(_t))]
		 else
			a = _qatan[(int)(-qatan_n/my(_t))] - pi/2

def qatan2(a, y, x)
	num my(_x) = x
	num my(_y) = y
	if my(_x) == 0
		a = my(_y) >= 0 ? pi/2 : -pi/2
	 else
		qatan(a, my(_y)/my(_x))
		if my(_x) < 0
			if my(_y) < 0
				a -= pi
			 else
				a += pi

def qAtan(a, t)
	qatan(a, t)
	a = rad2angle(a)

def qAtan2(a, y, x)
	qatan2(a, y, x)
	a = rad2angle(a)

# quick random numbers (in a macro)

def rand_M ((1U<<31) -1)
def rand_A 48271
def rand_Q 44488
def rand_R 3399

unsigned int rand_v = 1
def qrand() (unsigned int)(rand_v = rand_A*(rand_v%rand_Q) - rand_R*(rand_v/rand_Q))
def qtoss() (qrand() % 2)
