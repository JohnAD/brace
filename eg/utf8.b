#!/lang/b
use b
Main()
	cstr s = "1000Ω"
	if (strstr(s, "Ω") == s+strlen(s)-strlen("Ω"))
		printf("yes, %s ends with Ω\n", s)
