# CMPE/CISK 458 Group K Assignemnt 2 Docs

### New Tokens Tokens
Added new input tokens to `parser.ssl`, allong with their character string ('/', '=='), including:
pSlash, pPercen, pHash, pBar, pBang, pDoubleBar, pPlusEqual, pMinusEqual, pStarEquals, pSlashEqual, pPercentEqual, pDoubleEquals, pLeftBrace, pRightBrace, pLike, pPkg. 
See lines 80 to 92.

Added new ouput semantic tokens to `parser.ssl`, including: sLike, sPackage, sPublic sConcatinate, sRepeatString, sSubstring, sLength, sInitialValue, sCaseElse. 
See lines 152 to 160.

Coppied the contents of `scan.def` into `parser.pt`, see lines 195 to 192

### Structural changes
Since _Like_ can take any combination of statements and declarations the main block of the scanner had to be reconfigured.
Initialy it only took definitions, and then called a `Statement` rule.
To meet the _Like_ specificaiton, we took the contents of `Statement` rule and moved them into the `Block` loop. 
The `Statement` rule is removed, and the `Block` changes can bee seen on lines 185 to 230. 

### Program
Updated the `Program` Rule to match a _Like_ program (line 167).
Identifies the keyword 'using', emits the sProgram token, matches 1 or more comma seperated params, and calls the `Block` rule to get the contents of the program.

### Like Clause
A new rule called `LikeClause` is added to match like clauses, see line 344.
It checks for an optinoal array by trying to match a '[' character, then an unsinged int, and a final ']'.
Then it matches a ':'.
Then it checks for the optial file keyword, and emmits sFile if necicary.
Lastly it matches 'like' token, emits the sLike token, and matches a value that the var/param is _like_.

### Variables
When a `var` token is matched in `Block`, a call to `NonPublicVariableDeclaration is made. (see line 192).
`NonPublicVairableDeclaration` (line 331) matches an identifier then checks if an '=' character is next. If a '=' is mathced, sInitial value is emmitied, and and Expression is matched. 
Otherwise, a `LikeClause` matched. 

### Constants
When a `val` token in matched in `Block`, a call to `NonPublicConstantDefinition` is made. (see line 188).
`NonPublicConstantDefinition` (line 285) mathces and emits an identifier, then calls the `ConstantValue` rule to attribute a value. 
Then depending on if the next character is a comma or a semicollon, it will either match another identifier and token, or exit.

### Functions
When a `fun` keyword is matched in a `Block`, the .sProcedure token is emitted, and the  `NonPublicFunction` rule is called, see line 205.
The `NonPublicFunction` rule (line 275) matches and emits an Identifier for the name, then mathched Procedure heading, emits a sBegin token, followed by a `Block`, and an sEnd token.
The `ProcedureHeadings` rule has been modified to accept a like clause (line 378), and params are seperated by commas instead of semicolons (line 380).


### Public
The `public` keyword was added, and can be matched on `val`, `var` and `fun` keyworkds.
To adapt to this, a new `public` token is matched inside `Block` (see line 210).
Within the `public` match, there are calls to `PublicConstantDefinition`, `PublicVairableDeclaration` and `PublicFunctionDeclaration`, depending on the proseding parse token. 
Each of the new Public rules produce and output similar to their NonPublic counterparts, with an appropriatly insterted sPublic token.  

### Pkg
The `pkg` token is matched in a block on line 197, and calls the `PkgStatement` Rule.
The PkgStatement rule emits a sPackage token, an identifier, and the sBegin `Block` sEnd denoting the package. 

### Statements
Within the following statements(if, choose, while, repeat) All calls for @Statement in PT Pascal are replaced with @Block calls
because Like supports any sequence of declarations and statements which are implemented in @Block 
### elseif
pElseIf ('elseif')
(parser.ssl -> 22, 488->497)
pElseIf, defined as 'elseif' is declared as an input in line 22.
In parser.ssl the if statement is updated to include elseif functionality, line 488->497. Nested if statements were used in the place of 
a new elseif token to allow for less work in semantic stage. 

	IfStmt :
        .sIfStmt
        @Expression
        .sExpnEnd
        'then'  .sThen
        .sBegin @Block .sEnd

        {[
            | 'elseif':
                .sElse
                .sIfStmt
                @Expression
                .sExpnEnd
                'then'  .sThen
                .sBegin @Block .sEnd
            | *:
                >
        ]}
        [
            | 'else':
                .sElse
                .sBegin @Block .sEnd
            | *:
        ];

### Choose
pChoose ('choose')
(parser.ssl -> 20-21, 203->204, 506->527)
pChoose, defined as 'choose' is declared as an input in lines 20-21. Under the Block function it is declared
that if 'choose' is declared then @ChooseStmt is called.
| 'choose':
	@ChooseStmt
ChooseStmt is a function, lines 506-527, that is used to check for an else following the other alternatives in 
the case statement, and output the sCaseElse output token followed by the statements of the elseclause, using the 
modified Statement rule to enclose them in sBegin .. sEnd

	ChooseStmt :
        .sCaseStmt
        @Expression
        .sExpnEnd
        'of' 
        @CaseAlternative
        {[
            | 'end':
                .sEnd ';'
                >
                        
            | 'when':
                @CaseAlternative
        ]}
        .sCaseEnd
        [
            | 'else':
                .sCaseElse
                .sBegin @Block 
                'end' .sEnd ';'
            | *:
        ];

### repeat while
Inputs
pWhile ('while') line 41
pRepeat ('repeat') line 42
Outputs
sWhileStmt line 130 
sRepeatStmt line 131
sRepeatEnd line 132
Under the Block declaration, a check is done to see if @WhileStmt or @RepeatStmt needs to be called, lines 224-230.
	| 'repeat':
            [
                | 'while':
                    @WhileStmt
                |*:
                    @RepeatStmt
            ]
In parser.ssl the alternatives of repeat while and repeat...while are built of PT Pascal's while statement and repeat statement respectively 
Like's repeat while statement is similar instructure to PT's while statement, therefore it was used to implement repeat while. Lines 545-550.

	WhileStmt :
        .sWhileStmt
        @Expression
        .sExpnEnd
        .sBegin @Block 
        'end' .sEnd ';';

In parser.ssl repeat...while modifies PT pascal repeat statements by emitting a sNot token at the end of the expression. 
This sNot is used because repeat...while expression works on the opposite logic of the repeat...until expression, hence the 
purpose of the sNot token. Lines 552-563.
	
	RepeatStmt :
        .sRepeatStmt
        {
            .sBegin @Block .sEnd
            [
                | 'while':
                    .sRepeatEnd
                    >
            ]
        }
        @Expression .sNot
        .sExpnEnd;
____________________________________________________________________________________________________________________________________________
The String Type Documentation

sConcatenate (s|s)
(parser.ssl -> 155, 599->600)
Variable declared as output on line 155. Under SimpleExpression, lines 583->605, check for "|", go to @Term 
and return .sConcatinate. This is done as Like replaces the old PT char data type with a varying length string type. 
| '|':
	@Term .sConcatinate

sRepeatString (s||n)
(parser.ssl -> 156, 601->602)
Variable declared as output on line 156. Under SimpleExpression, lines 582->605, check for "||", go to @Term 
and return .sRepeatString. This is done as Like replaces the old PT char data type with a varying length string type.
| '||':
	@Term .sRepeatString

sSubstring (s/n:m)
(parser.ssl -> 157, 612->625)
Variable declared as output on line 157. Under Term, lines 607->633, check for "/", now check to see if type is 
integer, if yes check to see if ":" follows the integer. If yes go to @Term and return .sSubstring.  This is done 
as Like replaces the old PT char data type with a varying length string type.
| '/':
	[
		| pInteger: 
		.sInteger
			[
				| ':':
                                @Term
                                .sSubstring
                            	| *:
                                .sDivide
                        ]
		| *:
                    @Factor  .sDivide
                ] 


sLength (#s)
(parser.ssl -> 158, 652->654)
Variable declared as output on line 158. Under Factor, lines 635->654, check for "pHash", go to @Factor and return
.sLength. This is done as Like replaces the old PT char data type with a varying length string type.
| pHash:
	@Factor
	.sLength

### Double Character Assignments
New double character assignments expand to proper postifx

## Plus Equals
pPlusEquals ('+=')
(parser.ssl -> 87, 416-422)
pPlusEquals is declared as an input in line 87.
Under the @AssignmentOrCallStmt function, pPlusEquals has been updated to save ourselves work in the Semantic phase 
by simply outputting the semantic token stream for a regular assignment, so that the Semantic phase doesn’t
have to handle short form assignments at all.

| '+=':
	.sAssignmentStmt
	.sIdentifier    
	.sIdentifier    
	@Expression
	.sAdd
	.sExpnEnd

## Minus Equals
pMinusEquals ('-=')
(parser.ssl -> 88, 423-429)
pMinusEquals is declared as an input in line 88.
Under the @AssignmentOrCallStmt function, pMinusEquals has been updated to save ourselves work in the Semantic phase 
by simply outputting the semantic token stream for a regular assignment, so that the Semantic phase doesn’t
have to handle short form assignments at all.
| '-=':
	.sAssignmentStmt
	.sIdentifier    
	.sIdentifier    
	@Expression
	.sSubtract
	.sExpnEnd

## Star Equals
pStarEquals ('*=')
(parser.ssl -> 89, 430-436)
pStarEquals is declared as an input in line 89.
Under the @AssignmentOrCallStmt function, pStarEquals has been updated to save ourselves work in the Semantic phase 
by simply outputting the semantic token stream for a regular assignment, so that the Semantic phase doesn’t
have to handle short form assignments at all.

| '*=':
	.sAssignmentStmt
	.sIdentifier    
	.sIdentifier    
	@Expression
	.sMultiply
	.sExpnEnd

## Slash Equals
pSlashEquals ('/=') 
(parser.ssl -> 90, 437-443)
pSlashEquals is declared as an input in line 90.
Under the @AssignmentOrCallStmt function, pSlashEquals has been updated to save ourselves work in the Semantic phase 
by simply outputting the semantic token stream for a regular assignment, so that the Semantic phase doesn’t
have to handle short form assignments at all.

| '/=':
	.sAssignmentStmt
	.sIdentifier    
	.sIdentifier    
	@Expression
	.sDivide
	.sExpnEnd

## Percent Equals
pPercentEquals ('%=') 
(parser.ssl -> 91, 444-450)
pPercentEquals is declared as an input in line 91.
Under the @AssignmentOrCallStmt function, pPercentEquals has been updated to save ourselves work in the Semantic phase 
by simply outputting the semantic token stream for a regular assignment, so that the Semantic phase doesn’t
have to handle short form assignments at all.

| '%=':
	.sAssignmentStmt
	.sIdentifier    
	.sIdentifier    
	@Expression
	.sModulus
	.sExpnEnd
