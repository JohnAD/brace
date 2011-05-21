export shadow.h
use process
export syscall.h

# tkill and tgkill - kill threads

def tkill(tid) tkill(tid, SIGTERM)
int tkill(int tid, int sig):
	return syscall(SYS_tkill, tid, sig)

def tgkill(tgid, tid) tgkill(tgid, tid, SIGTERM)
int tgkill(int tgid, int tid, int sig);
	return syscall(SYS_tgkill, tgid, tid, sig)

def Tgkill(tgid, tid) Tgkill(tgid, tid, SIGTERM)
Tgkill(int tgid, int tid, int sig):
	int rv = tgkill(tgid, tid, sig)
	if rv < 0:
		failed("tgkill")

def Tkill(tid) Tkill(tid, SIGTERM)
Tkill(int tid, int sig):
	int rv = tkill(tid, sig)
	if rv < 0:
		failed("tkill")


