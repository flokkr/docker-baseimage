#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/consul_starter.py --prefix conf/$CONSUL_KEY --destination $CONF_DIR
cat <<- END > $DIR/../custom_launcher.sh
   $DIR/consul_starter.py --prefix conf/$CONSUL_KEY --destination $CONF_DIR $@ 
END

