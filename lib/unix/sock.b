use sock

listener_unix_init(listener *p, cstr addr)
	int listen_fd = Server(addr)
	init(p, listener, listen_fd, sizeof(sockaddr_un))

