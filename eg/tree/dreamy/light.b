use m
use gr
use error
use stdlib.h

main  int argc  char *argv[]
	gr_init 400 300
	if argc < 2
		error "syntax: %s depth [colour]" argv[0]
	if argc > 2
		col argv[2]
	clear
	int depth = atoi(argv[1])
	tree 0 -140 0 70 depth
	event_loop

tree  num x  num y  num a  num r  int depth
	if depth == 0
		# draw a leaf
		col "green" ; circle_fill x y r/2
	else
		# draw a branch and two smaller trees
		num x1 = x + r*Sin(a)
		num y1 = y + r*Cos(a)
		col "brown" ; line x y x1 y1
		tree x1 y1 a-30 r*3/4 depth-1
		tree x1 y1 a+25 r*3/4 depth-1

