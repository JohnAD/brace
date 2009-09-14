#!/lang/b

Main()
	cgi_png(400, 300)
	paper(400, 300, beige)
	num R = 90

	# draw a rainbow
	let(phase, Rand(360)) # rand_angle
	back(r, R, 0)
		rainbow(r/R * 360 + phase)
		circle_fill(0, 0, r)

	# draw a little white shape
	line_width(2)
	white()

	home()
	forward(10) ; right(90) ; forward(10)
	draw(-10, -10)
	fd(10) ; lt(90) ; fd(20)
	line(-10, 10,  10, -10)
	north(10) ; west(20) ; north(10)

	# draw a star or something
	R *= 0.9
	int step
	do
		step = randi(1, 12)
	 while step == 6
	thin() ; white()
	move(0, R)
	let(i, 0)
	repeat
		i += step
		draw(SinCos(i*30, R))
		if i % 12 == 0
			break

	# write a message
	black()
	text_home()
	font("helvetica-bold", 18)
	gprint("Hello, World!  ")
	font("helvetica-medium", 12)
	gsayf("Welcome to %s!", Getenv("HTTP_HOST", "somewhere"))
	gnl()
	font("helvetica-medium", 12)
	gsay("This CGI script is written in brace - http://sam.nipl.net/brace/")

	move(-w_2, -h_2 + font_height() * 4)
	gsayf("server software: %s", Getenv("SERVER_SOFTWARE"))
	gnl()
	gsay_date(time())

gsay_date(num t)
	# this prints the time and date
	decl(currenttime, datetime)
	Gmtime(t, currenttime)
	cstr s = Timef(currenttime)
	gsayf("The time is %s UTC.", s)
	Free(s)

use b
