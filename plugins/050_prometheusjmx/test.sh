#!/usr/bin/env bash

plugin-is-active() {
  echo "===== Plugin is activated $1 ====="
}
call-next-plugin() {
  java $APP_JAVA_OPTS -cp . Test 
}

export JAVA_OPTS_VAR="APP_JAVA_OPTS"
export PROMETHEUSJMX_ENABLED=true
export CONF_DIR=/tmp
source prometheusjmx.sh
