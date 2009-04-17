export setjmp.h
def sigjmp_buf jmp_buf
def sigsetjmp(env, savesigs) setjmp(env)
def siglongjmp(env, val) longjmp(env, val)
