#!/usr/bin/env bash

# snaphu
if [ -f snaphu-v1.4.2.tar.g ]; then
	  echo "Snaphy File exists."
else
   mkdir -p snaphu-build/man1
   wget http://web.stanford.edu/group/radar/softwareandlinks/sw/snaphu/snaphu-v1.4.2.tar.gz
   tar xfz snaphu-v1.4.2.tar.gz
   cp snaphu_makefile snaphu-v1.4.2/src/Makefile 
   cd snaphu-v1.4.2
   cd src/
   make install
   cd ..
   cd ..
fi
# verify snaphu
snaphu
