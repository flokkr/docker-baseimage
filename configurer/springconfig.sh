#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/conversions.sh


function configure() {
   NAME=${1%.*}
   EXT=${1##*.}
   SAFENAME=${NAME/-/_}
   echo "Downloading $1 config file"
   TEMPFILE=$CONF_DIR/$NAME.$EXT.env
   curl -s $CONFIG_SERVER_URL/$SAFENAME-$CONFIG_GROUP.properties | awk -F: '{ st = index($0,":");print $1 "=" substr($0,st+2)}' > $TEMPFILE
   eval env-to-$EXT $TEMPFILE $CONF_DIR/$NAME.$EXT
}


CONFIG_SERVER_URL=${CONFIG_SERVER_URL:-http://localhost:8888}
CONFIG_GROUP=${CONFIG_GROUP:-default}
#CONF_DIR
for conffile in $(curl -s $CONFIG_SERVER_URL/bigdata-$CONFIG_GROUP.json | jq -r ".configfiles.$CONFIG_GROUP | . as \$a | keys[] | . + \".\" + \$a[.]"); do
   configure $conffile
done
