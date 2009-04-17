export cstr
use hash sym util vio

cstr mimetypes_file = "/etc/mime.types"

def load_mimetypes()
	load_mimetypes(mimetypes_file)
def load_mimetypes(file)
	F_in(file)
		load_mimetypes_vio()

size_t mimetypes_n_buckets = 1009
hashtable struct__mimetypes, *mimetypes = NULL
load_mimetypes_vio()
	sym_init()
	if !mimetypes
		mimetypes = &struct__mimetypes
		init(mimetypes, hashtable, cstr_hash, (eq_func)cstr_eq, mimetypes_n_buckets)
	eachline(l)
		if among(*l, '#', '\0')
			continue
		cstr type = l
		cstr ext = strrchr(l, '\t')
		if ext++
			*Strchr(type, '\t') = '\0'
			type = sym(type)
			cstr *exts = split(ext, ' ')
			forary_null(e, exts)
				kv(mimetypes, sym(e), type)
#				cstr otype = kv(mimetypes, sym(e), type)->value
#				if otype != type
#					warn("duplicate mimetypes for ext %s: %s %s", e, otype, type)
			Free(exts)

cstr mimetype(cstr ext)
	return get(mimetypes, ext, NULL)

cstr Mimetype(cstr ext)
	return Get(mimetypes, ext)

