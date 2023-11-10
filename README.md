# Dev env for Wolfgangs SAR

Assumes nix

If you have direnv, just cd into this folder

If not do ``nix-shell``

Install isce2 and deps

./setup.sh

Which will install 

- ✅MINOPY (now known as MiaplPy)
- ✅ISCE (based on setup notes [here](https://github.com/isce-framework/isce2)),
- ✅FRINGE,

Afterwards you can check the install by doing

``python test.py``
