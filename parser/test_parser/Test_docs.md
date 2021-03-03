# CMPE/CISK 458 Group K Assignemnt 2 Test Docs

### Variable `$./run_test r`
Checks if variables will be parsed properly
Runs `variable_dec.pt`. 
Checks if sInitial value variabels parse proprely
checks if arrays can be parsed
checks if like clause works with ints, strings and identifiers
checks if vars can be declared public

### Constant `$./run_test l`
This a _Like_  (`constant_dec.pt`) program that declares a few constants and exits. 
It tests wether multiple constants can be delared.
If intergers, string literals, and identifiers work.
If the public keyword works with single, and multiple variables.

### Function `$./run_test f`
Tests if _Like_ functions are parsed properly.
Runs `function_dec.pt`.
Tests if a function can be declared, and the block exits properly.
checks if paramaters can be declared and parsed properly.
check if functions can be declared public.
ckecs if the like clause in function works properly
checks if functions can be delcared `var`

### Packages `$./run_test p`
Checks if packages can be delcared and parsed properly. 
runs `packages.pt`
cheks if the body of a packages can be parsed properly

### Choose '$./run_test c'
Checks if choose works properly
Runs 'choose.pt'.
Checks if 2, 3, or 4 are chosen, sets case specific output.
Checks if 1 is choosen, sets case specific output.
If none of these numbers are choosen enters an else clause and emits a case specific output.

### Elseif '$./run_test e'
Checks if elseif works properly
Runs 'elseif.pt'.
Checks if 'if' loop emits the proper identifier.
Checks if 'elseif' loop emits the proper identifier.
Checks if nested if and else statements emit the proper identifiers.
Checks if unnested 'else' emits the proper identifier.

### String Type '$./run_test w'
Checks if while loops work properly
Runs 'while.pt'.
Checks to see if while loop can be entered.
Checks to see if while loop will exit when conditions are met.

### Repeat '$./run_test r'
Checks if repeat statement functions
Runs 'repeat.pt'
Repeatedly increments are variable until a while loop condition is met.

### String Type '$./run_test s'
Checks if new String Types work properly
Runs 'stringType.pt'.
Checks if sSubString can split the string into substrings.
Checks if sConcatenate can concatenate two strings
Checks if sRepeatString can repeat the string a specified number of times.
Checks if sLength can accurately check the length of a string.