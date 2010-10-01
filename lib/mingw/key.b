use conio.h

raw()
	key_raw = 1

cooked()
	key_raw = 0

noecho()
	key_noecho = 1

echo()
	# XXX FIXME
	key_noecho = 0

key_init()
	raw()

key_final()
	cooked()

int key()
	return key_noecho ? getch() : getche()
