export buffer vec

# this is a binary help implementation of a priority queue

typedef vec priq

def priq_p(i) (i-1)/2
def priq_c1(i) i*2+1

def priq_init(q, element_type, space)
	init(q, vec, element_type, space)

def priq_free(q)
	vec_free(q)

def priq_get_size(q) vec_get_size(q)

def priq_element(q, i) vec_element(q, i)

def priq_clear(q) vec_set_size(q, 0)

def priq_empty(q) priq_get_size(q) == 0

def priq_peek(q) priq_element(q, 0)

def priq_shift(q, type, cmp)
	priq_shift(q, type, cmp, void, NULL)

def priq_shift(q, type, cmp, move_notify, move_notify_arg)
	priq_remove(q, type, cmp, 0, move_notify, move_notify_arg)

def priq_remove(q, type, cmp, i)
	priq_remove(q, type, cmp, i, void, NULL)

def priq_remove(q, type, cmp, i, move_notify, move_notify_arg)
	int my(last_i) = priq_get_size(q) - 1
	priq_remove(q, type, cmp, i, move_notify, move_notify_arg, my(last_i))

def priq_remove(q, type, cmp, i, move_notify, move_notify_arg, last_i)
	priq_remove(q, type, cmp, i, move_notify, move_notify_arg, last_i, my(size), my(c1), my(c2), my(last), my(j))

def priq_remove(q, type, cmp, i, move_notify, move_notify_arg, last_i, size, c1, c2, last, j)
	# 1. look at the highest element
	# 2. we have a hole at i
	# 3. find the lower child of the hole
	# 4. if it has a child, and the lower child is lower than the highest element, move the lower child to the hole. now the hole is at the lower child. goto 2
	# 5. else, move the highest element to the hole
	# 6. vec_pop() to reduce the size of the priq. done!

	int j = i
	int size = priq_get_size(q)
	int c1, c2
	void *last = priq_element(q, size-1)
	repeat
		c1 = priq_c1(j)
		c2 = c1+1
		if c2 >= size
			break
		if cmp(priq_element(q, c2), priq_element(q, c1)) < 0
			c1 = c2
		if cmp(priq_element(q, c1), last) >= 0
			break
		priq_move(q, type, j, c1, move_notify, move_notify_arg)
		j = c1
	if j != size-1
		priq_move(q, type, j, size-1, move_notify, move_notify_arg, last_i)
	
	vec_pop(q)

def priq_push(q, type, cmp, element_p)
	priq_push(q, type, cmp, element_p, my(i), void, NULL)

def priq_push(q, type, cmp, element_p, i)
	priq_push(q, type, cmp, element_p, i, void, NULL)

def priq_push(q, type, cmp, element_p, i, move_notify, move_notify_arg)
	vec_push(q)
	int i = priq_get_size(q)-1
	priq_push_from(q, type, cmp, element_p, i, move_notify, move_notify_arg)

def priq_push_from(q, type, cmp, element_p, i, move_notify, move_notify_arg)
	for ; i>0 && cmp(element_p, priq_element(q, priq_p(i))) < 0 ; i = priq_p(i)
		priq_move(q, type, i, priq_p(i), move_notify, move_notify_arg)
	*(type *)priq_element(q, i) = *element_p

def priq_move(q, type, to, from, move_notify, move_notify_arg)
	int my(old_i) = from
	priq_move(q, type, to, from, move_notify, move_notify_arg, my(old_i))

def priq_move(q, type, to, from, move_notify, move_notify_arg, old_i)
	vec_copy_element(q, to, from, type)
	if to != old_i
		move_notify(q, to, old_i, move_notify_arg)

def priq_check(q, cmp)
	priq_check(ok, q, cmp, my(size), my(i), my(c), my(p))
def priq_check(ok, q, cmp, size, i, c, p)
	int size = priq_get_size(q)
	for(i, 1, size)
		void *c = priq_element(q, i)
		void *p = priq_element(q, priq_p(i))
		if cmp(p, c) > 0
			fault("priq broken")

# priq_repos
# method -
# if it is < the parent node, move it down using the "push" method
# else add a new element and move it to that "last element"
# remove the hole where it was. It will get copied back in from the last element.

def priq_repos(q, type, cmp, i)
	priq_repos(q, type, cmp, i, void, NULL)

def priq_down(q, type, cmp, i)
	priq_down(q, type, cmp, i, void, NULL)

def priq_up(q, type, cmp, i)
	priq_up(q, type, cmp, i, void, NULL)

def priq_repos(q, type, cmp, i, move_notify, move_notify_arg)
	priq_down(q, type, cmp, i, move_notify, move_notify_arg)
	else
		priq_up(q, type, cmp, i, move_notify, move_notify_arg)

def priq_down(q, type, cmp, i, move_notify, move_notify_arg)
	priq_down(q, type, cmp, i, move_notify, move_notify_arg, my(to), my(tmp))

def priq_down(q, type, cmp, i, move_notify, move_notify_arg, to, tmp)
	if cmp(priq_element(q, i), priq_element(q, priq_p(i))) < 0
		type tmp = *(type*)priq_element(q, i)
		int to = i
		priq_push_from(q, type, cmp, &tmp, to, move_notify, move_notify_arg)
		move_notify(q, to, i, move_notify_arg)
		i = to

def priq_up(q, type, cmp, i, move_notify, move_notify_arg)
	priq_up(q, type, cmp, i, move_notify, move_notify_arg, my(c1), my(c2), my(e), my(size), my(last_i))

def priq_up(q, type, cmp, i, move_notify, move_notify_arg, c1, c2, e, size, last_i)
	vec_push(q)
	int size = priq_get_size(q)
	vec_copy_element(q, size-1, i, type)
	int last_i = i
	priq_remove(q, type, cmp, i, move_notify, move_notify_arg, last_i)

