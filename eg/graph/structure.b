struct Node
	int index      # negative means free, and indicates next free
	char *name
	Shape *shape   # NULL means a unit circle
	double angle, scale
	Point o
	Transform transform
	Region region
	XPoint so

# note: the index field is redundant, could be calculated:
# index = node - nodes

struct Arc
	int from       # negative means free, and indicates next free
	int to
	char *name

# nodes and arcs ---------------------------------------------

static Vector struct_nodes
Vector *nodes = &struct_nodes
static Vector struct_arcs
Vector *arcs = &struct_arcs

structure_init()
	vector_init(nodes, sizeof(Node))
	vector_init(arcs, sizeof(Arc))

Node *new_node()
	Node *node = vector_alloc(nodes)
	node->index = vector_index(nodes, node)
	return node

Arc *new_arc(int from, int to)
	Arc *arc = vector_alloc(arcs)
	arc->from = from; arc->to = to
	return arc

delete_node(Node *node)
	draw_node(node, False)
	for_each_arc_to_or_from(node, delete_arc)
	if node->region != NULL
		XDestroyRegion(node->region)
	# XXX free(node->name) ? use atoms?
	vector_dealloc(nodes, node)

delete_arc(Arc *arc)
	draw_arc(arc)
	# XXX free(arc->name) ? use atoms?
	vector_dealloc(arcs, arc)

for_each_arc_to_or_from(Node *node, void (*f)(Arc *))
	int index = node->index
	VectorIterator i
	Arc *arc
	vector_iterator_init(arcs, &i)
	while (arc = vector_iterator_next(&i)) != NULL
		if arc->to == index || arc->from == index
			f(arc)

export vector shape
use graph

use io
