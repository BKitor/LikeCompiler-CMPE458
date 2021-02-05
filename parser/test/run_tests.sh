#!/bin/bash

BK_LIB=~/cisc458/17bwk/lib/pt
SCANSTR="ptc -o1 -t1 -L $BK_LIB str_lit.pt"
SCANCMT="ptc -o1 -t1 -L $BK_LIB comment.pt"
str_trace(){ ssltrace "$SCANSTR" $BK_LIB/scan.def; }
cmt_trace(){ ssltrace "$SCANCMT" $BK_LIB/scan.def; }

str(){ ptc -o1 -L $BK_LIB str_lit.pt; }
cmt(){ ptc -o1 -L $BK_LIB comment.pt; }

if [ $# -ne 0 ]; then
    if [[ "$1" == *"s"* ]];then str_trace; fi
    if [[ "$1" == *"c"* ]];then cmt_trace; fi
else
    echo "--- test String ---"
    str
    echo "-- test Comment ---"
    cmt
fi
