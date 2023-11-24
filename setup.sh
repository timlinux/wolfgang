#!/usr/bin/env bash
# Dev env for Wolfgangs SAR
git clone https://github.com/insarlab/MiaplPy.git
cd MiaplPy
python -m pip install .
cd ..
git clone https://github.com/isce-framework/isce2
cd isce2
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=../../isce2-build/
# This line a dirty hack to solve the Screenwriter.h missing
make 
# Running again should fix it....
make install
cd ..
cd ..
# fringe
git clone https://github.com/isce-framework/fringe.git
cd fringe
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=../../fringe-build/
make install
cd ..
cd ..

# snaphu
mkdir snaphu-build
wget http://web.stanford.edu/group/radar/softwareandlinks/sw/snaphu/snaphu-v1.4.2.tar.gz
tar xfz snaphu-v1.4.2.tar.gz
cp snaphu_makefile snaphu-v1.4.2/src/Makefile 
cd snaphu-v1.4.2
cd src/
make install
cd ..
cd ..
# verify snaphu
snaphu
