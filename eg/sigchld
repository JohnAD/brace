#!/lang/b
use b

Main()
	# This shows how a sigchld that occurs while that signal is blocked
	# is deferred until after the signal is enabled again.

	Sigact(SIGCHLD, chld_handler)

	Sig_defer(SIGCHLD)

	if fork() == 0
		warn("child sleeping for 2")
		sleep(2)
		Say("child finishing")
		exit(0)

	warn("parent sleeping for 4")

	# apparently sleep() is never automatically restarted, but my Sleep is.

#	int rv = sleep(4)
	Sleep(4)

#	warn("parent done sleeping for 4, sleep returned %d, allowing sigchld to come in now", rv)
	warn("parent done sleeping for 4, allowing sigchld to come in now")

	Sig_pass(SIGCHLD)

	warn("parent sleeping for 1")

	sleep(1)

	Say("parent finished")

void chld_handler(int signum)
	use(signum)
	Say("caught SIGCHLD")
	pid_t pid = Child_done()
	Sayf("child done %d", pid)

