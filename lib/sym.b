export types
use hash cstr util alloc

size_t syms_n_buckets = 1021

# interning symbols (cstr)
hashtable syms__struct
hashtable *syms = NULL

sym_init()
	if !syms
		syms = &syms__struct
		init(syms, hashtable, cstr_hash, cstr_eq, syms_n_buckets)
		# TODO rehash if the hashtable gets too full...?

# sym is called with a cstr.  this will be copied if it is put into the "syms" ht
cstr sym(cstr s)
	if !syms
		sym_init()
	list *ref = hashtable_lookup_ref(syms, s)
	if hashtable_ref_exists(ref)
		key_value *kv = hashtable_ref_key_value(ref)
		return (cstr)kv->k

	cstr s1 = cstr_copy(s)
	hashtable_add(syms, s1, NULL)
	return s1
	# should be a "hash_set"
	# or maybe "value" wants to be an int for this, a usage count?
	# or it could be a smallish "symbol ID" number?

	# todo ref count so that can free them??

# sym_this is called with a malloc'd cstr; will be freed if already interned
cstr sym_this(cstr s)
	if !syms
		sym_init()
	list *ref = hashtable_lookup_ref(syms, s)
	if hashtable_ref_exists(ref)
		key_value *kv = hashtable_ref_key_value(ref)
		Free(s)
		return (cstr)kv->k

	hashtable_add(syms, s, NULL)
	return s
	# should be a "hash_set"
	# or maybe "value" wants to be an int for this, a usage count?
	# or it could be a smallish "symbol ID" number?
