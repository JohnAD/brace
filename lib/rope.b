export str buffer vec types util
use alloc cstr error io deq

# this (together with str.b) is the way I think strings ought to be done

struct ropev
	rope *end
	rope *start
 # end comes before start so that we can distinguish a str from a ropev:

union rope
	str s
	ropev v

def rope_set_null(r) r.s.end = NULL

def rope_is_a_str(r) r.s.start <= r.s.end
def rope_is_a_ropev(r) r.v.start <= r.v.end

def ropev_is_null(v) v.start == NULL
def ropev_is_empty(r) r.v.start == r.v.end

def rope_is_null(r) r.s.end == NULL
def rope_is_empty(r) r.s.start == r.s.end

def cast_to_rope(str_or_ropev) *(rope *)&str_or_ropev
#def cast_to_rope(str_or_ropev) (rope)str_or_ropev

size_t rope_get_size(rope r)
	if rope_is_a_str(r)
		return str_get_size(r.s)
	 else
		return ropev_get_size(r.v)

ropev ropev_ref(rope *start, rope *end)
	ropev v = { end, start }
	return v

ropev ropev_of_size(int size)
	ropev v
	v.start = Nalloc(rope, size)
	v.end = v.start + size
	return v

size_t ropev_get_size(ropev v)
 # this gets the total length of the string, not the number of component strings
	size_t size = 0
	for(i, ropev_range(v))
		size += rope_get_size(*i)
	return size

str str_from_rope(rope r)
	let(s, str_of_size(rope_get_size(r)))
	rope_flatten(s.start, r)
	return s

cstr cstr_from_rope(rope r)
	cstr cs = cstr_of_size(rope_get_size(r) + 1)
	rope_flatten(cs, r)
	return cs

char *rope_flatten(char *to, rope r)
	if rope_is_empty(r)
		return to
	eif rope_is_a_str(r)
		return str_copy(to, r.s)
	else
		return ropev_flatten(to, r.v)

char *ropev_flatten(char *to, ropev v)
	for(i, ropev_range(v))
		to = rope_flatten(to, *i)
	return to

rope rope_cat_2(rope r1, rope r2)
	let(v, ropev_of_size(2))
	rope *p = v.start
	*p++ = r1
	*p = r2
	return cast_to_rope(v)

rope rope_cat_3(rope r1, rope r2, rope r3)
	let(v, ropev_of_size(3))
	rope *p = v.start
	*p++ = r1
	*p++ = r2
	*p = r3
	return cast_to_rope(v)

use stdarg.h

Def ropev_range(v) (rope *)v.start, (rope *)v.end

rope rope_cat_n(size_t n, ...)
	collect(vrope_cat_n, n)

rope vrope_cat_n(size_t n, va_list ap)
	let(v, ropev_of_size(n))
	for(i, ropev_range(v))
		*i = va_arg(ap, rope)
	return cast_to_rope(v)

# these functions want to be called with "rope" args, not "rope *" args...??

def rope_from_cstr(cs) cast_to_rope(str_from_cstr(cs))

def r(cs) rope_from_cstr(cs)
def r(a, b) rope_cat_2(a, b)
def r(a, b, c) rope_cat_3(a, b, c)
def r(a, b, c, d) rope_cat_n(4, a, b, c, d)
def r(a, b, c, d, e) rope_cat_n(5, a, b, c, d, e)

def R(r) cstr_from_rope(r)

def rope_dump(r)
	rope_dump(r, 0)
	nl(stderr)

rope_dump(rope r, int indent)
	tabs(stderr, indent)
	if rope_is_empty(r)
		warn("empty")
	eif rope_is_a_str(r)
		cstr s = S(r.s)
		warn("str >%s<", s)
		Free(s)
	else
		warn("ropev: %d", ropev_get_size(r.v))
		ropev_dump(r.v, indent+1)

ropev_dump(ropev v, int indent)
	for(i, ropev_range(v))
		rope_dump(*i, indent)


# rope_p

# bitfields for the flag type
# TODO a nice bitfield / enum / flags type for brace?
# auto-squeeze option for enum types?

int rope_p_char = 0
int rope_p_rope = 1
int rope_p_start = 0
int rope_p_end = 1
int rope_p_on = 2

struct rope_p
	vec stack
#	enum { rope_p_char, rope_p_rope } ref_type:8
#	enum { rope_p_start, rope_p_end, rope_p_on } where:8
	uchar ref_type
	uchar where

rope_p_init(rope_p *rp, size_t space)
	vec_init(&rp->stack, void *, space)
def rope_p_init(rope_p *rp) rope_p_init(rp, 1)

rope_p_free(rope_p *rp)
	vec_free(&rp->stack)

rope_p rope_start(rope r)
	new(rp, rope_p)
	vec_push(&rp->stack, r)
	rp->ref_type = rope_p_rope
	rp->where = rope_p_start
	return *rp

rope_p rope_end(rope r)
	new(rp, rope_p)
	vec_push(&rp->stack, r)
	rp->ref_type = rope_p_rope
	rp->where = rope_p_end
	return *rp

boolean rope_p_is_a_rope(rope_p *rp)
	return rp->ref_type == rope_p_rope
boolean rope_p_is_a_char(rope_p *rp)
	return rp->ref_type == rope_p_char

rope_p_enter(rope_p *rp)
	assert(rope_p_is_a_rope(rp), "rope_p: cannot enter, already at char level")
	rope p = *(rope *)vec_top(&rp->stack)
	assert(!rope_is_empty(p), "rope_p: cannot enter, rope is empty")
	assert(!rope_is_null(p), "rope_p: cannot enter, rope is null (it shouldn't be!)")
	assert(rp->where != rope_p_on, "rope_p: cannot enter, where == on")

	if rope_is_a_str(p)
		if rp->where == rope_p_start
#			vec_push(&rp->stack, p.s.start-1)
#			rp->where = rope_p_end
			vec_push(&rp->stack, p.s.start)
		 else
			vec_push(&rp->stack, p.s.end)
			rp->where = rope_p_start
		rp->ref_type = rope_p_char
	 else
		if rp->where == rope_p_start
			vec_push(&rp->stack, p.v.start)
		 else
			vec_push(&rp->stack, p.v.end)

boolean rope_p_at_top(rope_p *rp)
	return vec_get_size(&rp->stack) == 1

rope_p_leave(rope_p *rp)
	assert(!rope_p_at_top(rp), "rope_p: cannot leave, already at top level")
	vec_pop(&rp->stack)

rope_p_next(rope_p *rp)
	use(rp)

# all this is reminiscent of ved!  is it bogus?

rope_p_dup(rope_p *to, rope_p *from)
	vec_dup(&to->stack, &from->stack)
	to->ref_type = from->ref_type
	to->where = from->where

# TODO subropes... , balancing, auto-balancing?, test it!


# TODO automatic dup functions, like C++

# TODO strv?

# TODO convert strv to a vec of iovec for writev compatibility?
# <sys/uio.h>
# typedef struct iovec iovec


def SPC r(" ")
def NL r("\n")
def TAB r("\t")

fprint_rope(FILE *stream, rope r)
	for_str_in_rope(s, r)
		fprint_str(stream, s)
	# TODO use writev?

# this doesn't work, need to run macros before splitting to headers?
#prints_and_says(rope)

print_rope(rope r)
	fprint_rope(stdout, r)

fsay_rope(FILE *stream, rope r)
	fprint_rope(stream, r)
	nl(stream)

say_rope(rope r)
	fsay_rope(stdout, r)

# brace_shuffle is borked
#typedef void (*str_f)(str s)
#
#rope_each_str(rope r, void (*f)(str s))
#	if rope_is_empty(r)
#		.
#	 eif rope_is_a_str(r)
#		(*f)(r.s)
#	 else
#		ropev_each_str(r.v, f)
#
#ropev_each_str(ropev v, void (*f)(str s))
#	for(i, ropev_range(v))
#		rope_each_str(*i, f)

def for_str_in_rope(S, R)
	new(my(q), deq, rope)
	deq_push(my(q), R)
	rope my(r)
	while deq_get_size(my(q))
		deq_shift(my(q), my(r))
		if rope_is_empty(my(r))
			continue
		 eif rope_is_a_ropev(my(r))
		 	for(i, ropev_range(my(r).v))
				deq_push(my(q), my(r))
			continue
		let(S, my(r).s)
