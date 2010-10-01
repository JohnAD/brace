export complex.h
use m

typedef double complex cmplx

# complex number extensions

def cabs2(w) creal(w*(creal(w)-cimag(w)*I))

cmplx cis(num ang)
	return cos(ang)+sin(ang)*I

# TODO use intersection of C and C++ complex numbers, check
# the web / bookmarked with dsp stuff for how...

# once using that, move this back to m.h

# public domain code for computing the FFT
# contributed by Christopher Diggins, 2005
# adapted and converted from C++ to brace by Sam Watkins

fft(cmplx *in, cmplx *out, int log2_n)
	int n = 1 << log2_n
	for(i, 0, n)
		out[bit_reverse(i)] = in[i]
	for(s, 1, log2_n+1)
		int m = 1 << s
		cmplx w = 1
		cmplx wm = cis(2*pi/m)
		for(j, 0, m/2)
			for(k, j, n, m)
				cmplx t = w * out[k + m/2]
				cmplx u = out[k]
				out[k] = u + t
				out[k + m/2] = u - t
			w = w * wm
