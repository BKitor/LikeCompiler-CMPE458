# CMPE/CISK 458 Group K Assignemnt 3 Test Docs

### null '$./run_tests n'
This is a unit test for the null program. It was used to validate that the initial semantic phase works properly.

### block '$./run_tests b'
This unit test is used to validate that the initial restructuring of the block works properly. 
It also also tests some of the code samples that din't require changes to make sure they work out of the box. 
These tests include val, if/elseif/else, and repear/while.

### variables '$./run_tests v'
This unit test was added after updating variables. 
It only tests intergers, as strings had not been implimented yet (strigns are tested later). 
It also tests function parameter delcarations, ensuring that the like clause works properly. 

### packages '$./run_tests b' './run_fail_test.sh'
These tests validate that the pkg & public were implimented properly. 
There is a positive test that asserts var/val/fun delcared public in a package can be accesed outside of a package. 
There are three negative tests asserting that non public var/val/fun can't be accessed outside pkgs.

### substring '$./run_tests d'
Validate usage of substring through / operator
Runs substring.pt
Outputs:
tLiteralAddress
tFetchChar
tLiteralInteger
tLiteralInteger
sSubstring
```
using output;
var string = "Hi there" / 1:2;
```
### Get '$./run_tests g'
Validating usage of get with modification for strings  
checking for correct output of oEmitTrapKind(trReadString)
Runs get.pt
```
using input, output;
var infinitive : like "arreter";
get (infinitive);
getln;
```
### Put '$./run_tests u'
Validating usage of put with modification for strings
checking for correct output of oEmitTrapKind(trWriteString)
Runs put.pt
```
using output;
put ("Hello world"); 
putln;
```
### String '$./run_tests s'
Checks if strings can be set as a variable
Runs 'string.pt'
```
using output;
var string = "Hi there";
```
Checks for output of
tAssignBegin
tLiteralAddress
tLiteralAddress
tFetchChar
tAssignChar

### Length '$./run_tests l'
Checks if .tLength gets emitted as intended
Runs 'sLength.pt'
```
using input, output;
var y = "string";
var z= #y;
```

Checks for output of: 
tLiteralAddress
tFetchChar
tLegnth

### Concatenate '$./run_tests c'
Checks if tConcatenate gets emitted as intended
Runs 'concatenate.pt'
```
using input;
var S="Hello";
var T="World";
var output1 = S | T;
var output2 =  "Hello" | "World" ;
```

Checks for output of:
tLiteralAddress
tFetchChar
tLiteralAddress
tFetchChar
tConcatenate

### Repeat String '$./run_tests r'
Checks if the string can be repeated as intended
Runs 'repeat_string.pt'
```
using input;
var S = "Hello"; 
var repString = S || 2;
```

Checks for output of:
tLiteralAddress
tFetchChar
tLiteralAddress
tFetchChar
tRepeatString

### String Not Equals '$./run_tests a'
Checks if the strings are equal or not
Runs 'string_not_equals'
```
using input,output;
var hand = "string"; 
var x=1;
if hand != "f" then
    x=2;
end;
```
Checks for an output that contains.
tNot
tStringEQ

### String Not Equals '$./run_tests e'
Checks if the strings are equal or not
Runs 'string_equals'
```
using input,output;
var hand = "string"; 
var x=1;
    if hand == "f" then
        x=2;
    end;
```
Checks for an output that contains.
tStringEQ