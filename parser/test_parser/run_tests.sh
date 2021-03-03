#!/bin/bash

cd ..
make 
cd test_parser

LIKE_LIB=../../lib/pt

SCANPKG="ptc -o2 -t2 -L $LIKE_LIB packages.pt"
SCANVAL="ptc -o2 -t2 -L $LIKE_LIB constant_dec.pt"
SCANVAR="ptc -o2 -t2 -L $LIKE_LIB variable_dec.pt"
SCANFUN="ptc -o2 -t2 -L $LIKE_LIB function_dec.pt"
SCANCHS="ptc -o2 -t2 -L $LIKE_LIB choose.pt"
SCANWHI="ptc -o2 -t2 -L $LIKE_LIB while.pt"
SCANREP="ptc -o2 -t2 -L $LIKE_LIB repeat.pt"
SCANIF="ptc -o2 -t2 -L $LIKE_LIB elseif.pt"
SCANSTR="ptc -o2 -t2 -L $LIKE_LIB stringType.pt"

pkg_trace(){ ssltrace "$SCANPKG" $LIKE_LIB/parser.def -e; }
var_trace(){ ssltrace "$SCANVAR" $LIKE_LIB/parser.def -e; }
val_trace(){ ssltrace "$SCANVAL" $LIKE_LIB/parser.def -e; }
fun_trace(){ ssltrace "$SCANFUN" $LIKE_LIB/parser.def -e; }
chs_trace(){ ssltrace "$SCANCHS" $LIKE_LIB/parser.def -e; }
str_trace(){ ssltrace "$SCANSTR" $LIKE_LIB/parser.def -e; }
whi_trace(){ ssltrace "$SCANIF" $LIKE_LIB/parser.def -e; }
rep_trace(){ ssltrace "$SCANIF" $LIKE_LIB/parser.def -e; }
eif_trace(){ ssltrace "$SCANIF" $LIKE_LIB/parser.def -e; }


pkg(){ ptc -o2 -L $LIKE_LIB packages.pt; }
var(){ ptc -o2 -L $LIKE_LIB constant_dec.pt; }
val(){ ptc -o2 -L $LIKE_LIB variable_dec.pt; }
fun(){ ptc -o2 -L $LIKE_LIB function_dec.pt; }
chs(){ ptc -o2 -L $LIKE_LIB choose.pt; }
whi(){ ptc -o2 -L $LIKE_LIB while.pt; }
rep(){ ptc -o2 -L $LIKE_LIB repeat.pt; }
eif(){ ptc -o2 -L $LIKE_LIB elseif.pt; }
str(){ ptc -o2 -L $LIKE_LIB stringType.pt; }

if [ $# -ne 0 ]; then
    if [[ "$1" == *"p"* ]];then pkg_trace; fi
    if [[ "$1" == *"r"* ]];then var_trace; fi
    if [[ "$1" == *"l"* ]];then val_trace; fi
    if [[ "$1" == *"f"* ]];then fun_trace; fi
    if [[ "$1" == *"c"* ]];then chs_trace; fi
    if [[ "$1" == *"e"* ]];then eif_trace; fi
    if [[ "$1" == *"s"* ]];then str_trace; fi
    if [[ "$1" == *"w"* ]];then whi_trace; fi
    if [[ "$1" == *"i"* ]];then eif_trace; fi

else
    echo "-- test pkg ---"
    pkg
    echo "-- test var ---"
    var
    echo "-- test val ---"
    val
    echo "-- test fun ---"
    fun
    echo "-- test choose ---"
    chs
    echo "-- test elseif ---"
    eif
    echo "-- test stringType ---"
    str
fi
