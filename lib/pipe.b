# pipes!

# a pipe is a shuttle of type deq (at the moment)

# using deq is probably very inefficient for a fifo/pipe,
# I just need an array

use util
export shuttle deq

shuttle(deq)

def pipe_init(pipe, type, space, from_process, from_port, to_process, to_port)
	sh_init(pipe, from_process, from_port, to_process, to_port)
	deq_init(&pipe->data, type, space)

def pipe(type, space, from_process, to_process)
	pipe(my(pipe), type, space, from_process, to_process)
def pipe(type, space, from_process, from_port, to_process, to_port)
	pipe(my(pipe), type, space, from_process, from_port, to_process, to_port)
def pipe(var_name, type, space, from_process, to_process)
	pipe(var_name, type, space, from_process, out, to_process, in)
def pipe(var_name, type, space, from_process, from_port, to_process, to_port)
	decl(var_name, sh(deq))
	pipe_init(var_name, type, space, from_process, from_port, to_process, to_port)

def wrp(pipe, obj)
	pull(pipe)
	deq *my(q) = &pipe->data
	deq_push(my(q), obj)
	if deq_get_size(my(q)) == deq_get_space(my(q))
		push(pipe)

def rdp(pipe, obj)
	pull(pipe)
	deq *my(q) = &pipe->data
	deq_shift(my(q), obj)
	if deq_get_size(my(q)) == 0
		push(pipe)

def flush_pipe(pipe)
	pull(pipe)
	deq *my(q) = &pipe->data
	if deq_get_size(my(q))
		push(pipe)
