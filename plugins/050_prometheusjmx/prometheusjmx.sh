#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "true" == "$PROMETHEUSJMX_ENABLED" ]; then
  plugin-is-active "Prometheus JMX exporter"
  EXPORTER_FILE="/tmp/jmx_prometheus_javaagent-0.11-SNAPSHOT.jar"
  if [ ! -f "$EXPORTER_FILE" ]; then
     wget https://kv.anzix.net/jmx_prometheus_javaagent-0.11-SNAPSHOT.jar -O $EXPORTER_FILE
  fi
  export AGENT_STRING="-javaagent:$EXPORTER_FILE=0:$CONF_DIR/config.yaml"
  if [ ! -f "$CONF_DIR/config.yaml" ]; then
     cat << EOF > $CONF_DIR/config.yaml
---
startDelaySeconds: 0
EOF
  fi
  declare -x $JAVA_OPTS_VAR="$AGENT_STRING ${!JAVA_OPTS_VAR}"
  echo "Process is instrumented with setting $AGENT_STRING"
fi

call-next-plugin "$@"
