struct place
	int ns, ns_min, ns_sec, ew, ew_min, ew_sec

place_init(place *p, int ns, int ns_min, int ns_sec, int ew, int ew_min, int ew_sec)
	p->ns = ns ; p->ns_min = ns_min ; p->ns_sec = ns_sec
	p->ew = ew ; p->ew_min = ew_min ; p->ew_sec = ew_sec
