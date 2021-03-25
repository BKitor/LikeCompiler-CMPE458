#!/bin/bash

cd ..
make 
cd tests

LIKE_LIB=../../lib/pt

SEMNUL="ptc -o3 -t3 -L $LIKE_LIB null.pt"
SEMBLK="ptc -o3 -t3 -L $LIKE_LIB block.pt"
SEMVAR="ptc -o3 -t3 -L $LIKE_LIB variables.pt"
SEMPKG="ptc -o3 -t3 -L $LIKE_LIB pkg.pt"


# nul_trace(){ ssltrace "$SEMNUL" $LIKE_LIB/semantic.def | egrep " *[\.o%]"; }
nul_trace(){ ssltrace "$SEMNUL" $LIKE_LIB/semantic.def -e ; }
blk_trace(){ ssltrace "$SEMBLK" $LIKE_LIB/semantic.def -e ; }
var_trace(){ ssltrace "$SEMVAR" $LIKE_LIB/semantic.def -e ; }
pkg_trace(){ ssltrace "$SEMPKG" $LIKE_LIB/semantic.def -e ; }

nul(){ ptc -o3 -L $LIKE_LIB null.pt; }
blk(){ ptc -o3 -L $LIKE_LIB block.pt; }
var(){ ptc -o3 -L $LIKE_LIB variables.pt; }
pkg(){ ptc -o3 -L $LIKE_LIB pkg.pt; }

if [ $# -ne 0 ]; then
    if [[ "$1" == *"n"* ]];then nul_trace; fi
    if [[ "$1" == *"b"* ]];then blk_trace; fi
    if [[ "$1" == *"v"* ]];then var_trace; fi
    if [[ "$1" == *"p"* ]];then pkg_trace; fi
else
    echo "-- semantic null ---"
    nul
    echo "-- semantic block ---"
    blk
    echo "-- semantic variables ---"
    var
    echo "-- semantic pkg ---"
    pkg
fi
