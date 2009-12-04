use net

cork(int fd, int cork)
	Setsockopt(fd, IPPROTO_TCP, TCP_CORK, &cork, sizeof(cork))
