export types
use error io util

use net

typedef struct sockaddr sockaddr
typedef struct sockaddr_in sockaddr_in
typedef struct sockaddr_un sockaddr_un

int listen_backlog = SOMAXCONN

int Socket(int domain, int type, int protocol)
	int fd = socket(domain, type, protocol)
	if fd == -1
		get_winsock_errno()
		failed("socket")
	winsock_open_osfhandle(fd)
	return fd

Bind(int sockfd, struct sockaddr *my_addr, socklen_t addrlen)
	if bind(fd_to_socket(sockfd), my_addr, addrlen) != 0
		get_winsock_errno()
		failed("bind")

Listen(int sockfd, int backlog)
	if listen(fd_to_socket(sockfd), backlog) != 0
		get_winsock_errno()
		failed("listen")
def Listen(sockfd) Listen(sockfd, listen_backlog)

int Accept(int earfd, struct sockaddr *addr, socklen_t *addrlen)
	int sockfd = accept(fd_to_socket(earfd), addr, addrlen)
	if sockfd == -1
		get_winsock_errno()
		failed("accept")
	winsock_open_osfhandle(sockfd)
	return sockfd
def Accept(ear)
	Accept(ear, NULL, 0)

Connect(int sockfd, const struct sockaddr *serv_addr, socklen_t addrlen)
	if connect(fd_to_socket(sockfd), serv_addr, addrlen) != 0
		get_winsock_errno()
		failed("connect")

Sockaddr_in(struct sockaddr_in *sa, char *addr, int port)
	sa->sin_family = AF_INET
	sa->sin_port = htons(port)
	if inet_aton(addr, &sa->sin_addr) == 0
		error("Invalid IP address `%s'.\n", addr)
	memset(&sa->sin_zero, 0, 8)

typedef struct hostent hostent
hostent *Gethostbyname(const char *name)
	let(rv, gethostbyname(name))
	if rv == NULL
		get_h_errno()
		failed("gethostbyname")
	return rv

#       The variable h_errno can have the following values:
#
#       HOST_NOT_FOUND
#              The specified host is unknown.
#
#       NO_ADDRESS or NO_DATA
#              The requested name is valid but does not have an IP address.
#
#       NO_RECOVERY
#              A non-recoverable name server error occurred.
#
#       TRY_AGAIN
#              A  temporary  error  occurred on an authoritative name server.  Try again
#              later.

# Warning: name_to_ip returns either is argument (if already an IP address) or
# a pointer to a static buffer from inet_ntoa.  So you might want to use Strdup
# to duplicate the result before it is overwritten later.

cstr name_to_ip(const char *name)
	struct in_addr addr
	if inet_aton(name, &addr)
		return (char*)name
	let(he, Gethostbyname(name))
	if he->h_addrtype != AF_INET
		error("name_to_ip: does not support ip6 yet")
	return inet_ntoa(*(struct in_addr *)(he->h_addr_list[0]))

int Server_tcp(char *addr, int port)
	addr = name_to_ip(addr)
	int ear = Socket(PF_INET, SOCK_STREAM, 0)
	reuseaddr(ear)
	struct sockaddr_in sa
	Sockaddr_in(&sa, addr, port)
	Bind(ear, (sockaddr *)&sa, sizeof(sockaddr_in))
	Listen(ear)
	return ear

Setsockopt(int s, int level, int optname, const void *optval, socklen_t optlen)
	if setsockopt(fd_to_socket(s), level, optname, optval, optlen)
		get_winsock_errno()
		failed("setsockopt")

int Client_tcp(char *addr, int port)
	addr = name_to_ip(addr)
	int sock = Socket(PF_INET, SOCK_STREAM, 0)
	struct sockaddr_in sa
	Sockaddr_in(&sa, addr, port)
	Connect(sock, (sockaddr *)&sa, sizeof(sockaddr))
	return sock

def Server(addr, port) Server_tcp(addr, port)
def Client(addr, port) Client_tcp(addr, port)

# is caching hostname a good idea?
# beware if writing a program to change hostname!
def hostname__max_len 256
char hostname__[hostname__max_len] = ""
cstr Hostname()
	if hostname__[0] == '\0'
		if gethostname(hostname__, hostname__max_len) != 0
			get_winsock_errno()
			failed("gethostname")
		hostname__[hostname__max_len-1] = '\0'
	return hostname__


# FIXME wrap this!
#
# struct hostent *gethostbyaddr(const void *addr, int len, int type);

def Send(s, buf, len) Send(s, buf, len, 0)
ssize_t Send(int s, const void *buf, size_t len, int flags)
	ssize_t rv = send(fd_to_socket(s), buf, len, flags)
	if rv == -1
		get_winsock_errno()
		if errno == EAGAIN
			rv = 0
		 else
			failed("send")
	return rv

def Recv(s, buf, len) Recv(s, buf, len, 0)
ssize_t Recv(int s, void *buf, size_t len, int flags)
	errno = 0
	ssize_t rv = recv(fd_to_socket(s), buf, len, flags)
	if rv == -1
		get_winsock_errno()
		if errno == EAGAIN
			rv = 0
		 else
			failed("recv")
	return rv

def Recv_eof(fd) errno == 0

def SendTo(s, buf, len, to, tolen) Send(s, buf, len, 0, to, tolen)
ssize_t SendTo(int s, const void *buf, size_t len, int flags, const struct sockaddr *to, socklen_t tolen)
	ssize_t rv = sendto(fd_to_socket(s), buf, len, flags, to, tolen)
	if rv == -1
		get_winsock_errno()
		if errno == EAGAIN
			rv = 0
		 else
			failed("sendto")
	return rv

def RecvFrom(s, buf, len, from, fromlen) RecvFrom(s, buf, len, 0, from, fromlen)
ssize_t RecvFrom(int s, void *buf, size_t len, int flags, struct sockaddr *from, socklen_t *fromlen)
	errno = 0
	ssize_t rv = recvfrom(fd_to_socket(s), buf, len, flags, from, fromlen)
	if rv == -1
		get_winsock_errno()
		if errno == EAGAIN
			rv = 0
		 else
			failed("recvfrom")
	return rv

# shutdown's "how" can be SHUT_RD, SHUT_WR or SHUT_RDWR

def Shutdown(s) Shutdown(s, SHUT_WR)
Shutdown(int s, int how)
	int rv = shutdown(fd_to_socket(s), how)
	if rv == -1
		get_winsock_errno()
		failed("shutdown")

Closesocket(int fd)
	if closesocket(fd_to_socket(fd)) != 0
		failed("closesocket")

def keepalive(fd) keepalive(fd, 1)
keepalive(int fd, int keepalive)
	Setsockopt(fd, SOL_SOCKET, SO_KEEPALIVE, &keepalive, sizeof(keepalive))

def nodelay(fd) nodelay(fd, 1)
nodelay(int fd, int nodelay)
	Setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, &nodelay, sizeof(nodelay))

def cork(fd) cork(fd, 1)
cork(int fd, int cork)
	Setsockopt(fd, IPPROTO_TCP, TCP_CORK, &cork, sizeof(cork))

def reuseaddr(fd) reuseaddr(fd, 1)
reuseaddr(int fd, int reuseaddr)
	Setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &reuseaddr, sizeof(reuseaddr))

Getsockopt(int s, int level, int optname, void *optval, socklen_t *optlen)
	if getsockopt(s, level, optname, optval, optlen)
		get_winsock_errno()
		failed("getsockopt")

int Getsockerr(int fd)
	int err
	socklen_t size = sizeof(err)
	Getsockopt(fd, SOL_SOCKET, SO_ERROR, &err, &size)
	return err

# TODO add / use getaddrinfo
