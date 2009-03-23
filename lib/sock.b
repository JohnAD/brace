export proc shuttle sched net io alloc

size_t block_size = 1024

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
	if add_fd(listen_fd)
		Close(listen_fd)
		error("listener: can't create listener, too many sockets")
	cloexec(listen_fd)
	nonblock(listen_fd)
	repeat
		read(listen_fd)
		NEW(s, sock, socklen)
		s->fd = Accept(listen_fd, (struct sockaddr *)s->sa, &s->len)

		if add_fd(s->fd)
			warn("listener: maximum number of sockets exceeded, rejecting %d", s->fd)
			sock_free(s)
		 else
			cloexec(s->fd)
			nonblock(s->fd)
			keepalive(s->fd)
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

def reader reader_try
def writer writer_try
#def reader reader_sel
#def writer writer_sel

def reader_sel_init(r, fd)
	reader_sel_init(r, fd, block_size)

# Here are the reader and writer that call select first,
# to check if it's ready to read or write.

proc reader_sel(int fd, size_t block_size)
	port buffer out
	state boolean done = 0
	while !done
		proc_debug("reader %010p - before pull", b__p)
		pull(out)
		proc_debug("reader %010p - after pull", b__p)
		buffer_ensure_free(&out, block_size)
		proc_debug("reader %010p - calling read(%d)", b__p, fd)
		read(fd)
		ssize_t n = read(fd, bufend(&out), buffer_get_free(&out))
		if n == -1
			n = 0
			swarning("reader %010p: error", b__p)
			done = 1
		 eif n
			buffer_grow(&out, n)
		 else
			# XXXXXX not sure if this is a good idea to clear the buffer on EOF!
			proc_debug("reader %010p fd %d at EOF", b__p, fd)
			buffer_clear(&out)
			done = 1
		push(out)

proc writer_sel(int fd)
	port buffer in
	state boolean done = 0
	while !done
		proc_debug("writer %010p - before pull", b__p)
		pull(in)
		proc_debug("writer %010p - after pull", b__p)
		if !buflen(&in)
			shutdown(fd, SHUT_WR)
			done = 1
		while buflen(&in)
			proc_debug("writer %010p - calling write(%d)", b__p, fd)
			write(fd)
			ssize_t n = write(fd, buf0(&in), buflen(&in))
			if n == -1
				n = 0
				swarning("writer %010p: error", b__p)
				# signals the caller that we have an error,
				# by the fact that the buffer is not empty.
				done = 1
				break
			 else
				buffer_shift(&in, n)
		push(in)

def bread(in)
	bread(in, 1)
def bread(in, size)
	if here(in) && !buflen(&in)
		push(in)
	repeat
		pull(in)
		if (size_t)buflen(&in) >= (size_t)size || !buflen(&in)
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

def bwrite_direct(out, _start, _end)
	pull(out)
	out.start = _start
	out.end = _end
	out.space_end = _end

unsigned int max_line_length = 0

def breadln(in)
	breaduntil(in, '\n')
def breaduntil(in, eol)
	breaduntil(in, eol, my(c))
def breaduntil(in, eol, c)
	# this is getting ugly, need to do it better.
	if here(in) && !buflen(&in)
		push(in)
	repeat
		pull(in)
		if !buflen(&in)
			break
		char *c = memchr(buf0(&in), eol, buflen(&in))
		if c
			*c = '\0'
			break
		if max_line_length && buflen(&in) >= max_line_length
			# a too-long line is an error condition
			bufclr(&in)
			break
		push(in)
#		warn("breadln: buflen %d\n[%s]\n", buflen(&in), buffer_nul_terminate(&in))
#		buffer_dump(stderr, &in)
#	warn("breadln: %s", !buflen(&in) ? NULL : buf0(&in))
	proc_debug("breadln: %s", !buflen(&in) ? NULL : buf0(&in))
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

# I remember Paul / Dancer recommending to try writing before selecting.
# (they didn't say anything about anticipating reading).
# I'm not sure it if speeds things up or not.

# Here are the reader and writer that try to read or write first,
# and calling select only if the read / write fails.

def reader_try_init(r, fd)
	reader_try_init(r, fd, block_size)

proc reader_try(int fd, size_t block_size)
	port buffer out
	state boolean done = 0
	while !done
		proc_debug("reader %010p - before pull", b__p)
		pull(out)
		proc_debug("reader %010p - after pull", b__p)
		buffer_ensure_free(&out, block_size)
		ssize_t n = read(fd, bufend(&out), buffer_get_free(&out))
		if n == -1
			if errno == EAGAIN
				proc_debug("reader %010p - calling read(%d)", b__p, fd)
				read(fd)
				continue
			 else
				n = 0
				if errno != ECONNRESET
					swarning("reader %010p: error", b__p)
				done = 1
		 eif n
			buffer_grow(&out, n)
		 else  # n == 0
			# XXXXXX not sure if this is a good idea to clear the buffer on EOF!
			proc_debug("reader %010p fd %d at EOF", b__p, fd)
			buffer_clear(&out)
			done = 1
		push(out)

proc writer_try(int fd)
	port buffer in
	state boolean done = 0
	while !done
		proc_debug("writer %010p - before pull", b__p)
		pull(in)
		proc_debug("writer %010p - after pull", b__p)
		if !buflen(&in)
			shutdown(fd, SHUT_WR)
			done = 1
		while buflen(&in)
			ssize_t n = write(fd, buf0(&in), buflen(&in))
			if n == -1
				n = 0
				if errno == EAGAIN
					proc_debug("writer %010p - calling write(%d)", b__p, fd)
					write(fd)
					continue
				 else
					swarning("writer %010p: error", b__p)
					# signals the caller that we have an error,
					# by the fact that the buffer is not empty.
					done = 1
					break
			 else
				buffer_shift(&in, n)
		push(in)

# FIXME this connect_nb_tcp is a bit long for a macro!
# maybe it should be a proc?

def connect_nb_tcp(sk, addr, port)
	state sock_p sk
	NEW(sk, sock, sizeof(sockaddr_in))
	sk->fd = Socket(PF_INET, SOCK_STREAM, 0)
	if add_fd(sk->fd)
		Close(sk->fd)
		error("can't connect, too many sockets")
	cloexec(sk->fd)
	nonblock(sk->fd)

	Sockaddr_in((sockaddr_in *)sk->sa, name_to_ip(addr), port)
	if connect(sk->fd, sk->sa, &sk->socklen)
		if errno == EINPROGRESS
			write(sk->fd)
			int err
			size_t size = sizeof(err)
			if Getsockopt(s, SOL_SOCKET, SO_ERROR, &err, &size)
				errno = err
				failed("connect")
		 else
			failed("connect")

