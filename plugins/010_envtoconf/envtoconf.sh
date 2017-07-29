#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ "true" == "$ENVTOCONF_ENABLED" ] || [ "$CONFIG_TYPE" == "simple" ]; then
   plugin-is-active "ENVTOCONF"
   $DIR/envtoconf --outputdir $CONF_DIR $@
fi

call-next-plugin "$@"
