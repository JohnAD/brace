def for_exact(var, from, to, step)
	for(var, from+0.0, to+step/2.0, step+0.0)



num rb_smoothness = 1.1
rgb_colour rb_cols[24]

struct rgb_colour
	num red
	num green
	num blue
#
#hsv_init()
##	repeat
##		FILE *f = freopen("./colours", "r", stdin)
##		if f != NULL
##			break
#	freopen("./colours", "r", stdin)  # FIXME
#	
#	int i = 0
#	read_tsv(red_, green_, blue_)
#		if i == 24
#			error("too many lines in colours file!")
#		num red = atof(red_)
#		num green = atof(green_)
#		num blue = atof(blue_)
##			num white = atof(white_)
##			num black = atof(black_)
##			whiten() ; blacken()
##		red *= red_factor
##		green *= green_factor
##		blue *= blue_factor
#		
#		rb_cols[i].red = red
#		rb_cols[i].green = green
#		rb_cols[i].blue = blue
#		
#		++i
#	
#	if i != 24
#		error("not enough lines in colours file!")
#
#
#def rainbow(a) hsv(a, 1, 0)
#def hsv(a, s, v) hsv_(rad2lun(angle2rad(a)), s, v)
#colour hsv_(num a, num s, num v)
#	# from [0, 12)
#	a = rmod(a, 12)
#	a *= 2
#	int i0 = a
#	int i1 = (i0+1) % 24
#	num blend = (a - i0)
#	blend = pow(fabs(blend-0.5) * 2, 1/rb_smoothness)*fsgn(blend-0.5)/2 + 0.5
#	num red0 = rb_cols[i0].red
#	num green0 = rb_cols[i0].green
#	num blue0 = rb_cols[i0].blue
#	num red1 = rb_cols[i1].red
#	num green1 = rb_cols[i1].green
#	num blue1 = rb_cols[i1].blue
#	num red = (red1-red0)*blend+red0
#	num green = (green1-green0)*blend+green0
#	num blue = (blue1-blue0)*blend+blue0
#	num black = 1 - s
#	num white = v
#	blacken()
#	whiten()
#	return rgb(red, green, blue)

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

export vec util

def read_tsv_vec(v)
	read_tsv_vec(v, my(l))
def read_tsv_vec(v, l)
	repeat
		cstr l = Input()
		if l == NULL
			break
		split_cstr(v, l)

def read_tsv_vec_n(v, n)
	read_tsv_vec_n(v, n, my(l))
def read_tsv_vec_n(v, n, l)
	read_tsv_vec(v, l)
		if vec_get_size(v) != n
			error("read_tsv_vec_n: expected %d columns, got %d", n, vec_get_size(v))

# this is a degenerate case! but they are usually important to have
def read_tsv()
	_read_tsv(my(v))
def _read_tsv(v)
	new(v, vec, cstr, 0)
	read_tsv_vec_n(v, 0)
		.
#FIXME Free(v)!

# this is sort of degenerate but not really!
def read_tsv(a1)
	_read_tsv(my(v), a1)
def _read_tsv(v, a1)
	new(v, vec, cstr, 1)
	read_tsv_vec_n(v, 1)
		cstr a1 = *(cstr *)vec_element(v, 0)
#FIXME Free(v)!

def read_tsv(a1, a2)
	_read_tsv(my(v), a1, a2)
def _read_tsv(v, a1, a2)
	new(v, vec, cstr, 2)
	read_tsv_vec_n(v, 2)
		cstr a1 = *(cstr *)vec_element(v, 0)
		cstr a2 = *(cstr *)vec_element(v, 1)
#FIXME Free(v)!

def read_tsv(a1, a2, a3)
	_read_tsv(my(v), a1, a2, a3)
def _read_tsv(v, a1, a2, a3)
	new(v, vec, cstr, 3)
	read_tsv_vec_n(v, 3)
		cstr a1 = *(cstr *)vec_element(v, 0)
		cstr a2 = *(cstr *)vec_element(v, 1)
		cstr a3 = *(cstr *)vec_element(v, 2)
#FIXME Free(v)!

def read_tsv(a1, a2, a3, a4)
	_read_tsv(my(v), a1, a2, a3, a4)
def _read_tsv(v, a1, a2, a3, a4)
	new(v, vec, cstr, 4)
	read_tsv_vec_n(v, 4)
		cstr a1 = *(cstr *)vec_element(v, 0)
		cstr a2 = *(cstr *)vec_element(v, 1)
		cstr a3 = *(cstr *)vec_element(v, 2)
		cstr a4 = *(cstr *)vec_element(v, 3)
#FIXME Free(v)!

def read_tsv(a1, a2, a3, a4, a5)
	_read_tsv(my(v), a1, a2, a3, a4, a5)
def _read_tsv(v, a1, a2, a3, a4, a5)
	new(v, vec, cstr, 5)
	read_tsv_vec_n(v, 5)
		cstr a1 = *(cstr *)vec_element(v, 0)
		cstr a2 = *(cstr *)vec_element(v, 1)
		cstr a3 = *(cstr *)vec_element(v, 2)
		cstr a4 = *(cstr *)vec_element(v, 3)
		cstr a5 = *(cstr *)vec_element(v, 4)
#FIXME Free(v)!

# etc!  need snazzy variadic macros :)

# FIXME is this split_cstr, fixed s->i, in the latest brace?  I think not

split_cstr(vec *v, cstr s, char c)
	vec_clear(v)
	vec_push(v, s)
	for_cstr(i, s)
		if *i == c
			*i = '\0'
			vec_push(v, i+1)

def split_cstr(v, s) split_cstr(v, s, '\t')

def for_cstr(i, s)
	char *i
	for i=s; *i != '\0'; ++i
		.

# move to m.b
num fsgn(num x)
	if x == 0.0
		return 0.0
	if x < 0.0
		return -1.0
	return 1.0

# to m.b - new angle unit, lunes.. after the moon/months.. ok?
num lun2rad(num a)
	return a * pi / 6.0
num rad2lun(num a)
	return a * 6.0 / pi

# m.b

def rmod(r, low, high) rmod_range(r, low, high)
def rdiv(r, low, high) rdiv_range(r, low, high)
num rmod_range(num r, num low, num high)
	int d = rdiv_range(r, low, high)
	return r - d * (high-low)
num rdiv_range(num r, num low, num high)
	return rdiv(r-low, high-low)

# TODO rdiv/rmod variants based on ceiling instead of floor
#   (i.e. include top but not bottom of range?)


# TODO functions that compute sin and cos together?
def circular_blend(x, y, A, a)
	num y = Sin(a)/Sin(A)
	num x = Cos(a) - Cos(A)*y
	
	# this resolves an angle a into components parallel to two axes
	# which are at an angle A
	
	# to be used for fixing the colour space
	
	# could also be used for drawing circular arcs directly
	# in a projection of 3d, etc
	
	# what's a better name for it?  vector_arc?

# TODO functions that compute sin and cos together?

# I changed the semantics of circular_blend, now A comes last, and i is from 0
# to 1, not a from 0 to A.  this is so can put the limiting A=0 for a linear blend

### NO, CHANGED BACK: also I swapped x and y as the 0->1 one has more priority

# maybe should do a 3-arg form that only does one part (x/p1) of the blend

def circular_blend(x, y, i, A)
	if A == 0
		y = i
		x = 1-i
	 else
	 	num my(a) = A*i
		y = Sin(my(a))/Sin(A)
		x = Cos(my(a)) - Cos(A)*y

	# this resolves an angle a into components parallel to two axes
	# which are at an angle A
	
	# to be used for fixing the colour space
	
	# could also be used for drawing circular arcs directly
	# in a projection of 3d, etc
	
	# what's a better name for it?  vector_arc?

	# symmetrical, i.e. circular_blend(y, x, 1-i, A) is the same result
