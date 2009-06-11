export cstr types deq
use vio

boolean brace(deq *lines)
	brace_init()
	if readstmt(lines)
		writestmt()
		while readstmt(lines)
			writedelim()
			writestmt()
		writedelim()
	return 1


def MAXTABS 256

# TODO local enum, struct, etc.
enum { SWITCH, WHICH, STRUCT, CLASS, INIT, VOID_MAIN, MACRO, DO, DOWHILE, ELSE, OTHER }

local int blocktype[MAXTABS]

local char *kwdparens[] = { "if", "else if", "while", "do", "for", "switch", "else", 0 }

local char *l
local int len
local int tabs
local int lasttabs
local int skipsemi
local char *label
local char *lastlabel
# XXX do lastlabel and lastcase work?
# isn't the buffer overwritten for each line?
local int lastblank
local char *caselabel
local char *lastcase
local int casetabs
local int in_macro
local int first_line_of_macro

local int is_kwdparens
local int is_static


local brace_init()
	lastlabel = 0
	lastcase = 0
	in_macro = 0
	first_line_of_macro = 0

local int readstmt(deq *lines)
	if !readln(lines)
		tabs = 0
		return 0
	tabs = striptabs()
	strip_one_space_maybe()
	fussy()
	
	label = 0
	if len > 0 && tabs == 0
		int lbllen = wordlen()
		if l[lbllen] == '\t'
			label = l
			l += lbllen
			len -= lbllen
			tabs = striptabs()
			label[lbllen] = '\0'
	
	caselabel = 0
	casetabs = 0
	if len > 0 && tabs > 0 && l[0] != '#'
		int lbllen = caselen()
		if l[lbllen] == ',' && l[lbllen+1] == '\t'
			l[lbllen] = '\0'
			lbllen++
		if l[lbllen] == '\t'
			caselabel = l
			l += lbllen
			len -= lbllen
			casetabs = striptabs()
			caselabel[lbllen] = '\0'
			tabs += casetabs
	
	if len == 1 && l[0] == '.'
		l[0] = '\0' ; len = 0
	
	if tabs >= MAXTABS
		error("too many tabs")
	
	return 1

local writestmt()
	is_kwdparens = 0
	is_static = 0

	if caselabel && lasttabs >= tabs && !(lastblank && lastcase) \
			&& blocktype[tabs-1] == WHICH
		indent(tabs)
		print("break;\n")
	
	if label
		if isdigit((int)label[0])
			print("_")
		print(label)
		print(":")
	
	indent(tabs - casetabs)
	
	if caselabel
		if caselabel[0] == '\0'
			error("spurious space between tabs")
		eif strcmp(caselabel, "else") == 0
			print("default:")
		else
			print("case ")
			print(caselabel)
			print(":")
		indent(casetabs)

	if strcmp(l, "do") == 0
		blocktype[tabs] = DO
	eif blocktype[tabs] == DO && cstr_begins_with(l, "while ")
		blocktype[tabs] = DOWHILE
	eif cstr_begins_with(l, "switch ")
		blocktype[tabs] = SWITCH
	eif cstr_begins_with(l, "else") && (len == 4 || l[4] == ' ')
		blocktype[tabs] = ELSE
	eif cstr_begins_with(l, "which ")
		blocktype[tabs] = WHICH
	eif (cstr_begins_with(l, "enum") && (len == 4 || l[4] == ' ')) || \
			l[len-1] == '=' || \
			(tabs > 0 && blocktype[tabs-1] == INIT)
		blocktype[tabs] = INIT
	eif tabs > lasttabs && blocktype[lasttabs] == INIT
		int i
		for i=lasttabs+1; i<=tabs; ++i
			blocktype[i] = INIT
	else
		# check for struct, union, class
		char *c = l
		if cstr_begins_with(c, "template<")
			c = strchr(c+9, '>')
			if c == NULL
				error("template is missing >")
			++c
			if *c == '\0'
				error("template<...> must be followed by the start of a declaration on the same line")
			if *c != ' '
				error("template<...> must be followed by a space")
			++c
		 eif cstr_begins_with(c, "extern \"C\" ")
			c += 11
			if *c == '\0'
				error("extern \"C\" must be followed by the start of a declaration on the same line")
		
		if cstr_begins_with(c, "struct ") && classy(c+7)
			blocktype[tabs] = STRUCT
		eif cstr_begins_with(c, "union ") && classy(c+6)
			blocktype[tabs] = STRUCT
		eif cstr_begins_with(c, "class ") && classy(c+6)
			blocktype[tabs] = CLASS
		eif *c == '^' || *c == '#'
			# ignore directives and comments, not indented properly
		else
			blocktype[tabs] = OTHER
		# to be continued?
	
	skipsemi = 0
	if len > 0 && l[wordlen()] == '\0' && tabs > 0 && \
			blocktype[tabs] != INIT && \
				strcmp(l, "else") != 0 && \
				strcmp(l, "return") != 0 && \
				strcmp(l, "break") != 0 && \
				strcmp(l, "continue") != 0 && \
				strcmp(l, "do") != 0 && \
				strcmp(l, "repeat") != 0
			print("goto ")
			if isdigit((int)l[0])
				print("_")
	eif l[0] == '#'
		print("/")
		l[0] = '/'
	eif cstr_begins_with(l, "export ") || cstr_begins_with(l, "use ")
		l = strchr(l, ' ') + 1
		print("#include ")
		print(l)
		l = "" ; len = 0
	eif cstr_begins_with(l, "def ")
		if tabs != 0
			error("macro definitions must be at top level")
		blocktype[tabs] = MACRO
		in_macro = 1
		first_line_of_macro = 1
		print("#define ")
		l += 4 ; len -= 4
	eif cstr_begins_with(l, "local ") || cstr_begins_with(l, "static ")
		char *l2 = strchr(l, ' ')+1
		print("static ")
		is_static = 1
		len -= (l2-l) ; l = l2
		if tabs == 0
			addvoids()
	eif cstr_begins_with(l, "^")
		print("#")
		skipsemi = 1
		l++ ; len--
	eif l[len-1] == '{' || strcmp(l, "}") == 0
		skipsemi = 1
	eif tabs == 0
		addvoids()
	else
		procstmt()
	
	print(l)
	
	skipsemi = skipsemi || len == 0 || l[0] == '"' || l[0] == '<' || \
		l[0] == '/' || last() == '/'
	
	if caselabel && len == 0
		skipsemi = 0
	
	lastblank = len == 0
	lastlabel = 0
	lastcase = 0
	if label || !lastblank
		lastlabel = label
	if caselabel && !lastblank
		lastcase = caselabel
	lasttabs = tabs

local writedelim()
	int lt = lasttabs
	if first_line_of_macro
		skipsemi = 1
		if tabs != 0
			lt = tabs
	if lt >= tabs && \
			(!skipsemi || \
				(lastblank && (lastlabel || lastcase))) && \
			!(lt > 0 && blocktype[lt-1] == INIT)
		if is_kwdparens && blocktype[lt] != DOWHILE
			print(" {}")
		 else
			print(";")
	if in_macro && tabs > 0
		print(" \\")
	print("\n")
	if !(in_macro && tabs == 0)
		while lt > tabs
			indent(--lt)
			if blocktype[lt] == STRUCT || blocktype[lt] == CLASS
				print("};\n")
			eif blocktype[lt] == INIT && !(lt>0 && blocktype[lt-1] == INIT)
				print("};\n")
			else
				if lt == 0 && blocktype[0] == VOID_MAIN
					print("\treturn 0;\n")
				print("}\n")
		while lt < tabs
			indent(lt++)
			print("{\n")
	if in_macro && tabs == 0
		in_macro = 0
	first_line_of_macro = 0

local procstmt()
	char **k
	char *c
	if (c = cstr_begins_with(l, "which "))
		print("switch(")
		print(c)
		l = ")" ; len = 1
	eif cstr_begins_with(l, "eif ")
		print("else if(")
		print(l+4)
		l = ")" ; len = 1
		is_kwdparens = 1
	eif strcmp(l, "repeat") == 0
		l = "while(1)" ; len = 8
	#eif strcmp(l, "stop") == 0
	#	l = "break" ; len = 5
	else
		for k=kwdparens; *k != 0; ++k
			int c = strlen(*k)
			if cstr_begins_with(l, *k) && (l[c] == ' ' || l[c] == '\0')
				if l[c] == ' '
					l[c] = '('
					print(l)
					l = ")" ; len = 1
				is_kwdparens = 1
				break

local int readln(deq *lines)
	if deqlen(lines) == 0
		return 0
	l = *(cstr*)q(lines, 0)
	deq_shift(lines)
	len = strlen(l)
#	while last() == '\n' || last() == '\r'
#		l[--len] = '\0'
	return 1

local char last()
	if len == 0
		return '\0'
	return l[len-1]

local int striptabs()
	int tabs = 0
	while l[0] == '\t'
		++l
		++tabs
		--len
	return tabs

local fussy()
	if l[0] == ' '
		error("two spaces at start of line")
	if last() == ' '
		error("space at end of line")

local int wordlen()
	return strspn(l, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789.")

local int caselen()
	return strcspn(l, "\t")

local strip_one_space_maybe()
	if l[0] == ' '
		++l
		--len

local indent(int tabs)
	for ; tabs>0; --tabs
		print("\t")

local addvoids()
	char *c1 = cstr_begins_with(l, "extern \"C\" ")
	if c1
		print("extern \"C\" ")
		l = c1
	int addvoid = 1
	char *c = l
	for ; *c != 0; ++c
		if *c == ' '
			addvoid = 0
		if *c == '('
			if addvoid
				if cstr_begins_with(l, "main(")
					print("int ")
					blocktype[tabs] = VOID_MAIN
				else
					print("void ")
			if c[1] == ')'
				c[1] = '\0'
				print(l)
				c[1] = ')'
				print("void")
				len -= (c - l) + 1
				l = c + 1
			break

local int classy(char *c)
	char *spc = strchr(c, ' ')
	char *colon = strchr(c, ':')
	char *paren = strchr(c, '(')
	return !paren && (!spc || colon == spc + 1 || colon < spc)
