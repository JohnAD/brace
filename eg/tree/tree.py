#!/usr/bin/python

from play import *

paper(400, 300, "white")

def tree(x, y, a, r, depth):
	if depth == 0:
		circle(x, y, r/2, fill="green")
	else:
		nx = x + r*sin(a)
		ny = y + r*cos(a)
		line(x, y, nx, ny, width=r/6, fill="brown")
		tree(nx, ny, a-30, r*3/4, depth-1)
		tree(nx, ny, a+25, r*3/4, depth-1)

for depth in range(0, 9):
	tree(200, 50, 0, 70, depth)
	press_enter()
	clear()
