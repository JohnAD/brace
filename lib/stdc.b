Atexit(void (*function)(void))
	if atexit(function) != 0
		failed("atexit")

def exit() exit(0)

use stdlib.h
use error
