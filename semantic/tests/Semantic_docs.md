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



