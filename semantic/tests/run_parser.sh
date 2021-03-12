#!/bin/bash

cd ../../parser
make 
cd ../semantic/tests

LIKE_LIB=../../lib/pt

PARBLK="ptc -o2 -t2 -L $LIKE_LIB block.pt"

blk_trace(){ ssltrace "$PARBLK" $LIKE_LIB/parser.def -e; }

blk(){ ptc -o2 -L $LIKE_LIB block.pt; }

if [ $# -ne 0 ]; then
    if [[ "$1" == *"b"* ]];then blk_trace; fi
else
    echo "-- test blok ---"
    blk
fi
