#!/bin/sh
A="$*"
A=`echo "$A" | sed 's/=/ /'`
/usr/bin/install $A
