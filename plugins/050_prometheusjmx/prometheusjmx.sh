#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "true" == "$PROMETHEUSJMX_ENABLED" ]; then
  plugin-is-active "Prometheus JMX exporter"
  EXPORTER_FILE="/tmp/jmxpromo.jar"
  if [ ! -f "$EXPORTER_FILE" ]; then
     wget https://kv.anzix.net/jmxpromo.jar -O $EXPORTER_FILE
  fi
  export AGENT_STRING="-javaagent:$EXPORTER_FILE=$PROMETHEUSJMX_AGENTOPTS"

call-next-plugin "$@"
