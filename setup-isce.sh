#!/usr/bin/env bash
# Dev env for Wolfgangs SAR
mkdir isce2-build
git clone https://github.com/isce-framework/isce2
cd isce2
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=../../isce2-build/
# This line a dirty hack to solve the Screenwriter.h missing
make -j47
# Running again should fix it....
cd ..
cd ..
cd isce2/build
make install
cd ..
cd ..
