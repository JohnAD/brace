export vec error

def split_csv(v, l):
	split_csv(v, l, my(p), my(f), my(c), my(o))

def split_csv(v, l, p, f, c, o):
	char *p = l
	char *f = p
	repeat:
		char c = *p
		if c == '\0':
			vec_push(v, f)
			break
		 eif c == ',':
			*p++ = '\0'
			vec_push(v, f)
			f = p
		 eif c == '"':
			f = ++p
			csv_read_quoted(p, c, o)
		 else:
			++p

def csv_read_quoted(p, c, o):
	repeat:
		char c = *p
		if c == '\0':
			error("csv: mismatched quotes")
		 eif c == '"':
			if p[1] == '"':
				char *o = p+1
				p += 2
				csv_read_quoted_copy(o, p, c)
				break
			 eif among(p[1], ',', '\0'):
				*p++ = '\0'
				break
			 else:
				error("csv: quote inside field must be followed by quote, comma or newline")
		 else:
			++p

def csv_read_quoted_copy(o, i, c):
	repeat:
		char c = *i
		if c == '\0':
			error("csv: mismatched quotes")
		 eif c == '"':
			if i[1] == '"':
				++i
			 eif among(i[1], ',', '\0'):
				*o++ = '\0'
				++i
				break
			 else:
				error("csv: quote inside field must be followed by quote, comma or newline")
		 else:
			*o++ = *i++
