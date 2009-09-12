#!/lang/b
use b

num margins = 40
int font_ref = 200
num transition_delay = 3

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
	for_vec(l, lines, cstr)
		move(0, y)
		gsayf(*l)
		y -= height
	paint()
	Readline()
	int child = fork()
	if child == 0
		effect()
	Sleep(transition_delay)
	kill(child, SIGTERM)

effect()
	if depth > 16
		effect(long)
	 eif depth == 16
		effect(short)
	 eif depth == 8
	 	effect(char)

def effect(pixel_type)
	repeat
		bm_start()
		pixel_type *px = (pixel_type *)pixel(vid, 0, 0)
		long x, y, x2, y2, r2
		for y=-h_2; y<h_2; ++y
			y2 = y * y
			x2 = w_2 * w_2
			r2 = x2 + y2
			for x=-w_2; x<w_2; ++x
				if toss() && x>-w_2 && x<w_2-1 && y>-h_2+1 && y<h_2-1
					*px = px[toss()*2-1 + toss()*3*w-2*w]
					if *px
						*px -= 0x0202
#				*px = (*px + r2) & 0x030303
				++px
				r2 += 2*x + 1
#		csleep(1.0/30)
		Paint()
		bm_ps("painted")

def toss() random() > RAND_MAX/2
