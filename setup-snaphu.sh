#!/usr/bin/env bash

# snaphu
if [ -f snaphu-v2.0.6.tar.gz ]; then
  echo "Snaphu File exists."
else
   mkdir -p snaphu-build/man1
   wget http://web.stanford.edu/group/radar/softwareandlinks/sw/snaphu/snaphu-v2.0.6.tar.gz
   tar xfz snaphu-v2.0.6.tar.gz 
   cp snaphu_makefile snaphu-v2.0.6/src/Makefile 
   cd snaphu-v2.0.6
   cd src/
   make install
   cd ..
   cd ..
fi
# verify snaphu
snaphu
