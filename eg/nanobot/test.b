#!/lang/b

Main()
	let(ear, Server("127.0.0.1", 7777))
	warn("listening...")
	let(client, Fdopen(Accept(ear)))
	warn("accepted...")
	handle_client(client)

def handle_client(client)
	.
		new(b, buffer, 1024)
		repeat
			warn("X1")
			if Freadline(b, client) == EOF
				break
			warn("X2")
#			let(message, buffer_to_cstr(b))
#			warn("%s", message)

use b
