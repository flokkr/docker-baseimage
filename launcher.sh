#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export CONFIG_TYPE="simple"
export ENABLED_PLUGINS="envtoconf launcher"
export RUNTIME_ARGUMENTS="$@"
echo "Enabled plugins: "
for ENABLED_PLUGIN in $(echo $ENABLED_PLUGINS); do
   echo "  * ${ENABLED_PLUGIN}"
   declare -x ${ENABLED_PLUGIN^^}_ENABLED=true
done
echo ""
source $DIR/plugins/010_envtoconf/envtoconf.sh $(ls -1 plugins | sort);
