#!/bin/bash

# MY_SHELL="korn"
# IFCNF=$(ifconfig)
# echo "I like the $MY_SHELL shell"
# echo "ifconfig is $IFCNF"

for FL in $@
do
([ -f "$FL" ] &&  echo "$FL is regular file" ) || ([ -d "$FL" ] &&  echo "$FL is directory")  ||  echo "Your file is something irregular $FL"
done