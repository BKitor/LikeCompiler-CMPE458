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



