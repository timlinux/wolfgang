#!/usr/bin/env bash
# Dev env for Wolfgangs SAR
./setup-fringe.sh  
./setup-isce.sh  
./setup-miapl.sh
./setup-snaphu.sh

# Copy patches to pyaps3 to support concurrent ERA5 download
cp patches/pyaps3_autoget.py .venv/lib/python3.11/site-packages/pyaps3/autoget.py
