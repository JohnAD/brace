#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define bufsize 4096

int main(int argc, char **argv)
{
	char buf[bufsize];
	int count;
	int r;
	if (argc != 2) {
		fprintf(stderr, "usage: scramble (random seed)\n");
		exit(1);
	}
	srand(atoi(argv[1]));
	while ((count = read(0, buf, bufsize)) > 0) {
		char *i, *j;
		for (i=buf, j=buf+count; i!=j; ++i) {
			r = rand() % 256;
			*i = *i ^ r;
		}
		if (write(1, buf, count) < 0) {
			perror("write error");
		}
	}
	if (count < 0) {
		perror("read error");
	}
	exit(0);
}
