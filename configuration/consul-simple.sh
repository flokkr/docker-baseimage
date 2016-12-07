#!/bin/bash


DEST=/tmp/consul-template.json
PREFIX=${CONSUL_PREFIX:-conf}
CONSUL_SERVER=${CONSUL_SERVER:-127.0.0.1:8500}
function generate-template() {
   DEFAULTS_DIR=${DEFAULTS_DIR:-defaults}
   echo "consul = \"$CONSUL_SERVER\"" > $DEST
   for conf in `ls -1 $DEFAULTS_DIR`; do
      echo "template{" >> $DEST
      echo "   source=\"/tmp/$conf.template\"" >> $DEST
      echo "{{key \"$PREFIX/$conf\"}}" > /tmp/$conf.template
      echo "   destination=\"$CONF_DIR/$conf\"" >> $DEST
      echo "}" >> $DEST
   done
   echo "exec {" >> $DEST
   echo "   command = \"$@\"" >> $DEST 
   echo "}" >> $DEST
}

function generate-starter(){
   echo "consul-template -config=/tmp/consul-template.json" > /opt/custom_launcher.sh
   chmod +x /opt/custom_launcher.sh
}
generate-template $@
generate-starter
