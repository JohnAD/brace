export proc shuttle sched net io alloc

int block_size = 1024

struct sock
	int fd
	sockaddr *sa
	socklen_t len

typedef sock *sock_p

sock_init(sock *s, socklen_t socklen)
	s->fd = -1
	s->sa = Malloc(socklen)
	s->len = socklen
	bzero(s->sa, socklen)

sock_free(sock *s)
	if s->fd != -1
		close(s->fd)
	s->fd = -1
	Free(s->sa)

struct shuttle_buffer
	shuttle sh
	buffer d

struct shuttle_sock_p
	shuttle sh
	sock_p d

listener_tcp_init(listener *p, cstr listen_addr, int listen_port)
	int listen_fd = Server(listen_addr, listen_port)
	listener_init(p, listen_fd, sizeof(sockaddr_in))

listener_unix_init(listener *p, cstr addr)
	int listen_fd = Server(addr)
	listener_init(p, listen_fd, sizeof(sockaddr_un))

# FIXME handle Accept errors
proc listener(int listen_fd, socklen_t socklen)
	port sock_p out
	state sock_p s
	nonblock(listen_fd)
	add_fd(listen_fd)
	repeat
		read(listen_fd)
		NEW(s, sock, socklen)
		s->fd = Accept(listen_fd, (struct sockaddr *)s->sa, &s->len)

		if sched_io_full(s->fd)
			warn("listener: maximum number of sockets exceeded, rejecting %d", s->fd)
			sock_free(s)
		 else
			nonblock(s->fd)
			keepalive(s->fd)
			add_fd(s->fd)
			wr(out, s)
	# XXX sa not freed

typedef listener listener_tcp
typedef listener listener_unix

# this was for debugging

proc write_sock()
	port sock_p in
	state sock_p s
	repeat
		rd(in, s)
		Sayf("%d", s->fd)
		rm_fd(s->fd)
		sock_free(s)

# TODO use circbuf instead to avoid having to shift?

# NOTE at EOF, reader will return an ungrown buffer, might not be an empty buffer
# they need to check for that.

def reader_init(reader, fd)
	reader_init(reader, fd, block_size)

proc reader(int fd, size_t block_size)
	port buffer out
	repeat
		proc_debug("reader - before pull")
		pull(out)
		proc_debug("reader - after pull")
		buffer_ensure_free(&out, block_size)
		read(fd)
		ssize_t n = read(fd, bufend(&out), buffer_get_free(&out))
		if n == -1
			n = 0
			swarning("reader: error")
		 eif n
			buffer_grow(&out, n)
		 eif Read_eof(fd)
			# XXXXXX not sure if this is a good idea to clear the buffer on EOF!
			buffer_clear(&out)
		push(out)

proc writer(int fd)
	port buffer in
	repeat
		proc_debug("writer - before pull")
		pull(in)
		proc_debug("writer - after pull")
		if buflen(&in)
			while buflen(&in)
				ssize_t n = write(fd, buf0(&in), buflen(&in))
				if n == -1
					n = 0
					if errno == EAGAIN
						write(fd)
					 else
						swarning("writer: error")
						# signals the caller that we have an error,
						# by the fact that the buffer is not empty.
						break
				 else
					buffer_shift(&in, n)
		 else
			shutdown(fd, SHUT_WR)
		push(in)

def bread(in)
	bread(in, 1)
def bread(in, size)
	repeat
		pull(in)
		if buflen(&in) >= size || !buflen(&in)
			break
		buffer_ensure_space(&in, size)
		push(in)
	# can return an empty buffer at EOF

# bflush: remember to call it some time after bwrite, bprint etc.
# This sock buffered io does not ever at the moment auto flush.
# this assumes writer will (try to) write all the data
def bflush(out)
	proc_debug("bflush - start - pulling")
	pull(out)
	if !buflen(&out)
		proc_debug("bflush - buffer is empty")
	 else
		proc_debug("bflush - pushing")
		push(out)
		pull(out)
		proc_debug("bflush - done")

def bwrite(out, start, end)
	pull(out)
	buffer_cat_range(&out, start, end)

def max_line_length 0

def breadln(in)
	breaduntil(in, '\n')
def breaduntil(in, eol)
	breaduntil(in, eol, my(c))
def breaduntil(in, eol, c)
	pull(in)
	repeat
		char *c = memchr(buf0(&in), eol, buflen(&in))
		if c
			*c = '\0'
			break
		 else
			if max_line_length && buflen(&in) >= max_line_length
				break
			push(in)
			pull(in)
			if !buflen(&in)
				break
#	warn("breadln: %s", !buflen(&in) ? NULL : buf0(&in))
#	proc_debug("breadln: %s", !buflen(&in) ? NULL : buf0(&in))
	# can return an empty buffer at EOF

def bprint(out, s)
	pull(out)
	buffer_cat_cstr(&out, s)

def bsay(out, s)
	pull(out)
	buffer_cat_cstr(&out, s)
	buffer_cat_char(&out, '\n')

def bnl(out)
	pull(out)
	buffer_cat_char(&out, '\n')

def bcrlf(out)
	pull(out)
	buffer_cat_cstr(&out, "\r\n")


def bprintf(out, fmt)
	state cstr my(s) = format(fmt)
	bprint(out, my(s))
	Free(my(s))
def bprintf(out, fmt, a0)
	state cstr my(s) = format(fmt, a0)
	bprint(out, my(s))
	Free(my(s))
def bprintf(out, fmt, a0, a1)
	state cstr my(s) = format(fmt, a0, a1)
	bprint(out, my(s))
	Free(my(s))
def bprintf(out, fmt, a0, a1, a2)
	state cstr my(s) = format(fmt, a0, a1, a2)
	bprint(out, my(s))
	Free(my(s))
def bprintf(out, fmt, a0, a1, a2, a3)
	state cstr my(s) = format(fmt, a0, a1, a2, a3)
	bprint(out, my(s))
	Free(my(s))
def bprintf(out, fmt, a0, a1, a2, a3, a4)
	state cstr my(s) = format(fmt, a0, a1, a2, a3, a4)
	bprint(out, my(s))
	Free(my(s))
def bprintf(out, fmt, a0, a1, a2, a3, a4, a5)
	state cstr my(s) = format(fmt, a0, a1, a2, a3, a4, a5)
	bprint(out, my(s))
	Free(my(s))


def bsayf(out, fmt)
	state cstr my(s) = format(fmt)
	bsay(out, my(s))
	Free(my(s))
def bsayf(out, fmt, a0)
	state cstr my(s) = format(fmt, a0)
	bsay(out, my(s))
	Free(my(s))
def bsayf(out, fmt, a0, a1)
	state cstr my(s) = format(fmt, a0, a1)
	bsay(out, my(s))
	Free(my(s))
def bsayf(out, fmt, a0, a1, a2)
	state cstr my(s) = format(fmt, a0, a1, a2)
	bsay(out, my(s))
	Free(my(s))
def bsayf(out, fmt, a0, a1, a2, a3)
	state cstr my(s) = format(fmt, a0, a1, a2, a3)
	bsay(out, my(s))
	Free(my(s))
def bsayf(out, fmt, a0, a1, a2, a3, a4)
	state cstr my(s) = format(fmt, a0, a1, a2, a3, a4)
	bsay(out, my(s))
	Free(my(s))
def bsayf(out, fmt, a0, a1, a2, a3, a4, a5)
	state cstr my(s) = format(fmt, a0, a1, a2, a3, a4, a5)
	bsay(out, my(s))
	Free(my(s))

