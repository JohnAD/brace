#!/lang/b

use stdio.h unistd.h stdlib.h

def bufsize 4096

int main(int argc, char **argv)
	char buf[bufsize]
	int count
	if argc != 1
		fprintf(stderr, "usage: scrumble\n")
		exit(1)
	while (count = read(0, buf, bufsize)) > 0
		char *i, *j
		for i=buf, j=buf+count; i!=j; ++i
			*i = *i ^ 85
		if write(1, buf, count) < 0
			perror("write error")
	if count < 0
		perror("read error")
	exit(0)
