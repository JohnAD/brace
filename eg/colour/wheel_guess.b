#!/lang/b

# try ./wheel.b 0.88 0.5 1

Main()
	num red_factor, green_factor, blue_factor
	which args
	0	red_factor = green_factor = blue_factor = 1
	3	red_factor = atof(arg[0])
		green_factor = atof(arg[1])
		blue_factor = atof(arg[2])
	else	usage("[red_factor green_factor blue_factor]")

	int size = atoi(Getenv("size", "400"))

	space(size, size)

	gr_fast()

	repeat
		clear()

		repeat
			FILE *f = freopen("./colours", "r", stdin)
			if f != NULL
				break

		num r = h_2 - 10
		num a = -7.5
		move(X, Y)
		read_tsv(red_, green_, blue_)  # , white_, black_)
			num red = atof(red_)
			num green = atof(green_)
			num blue = atof(blue_)
#			num white = atof(white_)
#			num black = atof(black_)
#			whiten() ; blacken()
			rgb(red*red_factor, green*green_factor, blue*blue_factor)
			move(0, 0)
			a += 15
			triangle(X, Y)

		paint()
		
		sleep(0.2)

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

def trig_unit deg

use b

export vec util

def read_tsv_vec(v)
	read_tsv_vec(v, my(l))
def read_tsv_vec(v, l)
	repeat
		cstr l = Input()
		if l == NULL
			break
		split(v, l)

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

# FIXME is this split, fixed s->i, in the latest brace?  I think not

split(vec *v, cstr s, char c)
	vec_clear(v)
	vec_push(v, s)
	for_cstr(i, s)
		if *i == c
			*i = '\0'
			vec_push(v, i+1)

def split(v, s) split(v, s, '\t')

def for_cstr(i, s)
	char *i
	for i=s; *i != '\0'; ++i
		.
