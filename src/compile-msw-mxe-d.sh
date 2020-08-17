#!/bin/bash

TARGET_OS=NATIVE_WINDOWS

make -f makefile.linux-mingw CC=/mnt/mxe/usr/bin/i686-w64-mingw32.static-gcc CXX=/mnt/mxe/usr/bin/i686-w64-mingw32.static-g++
