export list cstr types
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
	hash_func hash
	eq_func eq

# hashtable abbrevs:

def Get(ht, key) hashtable_value(ht, key)
def get(ht, key) hashtable_value_or_null(ht, key)
def get(ht, key, value) hashtable_value_or(ht, key, value)
def put(ht, key, value) hashtable_add(ht, key, value)
def kv(ht, key) hashtable_lookup(ht, key)
def del(ht, key) hashtable_delete(ht, key)
def KV(ht, key) hashtable_lookup_or_die(ht, key)
def kv(ht, key, init) hashtable_lookup_or_add_key(ht, key, init)
# TODO, simplify hashtable so that it always returns a ref, and use key() and
# val() to get the key and value parts.

typedef unsigned int (*hash_func)(void *key)
typedef boolean (*eq_func)(void *k1, void *k2)

# I miss C++!!

# TODO typedef list *hashtable_node_ref

struct key_value
	void *key
	void *value

struct node_kv
	list l
	key_value kv

key_value kv_null = { (void*)-1, (void*)-1 }

def kv_is_null(kv) kv.key == (void*)-1

# TODO use ^^ to join type to _hash and _eq instead of passing both
# TODO like priq, use macros for hash_func and all hashtable funcs and pass type / hash_func / type_eq in to functions that need them..?

hashtable_init(hashtable *ht, hash_func hash, eq_func eq, size_t size)
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
	eq_func eq = ht->eq
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

# TODO is this a good hash function?  I forget!
unsigned int cstr_hash(void *s)
	unsigned int rv = 0
	for(i, cstr_range((char *)s))
		rv *= 101 #7123
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
#  - works with any size int
#  - same method could work for other types (float, struct etc)

unsigned int int_hash(void *i_ptr)
	int i = *(int *)i_ptr
	char s[64]
	size_t size = snprintf(s, sizeof(s), "%d", i)
	if size >= sizeof(s)
		failed("int_hash")
	return cstr_hash(s)

boolean int_eq(int *a, int *b)
	return *a == *b

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
