#!/bin/bash
rm -rf /tmp/test1
mkdir -p /tmp/test1
export CONF_DIR=/tmp/test1
export CONFIG_SERVER_URL=http://localhost:8889
export CONFIG_GROUP=hdfs
../configuration/springconfig.sh
set -e
if ! grep -q  "<property><name>fs.default.name</name><value>hdfs://localhost:9000</value></property>" /tmp/test1/core-site.xml; then
   echo "ERROR test key is missing" 
fi
