#!/bin/bash

cd ..
make 
cd tests

LIKE_LIB=../../lib/pt

SEMNUL="ptc -o3 -t3 -L $LIKE_LIB null.pt"
SEMBLK="ptc -o3 -t3 -L $LIKE_LIB block.pt"
SEMVAR="ptc -o3 -t3 -L $LIKE_LIB variables.pt"


# nul_trace(){ ssltrace "$SEMNUL" $LIKE_LIB/semantic.def | egrep " *[\.o%]"; }
nul_trace(){ ssltrace "$SEMNUL" $LIKE_LIB/semantic.def -e ; }
blk_trace(){ ssltrace "$SEMBLK" $LIKE_LIB/semantic.def -e ; }
var_trace(){ ssltrace "$SEMVAR" $LIKE_LIB/semantic.def -e ; }

blk(){ ptc -o3 -L $LIKE_LIB block.pt; }
var(){ ptc -o3 -L $LIKE_LIB variables.pt; }

if [ $# -ne 0 ]; then
    if [[ "$1" == *"n"* ]];then nul_trace; fi
    if [[ "$1" == *"b"* ]];then blk_trace; fi
    if [[ "$1" == *"v"* ]];then var_trace; fi
else
    echo "-- semantic block ---"
    blk
    echo "-- semantic variables ---"
    var
fi
