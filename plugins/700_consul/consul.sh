#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


if [ "true" == "$CONSUL_ENABLED" ] || [ -n "$CONSUL_KEY" ]; then
  plugin-is-active "CONSUL"
  CONSUL_PATH=${CONSUL_PATH:-conf}/${CONSUL_KEY:-/}
  #remove leading/trailing and double slashes
  CONSUL_PATH=$(echo $CONSUL_PATH| sed 's/\/\///g' | sed 's/\/*$//g' | sed 's/^\/*//g' )
  echo "Launch with consul launcher. Consul path: $CONSUL_PATH"
  $DIR/consul-launcher --path ${CONSUL_PATH} --destination $CONF_DIR $RUNTIME_ARGUMENTS
else
   call-next-plugin "$@"
fi
