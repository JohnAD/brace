#!/lang/b

use b

Main()
	space()
	long i = 0
	repeat
		unsigned long *px = pixel(vid, 1, 1)
		for(y, 0, h-2)
			for(x, 0, w-2)
				if i==0
					*px = fastrgb32(randi(0, 256), randi(0, 256), randi(0, 256))
				 else
					int r = random() % 10
					int lsb
					if (i / 20) % 2 == 0
						which r
						0	*px = px[-1]
						1	*px = px[1]
						2	*px = px[-w]
						3	*px = px[w]
						4	if random() % 5 == 0
								lsb = *px & 1
								*px = *px>>1 | lsb << 31
					 else
						int r = (r(px[0]) + r(px[1]) + r(px[-1]) + r(px[w]) + r(px[-w])) / 5 + 1
						int g = (g(px[0]) + g(px[1]) + g(px[-1]) + g(px[w]) + g(px[-w])) / 5 + 1
						int b = (b(px[0]) + b(px[1]) + b(px[-1]) + b(px[w]) + b(px[-w])) / 5 + 1
						*px = fastrgb32(r%256, g%256, b%256)
				px++
			px+=2
		++i
		Paint()

def fastrgb32(r0, g0, b0) (long)r0<<16 | (long)g0<<8 | (long)b0

def r(x) x >> 16 & 0xFF
def g(x) x >> 8 & 0xFF
def b(x) x & 0xFF
