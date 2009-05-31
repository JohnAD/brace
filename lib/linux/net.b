use error net

export sys/sendfile.h

ssize_t Sendfile(int out_fd, int in_fd, off_t *offset, size_t count)
	ssize_t rv = sendfile(out_fd, in_fd, offset, count)
	if rv == -1
		if errno == EAGAIN
			rv = 0
		 else
			failed("sendfile")
	return rv

def cork(fd) cork(fd, 1)
cork(int fd, int cork)
	Setsockopt(fd, IPPROTO_TCP, TCP_CORK, &cork, sizeof(cork))
