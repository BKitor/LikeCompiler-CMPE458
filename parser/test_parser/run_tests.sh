#!/bin/bash

cd ..
make 
cd test_parser

LIKE_LIB=../../lib/pt

SCANPKG="ptc -o2 -t2 -L $LIKE_LIB packages.pt"
SCANVAL="ptc -o2 -t2 -L $LIKE_LIB constant_dec.pt"
SCANVAR="ptc -o2 -t2 -L $LIKE_LIB variable_dec.pt"

pkg_trace(){ ssltrace "$SCANPKG" $LIKE_LIB/parser.def -e; }
var_trace(){ ssltrace "$SCANVAR" $LIKE_LIB/parser.def -e; }
val_trace(){ ssltrace "$SCANVAL" $LIKE_LIB/parser.def -e; }

pkg(){ ptc -o1 -L $LIKE_LIB packages.pt; }
var(){ ptc -o1 -L $LIKE_LIB packages.pt; }
val(){ ptc -o1 -L $LIKE_LIB packages.pt; }

if [ $# -ne 0 ]; then
    if [[ "$1" == *"p"* ]];then pkg_trace; fi
    if [[ "$1" == *"r"* ]];then var_trace; fi
    if [[ "$1" == *"l"* ]];then val_trace; fi
else
    echo "-- test pkg ---"
    pkg
    echo "-- test var ---"
    var
    echo "-- test val ---"
    val
fi
