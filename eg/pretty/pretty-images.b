#!/lang/b

# export OPTIMIZE=1

Main()
	gr_fast()
	space()

	qmath_init()

	bm_enabled = 1
	sleep_step_debug = 1

	bm_start()

	int shm_major, shm_minor
	Bool shm_pixmaps

	Bool shm_ok = XShmQueryVersion(display, &shm_major, &shm_minor, &shm_pixmaps)

	XImage *image
	XShmSegmentInfo *shmseginfo
	if shm_ok
		shmseginfo = Talloc(XShmSegmentInfo)
		bzero(shmseginfo)
		image = XShmCreateImage(display, visual, depth, ZPixmap, NULL, shmseginfo, w, h)
#		image = XShmGetImage(display, gr_buf, image, 0, 0, w, h, AllPlanes)

		shmseginfo->shmid = shmget(IPC_PRIVATE, image->bytes_per_line * image->height, IPC_CREAT|0777)
		if shmseginfo->shmid<0
			failed("shmget")
		shmseginfo->shmaddr = shmat(shmseginfo->shmid, NULL, 0)
		if !shmseginfo->shmaddr
			failed("shmat")
		shmseginfo->readOnly = False

		image->data = shmseginfo->shmaddr
		if !XShmAttach(display, shmseginfo)
			failed("XShmAttach")

	else
		warn("XShm not working")
		image = XGetImage(display, gr_buf, 0, 0, w, h, AllPlanes, ZPixmap)

	if image == NULL
		failed("XGetImage")

	bm("got image")

	int da = 0
	int dr = 0

	repeat
		long *px = pixel(image, 0, 0)
		da+=2

		int y
		for y=h_2-1; y>=-h_2; --y
			int r2 = w_2*w_2+y*y
			for(x, -w_2, w_2)
				int a
	#			r2 = x*x+y*y

				num s, atn
				qSin(s, r2/100.0+dr)
				qAtan2(atn, y, x)
				mod_fast(a, atn+s*50+da, 360)

	#			int X = SX(x)
	#			int Y = SY(y)
	#			if X>=0 && X<w && Y>=0 && Y<h
					#col(rb[a])
					#point(x, y)
					#XPutPixel(image, X, Y, rb[a])
					#*pixel(image, X, Y) = rb[a]

				*px++ = rb[a]

				r2 += 2*x+1

			px += image->bytes_per_line / sizeof(long) - w

		bm("calc done")
		if shm_ok
			XShmPutImage(display, gr_buf, gc, image, 0, 0, 0, 0, w, h, False)
		else
			XPutImage(display, gr_buf, gc, image, 0, 0, 0, 0, w, h)
		bm("put image")
#		sleep_step(0.1)
		Paint()
		bm("painted")
		bm_start()

	x_free_stuff()

def x_free_stuff()
	XShmDetach(display, shmseginfo)
	if(image)
		XDestroyImage(image)
	shmdt(shmseginfo->shmaddr)
	shmctl(shmseginfo->shmid, IPC_RMID, NULL)
	free(shmseginfo)

	# XFreeGC(display, gc)
	# XDestroyWindow(display, window)
	# XCloseDisplay(display)
	# free(xw)

def pixel(image, X, Y) (long *)(image->data + image->bytes_per_line * Y + sizeof(long)*X)

def mod_fast(ans, i, base)
	int my(_i) = i
#	int my(_base) = base
	if my(_i) >= 0
		ans = my(_i)%base
	 else
		ans = base-1 - (-1-my(_i))%base

num bm_start, bm_end
boolean bm_enabled = 1

def bm_start()
	if bm_enabled
		bm_start = rtime()

def bm(s)
	if bm_enabled
		bm_end = rtime()
		Sayf("%s: %f", s, bm_end-bm_start)

def trig_unit deg
def screen_trans fast

use b

use X11/extensions/XShm.h
use sys/ipc.h
use sys/shm.h
