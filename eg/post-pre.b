#!/lang/b

use b

Main()
	# also testing post-pre
	cstr x = strdup("hello world")

	post(_p1_)
		Free(x)
	 pre(_p1_)
		Sayf("%s", x)

	post(_p2_)
		Say("world")
	 pre(_p2_)
		Say("hello")

	int fd = Open("/etc/passwd", O_RDONLY)
	post(_1_)
		Close(fd)
		nl()
		Say("file closed")
	 pre(_1_)
		char b[1025]
		ssize_t count = Read(fd, b, 1024)
		b[count] = '\0'
		Say(b)
