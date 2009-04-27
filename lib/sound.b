use util m sound
export vec

typedef float sample
	# The float format has 23-bit mantissa,
	# and is able to hold a 24-bit int.
	# We can convert 24-bit audio to floats losslessly.

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

def fit(s0, s1)
	normalize(s0, s1, 1)

def normalize(s0, s1)
	normalize(s0, s1, 0)

normalize(sample *s0, sample *s1, boolean softer)
	range r = check_range(s0, s1)
	sample vol0 = fabs(r.min)
	sample vol1 = fabs(r.max)
	sample max = Max(vol0, vol1)
	if !softer || max > 1
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

struct sound_info
	int channels
	int sample_rate
	size_t n_samples
	int bits_per_sample


# TODO load_wav, read until EOF for wav with unknown length

sound_info load_wav(sound *s)
	sound_info info
	size_t header_size_1 = 36
	size_t header_size_2 = 8
	char headers[header_size_1 + header_size_2]
	if vs_read(headers, header_size_1) != header_size_1
		failed0("load_wav", "file too short")
	if strncmp(headers, "RIFF", 4) || strncmp(headers+8, "WAVEfmt ", 8)
		failed0("load_wav", "invalid / unknown wav format")

	size_t format_size = le4(headers + 16)
	if format_size < 0x10
		failed0("load_wav", "format_size too small")

	int compression_code = le2(headers + 20)
	if compression_code != 1
		failed0("load_wav", "compression not supported")
	size_t size = le4(headers+4) - 20 - format_size

	discard(format_size - 0x10)

	if vs_read(headers + header_size_1, header_size_2) != header_size_2
		failed0("load_wav", "file too short")

	if strncmp(headers + header_size_1, "data", 4)
		failed0("load_wav", "data chunk not found")

	if (size_t)le4(headers + header_size_1 + 4) != size
		failed0("load_wav", "file size mismatch")

	info.channels = le2(headers + 22)
	info.sample_rate = le4(headers + 24)
	int bytes_per_second = le4(headers + 28)
	use(bytes_per_second)
	int block_align = le2(headers + 32)
	info.bits_per_sample = le2(headers + 34)
	if info.bits_per_sample * channels != 8 * block_align
		failed0("load_wav", "bits_per_sample * channels != 8 * block_align")
	if size % block_align
		failed0("load_wav", "size is not a whole number of blocks")
	if info.bits_per_sample % 8
		failed0("load_wav", "bits_per_sample is not a multiple of 8")
	int bytes_per_sample = info.bits_per_sample / 8
	info.n_samples = size / bytes_per_sample

#	warn("bits_per_sample: %d", info.bits_per_sample)
#	warn("sample_rate: %d", info.sample_rate)
#	warn("block_align: %d", block_align)
#	warn("channels: %d", info.channels)
#	warn("size: %d", size)
#	warn("n_samples: %d", info.n_samples)

	# FIXME should read stereo into two buffers, not one

	int old_size = vec_get_size(s)
	vec_grow(s, info.n_samples)
	sample *o = vec_element(s, old_size)

	float divide = 1<<(info.bits_per_sample-1)
	float origin = bytes_per_sample == 1 ? divide : 0

	which bytes_per_sample
	1	read_samples(o, info.n_samples, 1, byte, divide, origin)
	2	read_samples(o, info.n_samples, 2, sle2, divide, origin)
	3	read_samples(o, info.n_samples, 3, sle3, divide, origin)
	4	read_samples(o, info.n_samples, 4, sle4, divide, origin)
	else	failed0("load_wav", "bytes_per_sample is not 1, 2, 3 or 4")

	return info

def read_samples(o, n, bytes_per_sample, sample_reader, divide, origin)
	read_samples(o, n, bytes_per_sample, sample_reader, divide, origin, my(chunk_size), my(chunk_samples), my(remain), my(to_read), my(to_read_bytes), my(in), my(end))

def read_samples(o, n, bytes_per_sample, sample_reader, divide, origin, chunk_size, chunk_samples, remain, to_read, to_read_bytes, in, end)
	.
		int chunk_size = block_size - block_size % bytes_per_sample
		int chunk_samples = chunk_size / bytes_per_sample
		int remain = n
		char buf[chunk_size]
		while remain
#			warn("remain: %d", remain)
			int to_read = imin(chunk_samples, remain)
			size_t to_read_bytes = to_read * bytes_per_sample
			if vs_read(buf, to_read_bytes) != to_read_bytes
				failed0("read_samples", "file too short")
			remain -= to_read
			char *in = buf
			char *end = buf + to_read_bytes
			while in < end
				*o++ = sample_reader(in) / divide - origin
				in += bytes_per_sample
#		if vs_read(buf, chunk_size) != 0
#			failed0("read_samples", "extra data at EOF")

