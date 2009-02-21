use error io util types net

export sys/socket.h
export netinet/in.h
export arpa/inet.h
export netdb.h
export sys/un.h
use string.h
def INVALID_SOCKET -1
def UNIX_PATH_MAX 108
typedef int SOCKET

def closesocket(s) close(s)

extern int h_errno

int Server_unix_stream(char *addr)
	int ear = Socket(PF_UNIX, SOCK_STREAM, 0)
	struct sockaddr sockaddr
	Sockaddr_unix(&sockaddr, addr)
	Bind(ear, &sockaddr, sizeof(sockaddr))
	Listen(ear, 20)
	return ear

int Client_unix_stream(char *addr)
	int sock = Socket(PF_UNIX, SOCK_STREAM, 0)
	struct sockaddr sockaddr
	Sockaddr_unix(&sockaddr, addr)
	Connect(sock, &sockaddr, sizeof(sockaddr))
	return sock

def Server(addr) Server_unix_stream(addr)
def Client(addr) Client_unix_stream(addr)

Sockaddr_unix(struct sockaddr *sockaddr, char *addr)
	struct sockaddr_un *sa = (struct sockaddr_un *)sockaddr
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
