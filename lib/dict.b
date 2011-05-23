# new flat hashtable code, called 'dict' to be different!

# key may not be zero, val may not be zero;
# TODO? change those sentinel values, or make a parameter?

# TODO check c >= n/2 or whatever, then double.
# Will infinite loop at the moment if it gets full :/

export util hash alloc

struct dict:
	size_t size
	size_t count
	key_value *table
	hash_func *hash
	eq_func *eq

def dict_default_size 101

# I assume size < 2^32
def dict_init(d)
	dict_init_prime(d, dict_default_size)
def dict_init(d, size)
	dict_init(d, cstr_hash, cstr_eq, size)
def dict_init(d, hash, eq)
	dict_init_prime(d, hash, eq, dict_default_size)
def dict_init(d, hash, eq, size)
	dict_init_prime(d, hash, eq, prime_2pow_32(size))

# note: dict_init_prime: size MUST be prime
def dict_init_prime(d, size)
	dict_init_prime(d, cstr_hash, cstr_eq, size)
dict_init_prime(dict *d, hash_func *hash, eq_func *eq, size_t size)
	d->size = size
	d->count = 0
	d->table = Valloc(key_value, size)
	d->hash = hash
	d->eq = eq

def dict_hash(hash, i, step, d, key):
	ulong hash = (*d->hash)(key)
	ulong i = hash % d->size
	ulong step = hash % (d->size-1) + 1

dict_add(dict *d, void *key, void *val):
	dict_hash(hash, i, step, d, key)
	dict_find_empty(d, i, step, key)
	dict_add_at(d, i, key, val)

def dict_add_at(d, i, key, val)
	d->table[i] = (key_value){key, val}
	++d->count

def dict_find_empty(d, i, step, key):
	while d->table[i].k:
		dict_step(d, i, step)

def dict_next_empty(last, d, i, step, key):
	do:
		dict_step(d, i, step)
	 while !d->table[i].k

def dict_step(d, i, step)
	i += step
	if i >= d->size:
		i -= d->size

void *dict_put(dict *d, void *key, void *val):
	void *old
	dict_hash(hash, i, step, d, key)
	dict_find_key(eq, d, i, step, key)
	if eq:
		old = d->table[i].v
		d->table[i].v = val
	 else:
		dict_add_at(d, i, key, val)
		old = NULL
	return old

def dict_find_key(eq, d, i, step, key):
	bit eq = 0
	while d->table[i].k:
		eq = (*d->eq)(key, d->table[i].k)
		if eq:
			break
		dict_step(d, i, step)

def dict_next_key(eq, d, i, step, key):
	bit eq = 0
	repeat:
		dict_step(d, i, step)
		if !d->table[i].k:
			break
		eq = (*d->eq)(key, d->table[i].k)
		if eq:
			break

void *dict_get(dict *d, void *key):
	dict_hash(hash, i, step, d, key)
	dict_find_key(eq, d, i, step, key)
	if eq:
		return d->table[i].v
	return NULL

struct dictp:
	ulong i
	ulong step

dictp dict_find(dict *d, void *key):
	dict_hash(hash, i, step, d, key)
	dict_find_key(eq, d, i, step, key)
	if eq:
		return (dictp){i, step}
	return (dictp){-1, 0}

def dictp(p) p->step

def dictp_val(d, p):
	d->table[p.i].v

dictp_next(dict *d, dictp *p, void *key):
	dict_next_key(eq, d, p->i, p->step, key)

#dictp_del(dict *d, dictp *p):
#	d->table[p.i] = {0, 0}

# XXX this is only for benchmark, not ok for multi-valued keys
bit dict_del1(dict *d, void *key):
	dict_hash(hash, i, step, d, key)
	dict_find_key(eq, d, i, step, key)
	if eq:
		d->table[i] = (key_value){0, 0}
	return eq
