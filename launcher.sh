#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_TYPE=${CONFIG_TYPE:-simple}
CONIG_SCRIPT_DIR=$DIR/configuration
echo "Called launcher with command parameters: $@"
echo "Configuration type: $CONFIG_TYPE"

#Configuration
if [ -e $CONIG_SCRIPT_DIR/$CONFIG_TYPE.py ] ; then
   $CONIG_SCRIPT_DIR/$CONFIG_TYPE.py $@
elif [ -e $CONIG_SCRIPT_DIR/$CONFIG_TYPE.sh ] ; then
   $CONIG_SCRIPT_DIR/$CONFIG_TYPE.sh $@
fi

#Runner
if [ -z "$1" ] ; then
   /bin/bash
elif [ -f "$DIR/custom_launcher.sh" ] ; then
   $DIR/custom_launcher.sh $@
else
   $@
fi
