use error net

export sys/epoll.h

typedef struct epoll_event epoll_event

int Epoll_create(int size)
	int rv = epoll_create(size)
	if rv < 0
		failed("epoll_create")
	return rv

Epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)
	int rv = epoll_ctl(epfd, op, fd, event)
	if rv < 0
		failed("epoll_ctl")

# these can return -1 on EINTR

int Epoll_wait(int epfd, struct epoll_event *events, int maxevents, num timeout)
	int rv = epoll_wait(epfd, events, maxevents, delay_to_ms(timeout))
	if rv < 0 && errno != EINTR
		failed("epoll_wait")
	return rv

int Epoll_pwait(int epfd, struct epoll_event *events, int maxevents, num timeout, const sigset_t *sigmask)
	int rv = epoll_pwait(epfd, events, maxevents, delay_to_ms(timeout), sigmask)
	if rv < 0 && errno != EINTR
		failed("epoll_pwait")
	return rv

