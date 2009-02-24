#!/lang/b

# TODO make the blending look good when viewed from an angle
# TODO fix the planet positions to be real at some base time!

def system_in 40
def system_out 185
def stars_start 190
def balance 1.25
def n_planets 9
def earth_dist 70

def secs_in_day 3600 * 24

def array_last(a) array_end(a)-1

colour rb[360]

rb_init()
	for(i, 0, 360)
		rb[i] = rainbow(i)

def rb(a) col(rb[mod((int)(a+0.5), 360)])

# 1956.10.28 9.0.0  -  +42.30.17 +10.7.3

struct time_place
	datetime time
	place place

num planet_a[n_planets]
num planet_r[] = { 3, 4, 5, 4, 8, 7, 6, 6, 3 }

num earth_orbit = 365.26 * secs_in_day
num planet_period[] = { 0.241, 0.615, 1.0, 1.88, 11.86, 29.46, 84, 164.8, 247.7 }
num planet_dist[] = { 0.387, 0.723, 1.0, 1.524, 5.203, 9.539, 19.18, 30.06, 39.53 }

num yscale

boolean anim = 1

num basea

Main()
	decl(birth, time_place)
	ref(birth_t, birth->time)
	ref(birth_p, birth->place)

	cstr person_name = toss() ? "Joe Bloggs" : "Jane Doe"

	switch args
	1	person_name = arg[0]
	0	datetime_init(birth_t, Randint(1970, 2006), Randint(1, 13), Randint(1, 28),  Randint(24), Randint(60), Randint(60))
		place_init(birth_p, Randint(-90, 90), Randint(60), Randint(60),  Randint(-180, 180), Randint(60), Randint(60))
		break
		#datetime_init(birth_t, 1976,9,1, 0,0,0)
		#place_init(birth_p, +42,30,17, 10,7,3)
		# datetime_init(&b.t, 1956,10,28, 9,0,0)
		# TODO localtime?? gmtime?? timezone??
	13	person_name = arg[0]
		++arg
	12	datetime_init(birth_t, atoi(arg[0]), atoi(arg[1]), atoi(arg[2]), atoi(arg[3]), atoi(arg[4]), atoi(arg[5]))
		place_init(birth_p, atoi(arg[6]), atoi(arg[7]), atoi(arg[8]), atoi(arg[9]), atoi(arg[10]), atoi(arg[11]))
		break
	else	usage("[name] year month day  hour min sec    ns min sec  ew min sec")

	#paper(1280, 800, spaceblue)
#	paper(640, 800, spaceblue = rgb(0, 0, 0.05))
	paper(640, 480, spaceblue = rgb(0, 0, 0.05))
	#paper(1280, 800, rgb(0, 0, 0))
	gr_fast()
	rb_init()
	grey_init()
	key_init()

	font("-adobe-helvetica-medium-r-normal--11-80-100-100-p-56-iso8859-1")
#	font("-adobe-helvetica-medium-r-normal--34-*-100-100-p-*-iso8859-1")

	num t = Mktime(birth_t)
	 # FIXME rewrite Mktime to handle older dates than 1970

	num ns = birth_p->ns + birth_p->ns_min/60.0 + birth_p->ns_sec/3600.0
	num ew = birth_p->ew + birth_p->ew_min/60.0 + birth_p->ew_sec/3600.0
	ew = ew

	yscale = Cos(ns)
#	yscale = 0.5

#	Sayf("%f %f %f", t, ns, ew)

#	coln("darkgrey")
#	Disc(22, 22, 6)

	int n_stars=500
	int star_x[n_stars], star_y[n_stars]
	colour star_c[n_stars]

	for(c, 0, n_stars)
		star(c)

	seed(0)
	let(last_dist, planet_dist[n_planets-1])
	eachplanet(i)
		planet_period[i] *= earth_orbit
#		planet_dist[i] *= system_out / last_dist
		planet_dist[i] = log(planet_dist[i])/log(last_dist) * (system_out-earth_dist) + earth_dist
		planet_a[i] = Rand(360)
#		Sayf("%f %f", planet_period[i], planet_dist[i])
		 # set up initial (1970) posn of planets - FIXME random for now!
	seed()

#	real dt = 10

#	real bend = 20.0

#	real z = 1
	zoom(1)

	repeat
#		let(phase, 0)
		for(phase, 0, 360)
# the following moves so that the sun would be up at noon, etc (assumes time given is localtime, ignores ns/ew)
			if !anim
				basea = 0
				planet_pos(earth, earth_r, _basea, earth_x, earth_y)
				u(earth_x) ; u(earth_y)
				basea = -_basea
	#			basea += 360 / 24 * birth_t->tm_hour
				basea += 360 / 24 * t / 3600 #birth_t->tm_hour
	#			planet_pos(earth, earth_r_1, earth_a_1, earth_x_1, earth_y_1)
	#			origin(earth_x_1, earth_y_1*yscale)

#			z=-Cos(t)*0.2 + 1.2
#			zoom(z)

			clear()

#			back(r, system_out*2+10.0, 200)
#				rgb(0, 0, 0.05*r/(system_out*2+10))
#				Disc(0, 0, r)
			stars()

#			real da = Sin(phase) * bend

			grey()
			move_to_text_origin()
			gsay(person_name)
			gsay_date(t)
			gsay_place(birth_p)

#			midnightblue()
			starburst()
			if anim
				blended_curves()
			else
				curve_orig()
			thin()

			sun()

			.
				eachplanet(i)
					if i != earth
						planet()

			int i = earth
			planet()

			paint()
			sleep(0.01)
			#sleep(1)
			if !anim
				switch key()
				27	.
				'q'	done
				anim = 1

			t += dt
done	.

def every(n)
	static int my(c) = 0
	if my(c)++ == n
		my(c) = 0
	which my(c)

def sqrrand(from, to) sqr(Rand()) * (to-from) + from

def sun()
	if anim
		every(2)
		0	yellow()
		2	white()
	else
		grey()
	for(a, 0, 360, 10)
		polar_to_rec_clock(0, 0, a+Rand(-0.5, 0.5), sqrrand(20, 35), x, y)
		let(d, hypot(x, y))
		num f = (19+Rand(-0.5, 0.5))/d
		line(x*f, y*f, x, y)
	if anim
		every(4)
		0	white()
		1	cyan()
		2	orange()
		3	yellow()
	else
		yellow()
	Disc(0, 0, 15)

def stars()
	for(c, 0, n_stars)
		if toss()
			col(star_c[c])
		else
			white()
		point(star_x[c], star_y[c])
	int c = Rand(n_stars)
	star(c)

def star(c)
	repeat
		let(b, Rand(1))
		num tint = 0.55
		star_c[c] = rgb(b+Rand(tint), b+Rand(tint), b+Rand(tint))
		star_x[c] = Rand(-w/2, w/2)
		star_y[c] = Rand(-h/2, h/2)
		if hypot(star_x[c], star_y[c]/yscale) > stars_start
			break

def planet_pos(i, r, a, x, y)
#	let(r, system_in + pow(i, balance)/pow(8, balance)*(system_out-system_in))
	let(r, planet_dist[i])
	let(a, planet_a[i] + 360 * t * 1.0/planet_period[i])
	a += basea
	polar_to_rec_clock(0, 0, a, r, x, y)

def polar_to_rec_clock(x0, y0, a, r, x1, y1)
	polar_to_rec(y0, x0, a, r, y1, x1)

def star_pos(i, x, y)
	let(x, star_x[i])
	let(y, star_y[i])

def planet()
	.
		planet_pos(i, r, a, x, y)
		rainbow(-60 + i*330/8)
		#width(2)
#		Circle(0, 0, r)
		num pr = planet_r[i]

		if i == earth
			Disc(x, y, pr)
			grey()
			moon()
		eif i == pluto_charon
			pluto_charon()
		else
			Disc(x, y, pr)

		if i == saturn
			grey()
			every(4)
			0	Circle(x, y, pr + 4)
				Circle(x, y, pr + 6)
			else	Circle(x, y, pr + 5)
				Circle(x, y, pr + 7)

int earth = 2
int saturn = 5
int pluto_charon = 8

# XXX fixme 28?
def moon()
	polar_to_rec_clock(x, y, 360*t/secs_in_day/28, 12, mx, my)
	Disc(mx, my, 2)

def pluto_charon()
	int oa = -a*1000
	int pc_r = 3
	polar_to_rec_clock(x, y, oa, pc_r, pluto_x, pluto_y)
	Disc(pluto_x, pluto_y, 1)
	polar_to_rec_clock(x, y, oa+180, pc_r, charon_x, charon_y)
	Disc(charon_x, charon_y, 1)

def trig_unit deg

def eachplanet(i)
	for(i, 0, n_planets)
def eachstar(i)
	for(i, 0, n_stars)

def PrintDate(dt)
	SayFree(Timef(dt, dt_format))

# people have some CHOICE, they can choose either one arc or the other at each planet transition

def blended_curves()
	.
		# connect the planets with a curve...
		#width(2)
		planet_pos(0, or, oa, x0, y0)
		
		eachplanet(i)
			if i == 0
				continue
			planet_pos(i, r, a, x1, y1)
			blended_curve(i, x0, y0, or, oa, r, a)
			x0 = x1 ; y0 = y1
			or = r ; oa = a

blended_curve(int i, num x0, num y0, num or, num oa, num r, num a)
	num da = a - oa
	da = rmod(da, 360)
	num da1 = -(360-da)
#	if (da > 180) ^ golong
	if da > 180
		swap(da, da1)

	num wp = or*or / 100 #100 * or/300
	num aweight = 1-pow(fabs(da)/360, wp)*pow(2, wp-1)
	num a1weight = 1-aweight

	num maxda = nmax(fabs(da), fabs(da1))
	int steps = 1 + (int)maxda / 3

	da /= steps
	da1 /= steps

	num dr = (r - or) / steps
	num p = 0.0
	num dp = 1.0/steps
	num oa1 = oa

	Move(x0, y0)
	for ; steps > 0; --steps
#			if steps % 2
		rb(-60 + (i+p)*330/8)
#			else
#				black()
		oa += da
		oa1 += da1
		or += dr
		polar_to_rec_clock(0, 0, oa, or, x, y)
		polar_to_rec_clock(0, 0, oa1, or, x_, y_)
#		Draw(x, y)
#		Draw(x_, y_)
		u(x) ; u(y)
		u(x_) ; u(y_) ; u(aweight) ; u(a1weight)
		#Draw(x*aweight + x_*a1weight, y*aweight + y_*a1weight)
		let(w, or/240 * wavg(planet_r[i-1], planet_r[i], p))
		w = bound(w, 1, 3)
		wide_line(lx, ly/yscale, x*aweight + x_*a1weight, y*aweight + y_*a1weight, w)
		p+=dp

wide_line(num x0, num y0, num x1, num y1, num w)
	width(w)
	unit(x1-x0, y1-y0, ux, uy)
	ux *= w/2 ; uy *= w/2
	Line(x0-ux, y0-uy, x1+ux, y1+uy)
	Move2(x0, y0, x1, y1)
	thin()

def unit(dx, dy, ux, uy)
	let(d, hypot(dx, dy))
	let(ux, dx / d)
	let(uy, dy / d)

def wavg(a, b, w) a*(1-w) + b*w

def u(v) v=v

def curves()
	.
		# connect the planets with a curve...
		width(2)
		planet_pos(0, or, oa, x0, y0)
		
		eachplanet(i)
			if i == 0
				continue
			planet_pos(i, r, a, x1, y1)
			curve(i, x0, y0, or, oa, r, a, 0)
			curve(i, x0, y0, or, oa, r, a, 1)
			x0 = x1 ; y0 = y1
			or = r ; oa = a

#x=x ; y=y  # keep gcc happy  IDEA for macros; omit to do an op if the result isn't ever used;
	   #                 this would keep gcc happy too!

curve(int i, num x0, num y0, num or, num oa, num r, num a, boolean golong)
	num da = a - oa
	da = rmod(da, 360)
	num da1 = -(360-da)
	if (da > 180) ^ golong
		swap(da, da1)

	Move(x0, y0)
	int steps = 1 + (int)fabs(da) / 5 #(150/r) # equal size steps
	da /= steps
	num dr = (r - or) / steps
	num p = 0.0
	num dp = 1.0/steps
	for ; steps > 0; --steps
#			if steps % 2
		rb(-60 + (i+p)*330/8)
#			else
#				black()
		oa += da
		or += dr
		polar_to_rec_clock(0, 0, oa, or, x, y)
		Draw(x, y)
		p+=dp

# need to be able to define macros from within a macro

def curve_orig()
	.
		# connect the planets with a curve...
		width(2)
		planet_pos(0, or, oa, x, y)
		Move(x, y)
		eachplanet(i)
			if i == 0
				continue
			planet_pos(i, r, a, x, y)
			x=x ; y=y  # keep gcc happy
			num da = a - oa
			da = rmod(da, 360)
			if da > 180
				da = -(360-da)
			int steps = 1 + (int)fabs(da) / 5 #(150/r) # equal size steps
			da /= steps
			num dr = (r - or) / steps
			num p = 0.0
			num dp = 1.0/steps
			for ; steps > 0; --steps
#				if steps % 2
				rb(-60 + (i+p)*330/8)
#				else
#					black()
				oa += da
				or += dr
				polar_to_rec_clock(0, 0, oa, or, x, y)
				Draw(x, y)
				p+=dp
			
			or = r ; oa = a

def Toss()
	if toss()

# TODO sun is planet[0] !

def starburst()
	.
		# connect the planets with a curve...
		width(2)
		eachplanet(j)
			if j != earth
				connect(0, earth, j)
		connectsun(1, earth)
		#planet_pos(earth, r0, a0, x0, y0)
		#connect_grey(1, x0, y0, 0, 0)
		#connect_grey(1, 0, 0, x0, y0)
#			eachplanet(i)
#				if i > j #&& i != earth && j != earth
#		eachplanet(i)
#			connect(earth, i)

#		eachstar(s)
#			connectstar(s)

def connect(strong, A, B)
	planet_pos(A, r0, a0, x0, y0)
	planet_pos(B, r1, a1, x1, y1)
	connect_grey(strong, x0, y0, x1, y1)

def connectsun(strong, A)
	planet_pos(A, r0, a0, x0, y0)
	let(x1, 0.0) ; let(y1, 0.0)
	connect_grey(strong, x0, y0, x1, y1)

def connectstar(S)
	star_pos(S, x1, y1)
	connect_grey(0, 0, 0, x1, y1)

# IDEA - once have auto decl, won't need to worry about whether decl'd or not

def greypowhigh 6
def greypowlow 2
def burst_len 100
def connect_grey(strong, x0, y0, x1, y1)
	Move(x0, y0)
	let(my(d), dist(x0, y0, x1, y1))
	let(my(bl), 1/sqr(my(d)) * 1000000)
	my(bl) = bound(my(bl), 0, my(d))
	x1 = x0 + (x1-x0) * my(bl)/my(d)
	y1 = y0 + (y1-y0) * my(bl)/my(d)
	my(d) = my(bl)
#	let(my(d), dist(x0, x0, x1, y1))
	for(my(p), 0.0, 1, 1/my(d))
		let(xx, x0 + (x1-x0)*my(p))
		let(yy, y0 + (y1-y0)*my(p))
#		if toss()
#			black()
#		else
#			white()
#		rb(-60 + (i*R/r)*330/8.0)
		num v
		if !anim || toss()
			#rb(-60 + p*i*330/8.0)
			if strong
				v = pow(1-my(p), greypowlow)
			else
				v = pow(1-my(p), greypowhigh)
		else
			v = 0
#		if v > 0.01 && p*d > 10 && (1-p)*d > 10
	#	if v > 0.01 #p*d > 10 && (1-p)*d > 10 #&& v > 0.01
		gr(v)
		Draw(xx, yy)
#		else
#			Move(xx, yy)

def bound(a, low, high) a < low ? low : a > high ? high : a


colour gr[256]

grey_init()
	for(i, 0, 256)
		gr[i] = grey(i/256.0)

def gr(p) col(gr[bound((int)(p*256), 0, 256)])
def grey(p) rgb(p, p, p*.95+.05)

num dt = secs_in_day / 2 #/ 4 #* 2 #/ 24
#real dt = secs_in_day / 24 / 4 # 15 min 962 #/ 4 #* 2 #/ 24

# TODO put in "colours" file
colour spaceblue

def gsay_date(t)
	# print the date
	decl(currenttime, datetime)
	Localtime(t, currenttime)
	cstr birth_t_cstr = Timef(currenttime, dt_format)
	gsay(birth_t_cstr)
	Free(birth_t_cstr)

def gsay_place(p)
	# print the place
	cstr NS
	cstr EW
	int ns = p->ns
	int ew = mod(p->ew, 360)
	if ew > 180
		ew -= 360

	# FIXME have N/S E/W in place (a separate sign)
	# otherwise ~ equator there are problems
	if ns >= 0
		NS = "N"
	else
		NS = "S"
		ns = -ns
	if ew >= 0
		EW = "E"
	else
		EW = "W"
		ew = -ew

	# todo mod to a - to + range...
	gsayf("%d:%d'%d\"%s  %d:%d'%d\"%s", ns, p->ns_min, p->ns_sec, NS, ew, p->ew_min, p->ew_sec, EW)

def Move(x, y)
	move(x, y*yscale)

def Draw(x, y)
	draw(x, y*yscale)

def Point(x, y)
	point(x, y*yscale)

def Circle(x, y, r)
	circle(x, y*yscale, r)

def Disc(x, y, r)
	disc(x, y*yscale, r)

def Move2(x0, y0, x1, y1)
	move2(x0, y0*yscale, x1, y1*yscale)

def Line(x0, y0, x1, y1)
	line(x0, y0*yscale, x1, y1*yscale)

use gr
use util
use m
use main
use time
use place
use error
use alloc
use key
