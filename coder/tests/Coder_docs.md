# CMPE/CISK 458 Group K Assignemnt 4 Docs
## Updates to Semantic.ssl


@VariableDeclarations
(semantic.ssl 1093->1143)
Changed handling for sInitialValue to emit .tInitialValue and .tInitEnd
```
[
            | sInitialValue:    % check if initial value, otherwise match like clause
                .tInitialValue
                % add properties to type/symbol stacks
                @Expression     % Get value and type of expression
                .tInitEnd
                @TypeTblEnterIfNew
                oSymbolStkPop   % pop Expression from stack
                @EnterVariableAttributes
                % Reverse Assignment of Value to var tLiteralAddress emitStore 
                .tLiteralAddress
                oValuePushSymbol
                oEmitValue
                oValuePop
                [ oTypeStkChooseKind
                    | tpArray:
                        #eScalarReqd	% can't assign whole arrays
                    | *:                
                        @EmitStore
                ]
```
@CaseStmt
(semantic.ssl 1614->1649)
Added missing loop for sCaseElse check.
```
[
	| sCaseElse:
                @CaseElseAlternative
	| *:
]
```

@CaseElseAlternative
(semantic.ssl 1651->1655)
Added handling for CaseElseAlternative as it was missing.
```
CaseElseAlternative :
        .tCaseElse
        @Statement
        .tCaseElseEnd;
```

@Operand
(semantic.ssl 1735->1781)
Changed handling for |sStringLiteral as it was incorrect emitted the char value(Removed oValuePushChar and oValuePop).
```
| sStringLiteral:
                oSymbolStkPush(syExpression)
                @StringLiteral  % pushes type and value
                .tLiteralAddress
		 %oValuePushChar
                oEmitValue
                %oValuePop
                .tFetchChar
                oValuePop
```

@BinaryOperator
(semantic.ssl 1847->1907)
Changed sNE handling as T-codes were being emitted in the wrong order.
```
| sNE:
	[ oTypeStkChooseKind
                    | tpChar:
                        .tNot
                    % NEW these were out of order
                        .tStringEQ
                        .tNot
                    |*:
                        .tNE 
	]
``` 

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
@EmitDefaultCaseAbort
(coder.ssl 1241->1277)
Added handling for tCaseElse.
```
[
        | tCaseElse:
            % use theStatementsrule to handle its statements
            @Block
            % emit a case merge branch
            tCaseElseEnd
            oEmitCaseMergeBranch
        | *:
]
```
## String Constants, Variables, Arrays 
(coder.pt 495-497)
Added a definition for stringSize (256)
```
{+++++++++++++++++++++++++++++++++++++}
        stringSize = 256;
{+++++++++++++++++++++++++++++++++++++}
```
@AcceptInputToken
(coder.pt 1895-1906)
Added reading of the trailing null character (zero) for tStringData in AcceptInputToken. +1 added to loop and nextTCodeAddress for handling
```
tStringData:
                            begin
                                compoundTokenLength := compoundTokenValue;
                                compoundTokenValue := tCodeAddress;
                                i := 1;
                                {+1 added to handle the null character}
                                while i <= compoundTokenLength + 1 do
                                    begin
                                        read (tCode, compoundTokenText[i]);
                                        i := i + 1;
                                    end;
                                    { +1 Code Address added to handle updating address with the null character included }
                                nextTCodeAddress := nextTCodeAddress + compoundTokenLength+1;
                            end;
```
OperandFoldManifestSubscript
(coder.pt 1811-1818)
Added offset scaling by stringSize (256) to OperandFoldManifestSubscript if the array operand’s length is string
```
            else
                begin
                    subscript := subscript - lowerBound;
                    if operandStkLength[operandStkTop-1] = word then
                        { Convert a byte offset to a word offset }
                        subscript := subscript * wordSize;
{ +++++add offset scaling by stringSize 256 if the array operands length is string+++++++++++++++ }
                    if operandStkLength[operandStkTop-1] = string then
                        { Convert a byte offset to a word offset }
                        subscript := subscript * stringSize;
{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }   
```
OperandPushExpressionAssignPopPop
(coder.ssl 2370-2504)
Add an alternative for tSkipString just like the one in OperandPushExpression and removed handling of tLiteralString and tLiteralChar .
```
OperandPushExpressionAssignPopPop:
    {[
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++
        %alternative for tSkipString matching alternative from OperandPushExpression
        | tSkipString:
        % Emit string literal to data area
        oEmitNone(iData)                    %       .data
        tStringData
        oEmitString                         % sNNN: .asciz  "SSSSS"
        oEmitNone(iText)                    %       .text
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++
```
@Routine
(coder.ssl 820->852)
Under tStoreChar case switched oOperandSetLength(byte) to oOperandSetLength(string)
```
    | tStoreChar:
        %CHANGE: Updated to specify string rather than byte
        oOperandSetLength(string)
        @OperandAssignCharPopPop
```
@OperandPushVariable
(coder.ssl 1838-1877)
After a tLiteralAddress has been accepted changed how tFetchChar was handled, from byte to string
```
| tFetchChar:
            oOperandSetLength(string)
```
@OperandSubscriptCharPop
(coder.ssl 2024->2051)
Updated to set oOperandSetLength to string instead of byte.
```
%-----------------------------------------------
%                    oOperandSetLength(byte)
%-----------------------------------------------
%++++++++++++++++++++++++++++++++++++++++++++++
                    oOperandSetLength(string) 
%++++++++++++++++++++++++++++++++++++++++++++++    

```
@OperandForceToStack
(coder.ssl 3699->3716)
Added an alternative for operand length string that calls OperandForceAddressIntoTemp
```
 | string:
                @OperandForceAddressIntoTemp

```
@OperandForceIntoTemp
(coder.ssl 3559->3589)
Added an alternative for operand length string which calls OperandForceAddressIntoTemp and then exits the rule
```
         | *:
            [ oOperandChooseLength
                | byte:
                    @OperandPushTempByte
                | word:
                    @OperandPushTempWord
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                %alternative for operand length string which calls OperandForceAddressIntoTemp
                | string :
                    @OperandForceAddressIntoTemp
                    % and then exits the rule
                    >>
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ]
```
@OperandCheckedSubscriptNonManifestCharPop
(coder.ssl 2088->2196)
Scaled the subscript by string size, matching word size implementation in OperandCheckedSubscriptNonManifestIntegerPop, but scaling by 256 (2^8) instead of 4 (2^2)
```
    @OperandSubtractPop                         %       subl lower, %T
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % Scale subscript by string size              % ... arraydesc, %T
    oOperandPushMode(mManifest)
    oOperandSetLength(string)
    oOperandSetValue(eight)                       % ... arraydesc, %T, 8
    oEmitDouble(iShl)                           %       shll    $8, %T
    oOperandPop 
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    % Add normalized subscript to array address
    oOperandSwap                                % ... %T, arraydesc
```
@OperandUncheckedSubscriptNonManifestCharPop
(coder.ssl 2145->2152)
Added scaling of lower bound and the subscript by string size, OperandUncheckedSubscriptNonManifestIntegerPop used for reference. 
```
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            % Scale subscript by string size              % ... arraydesc, %T
            oOperandPushMode(mManifest)
            oOperandSetLength(string)
            oOperandSetValue(eight)                       % ... arraydesc, %T, 8
            oEmitDouble(iShl)                           %       shll    $8, %T
            oOperandPop 
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
```
@OperandAssignCharPopPop
(coder.ssl 3289->3337)
 A target string variable can now be assigned a string value, based on the OperandEolnFunction rule. 
```
OperandAssignCharPopPop:
%Emit code to call the new trAssignString trap
%-----------------------------------------------------------
%    oOperandSetLength(byte)
%    @EmitMove                   %       movb    y, x
%    @OperandPopAndFreeTemp
%    @OperandPopAndFreeTemp;
%---------------------------------------------------------
    % First save the temp registers, since we are called in an
    % expression, they  may be in use
    @SaveTempRegsToStack        %       pushl %eax .. %edx

    % Now send the arguments addresses to the stack
    @OperandForcetoStack        
    oOperandPop
    oOperandSetLength(string)
    @OperandForcetoStack      
    oOperandPop

    % Call the AssignString trap
    oOperandPushMode(mTrap)
    oOperandSetValue(trAssignString)
    oOperandSetLength(word)
    oEmitSingle(iCall)          %       call    pttrap101
    oOperandPop

    % Pop arguments
    oOperandPushMode(mStackReg)
    oOperandSetLength(word)
    oOperandPushMode(mManifest)
    oOperandSetLength(word)
    oOperandSetValue(eight)      % ... %esp, 1arg*8
    oEmitDouble(iAdd)           %       addl    $8, %esp
    oOperandPop
    oOperandPop

    %--------------------------------------------------------------------
    %oOperandPushMode(mScratchReg1)
    %oOperandSetLength(word)
    %oOperandPushMode(mResultReg)
    %oOperandSetLength(word)
    %oEmitDouble(iMov)           %       movl    %eax, %S1
    %oOperandPop %eax
    %---------------------------------------------------------------------

    % Restore temp regs
    @RestoreTempRegsFromStack;   %       popl    %edx .. $eax
```
## String Operations
@OperandPushExpression
(coder.ssl 1528->1617)
Added handling for tSubString, tRepeatString, tConcatinate, tLength, tStringEQ and removed tLiteralChar and tLiteralString handling
```
	| tSubstring:
            @OperandSubStringPop
        | tRepeatString:
            @OperandRepeatStringPop
        | tConcatinate:
            @OperandConcatinatePop
        | tLength:
            @OperandlengthPop
        | tStringEQ:
            @OperandStringEqPop
```
OperandPushExpressionAssignPopPop
(coder.ssl 2370-2504)
Added handling for tSubString, tRepeatString, tConcatinate, tLength, tStringEQ and removed tLiteralChar and tLiteralString handling
```
	| tSubstring:
            @OperandSubStringPop
        | tRepeatString:
            @OperandRepeatStringPop
        | tConcatinate:
            @OperandConcatinatePop
        | tLength:
            @OperandlengthPop
        | tStringEQ:
            @OperandStringEqPop
```
### tConcatenate
@OperandConcatinatePop
(coder.ssl 1745->1784)
Takes two strings s1, s2 and leaves the address of the string result of their concatenation in temporary register %X
```
OperandConcatinatePop:
    % TOS is string2, then string1
    @SaveTempRegsToStack

    % Push the strings onto the stack
    @OperandForceToStack
    oOperandPop
    @OperandForceToStack
    oOperandPop

    % Call the trConcatenate trap 
    oOperandPushMode(mTrap)
    oOperandSetValue(trConcatenate)
    oOperandSetLength(word)
    oEmitSingle(iCall)
    oOperandPop

    % Clean up the stack
    oOperandPushMode(mStackReg)
    oOperandSetLength(word)
    oOperandPushMode(mManifest)
    oOperandSetLength(word)
    oOperandSetValue(eight)
    oEmitDouble(iAdd)
    oOperandPop
    oOperandPop

    % Move the result to a scratch register
    oOperandPushMode(mScratchReg1)
    oOperandSetLength(word)
    oOperandPushMode(mResultReg)
    oOperandSetLength(word)
    oEmitDouble(iMov)
    oOperandPop

    @RestoreTempRegsFromStack
    @OperandForceIntoTemp
    oOperandSetLength(word)
    % exit with the new string in a temp on top of the operand stack
    ; 
```
### tRepeatString
@OperandRepeatStringPop
(coder.ssl 1789->1828)
takes string s1, and repetition count i1;  returns the address of the string result in temporary register %X
```
OperandRepeatStringPop:
    % TOS is num repeats, then string
    @SaveTempRegsToStack

    % Push the string and num onto the stack
    @OperandForceToStack
    oOperandPop
    @OperandForceToStack
    oOperandPop

    % Call the trRepeatString trap 
    oOperandPushMode(mTrap)
    oOperandSetValue(trRepeatString)
    oOperandSetLength(word)
    oEmitSingle(iCall)
    oOperandPop

    % Clean up the stack
    oOperandPushMode(mStackReg)
    oOperandSetLength(word)
    oOperandPushMode(mManifest)
    oOperandSetLength(word)
    oOperandSetValue(eight)
    oEmitDouble(iAdd)
    oOperandPop
    oOperandPop

    % Move the result to a scratch register
    oOperandPushMode(mScratchReg1)
    oOperandSetLength(word)
    oOperandPushMode(mResultReg)
    oOperandSetLength(word)
    oEmitDouble(iMov)
    oOperandPop

    @RestoreTempRegsFromStack
    @OperandForceIntoTemp
    oOperandSetLength(word)
    % exit with the new string in a temp on top of the operand stack
    ;
```
### tSubstring
@OperandSubStringPop
(coder.ssl 1620->1656)
Takes string s1, lower index i1 and upper index i2;  leaves 
the address of the substring result in temporary register %X
```
OperandSubStringPop:
 %Emit code for SubString trap
    @SaveTempRegsToStack

    % push  top, bot and string arguments to stack
    @OperandForceToStack
    oOperandPop
    @OperandForceToStack
    oOperandPop
    @OperandForceToStack
    oOperandPop

    %call substring trap
    oOperandPushMode(mTrap)
    oOperandSetValue(trSubString)
    oOperandSetLength(word)
    oEmitSingle(iCall)
    oOperandPop
    
    % Pop arguments
    oOperandPushMode(mStackReg)
    oOperandSetLength(word)
    oOperandPushMode(mManifest)
    oOperandSetLength(word)
    oOperandSetValue(twelve)
    oEmitDouble(iAdd)
    oOperandPop
    oOperandPop

    %Handling Results
    oOperandPushMode(mScratchReg1)
    oOperandSetLength(word)
    oOperandPushMode(mResultReg)
    oOperandSetLength(word)
    oEmitDouble(iMov)
    oOperandPop

    @RestoreTempRegsFromStack
    @OperandForceIntoTemp
    oOperandSetLength(word)
    ;
```

### tLength
@OperandLengthPop
(coder.ssl 1704->1741)
Takes string s1 and returns its integer length in temp reg %X
```
OperandLengthPop:
    % String to get lenght of is on stack
    @SaveTempRegsToStack

    % Push the string onto the stack
    @OperandForceToStack
    oOperandPop

    % Call the trLength trap 
    oOperandPushMode(mTrap)
    oOperandSetValue(trLength)
    oOperandSetLength(word)
    oEmitSingle(iCall)
    oOperandPop
    
    % Clean up the stack
    oOperandPushMode(mStackReg)
    oOperandSetLength(word)
    oOperandPushMode(mManifest)
    oOperandSetLength(word)
    oOperandSetValue(four)
    oEmitDouble(iAdd)
    oOperandPop
    oOperandPop

    % Move the result to a scratch register
    oOperandPushMode(mScratchReg1)
    oOperandSetLength(word)
    oOperandPushMode(mResultReg)
    oOperandSetLength(word)
    oEmitDouble(iMov)
    oOperandPop

    @RestoreTempRegsFromStack
    @OperandForceIntoTemp
    oOperandSetLength(word)
    % exit with the string lengths in a temp on top of the operand stack
    ;
```
### tStringEQ 
@OperandStringEQPop
(coder.ssl 1661->1700)
Takes two strings s1 and s2 and returns a boolean result  in temporary register %X
```
OperandStringEQPop:
% TOS is string2, then string1
    @SaveTempRegsToStack

    % Push both strings onto the stack
    @OperandForceToStack
    oOperandPop
    @OperandForceToStack
    oOperandPop

    % Call the trStringEqual trap 
    oOperandPushMode(mTrap)
    oOperandSetValue(trStringEqual)
    oOperandSetLength(word)
    oEmitSingle(iCall)
    oOperandPop
    
    % Clean up the stack
    oOperandPushMode(mStackReg)
    oOperandSetLength(word)
    oOperandPushMode(mManifest)
    oOperandSetLength(word)
    oOperandSetValue(eight)
    oEmitDouble(iAdd)
    oOperandPop
    oOperandPop

    % Move the result to a scratch register
    oOperandPushMode(mScratchReg1)
    oOperandSetLength(word)
    oOperandPushMode(mResultReg)
    oOperandSetLength(word)
    oEmitDouble(iMov)
    oOperandPop

    @RestoreTempRegsFromStack
    @OperandForceIntoTemp
    oOperandSetLength(word)
    % exit with eith 1 or 0 in a temp on top of the operand stack
    ;
```
### tChr
@OperandChar
(coder.ssl 2984->3017)
Takes integer i1, converts its value to a character and  returns the address of the 
string result in temp register %X
```
OperandChr:
    @SaveTempRegsToStack

    % Assume operand's value is in range
    % Force integer (word) value to stack
    @OperandForceToStack
    oOperandPop  

    % call trChrString to handle 
    oOperandPushMode(mTrap)
    oOperandSetValue(trChrString)
    oOperandSetLength(word)
    oEmitSingle(iCall)
    oOperandPop   
    
    %Pop arguments
    oOperandPushMode(mStackReg)
    oOperandSetLength(word)
    oOperandPushMode(mManifest)
    oOperandSetLength(word)
    oOperandSetValue(four)
    oEmitDouble(iAdd)
    oOperandPop
    oOperandPop
    
    %Result
    oOperandPushMode(mScratchReg1)
    oOperandSetLength(word)
    oOperandPushMode(mResultReg)
    oOperandSetLength(word)
    oEmitDouble(iMov)
    oOperandPop

    @RestoreTempRegsFromStack
    @OperandForceIntoTemp
    oOperandSetLength(word);
```
### tOrd
@OperandOrd
(coder.ssl 3019->3051)
Removed old @OperandOrd, commented out, created new one that takes 
string s1; converts the first character of s1 into an integer  in temporary register %X
```
OperandOrd:
    % TOS is string
    oOperandPushMode(mManifest) % add new operand for result
    oOperandSetValue(zero)
    oOperandSetLength(word)
    @OperandForceIntoTemp

    oOperandSwap
    @OperandForceIntoTemp
    oOperandSetMode(mTempIndirect) % set the string to be derefrenced

    oEmitDouble(iMov) % get the value at the string adn stick it in the result
    @OperandPopAndFreeTemp % pop the string
    oOperandSetLength(byte)
    ;
```