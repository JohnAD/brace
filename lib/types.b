export sys/types.h
export stdint.h
export limits.h

typedef unsigned char byte
typedef double num
typedef unsigned char boolean
  # TODO change all boolean to bool
#typedef int bool
  # TODO hack around C++ with an ^ifndef __c_plus_plus ?
typedef char *cstr
typedef unsigned int count_t
#typedef size_t size

typedef unsigned char uchar
#typedef unsigned int uint

# TODO if not C++  ?
def true 1
def false 0

typedef struct timeval timeval
typedef struct timespec timespec
typedef struct tm datetime

typedef void (free_t)(void *)

union any
	void *p
	char *cs
	char c
	short s
	int i
	long l
	long long ll
	float f
	double d
	long double ld
	size_t z
	off_t o
