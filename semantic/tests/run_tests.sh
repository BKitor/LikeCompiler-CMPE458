#!/bin/bash

cd ..
make 
cd tests

LIKE_LIB=../../lib/pt

SEMBLK="ptc -o3 -t3 -L $LIKE_LIB blank.pt"

blk_trace(){ ssltrace "$SEMBLK" $LIKE_LIB/semantic.def -e; }

blk(){ ptc -o3 -L $LIKE_LIB stringType.pt; }

if [ $# -ne 0 ]; then
    if [[ "$1" == *"b"* ]];then blk_trace; fi

else
    echo "-- test blk ---"
    blk
fi
