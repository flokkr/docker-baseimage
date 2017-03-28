#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONSUL_PATH=${CONSUL_PATH:-conf}/${CONSUL_KEY:-/}
#remove leading/trailing and double slashes
CONSUL_PATH=$(echo $CONSUL_PATH| sed 's/\/\///g' | sed 's/\/*$//g' | sed 's/^\/*//g' )
echo "Consul path: $CONSUL_PATH"
$DIR/consul-launcher --path ${CONSUL_PATH} --destination $CONF_DIR $@
