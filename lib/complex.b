use m

struct complex
	num r
	num i

complex c_0 = { 0, 0 }
complex c_1 = { 1, 0 }
complex c_i = { 0, 1 }

def complex(r, i) (complex){r, i}
def complex(r) (complex){r, 0}
def complex_i(i) (complex){0, i}

complex c_add(complex a, complex b)
	return complex(a.r + b.r, a.i + b.i)

complex c_sub(complex a, complex b)
	return complex(a.r - b.r, a.i - b.i)

complex c_mul(complex a, complex b)
	return complex(a.r * b.r - a.i * b.i, a.r * b.i + a.i * b.r)

complex c_div(complex a, complex b)
	num denom = b.r * b.r + b.i * b.i
	return complex((a.r * b.r + a.i * b.i) / denom, (a.i * b.r - a.r * b.i) / denom)

num c_norm(complex a)
	return a.r*a.r + a.i*a.i

num c_mag(complex a)
	return hypot(a.r, a.i)

num c_ang(complex a)
	return atan2(a.i, a.r)

complex c_conj(complex a)
	return complex(a.r, -a.i)

complex c_add_r(complex a, num b)
	return complex(a.r + b, a.i)

complex c_sub_r(complex a, num b)
	return complex(a.r - b, a.i)

complex c_add_i(complex a, num b)
	return complex(a.r, a.i + b)

complex c_sub_i(complex a, num b)
	return complex(a.r, a.i - b)

complex c_mul_r(complex a, num b)
	return complex(a.r * b, a.i * b)

complex c_div_r(complex a, num b)
	return complex(a.r / b, a.i / b)

complex c_mul_i(complex a, num b)
	return complex(- a.i * b, a.r)

complex c_div_i(complex a, num b)
	return complex(a.i / b, - a.r / b)

complex c_mul_i1(complex a)
	return complex(-a.i, a.r)

complex c_div_i1(complex a)
	return complex(a.i, -a.r)

complex c_neg(complex a)
	return complex(-a.r, -a.i)

complex cis(num ang)
	return complex(cos(ang), sin(ang))

complex c_exp(complex a)
	num mag = exp(a.r)
	return complex(mag * cos(a.i), mag * sin(a.i))

complex c_log(complex a)
	return complex(log(c_mag(a)), c_ang(a))

complex c_pow(complex a, complex b)
	return c_exp(c_mul(c_log(a), b))

complex c_pow_r(complex a, num b)
	num mag = c_mag(a)
	return c_mul_r(cis(c_ang(a) * b), pow(mag, b))

# if I want to add more functions, e.g. sin, cos, see:
#   http://commons.apache.org/math/api-1.2/org/apache/commons/math/complex/Complex.html

# or http://www.suitcaseofdreams.net/Complex_Analysis_Content.htm
