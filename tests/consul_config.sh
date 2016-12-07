#!/bin/bash
rm -rf /tmp/testc
mkdir -p /tmp/testc
export CONF_DIR=/tmp/testc
export DEFAULTS_DIR=defaults-test1
../configuration/consul-simple.sh $@
set -e
if ! grep -q  "<property><name>test</name><value>asd</value></property>" /tmp/testc/core-site.xml; then
   echo "ERROR test key is missing" 
fi
