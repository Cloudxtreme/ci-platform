#!/bin/bash

# don't build mesos if library is already installed
if [ ! -e /usr/local/lib/libmesos.so ]
then
    ../configure > configure.log
    make clean
    make -j$(nproc) V=0 > make.log
    make install > install.log
fi
