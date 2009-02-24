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

Def let(to, from) sametype(to, from) = from

Def sametype(to, ref) typeof(ref) to

#Def castto(from, type) (*(type *)&(from))
Def castto(from, type) ((type)(from))
Def castto_ref(from, ref) castto(from, typeof(ref))

Def for(v)
	for(v, v^^0, v^^1)

Def for(v, ary)
	for(v, ary^^0, ary^^1)

def for(v, from, to)
	let(my(end), to)
	for let(v, from); v<my(end); ++v

def for(v, from, to, step)
	let(my(end), to)
	let(my(st), step)
	for let(v, from); v<my(end); v+=my(st)

def for_keep(v, from, to)
	let(v, from)
	let(my(end), to)
	for ; v<my(end); ++v

def for_keep(v, from, to, step)
	let(v, from)
	let(my(end), to)
	let(my(st), step)
	for let(v, from); v<my(end); v+=my(st)

def repeat(n)
	for(my(i), 0, n)

def back(v, from, to)
	let(my(end), to)
	for let(v, from); v>my(end); --v

def back(v, from, to, step)
	let(my(end), to)
	let(my(st), step)
	for let(v, from); v>my(end); v-=my(st)

def for_step(i, d)
	let(my(end), i^^1+d/2)
	for i = i^^0 ; i < my(end) ; i+=d

def map(out, in, func)
	for(in)
		*out = func
		++ out

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

Def ptr(var, type)
	type *var

Def stack(var, type)
	type struct__^^var
	var = &struct__^^var

Def heap(var, type)
	var = Talloc(type)

#Def decl(var, type)
#	ptr(var, type)
#	stack(var, type)

# This decl can be used as a global too, not in a struct though.

Def decl(var, type)
	type struct__^^var
	type *var = &struct__^^var
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
	let(my(tmp), b)
	b = a
	a = my(tmp)

# FIXME why v?

def eachline(v)
	eachline(v, stdin)

def eacharg(a)
	for(my(i), arg, arg+args)
		let(a, *my(i))
		if a == NULL
			break

def eachline(v, stream)
	new(my(b), buffer)
	repeat
		buffer_clear(my(b))
		if Freadline(my(b), stream)
			break
		char *v = buffer_get_start(my(b))

# can't do this because of recursion; need a way to map which is non-recursive
#def ln log
#def log log10

def Id(x) x

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
	warn("%08x = %s", obj, name)

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

def use(v) v=v

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
#def tweenx(a, low, high) a >= low && a < high
#def tweenX(a, low, high) a > low && a < high

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

def sort_num_array(x)
	qsort(x, array_size(x), sizeof(*x), num_cmp)

int num_cmp(const void *a, const void *b)
	num diff = *(num*)a - *(num*)b
	if num_eq(diff, 0)
		return 0
	 eif diff < 0
		return -1
	 else
		return 1

def sort_int_array(x)
	qsort(x, array_size(x), sizeof(*x), int_cmp)

int int_cmp(const void *a, const void *b)
	int diff = *(int*)a - *(int*)b
	return diff

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
