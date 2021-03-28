#!/bin/bash

cd ..
make 
cd tests

LIKE_LIB=../../lib/pt

SEMNUL="ptc -o3 -t3 -L $LIKE_LIB null.pt"
SEMBLK="ptc -o3 -t3 -L $LIKE_LIB block.pt"
SEMVAR="ptc -o3 -t3 -L $LIKE_LIB variables.pt"
SEMPKG="ptc -o3 -t3 -L $LIKE_LIB pkg.pt"
SEMSTR="ptc -o3 -t3 -L $LIKE_LIB string.pt"
SEMPUT="ptc -o3 -t3 -L $LIKE_LIB put.pt"
SEMGET="ptc -o3 -t3 -L $LIKE_LIB get.pt"
SEMLEN="ptc -o3 -t3 -L $LIKE_LIB sLength.pt"
SEMCAT="ptc -o3 -t3 -L $LIKE_LIB concatenate.pt"
SEMREP="ptc -o3 -t3 -L $LIKE_LIB repeat_string.pt"
SEMNOT="ptc -o3 -t3 -L $LIKE_LIB string_not_equals.pt"
SEMSEQ="ptc -o3 -t3 -L $LIKE_LIB string_equals.pt"



# nul_trace(){ ssltrace "$SEMNUL" $LIKE_LIB/semantic.def | egrep " *[\.o%]"; }
nul_trace(){ ssltrace "$SEMNUL" $LIKE_LIB/semantic.def -e ; }
blk_trace(){ ssltrace "$SEMBLK" $LIKE_LIB/semantic.def -e ; }
var_trace(){ ssltrace "$SEMVAR" $LIKE_LIB/semantic.def -e ; }
pkg_trace(){ ssltrace "$SEMPKG" $LIKE_LIB/semantic.def -e ; }
str_trace(){ ssltrace "$SEMSTR" $LIKE_LIB/semantic.def -e ; }
put_trace(){ ssltrace "$SEMPUT" $LIKE_LIB/semantic.def -e ; }
get_trace(){ ssltrace "$SEMGET" $LIKE_LIB/semantic.def -e ; }
len_trace(){ ssltrace "$SEMLEN" $LIKE_LIB/semantic.def -e ; }
cat_trace(){ ssltrace "$SEMCAT" $LIKE_LIB/semantic.def -e ; }
rep_trace(){ ssltrace "$SEMREP" $LIKE_LIB/semantic.def -e ; }
not_trace(){ ssltrace "$SEMNOT" $LIKE_LIB/semantic.def -e ; }
seq_trace(){ ssltrace "$SEMSEQ" $LIKE_LIB/semantic.def -e ; }

blk(){ ptc -o3 -L $LIKE_LIB block.pt; }
var(){ ptc -o3 -L $LIKE_LIB variables.pt; }
pkg(){ ptc -o3 -L $LIKE_LIB pkg.pt; }

if [ $# -ne 0 ]; then
    if [[ "$1" == *"n"* ]];then nul_trace; fi
    if [[ "$1" == *"b"* ]];then blk_trace; fi
    if [[ "$1" == *"v"* ]];then var_trace; fi
    if [[ "$1" == *"p"* ]];then pkg_trace; fi
    if [[ "$1" == *"s"* ]];then str_trace; fi
    if [[ "$1" == *"u"* ]];then put_trace; fi
    if [[ "$1" == *"g"* ]];then get_trace; fi
    if [[ "$1" == *"l"* ]];then len_trace; fi
    if [[ "$1" == *"c"* ]];then cat_trace; fi
    if [[ "$1" == *"r"* ]];then rep_trace; fi
    if [[ "$1" == *"a"* ]];then not_trace; fi
    if [[ "$1" == *"e"* ]];then seq_trace; fi
else
    echo "-- semantic block ---"
    blk
    echo "-- semantic variables ---"
    var
    echo "-- semantic pkg ---"
    pkg
    #echo "-- semantic str ---"
    #str
fi
