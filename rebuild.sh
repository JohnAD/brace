#!/bin/sh -e
cd "`dirname "$0"`"
./configure.sh
./clean.sh
./configure.sh
./build.sh
