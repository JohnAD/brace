use io

nonblock(int fd, int nb)
	if nb
		Fcntl_setfl(fd, Fcntl_getfl(fd) | O_NONBLOCK)
	 else
		Fcntl_setfl(fd, Fcntl_getfl(fd) & ~O_NONBLOCK)

