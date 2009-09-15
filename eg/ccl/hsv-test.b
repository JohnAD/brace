#!/lang/b
use b
Main()
	num black = 0
	num white = 0
	getargs(num, black, white)
	for(a, 0, 360)
		num r = (Cos(a)+1)/2
		num g = (Cos(a+120)+1)/2
		num b = (Cos(a-120)+1)/2
		eachp(x, r, g, b)
			*x *= (1-black)
			*x = 1-(1-*x)*(1-white)
		num t = r + g + b
		num ts = r*r + g*g + b*b
		num ds = (1-r)*(1-r) + (1-g)*(1-g) + (1-b)*(1-b)
		num x = r*g + g*b + b*r
		Pr(num, r, g, b, t, sqrt(ts*2), sqrt(ds*2))
