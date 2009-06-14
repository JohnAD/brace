export vec types tok
use util

int lines_initial_space = 4096

int block_lines_initial_space = 256
int struct_union_names_space = 257

boolean cxx_using_c_lib = 0 # TODO set this

vec *lines, *work

vec *defines, *cpp_directives,
 *includes, *extern_langs, *using_namespaces,
 *enums, *struct_union_class_template_protos, *struct_union_typedefs,
 *typedefs, *struct_union_class_templates, *function_protos, *var_protos,
 *local_and_global_vars, *var_assignments, *functions,
 *local_vars, *global_vars
	
# vec *lines

int cz_parse_vec_initial_space = 64

Def cz_parse_vov_names
 defines,
 extern_langs,
 enums,
 typedefs, struct_union_class_templates,
 var_assignments, functions,
 local_and_global_vars,
 local_vars, global_vars

Def cz_parse_vos_names
 cpp_directives,
 includes, using_namespaces,
 struct_union_class_template_protos,
 struct_union_typedefs,
 function_protos, var_protos

Def cz_parse_vec_names cz_parse_vov_names, cz_parse_vos_names

boolean cz_parse_initd = 0

cz_parse_init()
	cz_parse_initd = 1
	NEW(lines, vec, cstr, lines_initial_space)
	NEW(work, vec, cstr, lines_initial_space)
	call_each(cz_new_parse_vov, cz_parse_vov_names)
	call_each(cz_new_parse_vos, cz_parse_vos_names)

def cz_new_parse_vov(x)
	NEW(x, vec, vec*, cz_parse_vec_initial_space)

def cz_new_parse_vos(x)
	NEW(x, vec, cstr, cz_parse_vec_initial_space)

cz_parse_free()
	vec_free(lines)
	vec_free(work)
	call_each(vov_free, cz_parse_vov_names)
	call_each(vec_free, cz_parse_vos_names)

cz_parse_squeeze()
	call_each(vec_squeeze, cz_parse_vec_names)

cz_parse_clear()
	call_each(vecclr, cz_parse_vec_names)

cz_parse()
	if !cz_parse_initd
		cz_parse_init()
	vec *block = NULL
	for_vec(i, lines, cstr)
		cstr l = *i
		char x = l[strspn(l, " \t")]
		if among(x, '\0', '#')
			continue
		if strchr(l, '\t')
			if !block
				error("unexpected block: %s", l)
			vec_push(block, l)
			continue
		if block
			vec_squeeze(block)
			block = NULL

		vec *v
		boolean is_block = 1
		if cstr_begins_with_word(l, "use", "export")
			v = includes
			is_block = 0
		 eif cstr_begins_with_word(l, "using namespace")
			v = using_namespaces
			is_block = 0
		 eif cstr_begins_with_word(l, "def", "Def", "DEF", "ldef", "lDef", "lDEF")
			v = defines
		 eif l[0] == '^'
			v = cpp_directives
			is_block = 0
		 eif cstr_begins_with_word(l, "struct", "union", "class", "template") &&
		  !possible_struct_is_func_returning_struct(l) && !strchr(l, '=')
			v = struct_union_class_templates
		 eif cstr_begins_with_word(l, "enum")
			v = enums
		 eif cstr_begins_with_word(l, "typedef")
			v = typedefs
		 eif cstr_begins_with_word(l, "local", "static") && (strchr(l, '=') || !is_function(l))
			v = local_vars
		 eif cstr_begins_with(l, "extern \"")
			v = extern_langs
		 eif cstr_begins_with_word(l, "extern")
			if cxx_using_c_lib
				l = cxx_using_c_lib_correct_proto(l)
			if strchr(l, ')')
				v = function_protos
			 else
				v = var_protos
			is_block = 0
		 eif strchr(l, ')') && !strchr(l, '=')
			v = functions
		 else
			v = global_vars

		if is_block
			NEW(block, vec, cstr, block_lines_initial_space)
			vec_push(v, block)
			if among(v, local_vars, global_vars)
				vec_push(local_and_global_vars, block)
			vec_push(block, l)
		 else
			vec_push(v, l)

	for_vec(i, functions, vec*)
		if veclen(*i) == 1
			cstr l = *(cstr*)vec0(*i)
			if cxx_using_c_lib
				l = cxx_using_c_lib_correct_proto(l)
			vec_push(function_protos, l)
			vec_free(*i) ; *i = NULL

	new(struct_union_names, hashtable, cstr_hash, cstr_eq, struct_union_names_space)

	for_vec(i, struct_union_class_templates, vec*)
		cstr l = *(cstr*)vec0(*i)
		if veclen(*i) == 1
			vec_push(struct_union_class_template_protos, l)
			vec_free(*i) ; *i = NULL
		 else
			cstr name = cstr_begins_with_word(l, "struct", "union")
			if name
				char *e = name
				if token_type(*e) == NAME
					++e
					tok_name(e)
				name = tofree(Strndup(name, e-name))
				put(struct_union_names, name, name)

	for_vec(i, typedefs, vec*)
		if veclen(*i) == 1
			cstr l = *(cstr*)vec0(*i)
			cstr p = cstr_begins_with_word(l, "typedef")
			assert(p, "invalid entry in typedefs vec")
			p = cstr_begins_with_word(p, "struct", "union")
			if p
				char *w2 = p
				if token_type(*w2) == NAME
					++w2
					tok_name(w2)
				if *w2 == ' '
					int len = w2 - p
					++w2
					if strncmp(p, w2, len) == 0 && w2[len] == '\0' &&
					 get(struct_union_names, w2)
						vec_push(struct_union_typedefs, l)
						vec_free(*i) ; *i = NULL

	hashtable_free(struct_union_names)

	for_vec(i, local_and_global_vars, vec*)
		cstr l = *(cstr*)vec0(*i)
		if strchr(l, '=')
			vec_push(var_assignments, *i)
			*i = NULL

	call_each(remove_null, functions, struct_union_class_templates,
	 typedefs, local_and_global_vars)

boolean possible_struct_is_func_returning_struct(cstr l)
	char *p = strchr(l, ' ')
	if p && token_type(*++p) == NAME
		tok_name(p)
		while among(*p, ' ', '*', '&')
			++p
		if token_type(*p) == NAME
			++p
			tok_name(p)
			if *p == '('
				return 1
	return 0

boolean is_function(cstr l)
	char *p = strchr(l, '(')
	return p > l && char_name2(p[-1])

cstr cxx_using_c_lib_correct_proto(cstr l)
	if cstr_begins_with_word(l, "extern")
		l += 7
	if token_type(*l) == STRING
		++l
		tok_string(l)
		tok_space(l)
	l = tofree(format("extern \"C\" %s", l))
	return l
