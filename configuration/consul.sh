#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DEST=/tmp/consul-template.json
KEY_PATH=${CONSUL_PREFIX:-conf}
if [ ! -z "$CONSUL_KEY" ]; then
   KEY_PATH=$KEY_PATH/$CONSUL_KEY
fi
if [ ! -z "$CONSUL_PATH" ]; then
   KEY_PATH=$CONSUL_PATH
fi
KEY_PATH=${KEY_PATH}/
CONSUL_SERVER=${CONSUL_SERVER:-127.0.0.1:8500}
function generate-template() {
   cd $DIR
   export KEY_PATH
   echo $KEY_PATH
   export EXECUTOR=$@
   consul-template -once -config $DIR/consul.bootstrap.config
   chmod +x /opt/custom_launcher.sh
   cd -
}

generate-template $@
