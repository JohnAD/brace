use sched

boolean sched_sig_child_exited(sigset_t *oldsigmask)
	*oldsigmask = Sig_defer(SIGCHLD)
	return sched->got_sigchld

boolean sched_sig_child_exited_2(sigset_t *oldsigmask)
	boolean got_sigchld = 0
	if sched->got_sigchld
		got_sigchld = 1
		sched->got_sigchld = 0
	Sig_setmask(oldsigmask)
	return got_sigchld
