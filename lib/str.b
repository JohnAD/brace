use string.h stdlib.h
use alloc buffer cstr util

# this (together with rope.b) is the way I think strings ought to be done

# NB pass strings by pointer (not by value) _consistently_
# NB use either "length" or "size" everywhere, not both?

# TODO redefine buffer in terms of str?

# the law of str:
# every str must have a mutable byte after it (i.e. alloc an extra byte for
# each str) so it can be temporarily converted to a cstr easily by putting a
# '\0' there and then changing it back  :)  nice idea

struct str
	char *start
	char *end

# NEED an abbrev for this?
str new_str(char *start, char *end)
	str s = {start, end}
	return s

str str_null = { NULL, NULL }
def str_is_null(s) s.end == NULL
def str_is_empty(s) s.start == s.end

def str_get_size(s) s.end - s.start
def str_get_start(s) s.start
def str_get_end(s) s.end

str str_dup(str s)
	size_t size = str_get_size(s)
	# TODO in this context, "size" should be implicitly defined as above
	let(ret, str_of_size(size))
	str_copy(ret.start, s)
	return ret

str str_of_size(size_t size)
	str ret
	ret.start = Malloc(size)
	ret.end = ret.start + size
	return ret

# XXX is the to, from syntax sensible?  it's counter-intuitive.
char *str_copy(char *to, str from)
	size_t size = str_get_size(from)
	memmove(to, from.start, size)
	# XXX is memmove significantly less efficient than memcpy??
	return to+size

str_free(str s)
	Free(s.start)
	# str_null(s)

# this mallocs a new buffer for the cstr
# this should be in cstr.b, but I'm afraid of the mk_cc bug!
cstr cstr_from_str(const str s)
	int size = str_get_size(s)
	let(cs, cstr_of_size(size))
	strlcpy(cs, s.start, size+1)
	return cs

def str_from_buffer(b) *(str *)b
 # buffers are "str-compatible"

str str_cat_2(str s1, str s2)
	size_t s1_size = str_get_size(s1)
	size_t s2_size = str_get_size(s2)
	let(ret, str_of_size(s1_size + s2_size))
	str_copy(ret.start, s1)
	str_copy(ret.start + s1_size, s2)
	return ret

str str_cat_3(str s1, str s2, str s3)
	size_t s1_size = str_get_size(s1)
	size_t s2_size = str_get_size(s2)
	size_t s3_size = str_get_size(s3)
	let(ret, str_of_size(s1_size + s2_size + s3_size))
	str_copy(ret.start, s1)
	str_copy(ret.start + s1_size, s2)
	str_copy(ret.start + s1_size + s2_size, s3)
	return ret

def str_cat(a, b) str_cat_2(a, b)
def str_cat(a, b, c) str_cat_3(a, b, c)

# TODO a coherent function-form / relational-form return value system
#   the CALLER declares the space for the return value, and passes in a pointer
#   to it, or else receives a register value.

str str_from_char(char c)
	let(ret, str_of_size(1))
	*ret.start = c
	return ret

str str_from_cstr(cstr cs)
	return new_str(cstr_range(cs))
def S(cs) str_from_cstr(cs)
def CS(cs) cstr_from_str(cs)  # XXX conflicts with South!
 # this is for use mid-expression, especially with cstr literals

 # TODO need a better syntax for const literal strs
 # TODO need printf etc replacements that support strs / ropes, not just cstrs

## use memmem!
#
#char *find_str(char *haystack0, char *haystack1, char *needle0, char *needle1)
#	let(end, haystack1 - (needle1-needle0) + 1)
#	for(imy(i), haystack0 ; i!=end ; ++i

Def str_range(s) s.start, s.end

str_dump(str s)
	memdump(str_range(s))

char *str_chr(str s, char c)
	return memchr(s.start, c, str_get_size(s))

str str_null = { NULL, NULL }

str str_str(str haystack, str needle)
	str rv
	rv.start = mem_mem(haystack.start, str_get_size(haystack),
	  needle.start, str_get_size(needle))
	if rv.start == NULL
		return str_null
	rv.end = rv.start + str_get_size(needle)
	return rv

cstr *str_str_start(str haystack, str needle)
	return mem_mem(haystack.start, str_get_size(haystack),
	  needle.start, str_get_size(needle))

fprint_str(FILE *stream, str s)
	fprint_range(stream, str_get_start(s), str_get_end(s))
	#Fwrite(str_get_start(s), 1, str_get_size(s), stream)

#prints_and_says(str)

print_str(str s)
	fprint_str(stdout, s)

fsay_str(FILE *stream, str s)
	fprint_str(stream, s)
	nl(stream)

say_str(str s)
	fsay_str(stdout, s)
