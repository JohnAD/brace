#!/lang/b
use b
Main()
	# This crap is apparently not working :(
	num R = 1, G = 0.25, B = 0.25
	num det, r, g, b, bri, col
	num foo = 9.0 / (16*(R*R + G*G + B*B - G*B - R*G - R*B))
	Pr(num, foo)
	Pr(num, sqr(G+B) * foo)
	Pr(num, sqr(R+B) * foo)
	Pr(num, sqr(R+G) * foo)
	det = sqrt(.25 - sqr(G+B) * foo)
	r = 1/2 + det
	det = sqrt(.25 - sqr(R+B) * foo)
	g = 1/2 + det
	det = sqrt(.25 - sqr(R+G) * foo)
	b = 1/2 + det
	Pr(num, r, g, b)
