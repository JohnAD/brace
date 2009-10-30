export sprite colours
pix_t colour_to_pix(colour c)
	return pixn_rgb_safe(c.r, c.g, c.b)
