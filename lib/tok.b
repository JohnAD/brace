use util error
export types

#typedef enum { COMMENT, TABS, SPACE, NUMBER, STRING, CHARACTER, NAME, BRACKET, DELIMIT, OP, ILLEGAL = -1 } token_types
typedef enum { NAME, SPACE, BRACKET, OP, NEWLINE, TABS, DELIMIT, NUMBER, COMMENT, STRING, CHARACTER, BSPACE, TOKEN_TYPE_TOP, ILLEGAL = -1, TOK_EOT = -2 } token_t
# tried to order with commonest ones first... probably should use stats to do that :p  lol
# what is QUOTED good for?  symbols?  like in lisp?  code as data?
# disabled for now (cause hardish to implement!)

boolean tok_initd = 0

typedef char char_table[256]
char_table ct_token_type, ct_name2
# TODO more tables for different types of characters?

tok_init()
	if !tok_initd
		tok_initd = 1
		char_table_init(ct_token_type, c, token_type_(c))
		char_table_init(ct_name2, c, char_name2_(c))

def char_name2_(c) tween(c, 'A', 'Z') || tween(c, 'a', 'z') || tween(c, '0', '9') || among(c, '_', '$')

def token_type(c) ct_token_type[(int)(uchar)c]
def char_name2(c) ct_name2[(int)(uchar)(c)]

char token_type_(char c)
	if c == '\0'
		return TOK_EOT
	 eif c == '#'
		return COMMENT
	 eif c == '\n'
		return NEWLINE
	 eif c == '\t'
		return TABS
	 eif c == ' '
		return SPACE
	 eif c == '\b'
	 	return BSPACE
	 eif tween(c, '0', '9')
		return NUMBER
		# I want to be able to identify a token's type from its first char.
		# So can't allow .1, you must type 0.1  :/
	 eif c == '"'
		return STRING
	 eif c == '\''
		return CHARACTER
#		 eif c == '`'
#		 	return QUOTED
	 eif tween(c, 'A', 'Z') || tween(c, 'a', 'z') || among(c, '_', '$')
		return NAME
	 eif among(c, '[', ']', '(', ')', '{', '}')
		return BRACKET
	 eif among(c, ';', ',')
		return DELIMIT
	 eif tween(c, 33, 126)
		return OP
	 else
		return ILLEGAL

def char_table_init(array, var, predicate)
	.
		int var
		for var=0 ; var<256 ; ++var
			char *p = array + var
			*p = predicate

def tok_EOT '\0'
 # this can be over-ridden to be \n instead

def tok_comment(i)
	while *i != tok_EOT
		++i
def tok_tabs(i)
	while *i == '\t'
		++i
def tok_space(i)
	while *i == ' '
		++i
def tok_bspace(i)
	while *i == '\b'
		++i
def tok_number(i)
	if *(i-1) != '0'
		tok_decimal(i)
	 eif *i == 'x'
		++i
		tok_hex(i)
	 eif tween(*i, '0', '7')
		tok_octal(i)
	 eif !tween(*i, '0', '9')
		tok_decimal(i)
	# otherwise - a BAD number, at this tokenizer stage it will be split 08 -> 0 8 for example :p
def tok_decimal(i)
	tok_decimal_int(i)
	if *i == '.'
		++i
		tok_decimal_int(i)
	tok_float_exp(i)
	tok_float_suffix(i)
def tok_decimal_int(i)
	while tween(*i, '0', '9')
		++i
def tok_float_exp(i)
	if among(*i, 'e', 'E')
		++i
		if among(*i, '+', '-')
			++i
		tok_decimal_int(i)
def tok_float_suffix(i)
	if among(*i, 'f', 'F', 'l', 'L')
		++i
def tok_hex(i)
	while tween(*i, '0', '9') || tween(*i, 'A', 'F') || tween(*i, 'a', 'f')
		++i
def tok_octal(i)
	while tween(*i, '0', '7')
		++i
def tok_string(i)
	while !among(*i, '"', tok_EOT)
		if *i == '\\'
			++i
			if *i == tok_EOT
				break
		++i
	if *i == '"'
		++i
def tok_char(i)
	while !among(*i, '\'', tok_EOT)
		if *i == '\\'
			++i
			if *i == tok_EOT
				break
		++i
	if *i == '\''
		++i
def tok_name(i)
	while char_name2(*i)
		++i
def tok_bracket(i)
	.
def tok_delimit(i)
	.
def tok_op(i)
	while token_type(*i) == OP
		++i
def tok_illegal(i)
	while token_type(*i) == ILLEGAL && *i != tok_EOT
		++i

def bracket_type(c) among(c, '[', '(', '{') ? 1 : -1

token_t token(char **i_ptr)
	char *i = *i_ptr
	token_t t = token_type(*i++)
	which t
	TOK_EOT	.
	COMMENT	tok_comment(i)
	NEWLINE	.
	TABS	tok_tabs(i)
	SPACE	tok_space(i)
	BSPACE	tok_bspace(i)
	NUMBER	tok_number(i)
	STRING	tok_string(i)
	CHARACTER	tok_char(i)
	NAME	tok_name(i)
	BRACKET	tok_bracket(i)
	DELIMIT	tok_delimit(i)
	OP	tok_op(i)
	ILLEGAL	tok_illegal(i)
	else	fault("unknown token type here: %s", *i_ptr)
	*i_ptr = i
	return t

boolean tok_eq(char *p0, char *p1, cstr s)
	while p0 != p1
		if *p0++ != *s++
			return 0
	return *s == '\0'
