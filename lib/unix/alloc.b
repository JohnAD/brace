export sys/mman.h
use error
use alloc

void *Mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
	void *rv = mmap(addr, length, prot, flags, fd, offset)
	if rv == MAP_FAILED
		failed("mmap")
	return rv

int Munmap(void *addr, size_t length)
	int rv = munmap(addr, length)
	if rv < 0
		failed("munmap")
	return rv

Msync(void *addr, size_t length, int flags):
	int rv = msync(addr, length, flags)
	if rv < 0:
		failed("msync")

