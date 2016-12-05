#!/bin/bash
rm -rf /tmp/test2
mkdir -p /tmp/test2
export CONF_DIR=/tmp/test2
export DEFAULTS_DIR=defaults-cfg  
../configuration/simple.sh
set -e
if ! grep -q  "TEST=ASD" /tmp/test2/zoo.cfg; then
   echo "ERROR TEST key is missing"
fi
