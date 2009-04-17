typedef float sample

typedef vec sound
# of samples

struct range
	sample min, max

range check_range(sample *s0, sample *s1)
	range r
	r.min = 1e100
	r.max = -1e100
	for(s)
		if *s < r.min
			r.min = *s
		if *s > r.max
			r.max = *s
	return r

boolean range_ok(sample *s0, sample *s1)
	range r = check_range(s0, s1)
	return r.min >= -1 && r.max <= 1

sound_print(sample *s0, sample *s1)
	natatime(s, 2, Nl())
		printf("%.2f ", *s)
	nl() ; nl()

fit(sample *s0, sample *s1)
	range r = check_range(s0, s1)
	sample vol0 = fabs(r.min)
	sample vol1 = fabs(r.max)
	sample max = Max(vol0, vol1)
	if max > 1
		amplify(s0, s1, 1.0/max)
		clip(s0, s1)

amplify(sample *s0, sample *s1, num factor)
	for(s)
		*s *= factor

clip(sample *s0, sample *s1)
	for(s)
		if *s < -1
			*s = -1
		eif *s > 1
			*s = 1

# TODO a proper "normalize" function - would need to consider "strays" when
# dealing with real audio data, i.e. partly clip then amplify.  for synth data
# doesn't matter

sound_init(sound *s, size_t size)
	vec_init(s, sample, size)
	vec_set_size(s, size)
	sound_clear(s)

sound_clear(sound *s)
	# FIXME this don't work because brace_macro doesn't eval macros inside args first
	#for(i, (sample *)vec_range(s))
	for(i, sound_get_start(s), sound_get_end(s))
		*i = 0

mix_range(sample *up, sample *a0, sample *a1)
	while a0 != a1
		*up += *a0
		++up ; ++a0

sound_same_size(sound *s1, sound *s2)
	sound_grow(s1, sound_get_size(s2))
	sound_grow(s2, sound_get_size(s1))

sound_grow(sound *s, size_t size)
	let(old_size, sound_get_size(s))
	if old_size < size
		sound_set_size(s, size)
		for(i, sound_get_start(s)+old_size, sound_get_end(s))
			*i = 0

mix(sound *up, sound *add)
	sound_grow(up, sound_get_size(add))
	mix_range(sound_get_start(up), sound_range(add))

mix_to_new(sample *out, sample *a0, sample *a1, sample *b0, sample *b1)
	while a0 != a1 && b0 != b1
		*out = *a0 + *b0
		++out
		++a0 ; ++b0
	if b0 == b1
		swap(a0, b0)
		swap(a1, b1)
	while a0 != a1
		*out = *a0
		++out
		++a0

int sound_rate = 0
num sound_dt = 0

sound_set_rate(int r)
	sound_rate = r
	sound_dt = 1.0 / sound_rate

def sound_get_start(s) (sample *)vec_get_start(s)
def sound_get_end(s) (sample *)vec_get_end(s)
def sound_set_size vec_set_size
def sound_get_size vec_get_size
Def sound_range(s) sound_get_start(s), sound_get_end(s)

use util
use m
use sound
export vec
