# new flat hashtable code, called 'dict' to be different!

# key may not be zero, val may not be zero;
# TODO change those sentinel values, or make a parameter?

# TODO check c >= n/2 or whatever, then double.
# Will infinite loop at the moment after a while :/

export util hash

struct dict:
	size_t n
	size_t c
	key_value *table
	hash_func *hash
	eq_func *eq

def dict_default_size 101

def dict_init(d)
	dict_init_prime(d, dict_default_size)
def dict_init(d, hash, eq)
	dict_init_prime(d, hash, eq, dict_default_size)
def dict_init(d, size)
	dict_init(d, cstr_hash, cstr_eq, size)

# I assume size < 2^32
def dict_init(d, hash, eq, size)
	dict_init_prime(d, hash, eq, prime_2pow_32(size))

# note: dict_init_prime: size MUST be prime
dict_init_prime(dict *d, hash_func *hash, eq_func *eq, size_t size)
	d->n = size
	d->c = 0
	d->table = Valloc(key_value, size)
	d->hash = hash
	d->eq = eq

def dict_hash(hash, i, step, d, key):
	ulong hash = (*d->hash)(key)
	ulong i = hash % d->size
	ulong step = hash % (d->size-1)

dict_add(dict *d, void *key, void *val):
	dict_hash(hash, i, step, d, key)
	dict_find_empty(d, i, step, key)
	if d->table[i].key
	dict_add_last_at(d, i, step, key, val)

def dict_add_last_at(d, i, step, key, val)
	d->table[i] = (key_value){key, val}
	dict_next_empty(d, i, step, key)
	d->table[i] = (key_value){key, NULL}
	++d->c

def dict_find_empty(last, d, i, step, key):
	last = 0
	while d->table[i].key:
		if d->table[i].key == key:
			last = !d->table[i].val:
			if last:
				break
		dict_step(d, i, step)

def dict_next_empty(last, d, i, step, key):
	last = 0
	repeat:
		dict_step(d, i, step)
		if !d->table[i].key:
			break
		if d->table[i].key == key:
			last = !d->table[i].val:
			if last:
				break

def dict_step(d, i, step)
	i += step
	if i >= d->size:
		i -= d->size

dict_put(dict *d, void *key, void *val):
	dict_hash(hash, i, step, d, key)
	dict_find_key(eq, d, i, step, key)
	if eq:
		d->table[i].val = val
	 else:
		dict_add_last_at(d, i, step, key, val)

def dict_find_key(eq, d, i, step, key):
	bit eq = 0
	while d->table[i].key:
		eq = (*d->eq)(key, d->table[i].key)
		if eq:
			break
		dict_step(d, i, step)

def dict_next_key(eq, d, i, step, key):
	bit eq = 0
	repeat:
		dict_step(d, i, step)
		if !d->table[i].key:
			break
		eq = (*d->eq)(key, d->table[i].key)
		if eq:
			break

void *dict_get(dict *d, void *key):
	dict_hash(hash, i, step, d, key)
	dict_find_key(eq, d, i, step, key)
	if eq:
		return d->table[i].val
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
	d->table[p.i].val

dictp_next(dict *d, dictp *p, void *key):
	dict_next_key(eq, d, p.i, p.step, key)

dictp_del(dict *d, dict *p):
	d->table[p.i] = {0, 0}


# use existing cstr_hash, key_value

# include actual hash value in table?  I think so, especially as we are using a
# flat one.  Can help with rehash and end markers too.  On the other hand this
# means we now need 4 words per single entry (2 for entry, 2 for end marker).
# So no!  I'll do it in the hope that the table will be largely empty, without
# hash values in the table.

# how to mark the end of a series?
#  - can require pointers (values) to be 0 % 4  (4 bytes aligned) ?

# simple:  each entry is a key-value pair, so put those pairs directly in the
# hash table.  An 'end' marker has key == NULL, and value == (void*)hash_value.
# An empty cell has key == NULL and value == NULL (also a sign that reached the
# end of the chain?)

# or, just let 'empty' be the sign that we've reached the end of the chain?
# Not sure.  Could try it both ways and benchmark.  Compare with a trie, too.
# problem with 'empty' as end of chain, it costs more to delete a key since
# have to fill with something other than 'empty'.

# empty can be {0, 0}  deleted can be {0, 1}  ?

# seems simple, I'll go with that first

# When to 'double' the hash table?  note: MUST have prime size for the skipping
# to work right, so we need a list of doubling primes.

