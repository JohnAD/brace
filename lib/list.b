use error types io util
#use stdlib.h

# a singly-linked list
# used by hash.b

# The list itself is a plain "struct list".  This first struct
# in the list is not a node, but a pointer to the first node
# (or NULL).  The nodes are each a "struct list" pointing to
# the next node, followed by an arbitrary payload.  This list
# does not allocate or free memory itself.

struct list
	list *next

def list_next_p(node) &node->next

list_init(list *l)
	l->next = NULL

boolean list_is_empty(list *l)
	return l->next == NULL

# # This inserts new_node after old_node.
# # This only works to insert single nodes!
# # You don't have to call list_init for a node which will be inserted with list_insert
# list_insert(list *old_node, list *new_node)
# 	new_node->next = old_node->next
# 	old_node->next = new_node

# list types????!

def list_insert(link, object)
	let(next, *link)
	*link = object
	*list_next_p(object) = next

 # general insert, at a link, not at a node :)
 # do also list_insert_before list_insert_after --- prepend, append?

 # TODO empty lists...  I think when a list is empty e.g. db = NULL,
 # and the list manip functions/macros should modify that if inserting at the
 # start of the list or whatever...  this means list pointers would have to be
 # passed by reference somehow.., like a pointer to the link (pointer) to the
 # first node..that's ok

list *list_last(list *l)
	# XXX maybe should remember the tail of a list? no
	while l->next != NULL
		l = l->next
	return l

def list_next(l) l->next

# This unlinks the node after this link from the list.
# pre-req : *link is not NULL !
# This does NOT free memory, you need to free the node after (NOT before!) doing this.
def list_delete(link)
	*link = (*link)->next

# perhaps list_delete should be implemented in terms of a list_splice or list_cut ?

list_dump(list *l)
	repeat
		if l == NULL
			Say("NULL")
			break
		else
			Sayf("%010p ", l)
			l = list_next(l)

list *list_reverse(list *l)
	list *prev = NULL
	while l != NULL
		list *next = l->next
		l->next = prev
		prev = l
		l = next
	return prev

list *list_reverse_fast(list *l)
	list *prev = NULL
	repeat
		if l == NULL
			return prev
		list *next = l->next
		l->next = prev
		# now, to avoid those assignments!
		if next == NULL
			return l
		prev = next->next
		next->next = l
		# last one!
		if prev == NULL
			return next
		l = prev->next
		prev->next = next

list_push(list **list_pp, list *new_node)
	list_insert(list_pp, new_node)

list_pop(list **list_pp)
	list_delete(list_pp)

# idea - a general purpose function to create a node and insert it in an existing list in one go.  dodgy code:
#
#_link_list(list *prev, list *next, size_t size)
#	list *l = Malloc(sizeof(list *) + size)
#	if prev
#		prev->next = l
#	l->next = next
#	return &l->data
#
## FIXME change all _foo functions to foo_ ?
#_link_list_ptr(list *prev, list *next)
#	list *l = Malloc(sizeof(list *) + size)
#	if prev
#		prev->next = l
#	l->next = next
#	return &l->data

# 
# # pre-declare "node" so the type can be cast
# # FIXME for_list should use a node ref (ptr to prev node's list *)
# # so can delete or insert before?
# def for_list(node_p, l)
# 	node_p = (typeof(node_p))l
# 	for ; node_p != NULL ; node_p = (typeof(node_p))(((list *)node_p)->next)
# 
# I think the normal c-style list is better, where we just put next in the
# right place and don't include a "list" struct or anything like that.
# This here works but it would be simpler without the casting, right?


def for_list(i, first_link, link0, link1)
	# link0 and link1 are set to pointers to the links, i.e. node **
	let(link1, first_link)
	while *link1
		let(link0, link1)
		let(i, *link0)
		link1 = list_next_p(i)
		.

# we use i_p so can delete and pre-insert nodes in a list
# next_p is needed so can delete a node
# I would HOPE this stuff is optimised away in the cases where it's not used :p

# we refer to a LIST by a POINTER to its FIRST LINK, not the VALUE of its
# first LINK, which would be a pointer to its first NODE.
# When using macros or automatic referencing this could be done implicitly,
# but if want to be using function-calls we need to do it this way.

def for_list(i, first_link)
	for_list(i, first_link, my(link0), my(link1))
	# this should optimise clean if link0 and link1 weren't used in the
	# loop body, I hope!

# Should the list pointer point at the actual struct, and the "next" be stored
# at [-4] bytes or whatever?  maybe just let's try to write the "list" stuff
# with such generality that it would be doable to make this change later
# list_next_p is to help with that, and part of the general "struct accessors"
# idea.  I want to get brace to still output clean C this will be a challenge :)

# Maybe we could make a nice "graph" container with nodes and links,
# using this method of putting the links previous to the object pointer in memory.
# it might be assumed that the number of links from a node is known, or the list
# might be NULL terminated (or pre-terminated!)  hm how insane is this?!
# Anyway this "list" could then be a specific case of the graph type.

# And double-linked lists could use some functions designed to search lists, etc!


# list_free frees a list and all nodes
# it MIGHT in future need to know what type the nodes are for different allocator,
# can do that using sizeof(typeof(*foo)) in a macro I guess!
# can do allocators contextually too like graphics, IO, ...
list_free(list **l)
	for_list(i, l)
		Free(i)

# FIXME we need a "link" type and a "node" type, not a "list" type (which would be same as link type)
# can't use the name "link" though unless we rename the library function.  HOW to do that?


# list of void *:

struct list_x
	list *next
	void *o

list_x_init(list_x *n, void *o)
	n->o = o


# the dlist is represented by a dlist where next points to the first node, and prev points to the last node
# to check if at the start / end of the list, need to test if next/prev == list
# the "list" node does not have a body, and the list is empty if list.next (== list.prev) == list

struct dlist
	dlist *next
	dlist *prev

dlist_init(dlist *dl)
	dl->prev = dl->next = dl

dlist_append(dlist *point, dlist *new)
	new->next = point->next
	new->prev = point
	point->next = new
	new->next->prev = new

dlist_insert(dlist *point, dlist *new)
	#def dlist_insert(point, new) dlist_append(point->prev, new)
	new->prev = point->prev
	new->next = point
	point->prev = new
	new->prev->next = new

# This does NOT free memory, you need to free the node after (NOT before!) doing this.
dlist *dlist_delete(dlist *node)
	node->prev->next = node->next
	node->next->prev = node->prev
	return node

def dlist_empty(list) list->next == list

def dlist_push(list, new) dlist_insert(list, new)

def dlist_unshift(list, new) dlist_append(list, new)

def dlist_pop(list) dlist_delete(list->prev)

def dlist_shift(list) dlist_delete(list->next)

def for_dlist(i, list)
	for_dlist(i, list, dlist)

def for_dlist(i, listp, type)
	let(i, (type *)(listp->next))
	for ; (dlist *)i != (dlist *)listp ; i = (type *)i->next
		.

# TODO back_dlist ?
