from math import *
from math import sin as sinr, cos as cosr
from Tkinter import *
from Canvas import *
from time import sleep

def rad(a):
	return a/360.0 * 2*pi

def sin(a):
	return sinr(rad(a))

def cos(a):
	return cosr(rad(a))

def paper(width=400, height=300, colour="white"):
	global canvas, tk, paper_w, paper_h
	paper_w = width ; paper_h = height
	tk = Tk()
	canvas = Canvas(tk, width=width, height=height, background=colour)
	canvas.pack(fill=BOTH, expand=Y)

update_delay = 0.05

def update():
	tk.update()
	if update_delay != 0:
		sleep(update_delay)

def circle(x, y, r, fill="black"):
	Oval(canvas, x-r, paper_h-y-r, x+r, paper_h-y+r, fill=fill)
	update()

def line(x0, y0, x1, y1, width=0, fill="black"):
	Line(canvas, x0, paper_h-y0, x1, paper_h-y1, width=width, fill=fill)
	update()

def clear():
	canvas.delete("all")

def press_enter():
	raw_input("press enter ")
