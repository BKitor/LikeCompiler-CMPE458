#!/bin/bash

cd ..
make 
cd tests

LIKE_LIB=../../lib/pt

PT_TEST_FILES=( "null" "put" "init_val" )

like_run_test(){ # takes the name of a test (without .pt) as arg 1 
    echo "*** compiling $f.pt ***"
    ptc -L $LIKE_LIB $1.pt
    echo "*** running $f.out ***"
    ./$1.out
    echo
    rm $1.out
}

SEMNUL="ptc -S -L $LIKE_LIB null.pt"

if [ $# -ne 0 ]; then
    if [[ "$1" == *"n"* ]];then like_run_test null; fi
    if [[ "$1" == *"w"* ]];then like_run_test put; fi
    if [[ "$1" == *"i"* ]];then like_run_test init_val; fi
else
    for f in "${PT_TEST_FILES[@]}"; do
        like_run_test $f
    done
fi
