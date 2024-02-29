#!/usr/bin/env bash
# Dev env for Wolfgangs SAR
# fringe
git clone https://github.com/isce-framework/fringe.git
cd fringe
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=../../fringe-build/
make install
cd ..
cd ..
