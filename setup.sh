#!/usr/bin/env bash
# Dev env for Wolfgangs SAR
./setup-fringe.sh  
./setup-isce.sh  
./setup-miapl.sh
./setup-snaphu.sh
sleep 5
./setup-isce.sh
cp patches/pyaps3_autoget.py .venv/lib/python3.11/site-packages/pyaps3/autoget.py
