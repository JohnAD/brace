export proc shuttle sched net io alloc
use sock

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

in_addr sock_in_addr(sock *s)
	return ((sockaddr_in*)s->sa)->sin_addr

u_int16_t sock_in_port(sock *s)
	return ntohs(((sockaddr_in*)s->sa)->sin_port)

struct shuttle_buffer
	shuttle sh
	buffer d

struct shuttle_sock_p
	shuttle sh
	sock_p d

listener_tcp_init(listener *p, cstr listen_addr, int listen_port)
	int listen_fd = Server(listen_addr, listen_port)
	init(p, listener, listen_fd, sizeof(sockaddr_in))

#def listener listener_sel
def listener listener_try

proc listener_sel(int listen_fd, socklen_t socklen)
	port sock_p out
	state sock_p s
	if add_fd(listen_fd, 0)
		Close(listen_fd)
		error("listener: can't create listener, too many sockets")
	cloexec(listen_fd)
	nonblock(listen_fd)
	repeat
		NEW(s, sock, socklen)
		read(listen_fd)
		s->fd = accept(listen_fd, (struct sockaddr *)s->sa, &s->len)
		if s->fd < 0
			sock_free(s)
			if errno == EAGAIN  # can happen if forked
				.
			 eif errno == EMFILE || errno == ENFILE
				warn("listener: maximum number of file descriptors exceeded, rejecting %d", s->fd)
			 else
				failed("accept")
		 eif add_fd(s->fd)
			warn("listener: maximum number of sockets exceeded, rejecting %d", s->fd)
			sock_free(s)
		 else
			cloexec(s->fd)
			nonblock(s->fd)
			keepalive(s->fd)
			wr(out, s)

proc listener_try(int listen_fd, socklen_t socklen)
	port sock_p out
	state sock_p s
	if add_fd(listen_fd, 1)
		Close(listen_fd)
		error("listener: can't create listener, too many sockets")
	cloexec(listen_fd)
	nonblock(listen_fd)
	repeat
		NEW(s, sock, socklen)
		s->fd = accept(listen_fd, (struct sockaddr *)s->sa, &s->len)
		if s->fd < 0
			sock_free(s)
			if errno == EAGAIN  # can happen if forked
				.
			 eif errno == EMFILE || errno == ENFILE
				warn("listener: maximum number of file descriptors exceeded, rejecting %d", s->fd)
			 else
				failed("accept")
			read(listen_fd)
		 eif add_fd(s->fd)
			warn("listener: maximum number of sockets exceeded, rejecting %d", s->fd)
			sock_free(s)
		 else
			cloexec(s->fd)
			nonblock(s->fd)
			keepalive(s->fd)
			wr(out, s)

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

def reader_sel_init(r, fd, block_size, sel_first)
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
			if errno != ECONNRESET
				swarning("reader %010p: error", b__p)
		 eif n
			buffer_grow(&out, n)
		if n == 0
			# XXXXXX not sure if this is a good idea to clear the buffer on EOF!
			proc_debug("reader %010p fd %d at EOF", b__p, fd)
			buffer_clear(&out)
			done = 1
		push(out)

def writer_sel_init(w, fd, sel_first)
	writer_sel_init(w, fd)

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
		buffer_ensure_space(&in, size)
		push(in)
	repeat
		pull(in)
		if (size_t)buflen(&in) >= (size_t)size || !buflen(&in)
			break
		buffer_ensure_space(&in, size-buflen(&in))
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
	state buffer bwrite_direct__saved_buffer = out
	pull(out)
	out.start = _start
	out.end = _end
	out.space_end = _end
	bflush(out)
	out = bwrite_direct__saved_buffer

int max_line_length = 0

def breadln(in)
	breadln(in, 0)
def breadln(in, start)
	char *my(c)
	breadln(in, start, my(c))
def breadln(in, start, c)
	breaduntil(in, start, '\n', c)
def breaduntil(in, start, eol, c)
	# this is getting ugly, need to do it better.
	if here(in) && buflen(&in) <= start
		push(in)
	repeat
		pull(in)
		if buflen(&in) <= start
			break
		c = memchr(b(&in, start), eol, buflen(&in)-start)
		if c
			*c = '\0'
		if max_line_length &&
		 ((c && c-b(&in, start) >= max_line_length) ||
		  (!c && buflen(&in)-start >= max_line_length))
			warn("received line longer than max_line_length %d - closing", max_line_length)
			bufclr(&in)
			break
		if c
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
	pull(out)
	Sprintf(&out, fmt)
def bprintf(out, fmt, a0)
	pull(out)
	Sprintf(&out, fmt, a0)
def bprintf(out, fmt, a0, a1)
	pull(out)
	Sprintf(&out, fmt, a0, a1)
def bprintf(out, fmt, a0, a1, a2)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2)
def bprintf(out, fmt, a0, a1, a2, a3)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3)
def bprintf(out, fmt, a0, a1, a2, a3, a4)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3, a4)
def bprintf(out, fmt, a0, a1, a2, a3, a4, a5)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3, a4, a5)


def bsayf(out, fmt)
	pull(out)
	Sprintf(&out, fmt)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0)
	pull(out)
	Sprintf(&out, fmt, a0)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0, a1)
	pull(out)
	Sprintf(&out, fmt, a0, a1)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0, a1, a2)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0, a1, a2, a3)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0, a1, a2, a3, a4)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3, a4)
	buffer_cat_char(&out, '\n')
def bsayf(out, fmt, a0, a1, a2, a3, a4, a5)
	pull(out)
	Sprintf(&out, fmt, a0, a1, a2, a3, a4, a5)
	buffer_cat_char(&out, '\n')

# I remember Paul / Dancer recommending to try writing before selecting.
# (they didn't say anything about anticipating reading).
# I'm not sure it if speeds things up or not.

# Here are the reader and writer that try to read or write first,
# and calling select only if the read / write fails.

def reader_try_init(r, fd)
	reader_try_init(r, fd, block_size)

def reader_try_init(r, fd, block_size)
#	reader_try_init(r, fd, block_size, 1)
	reader_try_init(r, fd, block_size, 0)

proc reader_try(int fd, size_t block_size, boolean sel_first)
	port buffer out
	state boolean done = 0
	if sel_first
		read(fd)
	while !done
		proc_debug("reader %010p - before pull", b__p)
		pull(out)
		proc_debug("reader %010p - after pull", b__p)
		buffer_ensure_free(&out, block_size)
		ssize_t want = buffer_get_free(&out)
		ssize_t n = read(fd, bufend(&out), want)
		if n < 0 && errno != EAGAIN
			n = 0
			if errno != ECONNRESET
				swarning("reader %010p: error", b__p)
		if n >= 0
			if n == 0
				# XXX not sure if a good idea to clear buffer on EOF!
				proc_debug("reader %010p fd %d at EOF", b__p, fd)
				buffer_clear(&out)
				done = 1
			 else
				buffer_grow(&out, n)
			push(out)
		if n < want
			proc_debug("reader %010p - calling read(%d)", b__p, fd)
			read(fd)

def writer_try_init(w, fd)
	writer_try_init(w, fd, 0)

proc writer_try(int fd, boolean sel_first)
	port buffer in
	state boolean done = 0
	if sel_first
		write(fd)
	while !done
		proc_debug("writer %010p - before pull", b__p)
		pull(in)
		proc_debug("writer %010p - after pull", b__p)
		if !buflen(&in)
			shutdown(fd, SHUT_WR)
			done = 1
		while buflen(&in)
			ssize_t want = buflen(&in)
			ssize_t n = write(fd, buf0(&in), want)
			if n < 0 && errno != EAGAIN
#				if errno != EPIPE
				swarning("writer %010p: error", b__p)
				# signal the caller that we have an error,
				# by the fact that the buffer is not empty.
				done = 1
				break
			if n >= 0
				buffer_shift(&in, n)
			if n < want
				proc_debug("writer %010p - calling write(%d)", b__p, fd)
				write(fd)
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
	if connect(sk->fd, sk->sa, sk->len)
		if errno == EINPROGRESS
			write(sk->fd)
			errno = Getsockerr(sk->fd)
		if errno
			failed("connect")

def bshut(out)
	bufclr(&out)
	pull(out)
	push(out)

def bclose(out)
	bshut(out)
	repeat
		bread(in, block_size)
		if !buflen(&in)
			break
	# Now, we have shut writing, and they have shut writing.
	# The socket has not been closed as such yet, sock_free does that.

