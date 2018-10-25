#!/bin/tcsh
cp /usgs/apps/kakadu/v7_9_1-01762L.zip . 
unzip v7_9_1-01762L.zip
cd v7_9_1-01762L/make

if [ $(uname) == Linux ]; then
	make -f Makefile-Linux-x86-64-gcc
	rsync -rltpv ../lib/Linux-x86-64-gcc/* $PREFIX/lib/
fi

if [ $(uname) == Darwin ]; then
	make -f Makefile-MAC-x86-all-gcc
        install_name_tool -id libkdu_v79R.so ../lib/Mac-x86-64-gcc/libkdu_v79R.so
        cp ../lib/Mac-x86-64-gcc/* ${PREFIX}/lib/
fi
