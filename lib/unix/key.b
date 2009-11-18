use stdio.h
use termios.h
use unistd.h
use stdlib.h

use error
use util
use process

typedef struct termios termios
termios term, term_orig

raw()
	int rv
	rv = tcgetattr(STDIN_FILENO, &term)
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
	key_raw = 1

cooked()
	int rv
	rv = tcsetattr(STDIN_FILENO, TCSAFLUSH, &term_orig)
	if rv < 0
		error("tcsetattr failed")

noecho()
	int rv
	rv = tcgetattr(STDIN_FILENO, &term)
	if rv < 0
		error("tcgetattr failed")
	term_orig = term

	term.c_lflag &= ~(ECHO|ECHONL)
	term.c_lflag |= ISIG

	rv = tcsetattr(STDIN_FILENO, TCSANOW, &term)
	if rv < 0
		error("tcsetattr failed")
	key_noecho = 1

echo()
	# XXX FIXME
	key_noecho = 0

key_init()
	raw()
	Sigact(SIGCONT, cont_handler)
	Sigact(SIGINT, int_handler)
	Sigact(SIGPIPE, int_handler)

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
	Exit(1)

def Input_passwd() Input_passwd("Password: ")
cstr Input_passwd(cstr prompt)
	noecho()
	cstr pass = Input(prompt)
	nl()
	cooked()
	return pass
