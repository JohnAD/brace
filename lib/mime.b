export cstr
use hash sym util vio

cstr mimetypes_file = "/etc/mime.types"

mimetypes_init()
	if !mimetypes
		mimetypes = &struct__mimetypes
		init(mimetypes, hashtable, cstr_hash, cstr_eq, mimetypes_n_buckets)

def load_mimetypes()
	load_mimetypes(mimetypes_file)
def load_mimetypes(file)
	F_in(file)
		load_mimetypes_vio()

size_t mimetypes_n_buckets = 1009
hashtable struct__mimetypes, *mimetypes = NULL
load_mimetypes_vio()
	mimetypes_init()
	sym_init()
	eachline(l)
		if among(*l, '#', '\0')
			continue
		cstr type = l
		cstr ext = strrchr(l, '\t')
		if ext++
			*Strchr(type, '\t') = '\0'
			type = sym(type)
			lc(ext)
			cstr *exts = split(ext, ' ')
			forary_null(e, exts)
				kv(mimetypes, sym(e), type)
#				cstr otype = kv(mimetypes, sym(e), type)->v
#				if otype != type
#					warn("duplicate mimetypes for ext %s: %s %s", e, otype, type)
			Free(exts)

cstr mimetype(cstr ext)
	char ext_lc[strlen(ext)+1]
	strcpy(ext_lc, ext)
	lc(ext_lc)
	return get(mimetypes, ext_lc, NULL)

cstr Mimetype(cstr ext)
	cstr mt = mimetype(ext)
	if !mt
		failed("mimetype", ext)
	return mt

