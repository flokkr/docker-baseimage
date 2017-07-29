#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ "true" == "$ENVTOCONF_ENABLED" ] || [ "$CONFIG_TYPE" == "simple" ]; then
   $DIR/envtoconf --outputdir $CONF_DIR $@
fi

shift 1
source ./plugins/$1/${1:4}.sh
