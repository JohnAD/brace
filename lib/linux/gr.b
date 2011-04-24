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
typedef struct fb_var_screeninfo fb_var_screeninfo
fb_var_screeninfo framebuffer_info

framebuffer_init():
	int rv
	int Bpp
	framebuffer_fd = Open(framebuffer_file, O_RDWR)
	Ioctl(rv, framebuffer_fd, FBIOGET_VSCREENINFO, &framebuffer_info)
	w = framebuffer_info.xres
	h = framebuffer_info.yres
	depth = framebuffer_info.bits_per_pixel
	Bpp = depth / 8
	framebuffer_buflen = w*h*Bpp
	framebuffer = Mmap(NULL, framebuffer_buflen, PROT_WRITE, MAP_SHARED, framebuffer_fd, 0)
	vid = (void*)framebuffer
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
