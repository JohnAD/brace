#!/lang/b

Def S array_range(s)

int INT_NULL = 0x80 << (sizeof(int)-1)*8

boolean mean = 0
boolean set_key = 0

char symbol[12] = "({[</o\\>]})x"

int p
int getnote()
	# keys:
	# y, h, 6 are tonic
	cstr notekeys = "asdfghjkl;'\tqwertyuiop[`1234567890-=\x7f";

	repeat
		repeat
			_harmony[11] = 45.0/32
			let(c, key())
			char *x = strchr(notekeys, c)
			if x != NULL
				p = x - notekeys - 12 - 5
				break
			 eif c == ']'
				_harmony[11] = 64.0/45
				p = 6
				break
			 eif c == '\r'
				_harmony[11] = 64.0/45
				p = -6
				break
			 eif c == 27
				return INT_NULL
			 eif c == 'z'
				mean = 0
			 eif c == 'x'
				mean = 1
			 eif c == '.'
				kn += 12
				key_note(kn)
			 eif c == ','
				kn -= 12
				key_note(kn)
			 eif c == 'n'
				kn += p
				key_note(kn)
			 eif c == '/'
				kn += 7
				key_note(kn)
			 eif c == 'm'
				kn -= 7
				key_note(kn)
			 eif c == ' '
				set_key = 1
			 eif c == 'b'
				kn = 0
				key_note(kn)
			 else
				warn("unbound key pressed, ASCII %d", c)

		if set_key
			kn += p
			key_note(kn)
			set_key = 0
		 else
			break

	return p

int kn = 0

Main()
#	harmony_init()
	dsp_init()
	key_init()
	key_note(kn)
#	scales()
#return 0

	envelope(0.05, 0.1)
	dur(0.2)
#	wave = violin
	wave = oboe
#	vibrato(1.2, 10)
#	tremolo(0.25, 10)
# need to preserve phase; use a 2d rot matrix & normalize? l8r!

#	scales()

	repeat
		int n = getnote()
		if n == INT_NULL
			break

		dur(0.1)
		vol(1)
		if mean
			Note(n)
		 else
			note(n)
		int octave, degree
		divmod_range(n, -5, 7, &octave, &degree)

		Sayf("%c %s%d%s%d %f %f %f", symbol[degree+5], sign(octave), octave, sign(degree), degree, _p, _rf, _freq)

	key_final()

cstr sign(num r)
	if r == 0
		return "."
	 eif r > 0
		return "+"
	 else
		return ""

scales()
	dur(0.2)
	play_major_scale_equal()
#	play_major_scale_harmonic()
	play_minor_scale_equal()
#	play_minor_scale_harmonic()
	play_chromatic_scale_equal()
#	play_chromatic_scale_harmonic()
	dur(2)
	chord3(0, 4, 7)
	chord3(0, 3, 7)

play_major_scale_equal()
	note(0)
	note(2)
	note(4)
	note(5)
	note(7)
	note(9)
	note(11)
	note(12)

play_minor_scale_equal()
	note(0)
	note(2)
	note(3)
	note(5)
	note(7)
	note(8)
	note(10)
	note(12)

# TODO make a chord macro which can be invoked:
#Chord({t, rta, fa})

# TODO better symbols for the notes

play_chromatic_scale_equal()
	for(i, 0, 13)
		note(i)

num oboe(num t)
#	return (puretone(t) + puretone(t*7)/2
	return (puretone(t) + puretone(t*2) + puretone(t*3) + puretone(t*4) + puretone(t*5) + puretone(t*6) + puretone(t*7))/7

num violin(num t)
	return (puretone(t)*2 + sawtooth(t))/3

num puretone(num t)
	return sin(2*pi*t)

num sawtooth(num t)
	return rmod(t, 1)*2-1

use b
