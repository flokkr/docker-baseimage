#!/bin/bash
rm -rf /tmp/test1
mkdir -p /tmp/test1
export CONF_DIR=/tmp/test1
export CORE_SITE_TEST=yyy
export DEFAULTS_DIR=defaults-test1
../configuration/simple.sh
set -e
if  ! grep -q  "<property><name>test</name><value>yyy</value></property>" /tmp/test1/core-site.xml; then
   echo "ERROR core-site doesn't contain yyy"
fi
