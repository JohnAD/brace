export process.h
 # for getpid

def execl _execl
def execle _execle
def execlp _execlp
def execlpe _execlpe
def execv(path, argv) _execv(path, (const char* const*)argv)
def execve(path, argv, envp) _execve(path, (const char* const*)argv, (const char* const*)envp)
def execvp(file, argv) _execvp(file, (const char* const*)argv)
def execvpe(file, argv, envp) _execvpe(file, (const char* const*)argv, (const char* const*)envp)

def spawnl _spawnl
def spawnle _spawnle
def spawnlp _spawnlp
def spawnlpe _spawnlpe
def spawnv _spawnv
def spawnve _spawnve
def spawnvp _spawnvp
def spawnvpe _spawnvpe

def system_quote cmd_quote

def ignore_pipe()
	.
def ignore_hup()
	.

def WIFEXITED(status) 1
def WEXITSTATUS(status) status

sighandler_t sigact(int signum, sighandler_t handler, int sa_flags)
	use(sa_flags)
	return signal(signum, handler)

# these will be ignored in windows:

def SA_NOCLDSTOP 1
def SA_RESTART 0x10000000
def SA_INTERRUPT 0x20000000
