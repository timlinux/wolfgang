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
make install
cd ..
cd ..

