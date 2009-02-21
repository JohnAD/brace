use stdio.h
use termios.h
use unistd.h
use signal.h
use stdlib.h

use error
use util

typedef struct termios termios
termios term, term_orig

raw()
	int rv
	rv = tcgetattr (STDIN_FILENO, &term)
	if rv < 0
		error("tcgetattr failed")
	term_orig = term

	term.c_iflag &= ~(IGNBRK|BRKINT|PARMRK|ISTRIP|INLCR|IGNCR|ICRNL|IXON)
	term.c_iflag |= IGNBRK | BRKINT
	term.c_oflag |= OPOST
	term.c_lflag &= ~(ECHO|ECHONL|ICANON|IEXTEN)
	term.c_lflag |= ISIG
	term.c_cflag &= ~(CSIZE|PARENB)
	term.c_cflag |= CS8

	term.c_cc[VMIN] = 1
	term.c_cc[VTIME] = 0

	rv = tcsetattr(STDIN_FILENO, TCSANOW, &term)
	if rv < 0
		error("tcsetattr failed")

cooked()
	int rv
	rv = tcsetattr(STDIN_FILENO, TCSAFLUSH, &term_orig)
	if rv < 0
		error("tcsetattr failed")

key_init()
	raw()
	signal(SIGCONT, cont_handler)
	signal(SIGINT, int_handler)
	signal(SIGPIPE, int_handler)

key_final()
	cooked()

int key()
	unsigned char c
	ssize_t s
	s = read(STDIN_FILENO, &c, 1)
	if s == 0
		return -1
	return c

cont_handler(int signum)
	use(signum)
	raw()

int_handler(int signum)
	use(signum)
	cooked()
	exit(1)
