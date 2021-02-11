# CISC458k Test Suite

This document describes the process for an automatic testing process to check for correct output with regards to the input, errors included, in addition to cleaning up trace output from the terminal with commands such as grep. 
The parser tests are located in `./parser/test/`. There are 5 .pt files which act as unit tests for the features we implimented. 
There is also the script `./parser/test/run_test.sh` which compiles and runs the unit tests.
In the root of the project, `autoScanTest.sh` calls `parser/test/run_test.sh` multiple times, and filters the output through grep to make it human readable.

__As the T.A, all you need to do to run the test suite is `./autoScanTest.sh`__

1) `./parser/test/run_tests.sh k`:
Uses grep with pIdentifier to map each keyword to it's identifier and omitting the redundant details that are dumped when running the ./run_tests.sh file. 
Input: keywords.pt
Output: each .pIdentifier matched with its keyword, shown in test_k_expected.txt, and the removed keyowrds outputed as identifiers
2) `./parser/test/run_tests.sh c`:
Uses grep with . and an additional Line to map each character to it's identifier and omitting the redundant details that are dumped when running the ./run_tests.sh file. 
Input: new_char.pt
Output: each .p\[Character_Name_Identification\] matched with its appropriate character, shown in test_c_expected.txt
3) `./parser/test/run_tests.sh m`:
Uses grep with "@|\.|%" (to match '@', '.' and '%') as well as removing pNewLine to map each comment to it's .p[Character_Name_Identification] and an @ what comment routine it is, the grep omits the redundant details that are dumped when running the ./run_tests.sh file. 
Input: comment.pt
Output: each .p[Character_Name_Identification] matched with its appropriate comment, as well as an @ to determine what type of comment it is. Also contains special @Identifier for a comment with text inside of it, an output for the text within the comment
 and .p matches character handling of certain comment characters, such as a star and another brace shown in test_m_expected.txt
4) `./parser/test/run_tests.sh s`:
Uses grep with @|%|\.|# as well as an additional pNewLine to map each string literal an @StringLiteral and an identifier to .pString Literal. Also has the output for the string literal shown as well as errors if there's an illegal character. The grep omits the redundant details that 
are dumped when running the ./run_tests.sh file. 
Input: str_lit.pt
Output: an @StringLiteral for each string literal and an identifier .pString, finally contains the output for each token text and errors for illegal characters, shown in test_s_expected.txt
5) `./parser/test/run_tests.sh d`:
Runs the tests for double characters (+= -> .PlusEquals). The unit tests contains identifiers for all the new operators, as well as a few cases that should fail. the expected output (./test_d_expected.txt) emits all the new tokens, as well as tokens for some non-doubled operators.