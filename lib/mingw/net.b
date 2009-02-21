export winsock2.h ws2tcpip.h mswsock.h
export vec
use error stdc

# http://msdn.microsoft.com/en-us/library/ms740126(VS.85).aspx
# do I need to use ioctlsocket / WSAIoctl?

use net

# this code for inet_aton was snarfed from dietlibc, whose author disclaims authorship of it!
# (jokingly I think)

int inet_aton(const char *cp, struct in_addr *inp)
	int i = 24
	unsigned int ip = 0
	char *tmp = (char*)cp
	repeat
		long j
		j = strtoul(tmp, &tmp, 0)
		if *tmp == 0
			ip |= j
			break
		if *tmp == '.'
			if j > 255
				return 0
			ip |= (j<<i)
			if i > 0
				i-=8
			++tmp
			continue
		return 0
	inp->s_addr = htonl(ip)
	return 1

def get_h_errno()
	.

def get_winsock_errno()
	errno = WSAGetLastError()

winsock_init()
	winsock_error_message_init()
	global(winsock_fd_to_socket, vec, SOCKET, 64)
	global(winsock_out_buffer, vec, buffer, 64)
	WSADATA wsaData
	int err = WSAStartup(MAKEWORD(2, 2), &wsaData)
	if err != 0
		failed("WSAStartup")
	int sockopt = SO_SYNCHRONOUS_NONALERT;
	Setsockopt(INVALID_SOCKET, SOL_SOCKET, SO_OPENTYPE, &sockopt, sizeof(sockopt))
	atexit(winsock_free)

winsock_free()
	WSACleanup()

def SHUT_RD SD_RECEIVE
def SHUT_WR SD_SEND
def SHUT_RDWR SD_BOTH

# messages from ws-util.cpp, by Warren Young, http://tangentsoft.net/

winsock_error_message_init()
	add_error_message(WSAEINTR,           "Interrupted system call")
	add_error_message(WSAEBADF,           "Bad file number")
	add_error_message(WSAEACCES,          "Permission denied")
	add_error_message(WSAEFAULT,          "Bad address")
	add_error_message(WSAEINVAL,          "Invalid argument")
	add_error_message(WSAEMFILE,          "Too many open sockets")
	add_error_message(WSAEWOULDBLOCK,     "Operation would block")
	add_error_message(WSAEINPROGRESS,     "Operation now in progress")
	add_error_message(WSAEALREADY,        "Operation already in progress")
	add_error_message(WSAENOTSOCK,        "Socket operation on non-socket")
	add_error_message(WSAEDESTADDRREQ,    "Destination address required")
	add_error_message(WSAEMSGSIZE,        "Message too long")
	add_error_message(WSAEPROTOTYPE,      "Protocol wrong type for socket")
	add_error_message(WSAENOPROTOOPT,     "Bad protocol option")
	add_error_message(WSAEPROTONOSUPPORT, "Protocol not supported")
	add_error_message(WSAESOCKTNOSUPPORT, "Socket type not supported")
	add_error_message(WSAEOPNOTSUPP,      "Operation not supported on socket")
	add_error_message(WSAEPFNOSUPPORT,    "Protocol family not supported")
	add_error_message(WSAEAFNOSUPPORT,    "Address family not supported")
	add_error_message(WSAEADDRINUSE,      "Address already in use")
	add_error_message(WSAEADDRNOTAVAIL,   "Can't assign requested address")
	add_error_message(WSAENETDOWN,        "Network is down")
	add_error_message(WSAENETUNREACH,     "Network is unreachable")
	add_error_message(WSAENETRESET,       "Net connection reset")
	add_error_message(WSAECONNABORTED,    "Software caused connection abort")
	add_error_message(WSAECONNRESET,      "Connection reset by peer")
	add_error_message(WSAENOBUFS,         "No buffer space available")
	add_error_message(WSAEISCONN,         "Socket is already connected")
	add_error_message(WSAENOTCONN,        "Socket is not connected")
	add_error_message(WSAESHUTDOWN,       "Can't send after socket shutdown")
	add_error_message(WSAETOOMANYREFS,    "Too many references, can't splice")
	add_error_message(WSAETIMEDOUT,       "Connection timed out")
	add_error_message(WSAECONNREFUSED,    "Connection refused")
	add_error_message(WSAELOOP,           "Too many levels of symbolic links")
	add_error_message(WSAENAMETOOLONG,    "File name too long")
	add_error_message(WSAEHOSTDOWN,       "Host is down")
	add_error_message(WSAEHOSTUNREACH,    "No route to host")
	add_error_message(WSAENOTEMPTY,       "Directory not empty")
	add_error_message(WSAEPROCLIM,        "Too many processes")
	add_error_message(WSAEUSERS,          "Too many users")
	add_error_message(WSAEDQUOT,          "Disc quota exceeded")
	add_error_message(WSAESTALE,          "Stale NFS file handle")
	add_error_message(WSAEREMOTE,         "Too many levels of remote in path")
	add_error_message(WSASYSNOTREADY,     "Network system is unavailable")
	add_error_message(WSAVERNOTSUPPORTED, "Winsock version out of range")
	add_error_message(WSANOTINITIALISED,  "WSAStartup not yet called")
	add_error_message(WSAEDISCON,         "Graceful shutdown in progress")
	add_error_message(WSAHOST_NOT_FOUND,  "Host not found")
	add_error_message(WSANO_DATA,         "No host data of that type was found")

vec *winsock_fd_to_socket
vec *winsock_out_buffer

def winsock_out_buffer_autoflush 1024

def winsock_open_osfhandle(fd)
	winsock_open_osfhandle(fd, 0)  # O_RDWR|O_BINARY not needed?
def winsock_open_osfhandle(fd, flags)
	fd = _winsock_open_osfhandle(fd, flags)
int _winsock_open_osfhandle(int fd, int flags)
	int my(sockh) = fd
	fd = _open_osfhandle(fd, flags)
	vec_ensure_size_init(winsock_fd_to_socket, fd+1, INVALID_SOCKET)
	vec_ensure_size(winsock_out_buffer, fd+1)
	fd_to_socket(fd) = my(sockh)
	buffer *b = vec_element(winsock_out_buffer, fd)
	init(b, buffer, 64)
	return fd

def fd_to_socket(fd) *(SOCKET*)vec_element(winsock_fd_to_socket, fd)
def fd_is_socket(fd) fd < (int)vec_get_size(winsock_fd_to_socket) ? fd_to_socket(fd) : INVALID_SOCKET

def winsock_close(fd)
	SOCKET my(s) = fd_is_socket(fd)
	if my(s) != INVALID_SOCKET
		if close(fd) != 0
			failed("close")
		Closesocket(fd)
		fd_to_socket(fd) = INVALID_SOCKET
		return

def winsock_fclose(stream)
	int my(fd) = fileno(stream)
	SOCKET my(s) = fd_is_socket(my(fd))
	if my(s) != INVALID_SOCKET
		buffer *my(b) = vec_element(winsock_out_buffer, my(fd))
		_winsock_fflush(stream, my(fd), my(b))
		if fclose(stream) != 0
			failed("fclose")
		Closesocket(my(fd))
		fd_to_socket(my(fd)) = INVALID_SOCKET
		return

def winsock_vfprintf(stream, format, ap)
	int my(fd) = fileno(stream)
	SOCKET my(s) = fd_is_socket(my(fd))
	if my(s) != INVALID_SOCKET
		buffer *my(b) = vec_element(winsock_out_buffer, my(fd))
		int rv = Vsprintf(my(b), format, ap)
		winsock_autoflush(stream, my(fd), my(b))
		return rv

def winsock_fsay(stream, s)
	int my(fd) = fileno(stream)
	SOCKET my(s) = fd_is_socket(my(fd))
	if my(s) != INVALID_SOCKET
		buffer *my(b) = vec_element(winsock_out_buffer, my(fd))
		buffer_cat_cstr(my(b), s)
		buffer_nl(my(b))
		winsock_autoflush(stream, my(fd), my(b))
		return

def winsock_vfsayf(stream, format, ap)
	int my(fd) = fileno(stream)
	SOCKET my(s) = fd_is_socket(my(fd))
	if my(s) != INVALID_SOCKET
		buffer *my(b) = vec_element(winsock_out_buffer, my(fd))
		int rv = Vsprintf(my(b), format, ap)
		buffer_nl(my(b))
		winsock_autoflush(stream, my(fd), my(b))
		return rv

def winsock_putc(c, stream)
	int my(fd) = fileno(stream)
	SOCKET my(s) = fd_is_socket(my(fd))
	if my(s) != INVALID_SOCKET
		buffer *my(b) = vec_element(winsock_out_buffer, my(fd))
		buffer_cat_char(my(b), c)
		winsock_autoflush(stream, my(fd), my(b))

def winsock_fwrite(ptr, size, nmemb, stream)
	int my(fd) = fileno(stream)
	SOCKET my(s) = fd_is_socket(my(fd))
	if my(s) != INVALID_SOCKET
		buffer *my(b) = vec_element(winsock_out_buffer, my(fd))
		buffer_cat_range(my(b), ptr, ((char*)ptr)+size*nmemb)
		winsock_autoflush(stream, my(fd), my(b))
		return

winsock_autoflush(FILE *stream, int fd, buffer *b)
	use(stream)
	if buffer_get_size(b) >= winsock_out_buffer_autoflush
		_winsock_fflush(stream, fd, b)

def winsock_fflush(stream)
	int my(fd) = fileno(stream)
	SOCKET my(s) = fd_is_socket(my(fd))
	if my(s) != INVALID_SOCKET
		buffer *my(b) = vec_element(winsock_out_buffer, my(fd))
		_winsock_fflush(stream, my(fd), my(b))
		return

def _winsock_fflush(stream, fd, b)
	Write(fd, buffer_get_start(b), buffer_get_size(b))
	buffer_clear(b)
