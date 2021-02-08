#!/usr/bin/bash

cd parser/test/

echo -e "\n****Keyword test****"
./run_tests.sh k | grep "pIdentifier"

 echo -e "\n****Character test****"
 ./run_tests.sh c | grep "\." | grep -v "Line"
 
 echo -e "\n****Double Character Tokens test****"
 ./run_tests.sh d | grep "\." | grep -v "Line"

echo -e "\n****Comment test****"
./run_tests.sh m | grep -E "@|\.|%" | grep -v "pNewLine" 

echo -e "\n****String Litteral test****"
./run_tests.sh s | grep -E "@|%|\.|#" | grep -v "pNewLine"