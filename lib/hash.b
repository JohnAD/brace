export list cstr types vec util
use alloc m error

# TODO base this on a hashset ?
# maybe I should use (wrap) the glib hashtable for now?
# surely glib has lots of useful stuff

# TODO make hashtable work as a multi-hash by default,
# i.e. "add" always adds a new node...

# TODO use the hashtable itself for storage?  this would probably be more
# efficient overall.  maybe

struct hashtable
	list *buckets
	size_t size
	hash_func *hash
	eq_func *eq

# hashtable abbrevs:

def Get(ht, key) hashtable_value(ht, i2p(key))
def get(ht, key) hashtable_value_or_null(ht, i2p(key))
def get(ht, key, value) hashtable_value_or(ht, i2p(key), i2p(value))
def put(ht, key, value) hashtable_add(ht, i2p(key), i2p(value))
def kv(ht, key) hashtable_lookup(ht, i2p(key))
def del(ht, key) hashtable_delete(ht, i2p(key))
def KV(ht, key) hashtable_lookup_or_die(ht, i2p(key))
def kv(ht, key, init) hashtable_lookup_or_add_key(ht, i2p(key), i2p(init))
def already(ht, key) hashtable_already(ht, i2p(key))

def set(ht, key, value)
	set(ht, key, value, void)
def set(ht, key, value, free_or_void)
	hashtable_set(ht, key, value, free_or_void)

def hashtable_set(ht, k, v, free_or_void)
	let(my(kv), kv(ht, k, NULL))
	if my(kv)->value
		free_or_void(my(kv)->value)
	my(kv)->value = i2p(v)

# TODO, simplify hashtable so that it always returns a ref, and use key() and
# val() to get the key and value parts.

typedef unsigned long (hash_func)(void *key)
typedef boolean (eq_func)(void *k1, void *k2)

# I miss C++!!

# TODO typedef list *hashtable_node_ref

struct key_value
	void *key
	void *value

struct node_kv
	list l
	key_value kv

key_value kv_null = { i2p(-1), i2p(-1) }

def kv_is_null(kv) kv.key == i2p(-1)

# TODO use ^^ to join type to _hash and _eq instead of passing both
# TODO like priq, use macros for hash_func and all hashtable funcs and pass type / hash_func / type_eq in to functions that need them..?

hashtable_init(hashtable *ht, hash_func *hash, eq_func *eq, size_t size)
	ht->size = hashtable_sensible_size(size)
	ht->buckets = alloc_buckets(ht->size)
	ht->hash = hash
	ht->eq = eq

# TODO hashtable_free ?
# TODO rename to ht_* ?

list *alloc_buckets(size_t size)
	list *buckets = Nalloc(list, size)
	list *end = buckets + size
	list *i
	for i = buckets ; i != end ; ++i
		list_init(i)
	return buckets

#hashtable_set_size(hashtable *ht, size_t new_size)
	#list *new_buckets = alloc_buckets(new_size)
	# XXX TODO rehash, free old buckets, etc.
	#.

# this returns a list *, the actual matching node is rv->next -
#  this is so we can delete nodes, check if exists then add, etc
list *hashtable_lookup_ref(hashtable *ht, void *key)
	list *bucket = which_bucket(ht, key)
	eq_func *eq = ht->eq
	repeat
		node_kv *node = (node_kv *)bucket->next
		if node == NULL || (*eq)(key, node->kv.key)
			return bucket
		bucket = (list *)node

# XXX return a key_value instead of a key_value * ??
key_value *hashtable_lookup(hashtable *ht, void *key)
	list *l = hashtable_lookup_ref(ht, key)
	if l->next == NULL
		return NULL
	 else
		return hashtable_ref_lookup(l)

key_value *hashtable_ref_lookup(list *l)
	node_kv *node = (node_kv *)l->next
	return (key_value *)&node->kv

void *hashtable_value(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup(ht, key)
	if kv == NULL
		error("hashtable_value: key does not exist")
		return NULL # keep GCC happy
	 else
		return kv->value

void *hashtable_value_or_null(hashtable *ht, void *key)
	return hashtable_value_or(ht, key, NULL)
void *hashtable_value_or(hashtable *ht, void *key, void *def)
	key_value *kv = hashtable_lookup(ht, key)
	if kv == NULL
		return def
	 else
		return kv->value

key_value *hashtable_add(hashtable *ht, void *key, void *value)
	list *l = hashtable_lookup_ref(ht, key)
	hashtable_ref_add(l, key, value)
	return hashtable_ref_key_value(l)

hashtable_ref_add(list *l, void *key, void *value)
	if l->next != NULL
		error("hashtable_ref_add: key already exists")
	
	node_kv *node = Talloc(node_kv)
	node->kv.key = key ; node->kv.value = value
	list_insert(list_next_p(l), (list *)node)

# XXX TODO MAYBE make hashtable_add receive an already alloc'd node_kv,
#   and make hashtable_delete return it again, i.e. hashtable does not do
#   memory alloc itself

# this returns key_value because may need to free the strings?
# XXX better to use a hook?
# see above TODO MAYBE
key_value hashtable_delete(hashtable *ht, void *key)
	list *l = hashtable_lookup_ref(ht, key)
	return hashtable_ref_delete(l)

hashtable_delete_maybe(hashtable *ht, void *key)
	list *l = hashtable_lookup_ref(ht, key)
	if hashtable_ref_exists(l)
		hashtable_ref_delete(l)

key_value hashtable_ref_delete(list *l)
	key_value ret
	if hashtable_ref_exists(l)
		node_kv *node = hashtable_ref_node(l)
		list_delete(list_next_p(l))
		ret = node->kv
		Free(node)
	 else
		ret = kv_null
	return ret

node_kv *hashtable_ref_node(list *l)
	node_kv *node = (node_kv *)l->next
	assert(node != NULL, "hashtable_ref_node: node not found")
	return node

boolean hashtable_ref_exists(list *l)
	return l->next != NULL

# XXX todo a way to customise error messages produced by called subs?

key_value *hashtable_ref_key_value(list *l)
	node_kv *node = hashtable_ref_node(l)
	return &node->kv

list *which_bucket(hashtable *ht, void *key)
	unsigned int hash = (*ht->hash)(key)
	unsigned int i = hash % ht->size
	return ht->buckets + i

size_t hashtable_sensible_size(size_t size)
	if size == 0
		size = 1
	return size
	# TODO use primes?

# TODO keep track of max bucket size, number of elements, etc.

def hash_mult 101 #7123

# TODO is this a good hash function?  I forget!
unsigned long cstr_hash(void *s)
	unsigned long rv = 0
	for(i, cstr_range((char *)s))
		rv *= hash_mult
		rv += *i
	return rv

hashtable_dump(hashtable *ht)
	uint i
	for i=0; i<ht->size; ++i
		list *bucket = &ht->buckets[i]
		list *l = bucket
		repeat
			Printf("%010p ", l)
			l = l->next
			if l == NULL
				break
		nl()
	nl()

key_value *hashtable_lookup_or_add_key(hashtable *ht, void *key, void *value_init)
	list *ref = hashtable_lookup_ref(ht, key)
	if ref->next == NULL
		hashtable_ref_add(ref, key, value_init)
	return hashtable_ref_lookup(ref)

key_value *hashtable_lookup_or_die(hashtable *ht, void *key)
	list *ref = hashtable_lookup_ref(ht, key)
	if ref->next == NULL
		failed0("hashtable_lookup_or_die")
	return hashtable_ref_lookup(ref)

#void *hashtable_ref_value(list *l)
#	node_kv *node = hashtable_ref_node(l)
#	return node->kv.value
#
#void *hashtable_ref_value_ptr(list *l)
#	node_kv *node = hashtable_ref_node(l)
#	return &node->kv.value


# this is hackily designed in a single loop so you can "break" from it
# have to pre-declare "key" and "value" so the types can be cast
def for_hashtable(key, value, ht)
	for_hashtable(key, value, ht, my(kv), my(ref))
def for_hashtable(key, value, ht, kv, ref)
	_for_hashtable(key, value, ht, kv, ref, my(bucket), my(end))
def _for_hashtable(_key, _value, ht, _kv, ref, bucket, end)
	list *bucket = ht->buckets
	list *end = bucket + ht->size
	list *ref = bucket
	for ; ; ref = ref->next
		while bucket != end && ref->next == NULL
			++bucket
			ref = bucket
		if bucket == end
			break
		node_kv *n = (node_kv *)ref->next
		key_value *_kv = &n->kv
		_key = (typeof(_key))_kv->key
		_value = (typeof(_value))_kv->value

# this is redundant to hashtable_lookup I guess?
# should def hashtable_exists hashtable_lookup  ?
# otherwise it should be just a hashset I guess
#boolean hashtable_exists(hashtable *ht, void *key)
#	list *l = hashtable_lookup_ref(ht, key)
#	return hashtable_ref_exists(l)

# need a "reference" type I guess, so can assign to the "value" easier
# or use "with" ?

# TODO change hashtable_init so the number is the 3rd arg, as we're more likely to want to vary it than the hash type (cstr)  ??

# FIXME rename node->kv to node->key_value ?



# This int_hash converts the int to a cstr first then hashes that.
# disadvantage - a bit slow
# advantages
#  - can look up by string too potentially
#  - works with any size int, long too, up to sizeof(void *)
#  - same method could work for other types (float, struct etc)

unsigned long int_hash(void *i_ptr)
	long i = p2i(i_ptr)
	char s[64]
	size_t size = snprintf(s, sizeof(s), "%ld", i)
	if size >= sizeof(s)
		failed("int_hash")
	return cstr_hash(s)

boolean int_eq(void *a, void *b)
	return p2i(a) == p2i(b)

# here is an alternate I got from http://www.concentric.net/~Ttwang/tech/inthash.htm
# in java code, works for 32 bits only
#public int hash32shift(int key)
#{
#  key = ~key + (key << 15); // key = (key << 15) - key - 1;
#  key = key ^ (key >>> 12);
#  key = key + (key << 2);
#  key = key ^ (key >>> 4);
#  key = key * 2057; // key = (key + (key << 3)) + (key << 11);
#  key = key ^ (key >>> 16);
#  return key;
#}
#

hashtable_free(hashtable *ht)
	use(ht)
	# TODO


# multi-hash functions

# mget returns NULL if empty or a vec of pointers to whatever if not

vec *mget(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->value
	return v

mput(hashtable *ht, void *key, void *value)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->value
	if v == NULL
		NEW(kv->value, vec, void*, 1)
		v = kv->value
	*(void**)vec_push(v) = value

def mdel(ht, key, value, Free_or_void)
	mdel(ht, key, value, Free_or_void, my(kv))
def mdel(ht, key, value, Free_or_void, kv)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->value
	if v == NULL
		warn("mdel: key not found")
	 else
	 	int already = 0
		grep(i, v, void*, *i == value && !already++, Free_or_void)  # not ideal but ok

def mdelmany(ht, key, value, Free_or_void)
	mdelmany(ht, key, value, Free_or_void, my(kv))
def mdelmany(ht, key, value, Free_or_void, kv)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->value
	if v == NULL
		warn("mdel: key not found")
	 else
		grep(i, v, void*, *i == value, Free_or_void)

def mdelall(ht, key, Free_or_void)
	mdelall(ht, key, Free_or_void, my(kv))
def mdelall(ht, key, Free_or_void)
	list *l = hashtable_lookup_ref(ht, key)
	if l->next != NULL
		key_value *kv = hashtable_ref_lookup(l)
		vec *v = kv->value
	 	for_vec(i, v, void *)
			Free_or_void(*i)
		vec_free(v)
		hashtable_ref_delete(l)

void *mget1(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->value
	if v && veclen(v) == 1
		return *(void**)vec0(v)
	 else
	 	return NULL

ssize_t mgetc(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->value
	return v ? veclen(v) : 0

void *mget1st(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->value
	if v && veclen(v)
		return *(void**)vec0(v)
	 else
	 	return NULL

void *mgetlast(hashtable *ht, void *key)
	key_value *kv = hashtable_lookup_or_add_key(ht, key, NULL)
	vec *v = kv->value
	if v && veclen(v)
		return *(void**)vec_top(v)
	 else
	 	return NULL

# TODO for_mhashtable ...


# TODO ordered hash option - using a double-linked list to keep the keys in insertion order
# TODO sorted hash option - using a tree or something to keep the keys in sort order?
# or actually use a tree for the data structure

kv_cstr_to_hashtable(cstr kv[][2], hashtable *ht)
	cstr (*i)[2] = kv
	for ; (*i)[0] ; ++i
		put(ht, (*i)[0], (*i)[1])

ssize_t hashtable_already(hashtable *ht, void *key)
	Assert(sizeof(ssize_t) <= sizeof(void*), warn, "sizeof(ssize_t) %zu is bigger than sizeof(void *) %zu", sizeof(ssize_t), sizeof(void*))
	ssize_t count, count1
	key_value *x = kv(ht, key, i2p(0))
	count = (ssize_t)p2i(x->value)
	count1 = count + 1
	if !count1
		count1 = 1
	x->value = i2p(count1)
	return count


unsigned long vos_hash(void *s)
	unsigned long rv = 0
	for_vec(i, (vec*)s, cstr)
		cstr l = *i
		rv *= hash_mult
		for(j, cstr_range(l))
			rv *= hash_mult
			rv += *j
	return rv

boolean vos_eq(void *_v1, void *_v2)
	vec *v1 = _v1, *v2 = _v2
	if veclen(v1) != veclen(v2)
		return 0
	cstr *p2 = vec0(v2)
	for_vec(p1, v1, cstr)
		if !cstr_eq(*p1, *p2)
			return 0
		++p2
	return 1
