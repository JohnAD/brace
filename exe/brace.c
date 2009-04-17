#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>

enum { MAXLINE = 1024 };

enum { MAXTABS = 256 };

enum { SWITCH, WHICH, STRUCT, CLASS, INIT, VOID_MAIN, MACRO, DO, DOWHILE, ELSE, OTHER };

char *cstr_begins_with(char *s, const char *substr);
void exits(char *msg);
void writes(char *str);
char last(void);
int readln(void);
int striptabs(void);
void fussy(void);
int wordlen(void);
int caselen(void);
void strip_one_space_maybe(void);
int readstmt(void);
void indent(int tabs);
void addvoids(void);
void procstmt(void);
int classy(char *c);
void writestmt(void);
void writedelim(void);
int main(void);

extern char *kwdparens[];
extern char *lastlabel;
extern char *lastcase;
extern int in_macro;
extern int first_line_of_macro;

char buf[MAXLINE];
char *line;
int len;
int tabs;
int lasttabs;
int skipsemi;
char *label;
int lastblank;
char *caselabel;
int casetabs;
int blocktype[MAXTABS];
int is_kwdparens;

char *kwdparens[] = { "if", "else if", "while", "do", "for", "switch", "else", 0 };
char *lastlabel = 0;
char *lastcase = 0;
int in_macro = 0;
int first_line_of_macro = 0;

char *cstr_begins_with(char *s, const char *substr)
{
	while(1)
	{
		if(*substr == '\0')
		{
			return s;
		}
		if(*substr != *s)
		{
			return NULL;
		}
		++s;
		++substr;
	}
}

void exits(char *msg)
{
	if(msg == NULL)
	{
		exit(0);
	}
	else
	{
		fprintf(stderr, "%s\n", msg);
		exit(1);
	}
}

void writes(char *str)
{
	printf("%s", str);
}

char last(void)
{
	if(len == 0)
	{
		return '\0';
	}
	return line[len-1];
}

int readln(void)
{
	line = fgets(buf, MAXLINE, stdin);
	if(line == NULL)
	{
		return 0;
	}
	len = strlen(line);
	if(last() != '\n' && last() != '\r')
	{
		exits("line too long or does not end with newline");
	}
	while(last() == '\n' || last() == '\r')
	{
		line[--len] = '\0';
	}
	return 1;
}

int striptabs(void)
{
	int tabs = 0;
	while(line[0] == '\t')
	{
		++line;
		++tabs;
		--len;
	}
	return tabs;
}

void fussy(void)
{
	if(line[0] == ' ')
	{
		exits("two spaces at start of line");
	}
	if(last() == ' ')
	{
		exits("space at end of line");
	}
}

int wordlen(void)
{
	return strspn(line, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789.");
}

int caselen(void)
{
	return strcspn(line, "\t");
}

void strip_one_space_maybe(void)
{
	if(line[0] == ' ')
	{
		++line;
		--len;
	}
}

int readstmt(void)
{
	if(!readln())
	{
		tabs = 0;
		return 0;
	}
	tabs = striptabs();
	strip_one_space_maybe();
	fussy();
	label = 0;
	if(len > 0 && tabs == 0)
	{
		int lbllen = wordlen();
		if(line[lbllen] == '\t')
		{
			label = line;
			line += lbllen;
			len -= lbllen;
			tabs = striptabs();
			label[lbllen] = '\0';
		}
	}
	caselabel = 0;
	casetabs = 0;
	if(len > 0 && tabs > 0 && line[0] != '#')
	{
		int lbllen = caselen();
		if(line[lbllen] == ',' && line[lbllen+1] == '\t')
		{
			line[lbllen] = '\0';
			lbllen++;
		}
		if(line[lbllen] == '\t')
		{
			caselabel = line;
			line += lbllen;
			len -= lbllen;
			casetabs = striptabs();
			caselabel[lbllen] = '\0';
			tabs += casetabs;
		}
	}
	if(len == 1 && line[0] == '.')
	{
		line[0] = '\0';
		len = 0;
	}
	if(tabs >= MAXTABS)
	{
		exits("too many tabs");
	}
	return 1;
}

void indent(int tabs)
{
	for(; tabs>0; --tabs)
	{
		writes("\t");
	}
}

void addvoids(void)
{
	char *c1 = cstr_begins_with(line, "extern \"C\" ");
	if(c1)
	{
		writes("extern \"C\" ");
		line = c1;
	}
	char *c = line;
	int addvoid = 1;
	for(; *c != 0; ++c)
	{
		if(*c == ' ')
		{
			addvoid = 0;
		}
		if(*c == '(')
		{
			if(addvoid)
			{
				if(cstr_begins_with(line, "main("))
				{
					writes("int ");
					blocktype[tabs] = VOID_MAIN;
				}
				else
				{
					writes("void ");
				}
			}
			if(c[1] == ')')
			{
				c[1] = '\0';
				writes(line);
				c[1] = ')';
				writes("void");
				len -= (c - line) + 1;
				line = c + 1;
			}
			break;
		}
	}
}

void procstmt(void)
{
	char **k;
	char *c;
	if((c = cstr_begins_with(line, "which ")))
	{
		writes("switch(");
		writes(c);
		line = ")";
		len = 1;
	}
	else if(cstr_begins_with(line, "eif "))
	{
		writes("else if(");
		writes(line+4);
		line = ")";
		len = 1;
		is_kwdparens = 1;
	}
	else if(strcmp(line, "repeat") == 0)
	{
		line = "while(1)";
		len = 8;
	}
	else
	{
		for(k=kwdparens; *k != 0; ++k)
		{
			int l = strlen(*k);
			if(cstr_begins_with(line, *k) && (line[l] == ' ' || line[l] == '\0'))
			{
				if(line[l] == ' ')
				{
					line[l] = '(';
					writes(line);
					line = ")";
					len = 1;
				}
				is_kwdparens = 1;
				break;
			}
		}
	}
}

int classy(char *c)
{
	char *spc = strchr(c, ' ');
	char *colon = strchr(c, ':');
	char *paren = strchr(c, '(');
	return !paren && (!spc || colon == spc + 1 || colon < spc);
}

void writestmt(void)
{
	is_kwdparens = 0;
	if(caselabel && lasttabs >= tabs && !(lastblank && lastcase) && blocktype[tabs-1] == WHICH)
	{
		indent(tabs);
		writes("break;\n");
	}
	if(label)
	{
		if(isdigit((int)label[0]))
		{
			writes("_");
		}
		writes(label);
		writes(":");
	}
	indent(tabs - casetabs);
	if(caselabel)
	{
		if(caselabel[0] == '\0')
		{
			exits("spurious space between tabs");
		}
		else if(strcmp(caselabel, "else") == 0)
		{
			writes("default:");
		}
		else
		{
			writes("case ");
			writes(caselabel);
			writes(":");
		}
		indent(casetabs);
	}
	if(strcmp(line, "do") == 0)
	{
		blocktype[tabs] = DO;
	}
	else if(blocktype[tabs] == DO && cstr_begins_with(line, "while "))
	{
		blocktype[tabs] = DOWHILE;
	}
	else if(cstr_begins_with(line, "switch "))
	{
		blocktype[tabs] = SWITCH;
	}
	else if(cstr_begins_with(line, "else") && (len == 4 || line[4] == ' '))
	{
		blocktype[tabs] = ELSE;
	}
	else if(cstr_begins_with(line, "which "))
	{
		blocktype[tabs] = WHICH;
	}
	else if((cstr_begins_with(line, "enum") && (len == 4 || line[4] == ' ')) || line[len-1] == '=' || (tabs > 0 && blocktype[tabs-1] == INIT))
	{
		blocktype[tabs] = INIT;
	}
	else if(tabs > lasttabs && blocktype[lasttabs] == INIT)
	{
		int i;
		for(i=lasttabs+1; i<=tabs; ++i)
		{
			blocktype[i] = INIT;
		}
	}
	else
	{
		char *c = line;
		if(cstr_begins_with(c, "template<"))
		{
			c = strchr(c+9, '>');
			if(c == NULL)
			{
				exits("template is missing >");
			}
			++c;
			if(*c == '\0')
			{
				exits("template<...> must be followed by the start of a declaration on the same line");
			}
			if(*c != ' ')
			{
				exits("template<...> must be followed by a space");
			}
			++c;
		}
		else if(cstr_begins_with(c, "extern \"C\" "))
		{
			c += 11;
			if(*c == '\0')
			{
				exits("extern \"C\" must be followed by the start of a declaration on the same line");
			}
		}
		if(cstr_begins_with(c, "struct ") && classy(c+7))
		{
			blocktype[tabs] = STRUCT;
		}
		else if(cstr_begins_with(c, "union ") && classy(c+6))
		{
			blocktype[tabs] = STRUCT;
		}
		else if(cstr_begins_with(c, "class ") && classy(c+6))
		{
			blocktype[tabs] = CLASS;
		}
		else if(*c == '^' || *c == '#') {}
		else
		{
			blocktype[tabs] = OTHER;
		}
	}
	skipsemi = 0;
	if(len > 0 && line[wordlen()] == '\0' && tabs > 0 && blocktype[tabs] != INIT && strcmp(line, "else") != 0 && strcmp(line, "return") != 0 && strcmp(line, "break") != 0 && strcmp(line, "continue") != 0 && strcmp(line, "do") != 0 && strcmp(line, "repeat") != 0)
	{
		{
			writes("goto ");
			if(isdigit((int)line[0]))
			{
				writes("_");
			}
		}
	}
	else if(line[0] == '#')
	{
		writes("/");
		line[0] = '/';
	}
	else if(cstr_begins_with(line, "export ") || cstr_begins_with(line, "use "))
	{
		line = strchr(line, ' ') + 1;
		writes("#include ");
		writes(line);
		line = "";
		len = 0;
	}
	else if(cstr_begins_with(line, "def "))
	{
		if(tabs != 0)
		{
			exits("macro definitions must be at top level");
		}
		blocktype[tabs] = MACRO;
		in_macro = 1;
		first_line_of_macro = 1;
		writes("#define ");
		line += 4;
		len -= 4;
	}
	else if(cstr_begins_with(line, "local "))
	{
		writes("static ");
		line += 6;
		len -= 6;
	}
	else if(cstr_begins_with(line, "^"))
	{
		writes("#");
		skipsemi = 1;
		line++;
		len--;
	}
	else if(line[len-1] == '{' || strcmp(line, "}") == 0)
	{
		skipsemi = 1;
	}
	else if(tabs == 0)
	{
		addvoids();
	}
	else
	{
		procstmt();
	}
	writes(line);
	skipsemi = skipsemi || len == 0 || line[0] == '"' || line[0] == '<' || line[0] == '/' || last() == '/';
	if(caselabel && len == 0)
	{
		skipsemi = 0;
	}
	lastblank = len == 0;
	lastlabel = 0;
	lastcase = 0;
	if(label || !lastblank)
	{
		lastlabel = label;
	}
	if(caselabel && !lastblank)
	{
		lastcase = caselabel;
	}
	lasttabs = tabs;
}

void writedelim(void)
{
	int lt = lasttabs;
	if(first_line_of_macro)
	{
		skipsemi = 1;
		if(tabs != 0)
		{
			lt = tabs;
		}
	}
	if(lt >= tabs && (!skipsemi || (lastblank && (lastlabel || lastcase))) && !(lt > 0 && blocktype[lt-1] == INIT))
	{
		if(is_kwdparens && blocktype[lt] != DOWHILE)
		{
			writes(" {}");
		}
		else
		{
			writes(";");
		}
	}
	if(in_macro && tabs > 0)
	{
		writes(" \\");
	}
	writes("\n");
	if(!(in_macro && tabs == 0))
	{
		while(lt > tabs)
		{
			indent(--lt);
			if(blocktype[lt] == STRUCT || blocktype[lt] == CLASS)
			{
				writes("};\n");
			}
			else if(blocktype[lt] == INIT && !(lt>0 && blocktype[lt-1] == INIT))
			{
				writes("};\n");
			}
			else
			{
				if(lt == 0 && blocktype[0] == VOID_MAIN)
				{
					writes("\treturn 0;\n");
				}
				writes("}\n");
			}
		}
		while(lt < tabs)
		{
			indent(lt++);
			writes("{\n");
		}
	}
	if(in_macro && tabs == 0)
	{
		in_macro = 0;
	}
	first_line_of_macro = 0;
}

int main(void)
{
	if(readstmt())
	{
		writestmt();
		while(readstmt())
		{
			writedelim();
			writestmt();
		}
		writedelim();
	}
	return 0;
}

