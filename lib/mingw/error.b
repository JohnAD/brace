export setjmp.h
use util

typedef jmp_buf sigjmp_buf
int sigsetjmp(sigjmp_buf env, int savesigs)
	use(savesigs)
	return setjmp(env)
siglongjmp(sigjmp_buf env, int val)
	longjmp(env, val)
