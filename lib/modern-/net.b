use io m types
use net

ssize_t sendfile(int out_fd, int in_fd, off_t *offset, size_t count)
	int err = 0
	char buf[block_size]
	off_t totsent = 0
	off_t old_offset = 0
	if offset
		old_offset = tell(in_fd)
		if old_offset == -1
			return -1
		if lseek(in_fd, *offset) == -1
			return -1
	while count
		ssize_t len = read(in_fd, buf, imin(sizeof(buf), count))
		if len < 0
			err = 1
		if len <= 0
			end
		count -= len
		char *p = buf
		while len
			ssize_t sent = write(out_fd, p, len)
			if sent < 0
				err = 1
			if sent <= 0
				end
			len -= sent ; p += sent
			totsent += sent
end	if offset
		*offset += totsent
		if lseek(in_fd, old_offset) == -1
			return -1
	return err ? -1 : (ssize_t)totsent  # XXX ssize_t ??

cork(int fd, int cork)
	use(fd, cork)
