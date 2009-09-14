#!/lang/b

use gr m util

rose(int x, int y, int r0, int a0, int da0, int petals, num cola, num red0, num redr, num reda, num green0, num greenr, num greena, num blue0, num bluer, num bluea)
	num a, ca, pr, r
	num da = 360.0/petals
	for r=r0; r>0; r-=(r+20)/25
		pr = r * 7.0/6
		for a=a0; a<358+a0; a+=da
			ca = (r0-r) / r0 * cola
			rgb(red0+redr*Cos(ca+reda), green0+greenr*Cos(ca+greena), blue0+bluer*Cos(ca+bluea))
			circle_fill(Sin(a)*r + x, Cos(a)*r + y, pr)
		a0 += da0

num rot

roses()
	int i, x, y
	int n = 9
	int nc = 3
	int j
	num da = 360.0/n
	num a
	rgb(.1, 0, .2)
	clear()
	rose(0, 0, 65, 30 + rot, 47, 4, 360,       .9, .1, 0,  .5, .1, 180,  .5, .1, 180)
	for i=0; i<n; ++i
		j = i / nc
		a = i*da + 40 - rot
		x = 225*Sin(a)
		y = 225*Cos(a)
		rose(x, y, 30, -60+a + rot*5, 37, 6, c[j][0], c[j][1], c[j][2], c[j][3], c[j][4], c[j][5], c[j][6], c[j][7], c[j][8], c[j][9])
	paint()

num c[3][10] =
		180,  .9, .1, 0,  .5, .1, 0,  .4, .1, 180
	,
		180,  .7, .1, 0,   0,  0, 0,  .2, .2, 180
	,
		220,  .5, .1, 120,  .7, .2, 120,  .7, .2, -60

main()
	space(600, 600)
	gr_fast()
	yflip()

	for rot = 0; rot <= 360; ++rot
		roses()
		paint()
