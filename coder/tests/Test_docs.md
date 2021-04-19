# CMPE/CISK 458 Group K Assignemnt 4 Test Docs

There are two test scripts, `run_coder.sh` and `run.sh`.
`run.sh` compiles the specified like program and runs it, it's used to verify that the *like* compiler functions properly.
The `run_coder.sh` outputs the generated assembly code. 

The test progrma to run is specified by adding a flag to the input.
For example, to run the `null.pt`, call `./run.sh. n`

## null.pt `./run n`
The null program is and empty program, it's one of the first tests made, used to validate that the semantic phase is synced with the coder phase.

There is no output, and the generated x86 code is simply a program headder. 

## put.pt `./run w`
This unit tests validate that the write comnmand works properly. It make a call to `put()`, which is translated to a pttrap8 call, and a value is printed to stdout. 


## init.pt `./run i`
This unit tests validates that initial values were implimented properly.
It sets and sets a few initial values and prints them, also calling a few expressions along the way.

## choose.pt `./run c`
Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis Benis 