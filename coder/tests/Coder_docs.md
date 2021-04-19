# CMPE/CISK 458 Group K Assignemnt 4 Docs

## New tokens
New tokens were added to the start of the file, these include the new tCodes for strings, initial value, and case, see lines 85->93 of coder.ssl

```
% NEW like t codes
tConcatinate
tRepeatString
tSubstring
tLength
tStringEQ
tInitialValue
tInitEnd
tCaseElse
tCaseElseEnd
```
The new 256 integer was added to coder.ssl as well, se line 138
`twofiftysix = 256`

New trap codes for strings were added as well, see lines 164->172 of coder.ssl.
```
% NEW like trap codes
trAssignString = 101
trChrString = 102
trConcatenate = 103
trSubstring = 104
trLength = 105
trStringEqual= 107
trReadString = 108
trWriteString = 109
trRepeatString = 110
```
Finaly, string was added as a datakind, see line 176 of coder.ssl
`string = 3`

## Update Block Rule
As outlined in the handout, the Block rule was reconfigured to match both 
```
% NEW moved body of statement rule into Block to match both declarations and statements
| tAssignBegin:
    @AssignStmt
| tCallBegin:
    @CallStmt
| tIfBegin:
    @IfStmt
| tWhileBegin:
    @WhileStmt
| tRepeatBegin:
    @RepeatStmt
| tCaseBegin:
    @CaseStmt
| tWriteBegin:
    @WriteProc
| tReadBegin:
    @ReadProc
| tTrapBegin:
    @TrapStmt

% NEW initial value feature
| tInitialValue:
    @InitialValue
```

Switch all the statement rules to Block rules, includes line 974, 987, 1038, 1050, 1106, 1130, 1202, 

## Initial Value rules
```
InitialValue:
    @OperandPushExpression
    tInitEnd
    tLiteralAddress
    @OperandPushVariable
    oOperandSwap
    [
        | tStoreInteger:
            @OperandAssignIntegerPopPop
        | tStoreChar:
            @OperandAssignCharPopPop
    ]
    ;
```

## Case Else