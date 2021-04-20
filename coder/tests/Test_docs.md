# CMPE/CISK 458 Group K Assignemnt 4 Test Docs

There are two test scripts, `run_coder.sh` and `run.sh`.
`run.sh` compiles the specified like program and runs it, it's used to verify that the *like* compiler functions properly.
The `run_coder.sh` outputs the generated assembly code. 

The test progrma to run is specified by adding a flag to the input.
For example, to run the `null.pt`, call `./run.sh. n`

## null.pt `./run.sh n`
The null program is and empty program, it's one of the first tests made, used to validate that the semantic phase is synced with the coder phase.

There is no output, and the generated x86 code is simply a program headder. 

## put.pt `./run.sh w`
This unit tests validate that the write comnmand works properly. It make a call to `put()`, which is translated to a pttrap8 call, and a value is printed to stdout. 
It tests both ints, and strigns.


## init.pt `./run.sh i`
This unit tests validates that initial values were implimented properly.
It sets and sets a few initial values and prints them, also calling a few expressions along the way.
It also test that variables can be changed properly, by assigning a new value to a var and printing it again.

## choose.pt `./run.sh c`

## substring.pt `./run.sh g`
This unit test ensures that the substring operation works correctly.
It starts with a string variable S containing "Not Great".
It substring S from 5 to 9, and stores it in S, then prints S outputing "Great".
Finaly it substrings S at 3 and 3 inside a put call, printing "e"

## strLen.pt `./run.sh l`
This ensures that the string length operation works properly. 
There are two strings, s1 and s2, one with "four" and one with "negativefifteen".
It prints the length of both, printing 4 and 15. 
Then enrues that the length can be used in other expressions by repeating each string by it's length, ("four" four times, and "negativefifreen" fifteen times).

## strings.pt `./run.sh s`
This unit test was written to initaly verify that strings work.
It assigns strings as initial variables, assigns strings to existing variabels, and calls put with a string literal inside. 

## string_arrays.pt `./run.sh a`
This test check taht string arrays are implimented properly. 
It starts with declarign a string array with 6 positions, and allocates unique values for each index.
Next it accesses the diferent position and prints them testing different assignment strategies.  

## strcmp.pt `./run.sh e`
This check the `==` and `!=` operators for strings.
It contains 6 if statements. 
The first two check if a `==` works, the next to chekc `!=`.
The last two check if the oder of evaluation works properly, for different string operations. 
If all works, the test should print great for each if statement.

## repeat_string.pt `./run.sh r`
This was written when evaluating if the repeat string operator works. 
It tests different numebrs of repeats, as well as if the order of operations works appropriatly.

## ord.pt `./run.sh d`
This test checks if ord works properly. 
It prints ord for 'a' and 'b'. (97 and 98)

## concat.pt `./run.sh o`
This tests if string concatination works properly.
The first three outputs, check if concatinations work under variable or immediate assignemnts. 
The third output checks that concats can be used in expressions in tandem with repeats, so it can print the Kool-Aid Man's catchphrase.

## chr.pt './run.sh h`
This tests if chr works properly, by printing out values for o and p (111 and 112).

## choose.pt `./run.sh c`
The choose unit test validates that a chose can will work properly when a match is found, or if it has to fallback to else.
When working properly, it will print "yes" twice.

## loop.pt `./run.sh z`
This unit tests that loops in like work properly.
It tests both `repeat` and `while` loops.
It fprints form 0 to 9, then back down from 9 to 0.