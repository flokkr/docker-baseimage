#!/bin/bash
rm -rf /tmp/test1
mkdir -p /tmp/test1
export CONF_DIR=/tmp/test1
export DEFAULTS_DIR=defaults-test1
../configuration/simple.sh
set -e
if ! grep -q  "<property><name>test</name><value>asd</value></property>" /tmp/test1/core-site.xml; then
   echo "ERROR test key is missing" 
fi
