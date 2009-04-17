#!/bin/sh
export MAKE="make -j2"

cd "`dirname "$0"`"
pkg=`basename "$PWD"`
rm -f ../"$pkg"_*
fakeroot debian/rules binary
rm -f ../"$pkg"_*.{build,changes,changes.asc}
sudo dpkg -i ../"$pkg"_*.deb
