# Dev env for Wolfgangs SAR

## Setup - easy way

Use NixOS and nix-direnv
cd into this folder
do ``direnv allow``

## Setup - no direnv

If you do not have direnv, install the nix package manger (https://nixos.org/download) then do 

``nix-shell``

I have not tested on other OS, but if you have ubuntu, it should set everything up for you. But use NixOS....it should work without issue.

## What will get installed?

The ``setup.sh`` script will install these:

- ✅MINOPY (now known as MiaplPy)
- ✅ISCE (based on setup notes [here](https://github.com/isce-framework/isce2)),
- ✅FRINGE,

Afterwards you can check the install by doing

``python test.py``
