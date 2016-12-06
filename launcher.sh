#!/bin/bash
CONFIG_TYPE=${BIGDATA_CONFIG_TYPE:-simple}
echo "Called launcher with command parameters: $@"
echo "Configuration type: $CONFIG_TYPE"
./configuration/$CONFIG_TYPE.sh $@
if [ -z "$1" ] ; then
   /bin/bash
else
   if [ -f "custom_launcher.sh" ] ; then
      ./custom_launcher.sh $@
   else
      $@
   fi
fi
