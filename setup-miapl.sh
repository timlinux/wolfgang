#!/usr/bin/env bash
# Dev env for Wolfgangs SAR
git clone --depth 1 -b fix/numpy-int git@github.com:zamuzakki/MiaplPy.git
cd MiaplPy
python -m pip install .
yes| cp -rf src/miaplpy/defaults/ $(python -c 'import site; print(site.getsitepackages()[0])')/miaplpy/
cd ..
