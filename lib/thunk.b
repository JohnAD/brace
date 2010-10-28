export deq
use util

typedef void *thunk_func(void *obj, void *common_arg, void *specific_arg)

struct thunk
	thunk_func *func
	void *obj
	void *common_arg

def thunk() (thunk){ thunk_void, NULL, NULL }
def thunk(f) (thunk){ f, NULL, NULL }
def thunk(f, o) (thunk){ f, o, NULL }
def thunk(f, o, a) (thunk){ f, o, a }

def thunk_init(t, func, obj, common_arg)
	t->func = func
	t->obj = obj
	t->common_arg = common_arg
def thunk_init(t, func, obj)
	thunk_init(t, func, obj, NULL)
def thunk_init(t, func)
	thunk_init(t, func, NULL, NULL)
def thunk_init(t)
	thunk_init(t, thunk_ignore)
def thunk_init_thunks(t, d)
	thunk_init(t, thunk_thunks, d, NULL)

void *thunk_ignore(void *obj, void *common_arg, void *specific_arg)
	use(obj) ; use(common_arg) ; use(specific_arg)
	return thunk_yes

void *thunk_void(void *obj, void *common_arg, void *specific_arg)
	use(obj) ; use(common_arg) ; use(specific_arg)
	return thunk_no

void *thunk_thunks(void *obj, void *common_arg, void *specific_arg)
	use(common_arg)
	return thunks_call((deq*)obj, specific_arg)

def thunk_call(t, specific_arg) (*t->func)(t->obj, t->common_arg, specific_arg)

def thunk_call(t) thunk_call(t, NULL)

thunk _thunk_null = { NULL, NULL, NULL }
thunk *thunk_null = &_thunk_null

def thunk_not_null(thunk) thunk->func != NULL
def thunk_is_null(thunk) thunk->func == NULL

# thunk_call_deq: call a series of thunks until an event is handled.
# a deq is my recommended container for this
# you could also use a list, vec or priq
def thunks_call(q)
	call_thunks(q, NULL)
void *thunks_call(deq *q, void *specific_arg)
	for_deq(i, q, thunk)
		void *handled = thunk_call(i, specific_arg)
		if handled
			return handled
	return thunk_no

# thunk return values:
# thunk_no (0) means not handled - try some other handler
# thunk_yes (1) means it was handled
# thunk_err (-1) means some error happened but don't try other handers

def thunk_no i2p(0)
def thunk_yes i2p(1)
def thunk_err i2p(-1)
def thunk_int(i) i2p(i)
