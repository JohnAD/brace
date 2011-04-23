export hash cstr vec
use io

meta_init()
	NEW(type_ix, hashtable, 1009)

type_add(type *t)
	cstr name = t->name
	put(type_ix, name, t)
	if among(t->type, TYPE_STRUCT, TYPE_UNION)
		decl_cast(s, type__struct_union, t)
		for(i, 0, s->n)
			cstr element_name = Format("%s.%s", name, s->e[i].name)
			put(type_ix, element_name, i)

type *type_get(cstr name)
	return get(type_ix, name)

read_structs(vec *v, type__struct_union *t)
	while read_struct(vec_push(v), t)
		.
	vec_pop(v)

write_structs(vec *v, type__struct_union *t)
	for_vec(i, v)
		write_struct(i, t)

# TODO how about "comments" aka markup in the file?
# maybe don't allow nested objects / hierarchical trees, use refs instead..?
# option for extra fields added to an "extra" catch all list or hash in each struct :)

def read_struct(s, t) read_struct(s, t, OE_ERROR)
int read_struct(void *s, type__struct_union *t, opt_err unknown_key)
	zero((char*)s, (char*)s+t->t.size)
	cstr name = t->t.name
	new(b, buffer, 64)
	boolean more = 0
	long i = 0
	long n = t->n
	Eachline(l)
		scan_kv(l, k, v)
		if *k
			if !v
				error("read_struct: missing delimiter after key: %s", k)
			make_name(lc(k))
			type__element *e
			repeat
				if i==n
					Sprintf(b, "%s.%s", name, k)
					int i = p2i(get(type_ix, buffer_add_nul(b), -1))
					bufclr(b)
					if i == -1
						if !opt_err_do(unknown_key, (any){.i=1}, (any){.i=0}, "read_struct: unknown key: %s", k).i
							return 0
						 else
							skip
					e = &t->e[i]
					break
				e = &t->e[i]
				if cstr_eq(k, e->name)
					break
				++i
			char *p = (char*)s + e->offset
			if among(e->type, (type*)t_cstr, (type*)t_char_p)
				*(cstr*)p = Strdup(v)
			 eif among(e->type, (type*)t_int, (type*)t_unsigned_int, (type*)t_signed_int)
				sc(int, v, *(int*)p)
			 eif among(e->type, (type*)t_short, (type*)t_unsigned_short, (type*)t_signed_short)
				sc(short, v, *(short*)p)
			 eif among(e->type, (type*)t_char, (type*)t_unsigned_char, (type*)t_signed_char)
				sc(char, v, *(char*)p)
			 eif among(e->type, (type*)t_long, (type*)t_unsigned_long, (type*)t_signed_long)
				sc(long, v, *(long*)p)
			 eif among(e->type, (type*)t_long_long, (type*)t_unsigned_long_long, (type*)t_signed_long_long)
				sc(long_long, v, *(long_long*)p)
			 eif e->type == (type*)t_float
				sc(float, v, *(float*)p)
			 eif e->type == (type*)t_double
				sc(double, v, *(double*)p)
			 eif e->type == (type*)t_long_double
				sc(long_double, v, *(long_double*)p)
			 else
				error("read_struct: only cstr, integer and floating point members, not type %s", e->type->name)
		 else
			more = 1
			break
skip		.

	if more == 0 && i>0
		error("read_struct: missing newline before EOF")
		# to avoid truncated records

	buffer_free(b)
	return more

def write_struct(s, t) write_struct(s, t, OE_ERROR)
boolean write_struct(void *s, type__struct_union *t, opt_err unknown_type)
	for(i, 0, t->n)
		type__element *e = &t->e[i]
		char *p = (char*)s + e->offset
		if among(e->type, (type*)t_cstr, (type*)t_char_p)
			if *(cstr*)p
				pr(cstr, e->name)
				Pr(cstr, *(cstr*)p)
		 else
			pr(cstr, e->name)
			if among(e->type, (type*)t_int, (type*)t_signed_int)
				Pr(int, *(int*)p)
			 eif among(e->type, (type*)t_short, (type*)t_signed_short)
				Pr(short, *(short*)p)
			 eif among(e->type, (type*)t_char, (type*)t_signed_char)
				Pr(char, *(char*)p)
			 eif among(e->type, (type*)t_long, (type*)t_signed_long)
				Pr(long, *(long*)p)
			 eif among(e->type, (type*)t_long_long, (type*)t_signed_long_long)
				Pr(long_long, *(long_long*)p)
			 eif among(e->type, (type*)t_unsigned_int)
				Pr(unsigned_int, *(unsigned_int*)p)
			 eif among(e->type, (type*)t_unsigned_short)
				Pr(unsigned_short, *(unsigned_short*)p)
			 eif among(e->type, (type*)t_unsigned_char)
				Pr(unsigned_char, *(unsigned_char*)p)
			 eif among(e->type, (type*)t_unsigned_long)
				Pr(unsigned_long, *(unsigned_long*)p)
			 eif among(e->type, (type*)t_unsigned_long_long)
				Pr(unsigned_long_long, *(unsigned_long_long*)p)
			 eif e->type == (type*)t_float
				Pr(float, *(float*)p)
			 eif e->type == (type*)t_double
				Pr(double, *(double*)p)
			 eif e->type == (type*)t_long_double
				Pr(long_double, *(long_double*)p)
			 else
				if !opt_err_do(unknown_type, (any){.i=1}, (any){.i=0},
				 "write_struct: only cstr, integer and floating point members, not type %s", e->type->name).i
					return 0
	sf()
	return 1

struct type__element
	type *type
	cstr name
	long offset
#	short bits
#	short offset_bit


typedef enum { TYPE_VOID, TYPE_INT, TYPE_FLOAT, TYPE_POINT, TYPE_ARRAY, TYPE_STRUCT, TYPE_UNION, TYPE_FUNC, TYPE_DEF } type_t

typedef enum { SIGNED_NORMAL, SIGNED_SIGNED, SIGNED_UNSIGNED=-1 } signed_t

struct type__size
	int size
	int var_size

type__size type__sizes[] =
	{ sizeof(type__void), 0 },
	{ sizeof(type__int), 0 },
	{ sizeof(type__float), 0 },
	{ sizeof(type__point), 0 },
	{ sizeof(type__array), sizeof(int) },
	{ sizeof(type__struct_union), sizeof(type__element) },
	{ sizeof(type__struct_union), sizeof(type__element) },
	{ sizeof(type__func), sizeof(type *) },
	{ sizeof(type__def), 0 }

struct type
	type_t type
	cstr name
	long size

struct type__void
	type t

struct type__int
	type t
	signed_t sign

struct type__float
	type t

struct type__point
	type t
	type *ref

struct type__array
	type t
	int dims
	type *ref
	int n[]

struct type__struct_union
	type t
	long n
	type__element e[]

struct type__func
	type t
	int n
	type *ret
	type *arg[]

struct type__def
	type t
	type *ref

type__int t_ints[] =
	{ { TYPE_INT, "int", sizeof(int) }, SIGNED_NORMAL },
	{ { TYPE_INT, "char", sizeof(char) }, SIGNED_NORMAL },
	{ { TYPE_INT, "short", sizeof(short) }, SIGNED_NORMAL },
	{ { TYPE_INT, "long", sizeof(long) }, SIGNED_NORMAL },
	{ { TYPE_INT, "long long", sizeof(long long) }, SIGNED_NORMAL },

	{ { TYPE_INT, "signed int", sizeof(signed int) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed char", sizeof(signed char) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed short", sizeof(signed short) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed long", sizeof(signed long) }, SIGNED_SIGNED },
	{ { TYPE_INT, "signed long long", sizeof(signed long long) }, SIGNED_SIGNED },

	{ { TYPE_INT, "unsigned int", sizeof(unsigned int) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned char", sizeof(unsigned char) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned short", sizeof(unsigned short) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned long", sizeof(unsigned long) }, SIGNED_UNSIGNED },
	{ { TYPE_INT, "unsigned long long", sizeof(unsigned long long) }, SIGNED_UNSIGNED }

def t_int t_ints + 0
def t_char t_ints + 1
def t_short t_ints + 2
def t_long t_ints + 3
def t_long_long t_ints + 4

def t_signed_int t_ints + 5
def t_signed_char t_ints + 6
def t_signed_short t_ints + 7
def t_signed_long t_ints + 8
def t_signed_long_long t_ints + 9

def t_unsigned_int t_ints + 10
def t_unsigned_char t_ints + 11
def t_unsigned_short t_ints + 12
def t_unsigned_long t_ints + 13
def t_unsigned_long_long t_ints + 14

type__float t_floats[] =
	{ { TYPE_FLOAT, "float", sizeof(float) } },
	{ { TYPE_FLOAT, "double", sizeof(double) } },
	{ { TYPE_FLOAT, "long double", sizeof(long double) } }

def t_float t_floats + 0
def t_double t_floats + 1
def t_long_double t_floats + 2

type__void t_voids[] =
	{ { TYPE_VOID, "void", 0 } }

def t_void t_voids + 0

type__point t_points[] =
	{ { TYPE_POINT, "char *", sizeof(char *) }, &t_char->t },
	{ { TYPE_POINT, "void *", sizeof(void *) }, &t_void->t }

def t_char_p t_points + 0
def t_void_p t_points + 1

type__def t_defs[] =
	{ { TYPE_DEF, "cstr", sizeof(cstr) }, &t_char_p->t }

def t_cstr t_defs + 0

hashtable struct__type_ix, *type_ix = &struct__type_ix

def struct_ref(s, offset) (void *)(((char *)s)+offset)
def struct_ref_ptr(s, offset) (void **)struct_ref(s, offset)
def struct_ref_int(s, offset) (int *)struct_ref(s, offset)

def struct_set_ptr(s, offset, value) *struct_ref_ptr(s, offset) = value
def struct_get_ptr(s, offset) *struct_ref_ptr(s, offset)
