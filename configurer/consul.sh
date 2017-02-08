#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
consul_starter --prefix conf --path ${CONSUL_KEY:-/} --destination $CONF_DIR
cat <<- END > $DIR/../custom_launcher.sh
   consul_starter --prefix conf --path ${CONSUL_KEY:-/} --destination $CONF_DIR $@
END
chmod +x $DIR/../custom_launcher.sh