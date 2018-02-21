#!/bin/bash
# Shell Script for testing shell arithmetic functions
# Created by immigration9 / 2018-02-14
# Conclusion::
#   Use $(( expression )) as norm. You do not need to use 'expr' or 'let' to evaluate expressions
#   In custom, both of the expressions are not recommended by the shell checker.
#   [shellcheck] Instead of 'let expr', prefer (( expr )). [SC2219]

COUNTER_NORM=0
COUNTER_ARITH=0
COUNTER_LET=0

for number in {1..5}
do
    echo "Step: "${number}
    echo "===================================="
    COUNTER_NORM+=1
    echo "Counter Norm: "${COUNTER_NORM}
    COUNTER_ARITH=$(( COUNTER_ARITH + 1 ))
    echo "Counter Arithmetic: "${COUNTER_ARITH}
    let COUNTER_LET+=1
    echo "Counter Let: "${COUNTER_LET}
done

COUNTER_NORM=0
echo "Counter Norm Reset: "${COUNTER_NORM}
COUNTER_ARITH=$(( 0 ))
echo "Counter Arithmetic Rest: "${COUNTER_ARITH}
let COUNTER_LET=0
echo "Counter Let Reset: "${COUNTER_LET}
