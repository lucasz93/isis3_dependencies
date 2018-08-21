#!/bin/tcsh
cp ~/v7_9_1-01762L.zip . 
unzip v7_9_1-01762L.zip
cd v7_9_1-01762L

cd make
# setenv CPLUS_INCLUDE_PATH /usr/lib/jvm/java-1.8.0/include:/usr/lib/jvm/java-1.8.0/include/linux
make -f Makefile-Linux-x86-64-gcc
rsync -rltpv ../lib/Linux-x86-64-gcc/* $PREFIX/lib/
