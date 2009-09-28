#!/lang/b
use b
Main()
	long N = 1000000
	bm_start()
	repeat(N)
		seteuid(1000)
		seteuid(0)
	bm_ps("done setuid", N)
