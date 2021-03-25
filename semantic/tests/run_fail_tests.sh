#!/bin/bash

cd ..
make 
cd tests

LIKE_LIB=../../lib/pt

FAILVAL="ptc -o3 -t3 -L $LIKE_LIB pkg_will_fail_var.pt"
FAILVAR="ptc -o3 -t3 -L $LIKE_LIB pkg_will_fail_val.pt"
FAILFUN="ptc -o3 -t3 -L $LIKE_LIB pkg_will_fail_fun.pt"


# nul_trace(){ ssltrace "$SEMNUL" $LIKE_LIB/semantic.def -e ; }

f_val(){ ptc -o3 -L $LIKE_LIB pkg_will_fail_val.pt; }
f_var(){ ptc -o3 -L $LIKE_LIB pkg_will_fail_var.pt; }
f_fun(){ ptc -o3 -L $LIKE_LIB pkg_will_fail_fun.pt; }

if [ $# -ne 0 ]; then
    # if [[ "$1" == *"p"* ]];then pkg_trace; fi
    echo
else
    echo "-- fail var ---"
    f_var
    echo "-- fail val ---"
    f_val
    echo "-- fail fun ---"
    f_fun
fi
