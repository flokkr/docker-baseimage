#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_TYPE=${CONFIG_TYPE:-simple}
CONIG_SCRIPT_DIR=$DIR/configurer
LAUNCHER=${@:-/bin/bash}
echo "Called launcher with command parameters: $LAUNCHER"
echo "Configuration type: $CONFIG_TYPE"

#Configuration
if [ -e $CONIG_SCRIPT_DIR/$CONFIG_TYPE.sh ] ; then
   $CONIG_SCRIPT_DIR/$CONFIG_TYPE.sh $@
else
  echo "No such configuration method: $CONFIG_TYPE"
fi
