# FIXME mingw doesn't have BSD random / srandom
def random() rand()
def srandom(seed) srand(seed)
int mingw_m = 1
