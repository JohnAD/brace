use io

def nonblock(fd, nb) nonblock_ioctl(fd, nb)
nonblock_ioctl(int fd, int nb)
	if ioctl(fd, FIONBIO, &nb) == -1
		failed("ioctl")
