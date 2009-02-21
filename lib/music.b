# chord(int n, real p[])

dur(num d)
	_dur = d

vol(num v)
	_vol = v

freq(num f)
	_freq = f

relfreq(num rf)
	_rf = rf
	_freq = relfreq2freq(rf)
	_p = relfreq2pitch(rf)

pitch(num p)
	_p = p
	_rf = pitch2relfreq(_p)
	_freq = relfreq2freq(_rf)

def note(p)
	harmony(p)
	note()
	# TODO convert vol (loudness) to amp?  how?  logarithmic, or squared?

def Note(p)
	pitch(p)
	note()
	# TODO convert vol (loudness) to amp?  how?  logarithmic, or squared?

def NOTE(rf)
	relfreq(rf)
	note()

note()
	new(buf, sound, _dur * sound_rate)
	wavegen(buf)
	play(buf)
	dsp_sync()

envelope(num attack, num release)
	_attack = attack
	_release = release
vibrato(num power, num freq)
	# note: power's base is 1 - that means no vibrato
	# a power of 2 means from /2 to *2 volume, etc
	assert(power >= 1, "vibrato power must be >= 1")
	vibrato_power = power
	vibrato_freq = freq
tremolo(num dpitch, num freq)
	tremolof(pitch2relfreq(dpitch), freq)
tremolof(num power, num freq)
	# note: power's base is 1 - that means no tremolo
	# a tremolo of 2 will bend an octave either way!!!
	tremolo_power = power
	tremolo_freq = freq

def wavegen(s)
	wavegen(sound_get_start(s), sound_get_end(s))

wavegen(float *from, float *to)
	num vol_factor = pow(ref_freq / _freq, 0) # this may not be quite right, seems ok

	num dur = _dur
	num peak = _vol * vol_factor
	num attack = _attack
	num release = _release
	num sustain = _dur - (attack + release)

#	warn("%f", peak)

	if sustain < 0
		num factor = dur / (attack + release)
		attack *= factor
		release *= factor
		peak *= factor
		sustain = 0

	size_t attack_c = attack * sound_rate
	size_t sustain_c = sustain * sound_rate
	size_t release_c = release * sound_rate

	num attack_dvol = peak / attack_c
	num sustain_dvol = 0
	num release_dvol = -peak / release_c
	
	float t = 0.0
	num evol = 0
	for(v, from, to)
		num vol
		if vibrato_power > 1
			vol = pow(vibrato_power, sin(2*pi*t*vibrato_freq)) * evol
		else
			vol = evol
		num freq
		if tremolo_power > 1
			freq = pow(tremolo_power, sin(2*pi*t*tremolo_freq)) * _freq
		else
			freq = _freq
		*v += vol*(*wave)(t*freq)

		if attack_c
			--attack_c
			evol += attack_dvol
		eif sustain_c
			--sustain_c
			evol += sustain_dvol
		eif release_c
			--release_c
			evol += release_dvol
		t += sound_dt

typedef num (*wave_f)(num t)

wave_f wave = puretone

num puretone(num t)
	return sin(2*pi*t)

num sawtooth(num t)
	return rmod(t, 1)*2-1

# todo envelope as a (coro) generator? or as object method?

chordf(int n, num f[])
	new(buf, sound, _dur * sound_rate)
	for(i, 0, n)
		freq(f[i])
		wavegen(buf)
	play(buf)
	dsp_sync()

rfChord(int n, num relfreq[])
	num freq[n]
	for(i, 0, n)
		freq[i] = relfreq2freq(relfreq[i])
	chordf(n, freq)

chord(int n, num pitch[])
	num relfreq[n]
	for(i, 0, n)
		relfreq[i] = pitch2relfreq(pitch[i])
	rfChord(n, relfreq)

chord2f(num a0, num a1)
	num a[2] = { a0, a1 }
	chordf(2, a)
rfChord2(num a0, num a1)
	num a[2] = { a0, a1 }
	rfChord(2, a)
chord2(num a0, num a1)
	num a[2] = { a0, a1 }
	chord(2, a)
chord3f(num a0, num a1, num a2)
	num a[3] = { a0, a1, a2 }
	chordf(3, a)
rfChord3(num a0, num a1, num a2)
	num a[3] = { a0, a1, a2 }
	rfChord(3, a)
chord3(num a0, num a1, num a2)
	num a[3] = { a0, a1, a2 }
	chord(3, a)
chord4f(num a0, num a1, num a2, num a3)
	num a[4] = { a0, a1, a2, a3 }
	chordf(4, a)
rfChord4(num a0, num a1, num a2, num a3)
	num a[4] = { a0, a1, a2, a3 }
	rfChord(4, a)
chord4(num a0, num a1, num a2, num a3)
	num a[4] = { a0, a1, a2, a3 }
	chord(4, a)

# old, but gold?
note_1_in_bits(num freq)
	int buf_dur = imin(1, _dur)
	# 1 second
	int rate = sound_rate
	int whole_size = _dur * rate
	int buf_size = buf_dur * rate
	
	new(buf, sound, buf_size)

	float t = 0.0

	while whole_size > 0
		int size = imin(buf_size, whole_size)
		sound_set_size(buf, size)
		#for(v, sound_range(buf))
		for(v, sound_get_start(buf), sound_get_end(buf))
			*v = _vol*sin(2*pi*t*freq)
			t += sound_dt

		play(buf)

		whole_size -= size
	
	dsp_sync()

num ref_freq = 440.0
num key_freq = 440.0

num _vol = 0.5
num _dur = 0.25
num _freq = 440
num _rf = 1
num _p = 0
num _attack = 0.05
num _release = 0.1
num vibrato_power = 1
num vibrato_freq = 4
num tremolo_power = 1
num tremolo_freq = 4

key_note_freq(num freq)
	key_freq = freq

key_note(num pitch)
	key_freq = ref_freq
	key_freq = pitch2freq(pitch)

num pitch2freq(num pitch)
	return relfreq2freq(pitch2relfreq(pitch))

num freq2pitch(num freq)
	return relfreq2pitch(freq2relfreq(freq))

num pitch2relfreq(num pitch)
	return pow(2, pitch/12)

num relfreq2pitch(num freq)
	return 12 * log(freq) / log(2)

num relfreq2freq(num relfreq)
	return relfreq * key_freq

num freq2relfreq(num relfreq)
	return relfreq / key_freq

harmony(int p)
	relfreq(harmony2relfreq(p))

num _harmony[12] =
	3.0/4, 4.0/5, 5.0/6, 8.0/9, 15.0/16,
	1, 16.0/15, 9.0/8, 6.0/5, 5.0/4, 4.0/3,
	45.0/32 # this is the rising 6
	#1.41421356237309504880, # sqrt(2) ?? or could use 45/32 rising to 3/2, or 32/45 falling to 2/3

num harmony2relfreq(int p)
	int octave, degree
	divmod_range(p, -5, 7, &octave, &degree)
	return pow(2, octave) * _harmony[degree + 5]

num harmony2freq(int p)
	return harmony2relfreq(p) * key_freq

use sound
use key
use io
use error
use m
