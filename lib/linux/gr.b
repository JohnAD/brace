export gr
use linux/fb.h

# FBIO_WAITFORVSYNC might not be defined in <linux/fb.h>, so:
^ifndef FBIO_WAITFORVSYNC
^define FBIO_WAITFORVSYNC _IOW('F', 0x20, __u32)
^endif

cstr framebuffer_file = "/dev/fb0"

int framebuffer_fd
long *framebuffer
size_t framebuffer_buflen

framebuffer_init(int vw, int vh, int Bpp):
	framebuffer_buflen = vw*vh*Bpp
	framebuffer_fd = Open(framebuffer_file, O_RDWR)
	framebuffer = Mmap(NULL, framebuffer_buflen, PROT_WRITE, MAP_SHARED, framebuffer_fd, 0)
	vid = (void*)framebuffer
	depth = Bpp * 8
	w = vw ; h = vh
	w_2 = w/2 ; h_2 = h/2
	vid_init()

framebuffer_sync():
	Msync(framebuffer, framebuffer_buflen, MS_SYNC|MS_INVALIDATE)

framebuffer_final():
	Munmap(framebuffer, framebuffer_buflen)

# wait_for_vsync does not work on my Intel GPU netbook  :/
wait_for_vsync():
	int arg = 0
	ioctl(framebuffer_fd, FBIO_WAITFORVSYNC, &arg)

