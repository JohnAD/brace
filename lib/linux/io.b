use io

nonblock(int fd, int nb)
	if ioctl(fd, FIONBIO, &nb) == -1
		failed("ioctl")
