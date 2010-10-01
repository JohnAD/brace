use net
use uprocess
use cstr
use io
use alloc

char *listen_addr = "127.0.0.1"
# use 0.0.0.0 for any
int listen_port = 9999

int main()
	int ear, sock
	char *data
	ear = Server(listen_addr, listen_port)
	repeat
		sock = Accept(ear, NULL, 0)
		data = Slurp(sock, NULL)

		cstr_dos_to_unix(data)

		char *args[] =
			"alert",
			data,
			NULL
		Systemv(args[0], args)

		Free(data)
		Close(sock)
