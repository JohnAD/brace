#!/lang/b
use b
# LC_ALL=POSIX xterm -lc
Main()
	for(a, 32, 255)
		if a == 127
			printf(" ")
			continue
		printf("%c", a)
	nl()
