use net
use io

char *serv_addr = "127.0.0.1"
int serv_port = 9999

int main(int argc, char **argv)
	int sock
	char *data
	FILE *sockf
	sock = Client(serv_addr, serv_port)
	if argc < 2
		data = Slurp(STDIN_FILENO, NULL)
	else
		data = argv[1]
	sockf = Fdopen(sock, "w")
	Fprintf(sockf, "%s", data)
	Fclose(sockf)
	return 0
