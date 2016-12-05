#!/bin/bash
CONFIG_TYPE=${BIGDATA_CONFIG_TYPE:-simple}
echo "Configuration type: $CONFIG_TYPE"
./configuration/$CONFIG_TYPE.sh
if [ -z "$1" ] ; then
   /bin/bash
else
   $1
fi
