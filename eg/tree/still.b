Main()
	int forks = 6

	which args
	0	.
	1	forks = atoi(arg[0])
	else	usage("[forks]")

	paper(640, 480, coln("tan"))
	gr_delay(0.01)

	tree(forks, 0, -200, 100, 90, 36, -43, .77, .80)

use headers
use tree
