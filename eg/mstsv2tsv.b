#!/lang/b

use error io

int main()
	int c
	while 1
		Getchar(c)
		which c
		EOF	return 0
		'"'	quoted()
		else	Putchar(c)

quoted()
	int c
	while 1
		Getchar(c)
		which c
		EOF	error("missing \" before EOF")
		'"'	if double_quote() == 0
				return
		'\n'	Print("\\n")
		'\r'	Print("\\r")
		'\t'	Print("\\t")
		'\\'	Print("\\\\")
		else	Putchar(c)

int double_quote()
	int c
	Getchar(c)
	which c
	'"'	Putchar('"')
		return 1
	EOF	.
	else	Putchar(c)
	return 0
