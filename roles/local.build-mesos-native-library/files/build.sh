#!/bin/bash

../configure > configure.log
make clean
make -j$(nproc) V=0 > make.log
make install > install.log
