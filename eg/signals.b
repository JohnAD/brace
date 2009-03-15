#!/lang/b
use b
Main()
	if args == 0
		Sig_defer(SIGINT)
		Sigign(SIGINT)
		Sigact(SIGPIPE, pipeh)
		Say("before fork")
		dump_sig_info()
		Fflush()
		if Fork()
			Child_wait()
			Say("finished")
			nl()
			Say("Why is quit ignored in linux, but not after fork?")
			Say("After fork, all default, procmask (defer) kept.")
			Say("After exec, handler -> def; ignored, defer kept.")
		 else
			Say("after fork")
			dump_sig_info()
			Sigign(SIGINT)
			Sigact(SIGPIPE, pipeh)
			dump_sig_info()
			Fflush()
			Execl(program_full, program_full, "--exec")
			exit()
	 else
		Say("after exec")
		dump_sig_info()

dump_sig_info()
	let(mask, Sig_getmask())
	for(i, 1, SIGRTMAX+1)
		if among(i, SIGKILL, SIGSTOP) || (i>=32 && i<SIGRTMIN)
			continue
		sighandler_t act = Sigget(i)
		Printd(i)
		if act == SIG_DFL
			Print("d")
		 eif act == SIG_IGN
			Print("-")
		else
			Print("*")
		if sigismember(&mask, i)
			Print("|")
		Print(" ")
	nl()

void pipeh(int sig)
	use(sig)
