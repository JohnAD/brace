#!/usr/bin/env python

def intro():
    print """
rocks 1.01

Copyright 2003 Sam Watkins
This is free software with ABSOLUTELY NO WARRANTY.
For details, type `i' during gameplay.

Type `h' if you don't know how to play.

"""

def info(e = None):
    print """

Happy Birthday, Ana!


Copyright 2003, 2004 Sam Watkins

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License , or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, write to

       The Free Software Foundation, Inc.
       59 Temple Place, Suite 330
       Boston, MA 02111, USA.

    You can also obtain a copy of the GPL from the Internet:

       http://www.gnu.org/licenses/gpl.txt


Rocks is a peaceful game.


If you enjoy this game, please send me a card!
Cards are an alternative to currency - for more information,
point your browser at:

  http://cards.sourceforge.net/
  http://cards.sourceforge.net/cgi-bin/view?Sam.Watkins


    Sam Watkins <sam@shallow.net>

"""

def help(e = None):
    print """

Your Mission - Pop the Rocks!

    z       left
    x       right
    enter   thrust
    /       retro

    space   hide
    q       bang!

    -       previous level
    =       restart level
    +       next level

    i       info
    h       help
    p       pause
    Escape  quit

Each rock has a gender and sexual preference!

    Dark red: straight male
    Dark blue: straight female
    Bright red: gay male
    Bright blue: gay female

This determines how they interact,
for example dark blue and dark red attract eachother,
and a dark blue will chase a bright red, which will run away!

Your ship also has gender and sexuality, but initially you don't know what.
You can guess what gender you are based on whether rocks are attracted to
or repelled from you and whether you are attracted to or repelled from them.
Your gender and sexuality change from time to time.  A little message
alerts you to this.

Have fun!

"""

level = 1
#w = 1280 ; h = 1024
w = 640 ; h = 480
frame_sleep = 20
resistance = 0.008
G = 1.5
max_init_vel = 1.0
new_level_sleep = 3000
sleep_of_death = 2000
start_space = 70
light = 25.0
heavy = 900.0
ship_mass = 150
turn_rate = 0.01
thrust_rate = 0.03
retro_rate = 0.01
rocks_warp = 0
ship_warps = 0
max_orbit_vel = 3.0
prob_coed = 0.7
prob_bent = 0.2
min_queerity_sleep = 20000
max_queerity_sleep = 30000

from Tkinter import *
from Canvas import *
from random import *
from math import *
from cmath import exp
from time import *
from sys import *
from os import * ; os_name = name
import atexit

def warp(s):
    if s.x.real < 0: s.x = complex(s.x.real+w, s.x.imag)
    if s.x.real > w: s.x = complex(s.x.real-w, s.x.imag)
    if s.x.imag < 0: s.x = complex(s.x.real, s.x.imag+h)
    if s.x.imag > h: s.x = complex(s.x.real, s.x.imag-h)
def bounce(r):
    if r.x.real < r.r: r.x = complex(2*r.r-r.x.real, r.x.imag) ; r.v = complex(-r.v.real, r.v.imag)
    elif r.x.real > w - r.r: r.x = complex(2*(w-r.r)-r.x.real, r.x.imag) ; r.v = complex(-r.v.real, r.v.imag)
    if r.x.imag < r.r: r.x = complex(r.x.real, 2*r.r-r.x.imag) ; r.v = complex(r.v.real, -r.v.imag)
    elif r.x.imag > h - r.r: r.x = complex(r.x.real, 2*(h-r.r)-r.x.imag) ; r.v = complex(r.v.real, -r.v.imag)

class Rock:
    def __init__(self):
	self.is_bouncy = 1
	q = -0.5
	self.m = (random()*(heavy**q-light**q)+light**q)**(1/q)
	self.r = sqrt(self.m)
	while 1:
	    self.x = complex(random() * (w-self.r*2) + self.r, random() * (h-self.r*2) + self.r)
	    if ship and abs(self.x - ship.x) < start_space: continue
	    overlapping = 0
	    for r0 in rocks:
		if abs(self.x - r0.x) < self.r + r0.r:
		    overlapping = 1 ; break
	    if not overlapping: break
	self.v = random()*max_init_vel * exp(1j*random()*2*pi)
	d = self.x - center ; u = d/abs(d)
	self.v += u*1j * level_orbit / abs(d) * h * max_orbit_vel
	if coed: self.gender = int(random()*2)*2 - 1
	else: self.gender = gob
	self.a = 0j
	self.to_be_removed = 0
	self.bent = random()<prob_bent
	self.ci = Oval(canvas, self.x.real-self.r, h-self.x.imag-self.r, self.x.real+self.r, h-self.x.imag+self.r,
		       fill=colour(self), outline='white')
    def move(r):
	if r.bent: r.a = -r.a
	o = r.x
	r.v += r.a
	r.v *= 1-resistance
	r.a = 0j
	r.x += r.v
	if rocks_warp: warp(r)
	else: bounce(r)
	d = r.x - o
	r.ci.move(d.real, -d.imag)
    def pop(r):
	print "pop!"
	r.to_be_removed = 1
    def delete(r):
	r.ci.delete()
    def gay(r):
	if r.bent: return sg < 0
	return sg > 0

def colour(r):
    if r.gender < 0:
	if r.gay(): c = 'blue'
	else: c = '#000055'
    elif r.gender > 0:
	if r.gay(): c = 'red'
	else: c = '#550000'
    else:
	c = '#333333'
    return c

class Ship:
    def __init__(self):
	self.is_bouncy = 0
	self.x = center
	self.v = 0
	self.a = 0
	self.t = 0
	self.tv = 0
	self.r = 10
	self.thrusting = 0
	self.retroing = 0
	self.lefting = 0
	self.righting = 0
	self.hidden = 0
	self.m = ship_mass
	self.ci = Polygon(canvas, 0, 0, 0, 0, 0, 0, fill='#005500', outline='white')
	tk.bind("<Return>", self.thrust)
	tk.bind("<KeyRelease-Return>", self.unthrust)
	tk.bind("<slash>", self.retro)
	tk.bind("<KeyRelease-slash>", self.unretro)
	tk.bind("z", self.left)
	tk.bind("<KeyRelease-z>", self.unleft)
	tk.bind("x", self.right)
	tk.bind("<KeyRelease-x>", self.unright)
	tk.bind("q", self.bang)
	tk.bind("<space>", self.hide)
	tk.bind("p", pause)
	tk.bind("+", next_level)
	tk.bind("=", new_level)
	tk.bind("-", prev_level)
	self.gender = int(random()*2)*2 - 1
	self.sg = int(random()*2)*2 - 1
    def change_dress(self, e=None):
	if paused: return
	self.gender = -self.gender
	self.sg = - self.sg
	print "I'm a sweet transvestite..."
    def change_attraction(self, e=None):
	if paused: return
	self.sg = - self.sg
	print "A shiver runs down your spine..."
    def change_gender(self, e=None):
	if paused: return
	self.gender = -self.gender
	print "Ouch! that hurt"
    def change_sexuality(self, e=None):
	i = int(random()*3)
	if i == 0: self.change_dress()
	elif i == 1: self.change_attraction()
	else: self.change_gender()
    def calc(s):
	x = s.x
	s.forwards = yu = complex(sin(s.t), cos(s.t)) * s.r
	s.right = xu = yu / 1j
	s.p0 = 2*yu + x
	s.p1 = xu-yu + x
	s.p2 = -xu-yu + x
    def bent(s): return s.sg == sg
    def move(s):
	if s.bent(): s.a = -s.a
	if s.thrusting: s.a += s.forwards * thrust_rate
	if s.retroing: s.a -= s.forwards * retro_rate
	if s.lefting: s.tv -= turn_rate
	if s.righting: s.tv += turn_rate
    	s.v += s.a
	s.v *= 1-resistance
	s.tv *= 1-resistance
	s.a = 0
	s.x += s.v
	s.t += s.tv
	if ship_warps: warp(s)
	else: bounce(s)
	s.calc()
	if not s.is_bouncy:
	    for r in rocks:
		for p,q in ((s.p0,s.p1), (s.p1,s.p2), (s.p2,s.p0)):
		    pq = q-p ; dpq = abs(pq) ; pqu = pq/dpq
		    pr = r.x-p ; dpr = abs(pr)
		    d = pr / pqu
		    dx = d.real
		    dy = d.imag
		    if dy < r.r and dy >= 0 and dx > 0 and dx < dpq or abs(pr) < r.r:
			if abs(pr) < r.r and p == s.p0:
			    r.pop()
			    break
			else:
			    s.bang()
			    return
	    s.ci.coords(((s.p0.real, h-s.p0.imag), (s.p1.real, h-s.p1.imag), (s.p2.real, h-s.p2.imag)))
    def thrust(self, e):
	self.thrusting = 1
    def retro(self, e):
	self.retroing = 1
    def left(self, e):
	self.lefting = 1
    def right(self, e):
	self.righting = 1
    def unthrust(self, e):
	self.thrusting = 0
    def unretro(self, e):
	self.retroing = 0
    def unleft(self, e):
	self.lefting = 0
    def unright(self, e):
	self.righting = 0
    def bang(self, e=None):
	if paused: return
	print "bang!\n"
	tk.unbind("<Return>")
	tk.unbind("<KeyRelease-Return>")
	tk.unbind("<slash>")
	tk.unbind("<KeyRelease-slash>")
	tk.unbind("z")
	tk.unbind("<KeyRelease-z>")
	tk.unbind("x")
	tk.unbind("<KeyRelease-x>")
	tk.unbind("q")
	tk.unbind("<space>")
	tk.unbind("p")
	tk.unbind("+")
	tk.unbind("=")
	tk.unbind("-")
	global ship, rocks
	rocks[0] = ship = None
	self.ci.delete()
	tk.after(sleep_of_death, start)
    def hide(self, e):
	if paused: return
	self.hidden = not self.hidden
	self.is_bouncy = self.hidden
	if self.hidden:
	    self.ci.coords(((-1,-1),(-1,-1),(-1,-1)))
	    print "where'd he go?"
	else:
	    print "thar she blows!"

rocks = [None]

def start():
    global ship, level
    rocks[0] = ship = Ship()
    new_level()
    sched_update()

paused = 0
def pause(e = None):
    global paused
    paused = not paused
    if not paused:
	sched_update()

def delete_all_rocks():
    for r in rocks[1:]: r.delete()
    del(rocks[1:])

def random_level():
    global coed, gob, sg, level_orbit
    coed = random() < prob_coed
    if not coed: gob = int(random()*2)*2-1
    sg = int(random()*2)*2-1
    level_orbit = random()-0.5

after_cancel = 0
def new_level(e = None):
    global level, g
    delete_all_rocks()
    print "Welcome to level %d" % level
    random_level()
    g = G * sg
    global after_cancel
    after_cancel += 1
    tk.after(new_level_sleep, plant_rocks)

def next_level(e = None):
    global level
    level += 1
    new_level()

def prev_level(e = None):
    global level
    if level > 0:
	level -= 1
	new_level()

def do_exit(e = None):
    exit(0)

def plant_rocks():
    global after_cancel
    after_cancel -= 1
    if after_cancel == 0:
	if not ship: return
	for i in range(0, level):
	    rocks.append(Rock())

compliments = [
    "Right on, commander!",
    "Great flying!",
    "Awesome effort!",
    "Are you addicted yet?",
    "Let's see you pass the NEXT level!",
    "You had me worried for a minute there!",
    "Fantasic!",
    "Go for the record!",
    "This is just too easy for you, isn't it?",
    "No one got past that rock before!"]

def level_complete():
    try:
	i = int(random()*len(compliments))
	print compliments[i] ; del(compliments[i])
    except:
	print "Hey, take a break, you've been playing too long!"
    print
    next_level()

def quad1(a, b, c):
    return (-b-sqrt(b**2-4*a*c))/2/a
def quad2(a, b, c):
    return (-b+sqrt(b**2-4*a*c))/2/a

scheduled = 0

def update():
    if ship: ship.move()
    if ship: low = 0
    else: low = 1
    for i in range(len(rocks)-1,0,-1):
	r = rocks[i]
	if r.to_be_removed:
	    r.delete()
	    del(rocks[i])
	    if len(rocks) == 1: level_complete()
	else:
	    r.move()
    for i in range(low+1, len(rocks)):
	for j in range(low, i):
	    r0 = rocks[i] ; r1 = rocks[j]
	    if r0 == None or r1 == None:
		print ship, rocks[0], low, i, j
		exit(0)
	    dx = r1.x - r0.x ; d = abs(dx)
	    q = dx * g * r0.gender * r1.gender / d ** 3
	    r0.a += q * r1.m ; r1.a -= q * r0.m
	    if r0.is_bouncy and r1.is_bouncy and d <= r0.r + r1.r:
		v0 = r0.v / dx ; v1 = r1.v / dx
		v0i = v0.imag ; v1i = v1.imag
		v0r = v0.real ; v1r = v1.real
		a = r0.m ; b = r1.m
		c = v0r*r0.m + v1r*r1.m
		d = v0r**2*r0.m + v1r**2*r1.m
		v0r = quad1(a**2 / b + a, -2*a*c/b, c**2/b-d)
		v1r = quad2(b**2 / a + b, -2*b*c/a, c**2/a-d)
		r0.v = complex(v0r, v0i) * dx ; r1.v = complex(v1r, v1i) * dx
		r0.a = 0j ; r1.a = 0j # dodgy?

    global scheduled
    scheduled = 0
    if not paused:
	sched_update()

def sched_update():
    global scheduled
    if not scheduled:
	scheduled = 1
	tk.after(frame_sleep, update)

def queerity():
    if ship and not paused: ship.change_sexuality()
    sched_queerity()

def sched_queerity():
    tk.after(min_queerity_sleep + int(random()*(max_queerity_sleep-min_queerity_sleep)), queerity)

intro()

if os_name == 'posix':
    def exiting():
	system("xset r on")
    atexit.register(exiting)
    system("xset r off")
    cursor="dot #111111"
else:
    cursor=None

tk = Tk()
canvas = Canvas(tk, width=w, height=h, background='black', cursor=cursor)
canvas.pack(fill=BOTH, expand=Y)

center = w/2+h/2*1j

tk.bind("h", help)
tk.bind("i", info)
tk.bind("<Escape>", do_exit)

start()

sched_queerity()

tk.mainloop()
