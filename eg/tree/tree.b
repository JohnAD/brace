boolean rb
num wf
colour branchcol

def tree(f, x, y, r, a, a0, a1, m0, m1)
	rb = 1
	wf = 1
	tree1(f, x, y, r, a, a0, a1, m0, m1)

#	rb = 0
#	wf = 0.7
#	branchcol = black
#	tree1(f, x, y, r, a, a0, a1, m0, m1)
#
#	rb = 0
#	wf = 0.2
#	branchcol = white
#	tree1(f, x, y, r, a, a0, a1, m0, m1)

tree1(int forks,
  num x, num y, num r, num a,
  num a0, num a1, num m0, num m1)
	polar_to_rec(x, y, a, r, x1, y1)

	branch(x, y, x1, y1, r/6)

	if forks == 0
		leaf(x1, y1, a, r/6)
	else
		tree1(forks-1, x1, y1, r*m0, a+a0, a0, a1, m0, m1)
		tree1(forks-1, x1, y1, r*m1, a+a1, a0, a1, m0, m1)

branch(num x0, num y0, num x1, num y1, num w)
	w *= wf
	if rb
		rainbow(x0/2)
	else
		col(branchcol)
	width(w)
	line(x0, y0, x1, y1)
	dot(x1, y1, w/2*.8)
	dot(x0, y0, w/2*1.1)

leaf(num x, num y, num a, num r)
	r *= wf
	if rb
		rainbow(x/2)
	else
		black()
	dot(x, y, r)
#	polar_to_rec(0, 0, a, r, dx, dy)
#	line(x-dx, y-dy, x+dx, y+dy)

def trig_unit deg

export m
export gr
use types
