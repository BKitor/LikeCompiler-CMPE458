#!/bin/bash

BK_LIB=~/cisc458/17bwk/lib/pt
SCANSTR="ptc -o1 -t1 -L $BK_LIB str_lit.pt"
SCANCMT="ptc -o1 -t1 -L $BK_LIB comment.pt"
SCANKW="ptc -o1 -t1 -L $BK_LIB keywords.pt"
SCANCH="ptc -o1 -t1 -L $BK_LIB new_char.pt"

str_trace(){ ssltrace "$SCANSTR" $BK_LIB/scan.def; }
cmt_trace(){ ssltrace "$SCANCMT" $BK_LIB/scan.def; }
kw_trace(){ ssltrace "$SCANKW" $BK_LIB/scan.def; }
ch_trace(){ ssltrace "$SCANCH" $BK_LIB/scan.def; }

str(){ ptc -o1 -L $BK_LIB str_lit.pt; }
cmt(){ ptc -o1 -L $BK_LIB comment.pt; }
kw(){ ptc -o1 -L $BK_LIB keywords.pt; }
ch(){ ptc -o1 -L $BK_LIB new_char.pt; }

if [ $# -ne 0 ]; then
    if [[ "$1" == *"s"* ]];then str_trace; fi
    if [[ "$1" == *"m"* ]];then cmt_trace; fi
    if [[ "$1" == *"k"* ]];then kw_trace; fi
    if [[ "$1" == *"c"* ]];then ch_trace; fi
else
    echo "--- test String ---"
    str
    echo "-- test Comment ---"
    cmt
    echo "-- test Keyworkds ---"
    kw
    echo "-- test charracters ---"
    ch
fi
