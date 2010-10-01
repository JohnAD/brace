use stdio.h

export gr
use m
use error

colour col_space, col_sea, col_land, col_lake, col_point, col_focus, col_grid

load_colour(FILE *f, colour &c)
	num r, g, b
	int err = fscanf(f, "%lf %lf %lf", &r, &g, &b)
	if err == 0
		error("real expected")
	if err == EOF
		error("missing colour")
	c = rgb(r, g, b)

load_palette(const char *palfile)
	FILE *f = fopen(palfile, "r")
	load_colour(f, col_space)
	load_colour(f, col_sea)
	load_colour(f, col_land)
	load_colour(f, col_lake)
	load_colour(f, col_point)
	load_colour(f, col_focus)
	load_colour(f, col_grid)
	fclose(f)
