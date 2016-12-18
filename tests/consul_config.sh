#!/bin/bash
rm -rf /tmp/testc
mkdir -p /tmp/testc
export CONF_DIR=/tmp/testc
export DEFAULTS_DIR=defaults-test1
export CONSUL_PREFIX=conf
export CONSUL_KEY=hdfs
../configuration/consul.sh ls /tmp/testc
/opt/custom_launcher.sh
set -e
if ! grep -q  "<property><name>test</name><value>asd</value></property>" /tmp/testc/core-site.xml; then
   echo "ERROR test key is missing"
fi
