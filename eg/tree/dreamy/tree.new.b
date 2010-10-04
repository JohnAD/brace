tree()
	branch()

	in(1.4)
	if unit < 0.2
		leaf()
	else
		let(fork, here)
		turn(-34) ; tree()
		here = fork
		turn(+43) ; tree()

branch()
	brown()
	forward(1)

leaf(pos p)
	green()
	dot(p, 1/6)

Main()
	paper(400, 300, coln(tan))
	down(140)
	zoom(70)
	tree()

use headers
