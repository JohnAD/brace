export vec util

def read_tsv_vec(v)
	read_tsv_vec(v, my(l))
def read_tsv_vec(v, l)
	repeat
		cstr l = Input()
		if l == NULL
			break
		splitv(v, l)

def read_tsv_vec_n(v, n)
	read_tsv_vec_n(v, n, my(l))
def read_tsv_vec_n(v, n, l)
	read_tsv_vec(v, l)
		if vec_get_size(v) != n
			error("read_tsv_vec_n: expected %d columns, got %d", n, vec_get_size(v))

# this is a degenerate case! but they are usually important to have
def read_tsv()
	_read_tsv(my(v))
def _read_tsv(v)
	new(v, vec, cstr, 0)
	read_tsv_vec_n(v, 0)
		.
#FIXME Free(v)!

# this is sort of degenerate but not really!
def read_tsv(a1)
	_read_tsv(my(v), a1)
def _read_tsv(v, a1)
	new(v, vec, cstr, 1)
	read_tsv_vec_n(v, 1)
		cstr a1 = *(cstr *)vec_element(v, 0)
#FIXME Free(v)!

def read_tsv(a1, a2)
	_read_tsv(my(v), a1, a2)
def _read_tsv(v, a1, a2)
	new(v, vec, cstr, 2)
	read_tsv_vec_n(v, 2)
		cstr a1 = *(cstr *)vec_element(v, 0)
		cstr a2 = *(cstr *)vec_element(v, 1)
#FIXME Free(v)!

def read_tsv(a1, a2, a3)
	_read_tsv(my(v), a1, a2, a3)
def _read_tsv(v, a1, a2, a3)
	new(v, vec, cstr, 3)
	read_tsv_vec_n(v, 3)
		cstr a1 = *(cstr *)vec_element(v, 0)
		cstr a2 = *(cstr *)vec_element(v, 1)
		cstr a3 = *(cstr *)vec_element(v, 2)
#FIXME Free(v)!

def read_tsv(a1, a2, a3, a4)
	_read_tsv(my(v), a1, a2, a3, a4)
def _read_tsv(v, a1, a2, a3, a4)
	new(v, vec, cstr, 4)
	read_tsv_vec_n(v, 4)
		cstr a1 = *(cstr *)vec_element(v, 0)
		cstr a2 = *(cstr *)vec_element(v, 1)
		cstr a3 = *(cstr *)vec_element(v, 2)
		cstr a4 = *(cstr *)vec_element(v, 3)
#FIXME Free(v)!

# etc!  need snazzy variadic macros :)
