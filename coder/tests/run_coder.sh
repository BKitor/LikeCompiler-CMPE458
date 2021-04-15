#!/bin/bash

cd ..
make 
cd tests

LIKE_LIB=../../lib/pt

PT_TEST_FILES=( "null" "put" "init_val")

like_build_asm(){
    ptc -S -L $LIKE_LIB $1.pt
    cat $1.s
    rm $1.s
}


if [ $# -ne 0 ]; then
    if [[ "$1" == *"n"* ]];then like_build_asm null; fi
    if [[ "$1" == *"w"* ]];then like_build_asm put; fi
    if [[ "$1" == *"i"* ]];then like_build_asm init_val; fi
else
    echo "-- semantic null ---"
    for f in "${PT_TEST_FILES[@]}"; do
        like_build_asm $f
    done
fi
