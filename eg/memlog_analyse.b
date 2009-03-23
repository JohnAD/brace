#!/lang/b
use b
size_t n_buckets = 10007
Main()
	new(alloced, hashtable, cstr, n_buckets)
	int n = 1
	eachline(l)
		if !(among(*l, 'A', 'F') || l[1] == '\t')
			continue
		let(words, split(l, '\t'))
		cstr type = words[0]
		cstr func = words[1]
		cstr addr = words[2]
		cstr size = words[3]
		cstr location = words[4]
		if *type == 'A'
			key_value = kv(alloced, addr)
			if key_value->value == NULL
				key_value->key = strdup(addr)
				key_value->value = strdup(l)
			 else
				Say("bad\t%s", l)
		 else  # type == 'F'
			int addr_not_null = 0
			for_cstr(i, addr)
				if *i != '0'
					addr_not_null = 1
					break
			if addr_not_null
				if kv_is_null(del(alloced, addr))
					Say("bad\t%s", l)
	

