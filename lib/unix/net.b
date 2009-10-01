use error io util types net

export sys/socket.h
export netinet/in.h
export netinet/tcp.h
export arpa/inet.h
export netdb.h
export sys/un.h
use string.h
def INVALID_SOCKET -1
def UNIX_PATH_MAX 108
typedef int SOCKET
typedef struct sockaddr_un sockaddr_un

def closesocket(s) close(s)

#extern int h_errno

int Server_unix_stream(char *addr)
	int ear = Socket(PF_UNIX, SOCK_STREAM, 0)
	struct sockaddr_un sa
	Sockaddr_unix(&sa, addr)
	Bind(ear, (sockaddr *)&sa, sizeof(sockaddr_un))
	Listen(ear, 20)
	return ear

int Client_unix_stream(char *addr)
	int sock = Socket(PF_UNIX, SOCK_STREAM, 0)
	struct sockaddr_un sa
	Sockaddr_unix(&sa, addr)
	Connect(sock, (sockaddr *)&sa, sizeof(sockaddr))
	return sock

def Server(addr) Server_unix_stream(addr)
def Client(addr) Client_unix_stream(addr)

Sockaddr_unix(struct sockaddr_un *sa, char *addr)
	sa->sun_family = AF_UNIX
	if strlen(addr) > UNIX_PATH_MAX-1
		error("pathname to unix socket too long: %s", addr)
	strcpy(addr, sa->sun_path)

def get_winsock_errno()
	.

def get_h_errno()
	errno = h_errno
	# TODO I haven't checked if strerror gives messages for this yet

def winsock_open_osfhandle(fd)
	winsock_open_osfhandle(fd, 0)
def winsock_open_osfhandle(fd, flags)
	void(fd, flags)

def fd_to_socket(fd) fd

def winsock_close(fd)
	.
def winsock_fclose(fd)
	.

def winsock_vfprintf(file, format, ap)
	.
def winsock_fsay(file, s)
	.
def winsock_vfsayf(file, format, ap)
	.
def winsock_putc(file, c)
	if 0
		.
def winsock_fwrite(ptr, size, nmemb, stream)
	.
def winsock_fflush(file)
	.

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

