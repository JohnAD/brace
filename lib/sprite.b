# TODO make these xpm compatible!

ldef debug void

typedef unsigned long pix_t

def pix_r(p) p>>16 & 0xFF
def pix_g(p) p>>8 & 0xFF
def pix_b(p) p & 0xFF
def pix_a(p) p>>24 & 0xFF

def pix_rgb(r, g, b) r<<16 | g<<8 | b
def pix_rgb_safe(r, g, b) (r&0xFF)<<16 | (g&0xFF)<<8 | (b&0xFF)

def pix_rgba(r, g, b, a) a<<24 | r<<16 | g<<8 | b
def pix_rgba_safe(r, g, b) (a&0xFF)<<24 | (r&0xFF)<<16 | (g&0xFF)<<8 | (b&0xFF)

def pixn_r(p) pix_r(p) / 256.0
def pixn_g(p) pix_g(p) / 256.0
def pixn_b(p) pix_b(p) / 256.0
def pixn_a(p) pix_a(p) / 256.0

def pixn_rgb(r, g, b) pix_rgb((int)(r*256), (int)(g*256), (int)(b*256))
def pixn_rgb_safe(r, g, b) pix_rgb(iclamp((int)(r*256), 0, 255), iclamp((int)(g*256), 0, 255), iclamp((int)(b*256), 0, 255))

def pixn_rgba(r, g, b, a) pix_rgb(r*256, g*256, b*256, a*256)
def pixn_rgba_safe(r, g, b, a) pix_rgb(iclamp((int)(r*256), 0, 255), iclamp((int)(g*256), 0, 255), iclamp((int)(b*256), 0, 255), iclamp((int)(a*256), 0, 255))


struct sprite
	pix_t *pixels
	long width
	long height
	long stride

sprite_init(sprite *s, long width, long height)
	s->pixels = Nalloc(pix_t, width*height)
	s->width = width
	s->height = height
	s->stride = width

def sprite_clear(s)
	sprite_clear(s, 0)

sprite_clear(sprite *s, pix_t c)
	pix_t *p = s->pixels
	for long y=0; y<s->height; ++y
		for long x=0; x<s->width; ++x
			*p++ = c
		p += s->stride - s->width

sprite_screen(sprite *s)
	s->width = w
	s->height = h
	s->stride = w
	s->pixels = (pix_t *)pixel(vid, 0, 0)

sprite_clip(sprite *target, sprite *source, sprite *target_full, sprite *source_full, long x, long y)
	*source = *source_full

	sprite_clip_1(x, width, 1)
	sprite_clip_1(y, height, source->stride)

	target->stride = target_full->stride
	target->pixels = target_full->pixels + y*target->stride + x
	target->width = source->width
	target->height = source->height

def sprite_clip_1(x, width, step)
	if x < 0
		source->width += x
		source->pixels -= x * step
		if source->width < 0
			source->width = 0
		x = 0
	long my(x_over) = x + source->width - target_full->width
	if my(x_over) > 0
		source->width -= my(x_over)
		if source->width < 0
			source->width = 0

sprite_blit(sprite *to, sprite *from)
	pix_t *i = from->pixels
	pix_t *o = to->pixels
	long w = imin(from->width, to->width)
	long h = imin(from->height, to->height)
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			*o++ = *i++
		i += from->stride - w
		o += to->stride - w

sprite_blit_transl(sprite *to, sprite *from)
	pix_t *i = from->pixels
	pix_t *o = to->pixels
	long w = imin(from->width, to->width)
	long h = imin(from->height, to->height)
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			pix_t c = *i++
			int a = pix_a(c)
			if a == 0
				*o = c
			 eif a < 255
				pix_t old = *o
				int a1 = 255 - a
				int r = (pix_r(c) * a1 + pix_r(old) * a) / 255
				int g = (pix_g(c) * a1 + pix_g(old) * a) / 255
				int b = (pix_b(c) * a1 + pix_b(old) * a) / 255
				*o = pix_rgb(r, g, b)
			++o
		i += from->stride - w
		o += to->stride - w

sprite_blit_transp(sprite *to, sprite *from)
	pix_t *i = from->pixels
	pix_t *o = to->pixels
	long w = imin(from->width, to->width)
	long h = imin(from->height, to->height)
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			pix_t c = *i++
			int a = pix_a(c)
			if a != 255
				*o = c
			++o
		i += from->stride - w
		o += to->stride - w

def sprite_put(to, from, x, y)
	sprite_put_x(, to, from, x, y)
def sprite_put_transp(to, from, x, y)
	sprite_put_x(_transp, to, from, x, y)
def sprite_put_transl(to, from, x, y)
	sprite_put_x(_transl, to, from, x, y)
def sprite_put_x(plottype, to, from, x, y)
	sprite_put_x(plottype, to, from, x, y, my(source), my(target))
def sprite_put_x(plottype, to, from, x, y, source, target)
	decl(source, sprite)
	decl(target, sprite)
	sprite_clip(target, source, to, from, x, y)
	sprite_blit^^plottype(target, source)
	gr__change_hook()

sprite_gradient(sprite *s, colour c00, colour c10, colour c01, colour c11)
	sprite_gradient_angle(s, c00, c10, c01, c11, 0)

sprite_gradient_angle(sprite *s, colour c00, colour c10, colour c01, colour c11, num angle)
	pix_t *p = s->pixels
	long w = s->width
	long h = s->height
	num r0 = pixn_r(c00), g0 = pixn_g(c00), b0 = pixn_b(c00)
	num r1 = pixn_r(c10), g1 = pixn_g(c10), b1 = pixn_b(c10)
	num r01 = pixn_r(c01), g01 = pixn_g(c01), b01 = pixn_b(c01)
	num r11 = pixn_r(c11), g11 = pixn_g(c11), b11 = pixn_b(c11)

	if angle != 0
		num s = sin(angle), c = cos(angle)
		num r0a = grad_value((s-c+1)/2, (-c-s+1)/2, r0, r1, r01, r11)
		num r1a = grad_value((s+c+1)/2, (-c+s+1)/2, r0, r1, r01, r11)
		num r01a = grad_value((-s-c+1)/2, (c-s+1)/2, r0, r1, r01, r11)
		num r11a = grad_value((-s+c+1)/2, (c+s+1)/2, r0, r1, r01, r11)
		r0 = r0a ; r1 = r1a ; r01 = r01a ; r11 = r11a
		num g0a = grad_value((s-c+1)/2, (-c-s+1)/2, g0, g1, g01, g11)
		num g1a = grad_value((s+c+1)/2, (-c+s+1)/2, g0, g1, g01, g11)
		num g01a = grad_value((-s-c+1)/2, (c-s+1)/2, g0, g1, g01, g11)
		num g11a = grad_value((-s+c+1)/2, (c+s+1)/2, g0, g1, g01, g11)
		g0 = g0a ; g1 = g1a ; g01 = g01a ; g11 = g11a
		num b0a = grad_value((s-c+1)/2, (-c-s+1)/2, b0, b1, b01, b11)
		num b1a = grad_value((s+c+1)/2, (-c+s+1)/2, b0, b1, b01, b11)
		num b01a = grad_value((-s-c+1)/2, (c-s+1)/2, b0, b1, b01, b11)
		num b11a = grad_value((-s+c+1)/2, (c+s+1)/2, b0, b1, b01, b11)
		b0 = b0a ; b1 = b1a ; b01 = b01a ; b11 = b11a

	num dr0 = (r01 - r0) / h, dg0 = (g01 - g0) / h, db0 = (b01 - b0) / h
	num dr1 = (r11 - r1) / h, dg1 = (g11 - g1) / h, db1 = (b11 - b1) / h
	for long y=0; y<h; ++y
		num r = r0, g = g0, b = b0
		num dr = (r1 - r0) / w, dg = (g1 - g0) / w, db = (b1 - b0) / w
		for long x=0; x<w; ++x
			pix_t c = pixn_rgb_safe(r, g, b)
			*p++ = c
			r += dr ; g += dg ; b += db
		p += s->stride - w
		r0 += dr0 ; g0 += dg0 ; b0 += db0
		r1 += dr1 ; g1 += dg1 ; b1 += db1

num grad_value(num x, num y, num v00, num v10, num v01, num v11)
	num v0 = v00 + (v01 - v00) * y
	num v1 = v10 + (v11 - v10) * y
	num v = v0 + (v1 - v0) * x
	return v

sprite_translucent(sprite *s, num a)
	pix_t *p = s->pixels
	long w = s->width
	long h = s->height
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			pix_t c = *p
			int a_old = 255 - pix_a(c)
			int A = (int)(255 - a_old * a) << 24
			c &= ~0xFF000000
			c |= A
			*p++ = c
		p += s->stride - w

sprite_circle(sprite *s)
	pix_t *p = s->pixels
	long w = s->width
	long h = s->height
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			num X = (x*2.0 / w) - 1
			num Y = (y*2.0 / h) - 1
			num R2 = X*X + Y*Y
			if R2 > 1
				*p |= 0xFF000000
			++p
		p += s->stride - w

sprite_circle_aa(sprite *s)
	# this will not be right for non-circular ovals I think
	pix_t *p = s->pixels
	long w = s->width
	long h = s->height
	num u = 4.0/(w+h)
#	num u = 2.0/w
	for long y=0; y<h; ++y
		for long x=0; x<w; ++x
			num X = (x*2.0 / w) - 1
			num Y = (y*2.0 / h) - 1
			num R = hypot(X, Y)
			if R > 1+u/2
				*p |= 0xFF000000
			 eif R > 1-u/2
				num f = (R - (1-u/2)) / u
				*p |= iclamp(255*f, 0, 255) << 24
			++p
		p += s->stride - w

def sprite_load_png(filename) sprite_load_png(filename, Talloc(sprite))

sprite *sprite_load_png(cstr filename, sprite *s)
	fopen_close(fp, filename)
		sprite_load_png_stream(fp, s)
	return s

def sprite_load_png_stream(in) sprite_load_png_stream(in, Talloc(sprite))

sprite *sprite_load_png_stream(FILE *in, sprite *s)
#	unsigned char header[8]
#	Fread_all(header, 1, 8, in)
#	if png_sig_cmp(header, 0, 8)
#		error("sprite_load_png: not a png image")

	png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, (png_voidp)NULL, NULL, NULL)
	if !png_ptr
		failed("png_create_read_struct")

	png_infop info_ptr = png_create_info_struct(png_ptr)
	if !info_ptr
		png_destroy_read_struct(&png_ptr, (png_infopp)NULL, (png_infopp)NULL)
		failed("png_create_info_struct")

	png_infop end_info = png_create_info_struct(png_ptr)
	if !end_info
		png_destroy_read_struct(&png_ptr, &info_ptr, (png_infopp)NULL)
		failed("png_create_info_struct")

	if setjmp(png_jmpbuf(png_ptr))
		png_destroy_read_struct(&png_ptr, &info_ptr, &end_info)
		error("sprite_load_png: failed")

	png_init_io(png_ptr, in)
#	png_set_sig_bytes(png_ptr, 8)

#	png_read_png(png_ptr, info_ptr, 0, NULL)
	png_read_info(png_ptr, info_ptr)
	png_uint_32 width, height
	int bit_depth, color_type, interlace_type, compression_type, filter_type
	png_get_IHDR(png_ptr, info_ptr, &width, &height, &bit_depth, &color_type, &interlace_type, &compression_type, &filter_type)

	if color_type == PNG_COLOR_TYPE_PALETTE
		debug("png_set_palette_to_rgb")
		png_set_palette_to_rgb(png_ptr)
	if color_type == PNG_COLOR_TYPE_GRAY && bit_depth < 8
		debug("png_set_expand_gray_1_2_4_to_8")
		png_set_expand_gray_1_2_4_to_8(png_ptr)
	if png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS)
		debug("png_set_tRNS_to_alpha")
		png_set_tRNS_to_alpha(png_ptr)
	if bit_depth == 16
		debug("png_set_strip_16")
		png_set_strip_16(png_ptr)
	png_set_invert_alpha(png_ptr)
	if among(color_type, PNG_COLOR_TYPE_RGB, PNG_COLOR_TYPE_GRAY, PNG_COLOR_TYPE_PALETTE)
		debug("png_set_add_alpha")
		png_set_add_alpha(png_ptr, 0x0, PNG_FILLER_AFTER)
#	if among(color_type, PNG_COLOR_TYPE_RGB_ALPHA, PNG_COLOR_TYPE_GRAY_ALPHA)
#		debug("png_set_swap_alpha")
#		png_set_swap_alpha(png_ptr)
	if among(color_type, PNG_COLOR_TYPE_GRAY, PNG_COLOR_TYPE_GRAY_ALPHA)
		debug("png_set_gray_to_rgb")
		png_set_gray_to_rgb(png_ptr)
	if among(color_type, PNG_COLOR_TYPE_RGB, PNG_COLOR_TYPE_RGB_ALPHA, PNG_COLOR_TYPE_PALETTE)
		png_set_bgr(png_ptr)

#	# gamma
#	cstr gamma_str
#	double gamma, screen_gamma
#
#	if (gamma_str = getenv("SCREEN_GAMMA")) != NULL
#		screen_gamma = atof(gamma_str)
#	else
#		screen_gamma = 2.2  # A good guess for a PC monitor in a bright office or a dim room
#		# screen_gamma = 2.0  # A good guess for a PC monitor in a dark room
#		# screen_gamma = 1.7 or 1.0  # A good guess for Mac systems
#
#	if png_get_gAMA(png_ptr, info_ptr, &gamma)
#		png_set_gamma(png_ptr, screen_gamma, gamma)
#	else
#		png_set_gamma(png_ptr, screen_gamma, 1/2.2)
##		png_set_gamma(png_ptr, screen_gamma, 0.45455)

	if interlace_type == PNG_INTERLACE_ADAM7
		debug("png_set_interlace_handling")
		int number_of_passes = png_set_interlace_handling(png_ptr)
		use(number_of_passes)

	png_read_update_info(png_ptr, info_ptr)

	png_uint_32 rowbytes = png_get_rowbytes(png_ptr, info_ptr)
	
	if rowbytes != width * 4
		error("sprite_load_png: rowbytes != width * 4 ; %ld != %ld", (long)rowbytes, (long)width*4)

	init(s, sprite, width, height)
	png_bytep row_pointers[height]
	for long y=0; y<(long)height; ++y
		row_pointers[y] = (png_bytep)(s->pixels + y * width)
	
	png_read_image(png_ptr, row_pointers)
	png_read_end(png_ptr, end_info)
	png_destroy_read_struct(&png_ptr, &info_ptr, &end_info)
	
	return s

# TODO jpeg
# TODO sprite_put_behind ...

use png.h
export types
use m gr
