#!/lang/b

Main()
	paper(1280, 800, black)
	gr_fast()

	let(dt, angle2rad(1))
	dt = dt

	int R = hypot(1280/2, 800/2)

	int *a = Nalloc(int, (R*2+1) * (R*2+1))
	int *d = Nalloc(int, (R*2+1) * (R*2+1))
#	int a[R*2+1][R*2+1]
#	int d[R*2+1][R*2+1]
	colour rb[360]
	int np[R*2+1]

	for(i, 0, 360)
		rb[i] = rainbow(i)

	for(y, -R, R)
		let(X, (int)notpot(R, y))
		np[y+R] = X
		for(x, -X, X)
#			d[x+R][y+R] = hypot(x, y)
			d[ix(x,y)] = hypot(x, y)
			let(A, Atan2(y, x))
#			a[x+R][y+R] = mod(((int)A), 360)
			a[ix(x,y)] = mod(((int)A), 360)

	let(da, 0.0)

	int first = 1
	wheel()
	paint()
	sleep(3)
	done()

	first = 0

	repeat
		wheel()
		paint()
		#spin()
		#da -= 5
		da -= 8
		first = 0

	done()

def ix(x,y) (x+R) + (y+R) * (R*2+1)

def wheel()
	.
#		for(i, 0, 360)
#			rb[i] = rainbow(i)
		for(y, -R, R)
			let(X, np[y+R])
			for(x, -X, X)
				if Rand() < 0.02 || first
#					let(A, (a[x+R][y+R] + d[x+R][y+R]))
					let(A, (a[ix(x,y)] + d[ix(x,y)]))
					if toss() || first
						A = mod(A*2+da/2, 360)
					else
						A = mod(A*3+da, 360)
					col(rb[A])
					point(x, y)

def spin()
	rb_red_angle += 1.6*dt
	rb_green_angle += 2*dt
	rb_blue_angle += -1*dt

def trig_unit deg

use main
use m
use gr
use error
use time
use io
