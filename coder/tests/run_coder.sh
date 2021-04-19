#!/bin/bash

cd ..
make 
cd tests

LIKE_LIB=../../lib/pt


PT_TEST_FILES=( "null" "put" "init_val" "choose" "strings" "repeat_string" )


like_build_asm(){
    ptc -S -L $LIKE_LIB $1.pt
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

else
    echo "-- semantic null ---"
    for f in "${PT_TEST_FILES[@]}"; do
        like_build_asm $f
    done
fi
