export types
use hash cstr util alloc

# interning symbols (cstr)
hashtable syms__struct
hashtable *syms

sym_init()
	heap(syms, hashtable)
	init(syms, hashtable, cstr_hash, (eq_func)cstr_eq, 1021)
	# 1021 is number of buckets, an arbitrary prime.
	# TODO rehash if the hashtable gets too full...?

# sym is called with a cstr.  this will be copied if it is put into the "syms" ht
cstr sym(cstr s)
	list *ref = hashtable_lookup_ref(syms, s)
	if hashtable_ref_exists(ref)
		key_value *kv = hashtable_ref_key_value(ref)
		return (cstr)kv->key

	cstr s1 = cstr_copy(s)
	hashtable_add(syms, s1, NULL)
	return s1
	# should be a "hash_set"
	# or maybe "value" wants to be an int for this, a usage count?
	# or it could be a smallish "symbol ID" number?

# sym_this is called with a malloc'd cstr; will be freed if already interned
cstr sym_this(cstr s)
	list *ref = hashtable_lookup_ref(syms, s)
	if hashtable_ref_exists(ref)
		key_value *kv = hashtable_ref_key_value(ref)
		Free(s)
		return (cstr)kv->key

	hashtable_add(syms, s, NULL)
	return s
	# should be a "hash_set"
	# or maybe "value" wants to be an int for this, a usage count?
	# or it could be a smallish "symbol ID" number?
