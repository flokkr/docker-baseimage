#!/bin/bash
set -e
cd tests
for i in `ls -1 *.sh`; do
   echo "Testing $i"
   ./$i
done
