#!/bin/bash

cd ..
make 
cd tests

LIKE_LIB=../../lib/pt



PT_TEST_FILES=( "null" "put" "init_val" "choose" "strings" "repeat_string" "string_arrays" "substring" "chr" "concat" "strlen" "strcmp" "ord")


like_build_asm(){
    ptc -S -L $LIKE_LIB $1.pt
    echo "---------"
    cat $1.s
    rm $1.s
    #ssltrace "ptc -o4 -t4 -L lib/pt test.pt" lib/pt/coder.def -e
}

if [ $# -ne 0 ]; then
    if [[ "$1" == *"n"* ]];then like_build_asm null; fi
    if [[ "$1" == *"w"* ]];then like_build_asm put; fi
    if [[ "$1" == *"c"* ]];then like_build_asm choose; fi
    if [[ "$1" == *"i"* ]];then like_build_asm init_val; fi
    if [[ "$1" == *"s"* ]];then like_build_asm strings; fi
    if [[ "$1" == *"r"* ]];then like_build_asm repeat_string; fi
    if [[ "$1" == *"a"* ]];then like_build_asm string_arrays; fi
    if [[ "$1" == *"g"* ]];then like_build_asm substring; fi
    if [[ "$1" == *"h"* ]];then like_build_asm chr; fi
    if [[ "$1" == *"o"* ]];then like_build_asm concat; fi
    if [[ "$1" == *"l"* ]];then like_run_test strLen; fi
    if [[ "$1" == *"e"* ]];then like_build_asm strcmp; fi
    if [[ "$1" == *"d"* ]];then like_build_asm ord; fi
else
    echo "-- semantic null ---"
    for f in "${PT_TEST_FILES[@]}"; do
        like_build_asm $f
    done
fi
