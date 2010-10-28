export sphere

#def debug printf
def debug null_function

inline void null_function(...)
	.

dump_angle3(const angle3 &a)
	debug("%f\t%f\n", Deg(a.latitude), Deg(a.longitude))
