colour black
def black() col(black)
colour white
def white() col(white)
colour red
def red() col(red)
colour orange
def orange() col(orange)
colour yellow
def yellow() col(yellow)
colour green
def green() col(green)
colour blue
def blue() col(blue)
colour magenta
def magenta() col(magenta)
colour cyan
def cyan() col(cyan)
colour grey
def grey() col(cyan)
colours_init()
	black = rgb(0,0,0)
	white = rgb(1,1,1)
	red = rgb(1,0,0)
	orange = rgb(1,0.5,0)
	yellow = rgb(1,1,0)
	green = rgb(0,1,0)
	blue = rgb(0,0,1)
	magenta = rgb(1,0,1)
	cyan = rgb(0,1,1)
	grey = rgb(0.5,0.5,0.5)
typedef uint32_t colour
colour rgb(double red, double green, double blue)
