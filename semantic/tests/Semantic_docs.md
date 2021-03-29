# CMPE/CISK 458 Group K Assignemnt 3 Docs

## New Tokens
Added new semantic input tokens to semantic.ssl, including: `sLike, sPackage, sPublic, sConcatinate, sRepeatString, sSubstring, sLength, sInitialValue, sCaseElse`. (lines 72-82)
Removed `sType` (line 30), 
Added new output t-codes, including: `tConcatinatem, tRepeatString, tSubstring, tLength, tStringEQ, tInitialValue, tInitEnd, tCaseElse, tCaseElseEnd` (lines 174-155)
Added new semantic mechanims `oSymbolTblMergePublicScope, oSymbolStkSetPublicFlag`(line 315)         
Added the new SymbolKind syPackage(line 323)
After generating semantic.def, the appropriate pt code was pasted into semantic.pt.

## Block Overhall
Changed lines 730 of semantic.pt to match a @Statement rule instead of a @Block rule, in order to start the program. 
Added the contents of the @Statement rule @Block in order to match both statements and declarations.
Modified @Statement to match sBegin, push a scope, recusivly call the @Block rule, and pop a scope when sEnd is encountered. (lines 1295-1303)
also removed the @BeginStatement rule

## Type Changes
Removed the @TypeDefinitions rule. 
Modified @SimpleType to match sLike, and a constant or symbol, and push the appropriate type on to the type stack. (lines 962-985)  

## Array Changes
Index type is modified so to remove the subrange, and make it so all arrays start at 1.(lines 923-930)
When an array is matched, 1 is pushed on the value stack as the lower bound, a @ConstantValue is matched as the upper bound, and everything contiues as normal after that. 

## Variables Changes
Remove the {} to only match 1 var per declaration.
After matching an identifier, the semantic analyzer checks for sInitialValue (line 1043).
If found, an expression is matched, and tcodes are emited to store the contents of the expression in the new var. (lines 1044-1052) 
If sInitialValue isn't fount, @TypeBody is called, and a type is matched. 

@VariableDeclaration is updated to check for sPublic. 
If found, a call to oSymbolStackSetPublicFlag is called. (line 1092)

## Constant Changes
@ConstandDeclaration is updated to check for sPublic. 
If found, a call to oSymbolStackSetPublicFlag is called. (line 880)

## Procedure/Function Changes
@ProcedureParamaterType was updated to to use SimpleType which matches the like clause. (line 1239) 

@ProcedureDeclaration is updated to check for sPublic. 
If found, a call to oSymbolStackSetPublicFlag is called. (line 1227)

## Packages
Added an sPackage match to @Block, as well as a new @PackageDefinition rule (semantic.ssl line 834) 
The @PackageDefinition rule matches an identifier (package name), creates a new symbol of package kind, pushes a scope matches sBegin and recursivly calls @Block, and finaly calls oSymbolTblMergeScope on sEnd.
We don't use @Block since it would call oSymbolTblPopScope.

semantic.pt is updated with the functionality of oSymbolTblMergeScope and oSymbolStkSetPublicFlag.
symbolTblPublicFlag bool array is added to track publicflag data in the symbol table (line 733)
symbolStkPublicFlag bool array is added to track publicflag data in the symbol Stack (line 747)
SymbolStkPush is update to init a publicflag to false (line 1351)
SymbolStkPushIdentifier is udpated to copy publicflad info over from the symbol table (line 1375)
oSymbolTblEnter, oSymbolTblUpdate, are updated to manage public flag data as well. (line 1729, 1755)
oSymbolTblMergePublicScope is added.
Most of the info is coppied from oSymbolTblPop, with an extra check to publicFlag made on line 1843, and lines modifing the display are removed. 
oSymbolStkSetPublicFlag is added, which sets the current publicflag stack TOS to true


## String Operand
@Operand
(semantic.ssl 1716->1760)
Modified the sStringLiteral case within @Operand. Originally the code was the following:
```
| sStringLiteral:
	oSymbolStkPush(syExpression)
	@StringLiteral  % pushes type and value
	[ oTypeStkChooseKind
		| tpChar:
                        .tLiteralChar
                        oEmitValue
                | *:
                        .tLiteralString
                        oEmitValue
        ]
```
This was unnecessary as the sStringLiteral should only be taking Chars so the oTypeStkChooseKind loop isn't required.
However, it was necessary to add oValuePushChar and oValuePop in order to access the char.
The modified sStringLiteral case can be seen below.
```
| sStringLiteral:
	oSymbolStkPush(syExpression)
	@StringLiteral  % pushes type and value
	.tLiteralAddress
        oValuePushChar
        oEmitValue
        oValuePop
        .tFetchChar
        oValuePop
```

## StringLiteral Modification
@StringLiteral
(semantic.ssl 1762-> 1792)
The oValueChoose loop was removed as we don't need to deal with the zero length or one length sceneraio as special, 
therefore the check for string length isn't required. However, some of the functionality within the loop was still
required so it was added back in outside the loop. 
```
StringLiteral :
	.tSkipString     
	oFixPushForwardBranch
	oEmitNullAddress
	.tStringData
	oEmitValue                      % string length
	oValuePop
	oValuePushChar          	% The string's characters are in the code area
	oValueNegate                    % encode that with a negative address
	oEmitString                     % string's characters
	oFixPopForwardBranch
	oTypeStkPush(tpChar)
	oTypeStkLinkToStandardType(stdChar)
	oValuePop
```

## String Unary Operator
@UnaryOperator
(semantic.ssl 1793->1823)
Added an additional case for sLength. This was needed to get the length of the string. 
```
| sLength:
	.tLength
	oTypeStkPush(tpInteger) % result type
	oTypeStkSwap
	[ oTypeStkChooseKind
		| tpChar:
                | *:
			#eTypeMismatch

        ] 
	oTypeStkPop
```

## String Binary Operators
@BinaryOperator
(semantic.ssl 1826->1915)
Needed to add cases for sRepeatString, sConcatinate, for Repeat String and Concatinate string operators.
```
| sRepeatString:
	.tRepeatString
	%Emulating @CompareAndSwapTypes because its made only for matching types
	oTypeStkPush(tpChar)
	oTypeStkSwap
	[ oTypeStkChooseKind
		| tpInteger:
                | *:
                        #eTypeMismatch
        ]
	oTypeStkPop
	@CompareAndSwapTypes
	oTypeStkPop             % only result type remains
	oSymbolStkPop
	oSymbolStkSetKind(syExpression)
	| sConcatinate:
                .tConcatinate
                oTypeStkPush(tpChar) % result type
                @CompareOperandAndResultTypes
```
Also within the @BinaryOperator function, the string equals and the string not equals cases needed to be modified
for the string equality and string inequality cases.
```
| sEq:
	[ oTypeStkChooseKind
		| tpChar:
                        .tStringEQ
                |*:
                        .tEQ
	]
        @CompareEqualityOperandTypes
| sNE:
	[ oTypeStkChooseKind
		| tpChar:
                        .tNot
                        .tStringEQ
		|*:
                        .tNE 
	]
```
Finally a conditional is added for sSubstring so the Substring operator is dealt with in @BinaryOperator
```
| sSubstring:
                .tSubstring
                 %Emulating @CompareAndSwapTypes because its made only for matching types
                oTypeStkPush(tpChar)
                oTypeStkSwap
                [ oTypeStkChooseKind
                    | tpInteger:
                    | *:
                        #eTypeMismatch
                ]
                oTypeStkPop
                oTypeStkSwap
                [ oTypeStkChooseKind
                    | tpInteger:
                    | *:
                        #eTypeMismatch
                ]
                oTypeStkPop
                @CompareAndSwapTypes
                oTypeStkPop             % only result type remains
                oSymbolStkPop
                oSymbolStkPop
                oSymbolStkSetKind(syExpression)
```
@CompareAndSwapTypes
(semantic.ssl 1917->1959)
Removed the tpString case as it was no longer necessary, using tpChar case instead.
| tpString:
	oTypeStkSwap
	[ oTypeStkChooseKind
		| tpString:
                | *:
                        #eTypeMismatch
	]
## String Misc. Modifications
@SimpleType 
(semantic.ssl 1020->1055)
Added an additional check for sStringLiteral. If a sStringLiteral is read an oTypeStkPush(tpChar) followed by
a oTypeStkLinkToStandardType(stdChar) is called as the char needs to be pushed to the TypeStack.
``` | sStringLiteral:         
	oTypeStkPush(tpChar)
        oTypeStkLinkToStandardType(stdChar) 
```

@ConstantOperand
(semantic.ssl 2109->2133)
Modified tpChar case as it needed to push onto the stack, and emit the .tFetchChar token.
```
| tpChar:
	.tLiteralAddress	
	oValuePushSymbol	
	oEmitValue	
	oValuePop	
        .tFetchChar
```
Removed the tpString case as it is no longer needed.
```
| tpString:         % a named literal string
	.tLiteralString
	oEmitValue
```
@AssignProcedure
(semantic.ssl 2299->2372)
Changed both instances of tpString to tpChar as we are now using char types instead of strings.
| tpChar, tpArray: (line 2355)
and 
| tpChar: (line 2319)

## String Get & Put

@WriteText
(semantic.ssl 2529->2602)
The purpose of @WriteText is to accept an optional field width specification, supplying a default field width if none is specified. 
Verify that the expression to be written is of legal type. The expression rule has just pushed symbol and type stack
entries for the expression to be written. 
A tpString check needed to be turned into a tpChar check, and the trap kind within a tpChar check needed to be
changed from oEmitTrapKind(trWriteChar) to oEmitTrapKind(trWriteString).
[ oTypeStkChooseKind
            | tpChar:
                .tTrap
                oEmitTrapKind(trWriteString)

@ReadText
(semantic.ssl)
Within @ReadText, the oEmitTrapKind needed to be changed from a trReadChar to a trReadString as the type stack
was reading a string.
[ oTypeStkChooseKind
            | tpChar:
                .tTrap
		oEmitTrapKind(trReadString)

## Semantic.pt String Modifications
stringSize
(semantic.pt ln 339)
Added in stringSize = 256 as specified in Phase 3 handout.

procedure SslWalker
(semantic.pt 1596-> 2529)
The purpose of this procedure is to walk the semantic analysis S/SL table.

oValuePushInteger
(semantic.pt 2324->2331)
The purpose of this function is to push the value ofthe last string token to be accepted
We removed ValueStackPush(compoundTokenText[1]) andreplaced it with ValueStackPush(codeAreaEnd)
as we needed the whole token.
```
    oValuePushChar:
	begin
        	Assert((compoundToken = sStringLiteral), assert37);
                ValueStackPush(codeAreaEnd);
        end;
```
oAllocateVariable
(semantic.pt 2392->2414)
Changed from having one case to handle both tpCharand tpBoolean to handling them individually
as the dataAreaEnd for boolean depends on byteSizeand it depends on stringSize for char.
```
	tpBoolean:
		dataAreaEnd := dataAreaEnd + byteSize;
	tpChar: 
		dataAreaEnd := dataAreaEnd + stringSize;
```
Within tpArray added an if statement for tpChartypes to calculate the size.
```
	if (kind = tpChar) then
		size := size * stringSize;	
```
oEmitString
(semantic.pt 2505->2517)
Updated oEmitString to append a 0 to the end ofemitted string so the end of a string is marked.
```
	EmitOutputToken(0);
```
