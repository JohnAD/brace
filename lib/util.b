export io types alloc
export stdarg.h string.h
use m

def my(a) skip(1, `my__prefix)^^a

def unless(cond)
	if !cond

def until(cond)
	while !cond

# todo print chars too
def hexdump_width 16
hexdump(FILE *stream, char *b0, char *b1)
	let(n, b1 - b0)
	while n > 0
		let(c, imin(n, hexdump_width))
		for(b, b0, b0 + c)
			hexbyte(stream, *b)
		spcs(stream, 3 * (hexdump_width - c) + 4)
		for(_b, b0, b0 + c)
			char_or_dot(stream, *_b)
		b0 += hexdump_width
		n -= hexdump_width
		nl(stream)
	nl(stream)

def hexdump(b0, b1)
	hexdump(stderr, b0, b1)

def hexbyte(stream, b)
	fprintf(stream, "%02x ", (uchar)b)
def hexbyte(b)
	hexbyte(stderr, b)
def char_or_dot(stream, b)
	Putc(printable(b) ? b : '.', stream)
def char_or_dot(b)
	char_or_dot(stderr, b)

boolean printable(uchar c)
	return c >= 32 && c < 128
	#return c >= 32 && c != 127
 # tab is excluded

Def lett(to, from) sametypet(to, from) = from
Def let(to, from) state lett(to, from)
 # the 0; is so we can put a declaration at the start of a "case",
 # perhaps this should be added at each "case" in brace

Def sametypet(to, ref) typeof(ref) to
Def sametype(to, ref) state sametypet(to, ref)

#Def castto(from, type) (*(type *)&(from))
Def castto(from, type) ((type)(from))
Def castto_ref(from, ref) castto(from, typeof(ref))

Def for(v)
	for(v, v^^0, v^^1)

Def for(v, ary)
	for(v, ary^^0, ary^^1)

# FIXME I think it might be better if for and back (especially)
# used inclusive ranges, not excluding "to" - a BIG change!

def for(v, from, to)
	let(my(end), to)
	let(my(v1), from)
	for ; my(v1)<my(end); ++my(v1)
		let(v, my(v1))

def for(v, from, to, step)
	let(my(end), to)
	let(my(st), step)
	let(my(v1), from)
	for ; my(v1)<my(end); my(v1)+=my(st)
		let(v, my(v1))

def for_keep(v, from, to)
	let(v, from)
	let(my(end), to)
	for ; v<my(end); ++v

def for_keep(v, from, to, step)
	let(v, from)
	let(my(end), to)
	let(my(st), step)
	for ; v<my(end); v+=my(st)

def repeat(n)
	for(my(i), 0, n)
		use(my(i))

def back(v, from, to)
	let(my(end), to)
	let(my(v1), from)
	for ; my(v1)>my(end); --my(v1)
		let(v, my(v1))

def back(v, from, to, step)
	let(my(end), to)
	let(my(st), step)
	let(my(v1), from)
	for ; my(v1)>my(end); my(v1)-=my(st)
		let(v, my(v1))

def for_step(i, d)
	let(my(end), i^^1+d/2)
	for i = i^^0 ; i < my(end) ; i+=d

def map(out, in, func)
	for(in)
		*out++ = func

#def Map(out_ary, in, func)
#	sametype(my(out), &*out_ary)
#	map(in, out, func)
# TODO use map more widely?

def natatime(v, n, sep)
	int my(i) = 0
	for(v)
		if my(i) == n
			sep
			my(i) = 0
		++my(i)

Def ptrt(var, type)
	type *var

Def ptr(var, type)
	state type *var

Def stack(var, type)
	type struct__^^var
	var = &struct__^^var

Def heap(var, type)
	var = Talloc(type)

#Def decl(var, type)
#	ptr(var, type)
#	stack(var, type)

# This decl can be used as a global too, not in a struct though.

Def declt(var, type)
	type struct__^^var
	type *var = &struct__^^var
#	type *const var = &struct__^^var

Def decl(var, type)
	state type struct__^^var
	state type *var = &struct__^^var
#	type *const var = &struct__^^var

# decl_member was for structs, but I think it is better to do it differently in
# a struct because it would use extra storage.

#Def decl_member(var, type)
#	type struct__^^var, *var

#Def member_init(obj, var, type)
#	obj->var = &obj->struct__^^var
#	init(obj->var, type)

#Def ptr_obj(var, type)
#	var = &struct__^^var

Def Decl(var, type)
	ptr(var, type)
	heap(var, type)

Def new(var, type)
	decl(var, type)
	init(var, type)
Def new(var, type, a1)
	decl(var, type)
	init(var, type, a1)
Def new(var, type, a1, a2)
	decl(var, type)
	init(var, type, a1, a2)
Def new(var, type, a1, a2, a3)
	decl(var, type)
	init(var, type, a1, a2, a3)
Def new(var, type, a1, a2, a3, a4)
	decl(var, type)
	init(var, type, a1, a2, a3, a4)
Def new(var, type, a1, a2, a3, a4, a5)
	decl(var, type)
	init(var, type, a1, a2, a3, a4, a5)

Def New(var, type)
	Decl(var, type)
	init(var, type)
Def New(var, type, a1)
	Decl(var, type)
	init(var, type, a1)
Def New(var, type, a1, a2)
	Decl(var, type)
	init(var, type, a1, a2)
Def New(var, type, a1, a2, a3)
	Decl(var, type)
	init(var, type, a1, a2, a3)
Def New(var, type, a1, a2, a3, a4)
	Decl(var, type)
	init(var, type, a1, a2, a3, a4)
Def New(var, type, a1, a2, a3, a4, a5)
	Decl(var, type)
	init(var, type, a1, a2, a3, a4, a5)

Def NEW(var, type)
	heap(var, type)
	init(var, type)
Def NEW(var, type, a1)
	heap(var, type)
	init(var, type, a1)
Def NEW(var, type, a1, a2)
	heap(var, type)
	init(var, type, a1, a2)
Def NEW(var, type, a1, a2, a3)
	heap(var, type)
	init(var, type, a1, a2, a3)
Def NEW(var, type, a1, a2, a3, a4)
	heap(var, type)
	init(var, type, a1, a2, a3, a4)
Def NEW(var, type, a1, a2, a3, a4, a5)
	heap(var, type)
	init(var, type, a1, a2, a3, a4, a5)

Def init(var, type)
	type^^_init(var)
Def init(var, type, a1)
	type^^_init(var, a1)
Def init(var, type, a1, a2)
	type^^_init(var, a1, a2)
Def init(var, type, a1, a2, a3)
	type^^_init(var, a1, a2, a3)
Def init(var, type, a1, a2, a3, a4)
	type^^_init(var, a1, a2, a3, a4)
Def init(var, type, a1, a2, a3, a4, a5)
	type^^_init(var, a1, a2, a3, a4, a5)

def global(var, type)
	heap(var, type)
	init(var, type)
def global(var, type, a1)
	heap(var, type)
	init(var, type, a1)
def global(var, type, a1, a2)
	heap(var, type)
	init(var, type, a1, a2)
def global(var, type, a1, a2, a3)
	heap(var, type)
	init(var, type, a1, a2, a3)
def global(var, type, a1, a2, a3, a4)
	heap(var, type)
	init(var, type, a1, a2, a3, a4)
def global(var, type, a1, a2, a3, a4, a5)
	heap(var, type)
	init(var, type, a1, a2, a3, a4, a5)

# TODO need ... macro arg!!!

Def declary(var, type, n)
	type struct__^^var[n]
	type *var[n]
	.
		type *declary__p = struct__^^var
		type **declary__pp = var
		type **declary__pp_end = var + n
		while declary__pp != declary__pp_end
			*declary__pp = declary__p
			++declary__pp ; ++declary__p
		# go go gadget, optimizer!!
	array(var)

# this is not working - why?
# TODO break into declary, newary, initary; impl also Newary (for Nalloc'd)
# TODO for ALL arrays, store the start and end (i.e. the range) explicitly;
#   if the end is not used, the compiler could optimise it away.
#   An array ~= a range.
Def initary(var, type, n)
	declary(var, type, n)
	.
		for(initary__i, &var[0], &var[n])
			type^^_init(*initary__i)

Def initary(var, type, n, a1)
	declary(var, type, n)
	.
		for(initary__i, &var[0], &var[n])
			type^^_init(*initary__i, a1)

Def initary(var, type, n, a1, a2)
	declary(var, type, n)
	.
		for(initary__i, &var[0], &var[n])
			type^^_init(*initary__i, a1, a2)

# ...!!!

def array_size(a) sizeof(a)/sizeof(*a)
def array_start(a) &a[0]
def array_end(a) array_end(a, array_size(a))
def array_end(a, n) &a[n]
Def array_range(a) array_start(a), array_end(a)

Def range(v) v->start, v->end
 # this is somewhat generic, it will work for buffer, vec, str, ropev, ...
 # actually it doesn't work for vec unless you cast it! which is a bit weird

Def array(a, n, type)
	type array__^^a[n]
	let(a^^0, (array_start(array__^^a)))
	let(a^^1, (array_end(array__^^a)))
	let(a^^_n, (array_size(array__^^a)))
	let(a, a^^0)
	use(a^^0)
	use(a^^1)
	use(a)
	use(a^^_n)

Def array(a, n)
	let(a^^0, (array_start(a)))
	let(a^^1, (array_end(a, n))
Def array(a)
	let(a^^0, (array_start(a)))
	let(a^^1, (array_end(a)))
# this last is not great, as can't iterate over the array with its own name

Def array(a, n, type, init)
	type array__^^a[n] = init
	let(a^^0, array_start(array__^^a))
	let(a^^1, array_end(array__^^a))
	let(a, a^^0)
# this one doesn't work yet

# Mm to m.b:
Def Max(a, b) a > b ? a : b
Def Min(a, b) a < b ? a : b

def swap(a, b)
	swap(a, b, my(ap), my(bp), my(tmp))
def swap(a, b, ap, bp, tmp)
	let(ap, &a) ; let(bp, &b)
	let(tmp, *bp)
	*bp = *ap ; *ap = tmp

# FIXME why v?

def eacharg(a)
	for(my(i), arg, arg+args)
		let(a, *my(i))
		if a == NULL
			break

def foraryp_null(i, a)
	let(i, &a[0])
	for ; *i ; ++i
		.

def forary_null(e, a)
	foraryp_null(my(i), a)
		let(e, *my(i))
		.

def foraryp(i, a)
	let(my(end), &a[sizeof(a)/sizeof(a[0])])
	let(my(i1), &a[0])
	for ; my(i1)<my(end) ; ++my(i1)
		let(i, my(i1))

def forary(e, a)
	foraryp(my(i), a)
		let(e, *my(i))
		.

def eachline(v)
	new(my(b), buffer)
	repeat
		buffer_clear(my(b))
		if rl(my(b))
			break
		char *v = buffer_get_start(my(b))

# can't do this because of recursion; need a way to map which is non-recursive
#def ln log
#def log log10

def Id(x) x

void *Id_func(void *x)
	return x

def ref(v, obj)
	let(v, &obj)

def then(expr, a, b)
	let(my(temp), expr)
	a(my(temp))
	b(my(temp))

def thenFree(a, expr)
	then(expr, a, Free)

def SayFree(expr)
	then(expr, Say, Free)

def FreeObj(o, type)
	type^^_free(o)

# this is a temp. hack, I could get new to output this instead (if debugging)
def name(obj, name)
	warn("%010p = %s", obj, name)

def void()
	.
def void(a)
	void()
def void(a, b)
	void()
def void(a, b, c)
	void()
def void(a, b, c, d)
	void()

def copy(to, from0, from1, type)
	let(my(_to), (type *)to)
	for(my(i), (type *)from0, (type *)from1)
		*my(_to) = *i
		++my(_to)

# this is used for implementing printf-like functions
# TODO can simplify further, such that printf- and vprintf- like funcs are
# generated from a single template

Def collect(vfunc, arg0)
	va_list ap
	va_start(ap, arg0)
	let(rv, vfunc(arg0, ap))
	va_end(ap)
	return rv
Def collect(vfunc, arg0, arg1)
	va_list ap
	va_start(ap, arg1)
	let(rv, vfunc(arg0, arg1, ap))
	va_end(ap)
	return rv
Def collect(vfunc, arg0, arg1, arg2)
	va_list ap
	va_start(ap, arg2)
	let(rv, vfunc(arg0, arg1, arg2, ap))
	va_end(ap)
	return rv
Def collect(vfunc, arg0, arg1, arg2, arg3)
	va_list ap
	va_start(ap, arg3)
	let(rv, vfunc(arg0, arg1, arg2, arg3, ap))
	va_end(ap)
	return rv

Def collect_void(vfunc, arg0)
	va_list ap
	va_start(ap, arg0)
	vfunc(arg0, ap)
	va_end(ap)
Def collect_void(vfunc, arg0, arg1)
	va_list ap
	va_start(ap, arg1)
	vfunc(arg0, arg1, ap)
	va_end(ap)
Def collect_void(vfunc, arg0, arg1, arg2)
	va_list ap
	va_start(ap, arg2)
	vfunc(arg0, arg1, arg2, ap)
	va_end(ap)
Def collect_void(vfunc, arg0, arg1, arg2, arg3)
	va_list ap
	va_start(ap, arg3)
	vfunc(arg0, arg1, arg3, ap)
	va_end(ap)

def format_add_nl(format1, format)
	size_t my(len) = strlen(format)
	char format1[my(len)+2]
	char *my(e) = format1 + my(len)
	strcpy(format1, format)
	*my(e) = '\n' ; my(e)[1] = '\0'

def readtsv(v, stream)
	new(v, vec, cstr)
	char *my(null) = NULL
	eachline(my(l), md)
		vec_clear(v)
		repeat
			vec_push(v, my(l))
			char *my(c) = strchr(my(l), '\t')
			if my(c) == NULL
				break
			*my(c) = '\0'
			my(l) = my(c)+1
		vec_push(v, my(null))

def bzero(ptr) bzero(ptr, sizeof(*ptr))

def zero(start, end) bzero(start, end-start)

def Map(a, b)
	a = a0
	b = b0
	my(ST)
	repeat
		++a
		++b
my(ST)		.
		if a == a1
			break

def Map(a, b, c)
	a = a0
	b = b0
	c = c0
	my(ST)
	repeat
		++a
		++b
		++c
my(ST)		.
		if a == a1
			break

Def For(v)
	For(v, v^^0, v^^1)

Def For(v, ary)
	For(v, ary^^0, ary^^1)

def For(v, from, to)
	v = from
	let(my(end), to)
	for ; v<my(end); ++v

#def use(v) v=v
def use(v) (void)v

## this defines print and say functions for type foo in terms of fprint_foo
#Def prints_and_says(type)
#	print_^^type(type o)
#		fprint_^^type(stdout, o)
#	fsay_^^type(FILE *stream, type o)
#		fprint_^^type(stream, o)
#		nl(stream)
#	say_^^type(type o)
#		fsay_^^type(stdout, o)

# warning, it's a macro, so don't call with an expression as arg
def tween(a, low, high) a >= low && a <= high
def Tween(a, low, high) a >= low && a < high
def TWEEN(a, low, high) a > low && a < high

def among(a) 0
def among(a, b0) a == b0
def among(a, b0, b1) a == b0 || a == b1
def among(a, b0, b1, b2) a == b0 || a == b1 || a == b2
def among(a, b0, b1, b2, b3) a == b0 || a == b1 || a == b2 || a == b3
def among(a, b0, b1, b2, b3, b4) a == b0 || a == b1 || a == b2 || a == b3 || a == b4
def among(a, b0, b1, b2, b3, b4, b5) a == b0 || a == b1 || a == b2 || a == b3 || a == b4 || a == b5
# need better macros!!!

def for_array_ptr(var_name, ary)
	_for_array_ptr(var_name, ary, my(i))
def _for_array_ptr(var_name, ary, i)
	let(i, &ary[0])
	for ; *i != NULL ; ++i
		let(var_name, *i)
# FIXME use a ref so can modify it

# range...  do we want this?
#struct range
#	void *start
#	void *end

# not named memmem because don't want to conflict with one in the library

void *mem_mem(const void* haystack, size_t haystacklen, const void* needle, size_t needlelen)
	int i
	if needlelen > haystacklen
		return 0
	for i=haystacklen-needlelen+1; i; --i, haystack = (char*)haystack+1
		if !memcmp(haystack,needle,needlelen)
			return (void*)haystack
	return 0

def sort_array_num(x)
	qsort(x, array_size(x), sizeof(*x), num_cmp)

#int num_cmp(const void *a, const void *b)
#	num diff = *(num*)a - *(num*)b
#	if num_eq(diff, 0)
#		return 0
#	 eif diff < 0
#		return -1
#	 else
#		return 1

int num_cmp(const void *a, const void *b)
	return ncmp(*(num*)a, *(num*)b)

def sort_array_int(x)
	qsort(x, array_size(x), sizeof(*x), int_cmp)

def ncmp(a, b) a > b ? 1 : a < b ? -1 : 0

int int_cmp(const void *a, const void *b)
	return ncmp(*(int*)a, *(int*)b)
#	int diff = *(int*)a - *(int*)b
#	return diff

int long_cmp(const void *a, const void *b)
	return ncmp(*(long*)a, *(long*)b)

int off_t_cmp(const void *a, const void *b)
	return ncmp(*(off_t*)a, *(off_t*)b)

def sort_array_cstr(x)
	qsort(x, array_size(x), sizeof(*x), cstrp_cmp)

# post / pre usage:
# post(x)
# 	Say("done after")
# pre(x)
# 	Say("done first")

def post(x)
	int x = 0
x	if x == 1
		++x
		.

def pre(x)
	for ; x < 2 ; ++x
		if x == 1
			goto x
		.

# TODO maybe it would be better to append __struct etc. instead of prepending
# struct__, so it would be easier in case of foo->bar__struct  etc.

# instead of having extra pointers in the struct, could use accessor methods /
# macros. But I can't define macros in a macro yet.

size_t arylen(void *_p)
	void **p = _p
	int count = 0
	while (*p++)
		++count
	return count

typedef int (*cmp_t)(const void *, const void *)

sort_vec(vec *v, cmp_t cmp)
	qsort(vec0(v), veclen(v), vec_get_el_size(v), cmp)

sort_vec_cstr(vec *v)
	sort_vec(v, cstrp_cmp)
#	qsort(vec0(v), veclen(v), sizeof(cstr), cstrp_cmp)

int cstrp_cmp(const void *_a, const void *_b)
	char * const *a = _a
	char * const *b = _b
	return strcmp(*a, *b)

int cstrp_cmp_null(const void *_a, const void *_b)
	char * const *a = _a
	char * const *b = _b
	if !*a || !*b
		if *a
			return -1
		eif *b
			return 1
		return 0
	return strcmp(*a, *b)

comm(vec *merge_v, vec *comm_v, vec *va, vec *vb, cmp_t cmp, free_t *freer)
	size_t maxlen = veclen(va)+veclen(vb)
	vec_set_space(merge_v, maxlen)
	vec_set_space(comm_v, maxlen)
	char *a = vec0(va)
	char *b = vec0(vb)
	char *a_end = vecend(va)
	char *b_end = vecend(vb)
	size_t e = vec_get_el_size(merge_v)
	while a != a_end && b != b_end
		int c = cmp(a, b)
		# can't just use memcmp in general, because there might be
		# unused padding space, or cmp function might not be simple

		void *m
		byte w
		if c == 0
			w = 3 ; m = a
			if freer
				(*freer)(*(void **)b)
			a += e ; b += e
		 eif c < 0
			w = 1 ; m = a
			a += e
		 eif c > 0
			w = 2 ; m = b
			b += e
		void *p = vec_push(merge_v)
		memmove(p, m, e)
		vec_push(comm_v, w)
	size_t n = 0
	byte comm_val
	if a != a_end
		n = (a_end - a) / e
		vec_append(merge_v, a, n)
		comm_val = 1
	 eif b != b_end
		n = (b_end - b) / e
		vec_append(merge_v, b, n)
		comm_val = 2
	if n
		vec_grow(comm_v, n)
		byte *e = vecend(comm_v)
		for(i, e-n, e)
			*i = comm_val
	vec_squeeze(merge_v)
	vec_squeeze(comm_v)

comm_dump_cstr(vec *merge_v, vec *comm_v)
	assert(vec_get_size(comm_v) == vec_get_size(merge_v), "badcall: comm_dump_cstr %d %d", vec_get_size(comm_v), vec_get_size(merge_v))
	vec_null_terminate(merge_v)
	cstr *m = vec_get_start(merge_v)
	byte *c = vec_get_start(comm_v)
	while *m
		Sayf("%d\t%s", *c, *m)
		++m ; ++c

# is this "never" macro a good idea or just namespace pollution?
# IDEA instead of calling macros macros, just call them defs.

def never
	if 0

def ary_null(a)
	void *a[1]
	a[0] = NULL

def ary_null(a, a0)
	sametype(a, a0)[2]
	a[0] = a0
	a[1] = NULL

def ary_null(a, a0, a1)
	sametype(a, a0)[3]
	a[0] = a0 ; a[1] = a1
	a[2] = NULL

def ary_null(a, a0, a1, a2)
	sametype(a, a0)[4]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2
	a[3] = NULL

def ary_null(a, a0, a1, a2, a3)
	sametype(a, a0)[5]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3
	a[4] = NULL

def ary_null(a, a0, a1, a2, a3, a4)
	sametype(a, a0)[6]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4
	a[5] = NULL

def ary_null(a, a0, a1, a2, a3, a4, a5)
	sametype(a, a0)[7]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5
	a[6] = NULL

def ary_null(a, a0, a1, a2, a3, a4, a5, a6)
	sametype(a, a0)[8]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6
	a[7] = NULL

def ary_null(a, a0, a1, a2, a3, a4, a5, a6, a7)
	sametype(a, a0)[9]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7
	a[8] = NULL

def ary_null(a, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	sametype(a, a0)[10]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8
	a[9] = NULL

def ary_null(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	sametype(a, a0)[11]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8 ; a[9] = a9
	a[10] = NULL

def aryp_null(a)
	void *a[1]
	a[0] = NULL

def aryp_null(a, a0)
	sametype(*a, a0)[2]
	a[0] = &a0
	a[1] = NULL

def aryp_null(a, a0, a1)
	sametype(*a, a0)[3]
	a[0] = &a0 ; a[1] = &a1
	a[2] = NULL

def aryp_null(a, a0, a1, a2)
	sametype(*a, a0)[4]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2
	a[3] = NULL

def aryp_null(a, a0, a1, a2, a3)
	sametype(*a, a0)[5]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3
	a[4] = NULL

def aryp_null(a, a0, a1, a2, a3, a4)
	sametype(*a, a0)[6]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4
	a[5] = NULL

def aryp_null(a, a0, a1, a2, a3, a4, a5)
	sametype(*a, a0)[7]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5
	a[6] = NULL

def aryp_null(a, a0, a1, a2, a3, a4, a5, a6)
	sametype(*a, a0)[8]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6
	a[7] = NULL

def aryp_null(a, a0, a1, a2, a3, a4, a5, a6, a7)
	sametype(*a, a0)[9]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7
	a[8] = NULL

def aryp_null(a, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	sametype(*a, a0)[10]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8
	a[9] = NULL

def aryp_null(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	sametype(*a, a0)[11]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8 ; a[9] = &a9
	a[10] = NULL

def ary(a)
	void *a[0]

def ary(a, a0)
	sametype(a, a0)[1]
	a[0] = a0

def ary(a, a0, a1)
	sametype(a, a0)[2]
	a[0] = a0 ; a[1] = a1

def ary(a, a0, a1, a2)
	sametype(a, a0)[3]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2

def ary(a, a0, a1, a2, a3)
	sametype(a, a0)[4]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3

def ary(a, a0, a1, a2, a3, a4)
	sametype(a, a0)[5]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4

def ary(a, a0, a1, a2, a3, a4, a5)
	sametype(a, a0)[6]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5

def ary(a, a0, a1, a2, a3, a4, a5, a6)
	sametype(a, a0)[7]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7)
	sametype(a, a0)[8]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	sametype(a, a0)[9]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	sametype(a, a0)[10]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8 ; a[9] = a9

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	sametype(a, a0)[11]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8 ; a[9] = a9 ; a[10] = a10

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	sametype(a, a0)[12]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8 ; a[9] = a9 ; a[10] = a10 ; a[11] = a11

def ary(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
	sametype(a, a0)[13]
	a[0] = a0 ; a[1] = a1 ; a[2] = a2 ; a[3] = a3 ; a[4] = a4 ; a[5] = a5 ; a[6] = a6 ; a[7] = a7 ; a[8] = a8 ; a[9] = a9 ; a[10] = a10 ; a[11] = a11 ; a[12] = a12

def aryp(a)
	void *a[0]

def aryp(a, a0)
	sametype(*a, a0)[1]
	a[0] = &a0

def aryp(a, a0, a1)
	sametype(*a, a0)[2]
	a[0] = &a0 ; a[1] = &a1

def aryp(a, a0, a1, a2)
	sametype(*a, a0)[3]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2

def aryp(a, a0, a1, a2, a3)
	sametype(*a, a0)[4]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3

def aryp(a, a0, a1, a2, a3, a4)
	sametype(*a, a0)[5]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4

def aryp(a, a0, a1, a2, a3, a4, a5)
	sametype(*a, a0)[6]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5

def aryp(a, a0, a1, a2, a3, a4, a5, a6)
	sametype(*a, a0)[7]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6

def aryp(a, a0, a1, a2, a3, a4, a5, a6, a7)
	sametype(*a, a0)[8]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7

def aryp(a, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	sametype(*a, a0)[9]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8

def aryp(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	sametype(*a, a0)[10]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8 ; a[9] = &a9

def aryp(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	sametype(*a, a0)[11]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8 ; a[9] = &a9 ; a[10] = &a10

def aryp(a, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	sametype(*a, a0)[12]
	a[0] = &a0 ; a[1] = &a1 ; a[2] = &a2 ; a[3] = &a3 ; a[4] = &a4 ; a[5] = &a5 ; a[6] = &a6 ; a[7] = &a7 ; a[8] = &a8 ; a[9] = &a9 ; a[10] = &a10 ; a[11] = &a11



def eachp(i)
	never
		.

def eachp(i, a0)
	.
		let(i, &a0)
		.

def eachp(i, a0, a1)
	aryp(my(ary), a0, a1)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2)
	aryp(my(ary), a0, a1, a2)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3)
	aryp(my(ary), a0, a1, a2, a3)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4)
	aryp(my(ary), a0, a1, a2, a3, a4)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5)
	aryp(my(ary), a0, a1, a2, a3, a4, a5)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6, a7)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6, a7)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	forary(i, my(ary))
		.

def eachp(i, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	aryp(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	forary(i, my(ary))
		.

def each(e)
	never
		.

def each(e, a0)
	.
		let(e, a0)
		.

def each(e, a0, a1)
	ary(my(ary), a0, a1)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2)
	ary(my(ary), a0, a1, a2)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3)
	ary(my(ary), a0, a1, a2, a3)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4)
	ary(my(ary), a0, a1, a2, a3, a4)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5)
	ary(my(ary), a0, a1, a2, a3, a4, a5)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	forary(e, my(ary))
		.

def each(e, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
	ary(my(ary), a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
	forary(e, my(ary))
		.

def local(var, val)
	let(my(old), var)
	var = val
	post(x)
		var = my(old)
	pre(x)
		.

def implies(cond, then) cond ? then : 1

# abba is an "occult macro" that needs a double-indent, so the user needs to
# double indent the block! that looks ok with switch stuff though. It does
# things either in one order or the reverse order. Reminds me of Duff's device.
# I was going to use this in splice, but didn't.
# How unlikely that I will ever use this..
#
# e.g.:
#
# abba(toss())
# 	0	Say("hello")
# 	1	Say("world")

def abba(choice)
	each(my(i), choice, !choice)  # assuming booleans are 0 or 1 here.
		which(my(i))
			.

def memdup(src, n) memdup(src, n, 0)
void *memdup(const void *src, size_t n, size_t extra)
	void *dest = Malloc(n+extra)
	memcpy(dest, src, n)
	return dest

# this is an inplace grep
def grep(i, v, type, test)
	grep(i, v, type, test, void)
def grep(i, v, type, test, Free_or_void)
	grep(i, v, type, test, Free_or_void, my(o))
def grep(i, v, type, test, Free_or_void, o)
	type *o = vec0(v)
	for_vec(i, v, type)
		if test
			*o++ = *i
		 else
			Free_or_void(*i)
	vec_set_size(v, o-(type *)vec0(v))
	# does not call vec_squeeze, my dodgy uniq depends on that!

# e.g.:
#   uniq(i, v, cstr, !strcmp(i[0], i[1]), Free)
#   uniq(i, v, int, i[0] == i[1], void)
def uniq(i, v, type, eq)
	uniq(i, v, type, eq, void)
def uniq(i, v, type, eq, Free_or_void)
	if vec_get_size(v)
		vec_grow(v, -1)
		type *last = (type*)vecend(v)
		grep(i, v, type, !eq, Free_or_void)
		vec_push(v, *last)

# TODO grep and map that work with blocks instead of expressions:
# def grep(i, v, type, keep)
# problematic because of can't-multi-indent expansion issue

# TODO make map work with vec too?  normal map shouldn't be inplace though,
# because the types may be different.

cstr_set_add(vec *set, cstr s)
	for_vec(i, set, cstr)
		if cstr_eq(*i, s)
			return
	vec_push(set, s)

# this could be sped up if necessary
unsigned int bit_reverse(unsigned int x)
	int n = 0
	while x
		n <<= 1
		n |= (x & 1)
		x >>= 1
	return n

# get and put endian words, e.g. from binary files
# TODO 64 bit?

# this stuff assumes 8 bit bytes etc

def byte(p) (unsigned char)p[0]
def us(x) (unsigned long)x
def si(x) (long)x

def le2(p) byte(p) | (byte(p+1)<<8)
def le3(p) byte(p) | (byte(p+1)<<8) | (byte(p+2)<<16)
def le4(p) byte(p) | (byte(p+1)<<8) | (byte(p+2)<<16) | (byte(p+3)<<24)

def be2(p) (byte(p)<<8) | byte(p+1)
def be3(p) (byte(p)<<16) | (byte(p+1)<<8) | byte(p+2)
def be4(p) (byte(p)<<24) | (byte(p+1)<<16) | (byte(p+2)<<8) | byte(p+3)

def le2(p, i)
	p[0] = us(i) ; p[1] = (us(i)>>8)
def le3(p, i)
	p[0] = us(i) ; p[1] = (us(i)>>8) ; p[2] = (us(i)>>16)
def le4(p, i)
	p[0] = us(i) ; p[1] = (us(i)>>8) ; p[2] = (us(i)>>16) ; p[3] = (us(i)>>24)

def be2(p, i)
	p[0] = (us(i)>>8) ; p[1] = us(i)
def be3(p, i)
	p[0] = (us(i)>>16) ; p[1] = (us(i)>>8) ; p[2] = us(i)
def be4(p, i)
	p[0] = (us(i)>>24) ; p[1] = (us(i)>>16) ; p[2] = (us(i)>>8) ; p[3] = us(i)

def sbyte(p) ((long)byte(p)) << 24 >> 24

def sle2(p) ((long)le2(p)) << 16 >> 16
def sle3(p) ((long)le3(p)) << 8 >> 8
def sle4(p) ((long)le4(p))

def sbe2(p) ((long)be2(p)) << 16 >> 16
def sbe3(p) ((long)be3(p)) << 8 >> 8
def sbe4(p) ((long)be4(p))


def boolean(s) !among(*s, '\0', '0', 'n', 'N')

# version_ge TODO a-z

boolean version_ge(cstr v0, cstr v1)
	cstr digits = "0123456789"
	repeat
		int i = atoi(v0), j = atoi(v1)
		if i > j
			return 1
		if i < j
			return 0
		v0 += strspn(v0, digits) ; v0 += strcspn(v0, digits)
		v1 += strspn(v1, digits) ; v1 += strcspn(v1, digits)
		if *v0 == '\0'
			return 1
		if *v1 == '\0'
			return 0

cstr hashbang(cstr file)
	cstr exe
	F_in(file)
		exe = rl()
		if exe
			cstr_chomp(exe)
			if cstr_begins_with(exe, "#!") == 0
				cstr_chop_start(exe, exe+2)
			 else
				Free(exe)
	return exe

def dflt(p) dflt(p, "")
void *dflt(void *p, void *dflt)
	return p ? p : dflt

def call_each(macro)
	.
def call_each(macro, a0)
	macro(a0)
def call_each(macro, a0, a1)
	macro(a0)
	macro(a1)
def call_each(macro, a0, a1, a2)
	macro(a0)
	call_each(macro, a1, a2)
def call_each(macro, a0, a1, a2, a3)
	macro(a0)
	call_each(macro, a1, a2, a3)
def call_each(macro, a0, a1, a2, a3, a4)
	macro(a0)
	call_each(macro, a1, a2, a3, a4)
def call_each(macro, a0, a1, a2, a3, a4, a5)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17)
def call_each(macro, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18)
	macro(a0)
	call_each(macro, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18)

def i2p(i) (void*)(intptr_t)i
def p2i(p) (intptr_t)p

remove_null(vec *v)
	grep(i, v, void*, *i)
	vec_squeeze(v)

# uniqo and already keep a count
# the count will not ever go back to 0
# counting should not slow it down much compared to the hash lookups

def uniqo_default_hashsize 1001

def uniqo(v, hash, eq)
	uniqo(v, hash, eq, void)
def uniqo(v, hash, eq, Free_or_void)
	uniqo(v, hash, eq, Free_or_void, uniqo_default_hashsize)
def uniqo(v, hash, eq, Free_or_void, hashsize)
	uniqo(v, hash, eq, Free_or_void, hashsize, my(already_ht))
def uniqo(v, hash, eq, Free_or_void, hashsize, already_ht)
	uniqo_keep(v, hash, eq, Free_or_void, hashsize, already_ht)
	hashtable_free(already_ht)
def uniqo_keep(v, hash, eq, Free_or_void, hashsize, already_ht)
	new(already_ht, hashtable, hash, eq, hashsize)
	uniqo_cont(v, hash, eq, Free_or_void, already_ht)
def uniqo_cont(v, hash, eq, Free_or_void, already_ht)
	grep(i, v, void*, !already(already_ht, *i), Free_or_void)


void *orp(void *a, void *b)
	return a ? a : b

int ori(int a, int b)
	return a ? a : b

def nul_to_space(a, b) nul_to(a, b, ' ')

def nul_to_nl(a, b) nul_to(a, b, '\n')

cstr nul_to(char *a, char *b, char replacement)
	for(i, a, b)
		if !*i
			*i = replacement
	return a

uniq_vos(vec *v)
	uniqo(v, cstr_hash, cstr_eq)

uniq_vovos(vec *v)
	uniqo(v, vos_hash, vos_eq)


def cache(ht, key, init) cachekv(ht, key, init)->value
def cachekv(ht, key, init) (cache__ref = hashtable_lookup_ref(ht, key))->next ? (void)0 : hashtable_ref_add(cache__ref, key, i2p(init)), hashtable_ref_lookup(cache__ref)
list *cache__ref
  # cache is non reentrant at present, it uses this instead of a local variable

Def tok_paste(x, y) x^^y

#def isword(c) char_name2(c)

boolean isword(char c)
	return isalnum(c) || c == '_'

# these boolean ops evaluate the args more than once, so are of limited use

def or() 0
def or(a) a
def or(a, b) a ? a : b
def or(a, b, c) a ? a : b ? b : c

def and() 1
def and(a) a
def and(a, b) a ? b : 0
def and(a, b, c) a ? b ? c : 0 : 0

# these boolean ops create a variable and use it as a temporary,
# and evaluate each arg only once

def Or(v)
	let(v, 0)
def Or(v, a)
	let(v, a)
def Or(v, a, b)
	let(v, a)
	if !v
		v = b
def Or(v, a, b, c)
	let(v, a)
	if !v
		v = b
		if !v
			v = c

def And(v)
	let(v, 1)
def And(v, a)
	let(v, a)
def And(v, a, b)
	let(v, a)
	if v
		v = b
def And(v, a, b, c)
	let(v, a)
	if v
		v = b
		if v
			v = c

Def back_vec(i, v, type)
	state type *my(end) = (type *)vec0(v)-1
	state type *my(i1) = (type *)vecend(v)-1
	for ; my(i1)!=my(end) ; --my(i1)
		let(i, my(i1))
		.
