# linux OSS "/dev/dsp" audio driver
# 44100 Hz 16 bit mono native byte order

# FIXME use "local" vars

int dsp_rate = 44100
int bits_per_sample = 16
int channels = 1
num dsp_buf_initial_duration = 1
int bytes_per_sample = 2
# bits_per_sample/8*channels

char *dsp_outfile = "/dev/dsp"
int use_dsp = 1

int dsp_fd

def play(s) dsp_play_sound(s)
dsp_play_sound(sound *s)
	sample *i = sound_get_start(s)
	sample *e = sound_get_end(s)
	size_t buf_size = dsp_buffer_get_size(dsp_buf)
	short *buf0 = dsp_buffer_get_start(dsp_buf)
	while i < e
		size_t count = imin(e-i, buf_size)
		fit(i, i+count)
		dsp_encode(i, i+count, buf0)
		dsp_play((char *)buf0, (char *)(buf0 + count))
		i += count

# decl(dsp_buf, dsp_buffer)
# this don't work because brace_header does not run brace_macro over things
# that look like functions

dsp_buffer struct__dsp_buf
dsp_buffer *dsp_buf = &struct__dsp_buf

dsp_init()
	# for "play"
	dsp_buffer_init(dsp_buf, dsp_rate * dsp_buf_initial_duration)

	dsp_fd = Open(dsp_outfile, O_WRONLY|O_CREAT|O_APPEND)
	
	if use_dsp
		int arg
		int status
		arg = bits_per_sample
		status = ioctl(dsp_fd, SOUND_PCM_WRITE_BITS, &arg)
		if status == -1
			error("SOUND_PCM_WRITE_BITS ioctl failed")
		if (arg != bits_per_sample)
			error("unable to set sample size")
		
		arg = channels
		status = ioctl(dsp_fd, SOUND_PCM_WRITE_CHANNELS, &arg)
		if (status == -1)
			error("SOUND_PCM_WRITE_CHANNELS ioctl failed")
		if (arg != channels)
			error("unable to set number of channels")
		
		arg = dsp_rate
		status = ioctl(dsp_fd, SOUND_PCM_WRITE_RATE, &arg)
		if (status == -1)
			error("SOUND_PCM_WRITE_RATE ioctl failed")
		if arg != dsp_rate
			warn("using sample rate %d instead of %d\n", arg, dsp_rate)
			dsp_rate = arg

	sound_set_rate(dsp_rate)

dsp_play(char *b0, char *b1)
	size_t size = b1 - b0
	Write(dsp_fd, b0, size)

dsp_sync()
	if use_dsp
		int status = ioctl(dsp_fd, SOUND_PCM_SYNC, 0)
		if (status == -1)
			error("SOUND_PCM_SYNC ioctl failed")

typedef vec dsp_buffer

dsp_buffer_init(dsp_buffer *b, size_t size)
	vec_init_el_size(b, bytes_per_sample, size)
	dsp_buffer_set_size(b, size)
	dsp_buffer_clear(b)

dsp_buffer_print(dsp_buffer *b)
	buffer_dump(&b->b)

size_t dsp_sample_size()
	return bytes_per_sample

dsp_encode(sample *in0, sample *in1, short *out)
	assert(bits_per_sample == 16 && channels == 1 && bytes_per_sample == 2, "dsp_encode can only produce 16bit mono sound at the moment")
	assert(sizeof(short) == bytes_per_sample, "short type is not two bytes!! oh dear")
	
	# for the sake of symmetry, we don't use the -0x8000 value
	map(out, in, 0x7fff * *in)

# TODO dsp_decode

def dsp_buffer_clear(b)
	#for(i, dsp_buffer_range(b))
	for(i, dsp_buffer_get_start(b), dsp_buffer_get_end(b))
		*i = 0

def dsp_buffer_get_start(b) (short *)vec_get_start(b)
def dsp_buffer_get_end(b) (short *)vec_get_end(b)
def dsp_buffer_set_size vec_set_size
def dsp_buffer_get_size vec_get_size
Def dsp_buffer_range vec_range

export vec types
use util sound error m

use linux/soundcard.h

use unistd.h
use fcntl.h
use sys/types.h
use sys/ioctl.h
