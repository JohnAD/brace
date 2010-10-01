# this is a fair bit less elegant than the shell script!

#echo "$*" | wall
#if [ -n "$DISPLAY" ]; then
#	xmessage -geometry -0-0 "$*" &
#fi

# would be cool if we could use namespaces in nipl to access the environment,
# arguments!

use uprocess
use io
use alloc
use error
use env
use string.h

main(int argc, char *argv[])
	if argc != 2
		error("syntax: alert message")
	
	char *data = argv[1]
	FILE *out = Popen("/usr/bin/wall", "w")
	Fprintf(out, "%s\n", data)
	Pclose(out)
	
	char *display = Getenv("DISPLAY", "")
	if strlen(display) > 0
		if Fork() == 0
			Execlp("xmessage", "xmessage", "-geometry", "-0-0", data, NULL)
