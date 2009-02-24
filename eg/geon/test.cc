#include <stdio.h>
#include <sys/types.h>
#include <stdarg.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/XShm.h>
#include <math.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <errno.h>
#include <setjmp.h>
#include <ctype.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/un.h>
#include <sys/select.h>
#include <poll.h>
#include <time.h>
#include <sys/time.h>
#include <algorithm>
#include <vector>
#include <map>

using namespace std;

enum region_type
{
	LAND,
	LAKE,
};

enum sector_side
{
	E, N, W, S
};

enum region_sector_containment
{
	REGION_CONTAINS_SECTOR,
	SECTOR_CONTAINS_REGION,
	REGION_OUTSIDE_SECTOR,
	REGION_CROSSES_SECTOR
};

struct polygon;
struct str;
struct buffer;
struct vec;
struct list;
struct list_x;
struct hashtable;
struct key_value;
struct node_kv;
struct circbuf;
struct deq;
struct thunk;
struct err;
struct error_handler;
template<class S, class F> F for_each(S &s, F f);
template<class S1, class S2, class F> void mapp(S1 &s1, S2 &s2, F &f);
struct vec3;
struct angle3;
struct region;
struct clip_to_hemisphere_arc;
struct sector_id;
struct sector_bounds;
struct sector_side_pos;
struct clip_to_sector_arc;

typedef struct polygon polygon;
typedef struct str str;
typedef struct buffer buffer;
typedef struct vec vec;
typedef struct list list;
typedef struct list_x list_x;
typedef struct hashtable hashtable;
typedef struct key_value key_value;
typedef struct node_kv node_kv;
typedef struct circbuf circbuf;
typedef struct deq deq;
typedef struct thunk thunk;
typedef struct err err;
typedef struct error_handler error_handler;
typedef struct vec3 vec3;
typedef struct angle3 angle3;
typedef struct region region;
typedef struct clip_to_hemisphere_arc clip_to_hemisphere_arc;
typedef struct sector_id sector_id;
typedef struct sector_bounds sector_bounds;
typedef struct sector_side_pos sector_side_pos;
typedef struct clip_to_sector_arc clip_to_sector_arc;

typedef unsigned char byte;
typedef double num;
typedef unsigned char boolean;
typedef char *cstr;
typedef unsigned int count_t;
typedef unsigned char uchar;
typedef struct timeval timeval;
typedef struct timespec timespec;
typedef long colour;
typedef unsigned int (*hash_func)(void *key);
typedef boolean (*eq_func)(void *k1, void *k2);
typedef void *(*thunk_func)(void *obj, void *common_arg, void *specific_arg);
typedef struct hostent hostent;
typedef int SOCKET;
typedef struct dirent dirent;
typedef struct stat stats;
typedef struct stat lstats;
typedef enum { if_dead_error, if_dead_null, if_dead_path, if_dead_warn=1<<31 } readlinks_if_dead;
typedef struct pollfd pollfd;
typedef struct tm datetime;
typedef vector<angle3> poly_angle3;
typedef vector<vec3> poly_vec3;
typedef map<num, clip_to_hemisphere_arc> in_angle_to_arc_t;

struct polygon
{
	XPoint *points;
	int n_points;
	int space;
};

struct str
{
	char *start;
	char *end;
};

struct buffer
{
	char *start;
	char *end;
	char *space_end;
};

struct vec
{
	buffer b;
	size_t element_size;
	size_t space;
	size_t size;
};

struct list
{
	list *next;
};

struct list_x
{
	list *next;
	void *o;
};

struct hashtable
{
	list *buckets;
	size_t size;
	hash_func hash;
	eq_func eq;
};

struct key_value
{
	void *key;
	void *value;
};

struct node_kv
{
	list l;
	key_value kv;
};

struct circbuf
{
	size_t size;
	size_t space;
	size_t start;
	char *data;
};

struct deq
{
	circbuf b;
	size_t element_size;
	size_t space;
	size_t size;
	size_t start;
};

struct thunk
{
	thunk_func func;
	void *obj;
	void *common_arg;
};

struct err
{
	cstr msg;
	int no;
	void *data;
};

struct error_handler
{
	sigjmp_buf *jump;
	thunk handler;
	int err;
};

template<class S, class F> F for_each(S &s, F f)
{
	return for_each(s.begin(), s.end(), f);
}

template<class S1, class S2, class F> void mapp(S1 &s1, S2 &s2, F &f)
{
	s2.clear();
	typename S1::const_iterator i = s1.begin();
	typename S1::const_iterator end = s1.end();
	for(; i!=end ; ++i)
	{
		typename S2::value_type i2;
		f(*i, i2);
		s2.push_back(i2);
	}
}

struct vec3
{
	num x, y, z;
	vec3() : x(0), y(0), z(0) {};
	vec3(num x, num y, num z) : x(x), y(y), z(z) {};
};

struct angle3
{
	num latitude, longitude;
	angle3() : latitude{(0) : longitude(0) {};
	angle3(num latitude, num longitude) : latitude(latitude), longitude(longitude) {};
};

struct region
{
	int id;
	region_type type;
	poly_angle3 points_a;
	poly_vec3 points_v;
};

struct clip_to_hemisphere_arc
{
	int from;
	int to;
	num to_angle;
};

struct sector_id
{
	int level, row, cell;
};

struct sector_bounds
{
	num west, east, south, north;
};

struct sector_side_pos
{
	sector_side side;
	num pos;
};

struct clip_to_sector_arc
{
	int from;
	int to;
	sector_side_pos from_side_pos, to_side_pos;
};
