#!/lang/b
use b

num margins = 40
int font_ref = 200

int page = 0

Main()
	gr_auto_event_loop = 0
	space()
	gr_fast()
	gprint_anchor(0, 0)
	new(lines, vec, cstr, 16)
	F_in("slides.txt")
		eachline(l)
			if *l == ''
				show_slide(lines)
				vecclr(lines)
			 else
				vec_push(lines, Strdup(l))

show_slide(vec *lines)
	int n = veclen(lines)
	font("helvetica-medium", font_ref)
	num height = font_height()
	num max_width = 0
	for_vec(l, lines, cstr)
		max_width = nmax(max_width, text_width(*l))
	num x_scale = (w - margins) / max_width
	num y_scale = (h - margins) / (height * n)
	num scale = nmin(x_scale, y_scale)
	int font_size = font_ref * scale

	font("helvetica-medium", font_size)

	height *= scale
	
	int y = height * n / 2
	clear()
	white()
	for_vec(l, lines, cstr)
		move(0, y)
		gsayf(*l)
		y -= height
	paint()
	Readline()
	effect()
	++page

effect()
	if depth > 16
		effect(long)
	 eif depth == 16
		effect(short)
	 eif depth == 8
	 	effect(char)

def effect(pixel_type)
	which page % 2
	0	for int i=0; i < 60; ++i
			pixel_type *px = (pixel_type *)pixel(vid, 0, 0)
			long x, y
			for y=-h_2; y<h_2; ++y
				for x=-w_2; x<w_2; ++x
					if toss() && x>-w_2 && x<w_2-1 && y>-h_2+1 && y<h_2-1
						*px = px[toss()*2-1 + toss()*3*w-2*w]
						if *px
							*px -= 0x0202
					++px
			Paint()
	1	black()
		for int i=0; i < 8000; ++i
			circle(Randi(-w_2, w_2), Randi(-h_2, h_2), Randi(h_2))
			if i % 10 == 0
				paint()
			if i % 100 == 0
				hsv(i/8000.0 * 360 * 2, Sin(180*i/8000.0)/3, 0)

def trig_unit deg

def toss() random() > RAND_MAX/2
