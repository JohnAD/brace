#!/bin/dash
tightvncserver -localhost -geometry 400x400 -depth 16 :1
export DISPLAY=:1.0
/home/sam/p/kosmogram/kosmogram.b
tightvncserver -kill :1
killall xstartup sleep
