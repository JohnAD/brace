#!/lang/b
use b
use lib_extra.b

Main()
	sym_init()
	Sym("linear") ; Sym("cos") ; Sym("cos2")
	Sym("hump") ; Sym("hump2")
	Sym("full-linear")
	Sym("full-sqrt")
	Sym("full-hump")
	Sym("full-hump2")
	Sym("circular")

	int width = atoi(Getenv("width", "600"))
	int height = atoi(Getenv("height", "300"))
	cstr method = sym(Getenv("method", "linear"))
	num span = atof(Getenv("span", "3"))  # 90 degrees
	cstr scale = getenv("span")  # mark colours and "divisions"

	num r0, g0, b0, r1, g1, b1
	which args
	6	r0 = atof(arg[0])
		g0 = atof(arg[1])
		b0 = atof(arg[2])
		r1 = atof(arg[3])
		g1 = atof(arg[4])
		b1 = atof(arg[5])
	else	usage("r0 g0 b0 r1 g1 b1")

	space(width, height)

	num max_r = 0
	num max_g = 0
	num max_b = 0

	for(x, -w_2, w_2)
		num i = (x+w_2+0.0) / (width-1)
		# i ranges from 0 to 1
		num p0, p1
		if method == "linear"
			p0 = 1-i
			p1 = i
		 eif method == "cos"
			num c = cos(i*pi)
		 	p0 = (1 + c) / 2
		 	p1 = (1 - c) / 2
		 eif method == "cos2"
			num c = ssquare(cos(i*pi))
		 	p0 = (1 + c) / 2
		 	p1 = (1 - c) / 2
		 eif method == "hump"
			p0 = cos(i*(pi/2))
			p1 = cos((1-i)*(pi/2))
		 eif method == "hump2"
			p0 = square(cos(i*(pi/2)))
			p1 = square(cos((1-i)*(pi/2)))
		 eif method == "full-linear"
			p0 = i < 0.5 ? 1 : (1-i)*2
			p1 = i > 0.5 ? 1 : i*2
		 eif method == "full-sqrt"
			p0 = i < 0.5 ? 1 : sqrt((1-i)*2)
			p1 = i > 0.5 ? 1 : sqrt(i*2)
		 eif method == "full-hump"
			p0 = i < 0.5 ? 1 : sin((1-i)*2*pi/2)
			p1 = i > 0.5 ? 1 : sin(i*2*pi/2)
		 eif method == "full-hump2"
			p0 = i < 0.5 ? 1 : square(sin((1-i)*2*pi/2))
			p1 = i > 0.5 ? 1 : square(sin(i*2*pi/2))
		 eif method == "circular"
			circular_blend(p0, p1, i, span)
		 else
		 	error("unknown method %s", method)

		num r = r0*p0 + r1*p1
		num g = g0*p0 + g1*p1
		num b = b0*p0 + b1*p1

		if r > max_r
			max_r = r
		if g > max_g
			max_g = g
		if b > max_b
			max_b = b

		# this means the "total" power midway will be sqrt(1/2)
		# maybe it should be 1/2 instead?  could try cos^2(i*pi) instead

		rgb(r, g, b)

		line(x, -h_2, x, +h_2-1)

	if scale
		# draw the scale
		# colour marks
		for(i, 0, span+1)
			int x = -w_2 + ((i+0.0)/span)*(width-1)
			black()
			line(x, -h_2, x, -h_2 + height/12)
			white()
			line(x, h_2-1, x, h_2-1 - height/12)
		# division marks
		.
			for(i, 0, span)
				int x = -w_2 + ((i+0.5)/span)*(width-1)
				white()
				line(x, -h_2, x, -h_2 + height/6)
				black()
				line(x, h_2-1, x, h_2-1 - height/6)
		# FIXME encourage to use odd number of pixels for window
		# if origin is in the center

	Sayf("max r: %f", max_r)
	Sayf("max g: %f", max_g)
	Sayf("max b: %f", max_b)

def trig_unit lun

num square(num x)
	return x * x

num ssquare(num x)
	return fsgn(x)*(x * x)

num cube(num x)
	return x * x * x

num ucube(num x)
	return fsgn(x)*(x * x * x)
 # yagni?!  :p

# ideas for casting, e.g. for env vars, args.
# need a builtin that returns a type name..
 # FIXME maybe id should not be in m.b but util.b?

def cstr_to_int atoi
def cstr_to_num atof
def cstr_to_cstr id

# Sym should be called with a literal string,
# it is not copied on inserting to the hash-table,
# and it is not freed if it's already there
cstr Sym(cstr s)
	list *ref = hashtable_lookup_ref(syms, s)
	if hashtable_ref_exists(ref)
		key_value *kv = hashtable_ref_key_value(ref)
		if (cstr)kv->key != s
			error("string table has duplicate \"%s\" - or Sym function misused", s)

	hashtable_add(syms, s, NULL)
	return s
	# should be a "hash_set"
	# or maybe "value" wants to be an int for this, a usage count?
	# or it could be a smallish "symbol ID" number?
