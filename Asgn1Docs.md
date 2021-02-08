### string lit
Pascal uses single quotes for string literals, while like uses single quotes. 

parser/parser.pt: 433, `quote='"';`

This chages the lQuote scanner input to check for `"` instead of `'`, giving us the same string literal functionality from Pascal

### comments
Remove Pascal `{}` and `(**)` comments, and add Like `//` and `/**/` comments

Added 2 routines `@OneLineComment` (parser/scan.ssl: 334) and `@MultiLineComment`(parser/scan.ssl: 315)

`@OneLineComment` (parser/scan.ssl: 239) is called after matchching two `/` characters in a row. The body of the function is a loop that matches any character (`?`) untill a `lNewLine`, where it returns

`@MultiLineComment` (parser/scan.ssl: 241) is called after matchching a `/`, then a `*`. The body of the function is a loop that matches any character (`?`) untill a `*` followd by a `/` is matched. It emmits `.pNewLine` for every `lNewLine` character.

(parser/scan.ssl: 243) if neither `/` or `*` is matched after the first slash, a `pSlash` token is emitted. 

### keywords
Add the new keywords to the screener. 

(parser/stdIdentifier:8->26) the new keywords were added to the file, and the old keywords were removed.

(parser/scan.ssl: 63->82) parse tokens for the new keywords were added to the scanner.
(parser/parser.pt: 100->120) parse tokens for the new keywords were added to the driver program.

Now the scanner/screener will emit proper parse tokens, for example it will emit `.pfun` instead of a number identifier for `fun`.