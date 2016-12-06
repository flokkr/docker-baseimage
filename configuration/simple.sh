#!/bin/bash
function env-to-conf() {
   envname=`echo $1 | awk '{print toupper($1)}'`
   env | grep $envname |  sed -e "s/^$envname_//" | awk -F "=" '{gsub("_",".",$1);print $1 "=" $2}' >> $CONF_DIR/$1.env
   env | grep ${envname/-/_} |  sed -e "s/^${envname/-/_}_//" | awk -F "=" '{gsub("_",".",$1);print $1 "=" $2}' >> $CONF_DIR/$1.env
}

function merge() {
   cat $CONF_DIR/$1.env $DEFAULTS_DIR/$1.$2| awk -F "=" '{if (!seen[$1]++) print}' > $CONF_DIR/$1.conf
}

function env-to-cfg(){
  cp $1 $2
}
function env-to-env() {
   cp $1 $2
}

function env-to-xml() {
      echo "<configuration>" > $2
      cat $1 | awk -F "=" 'NF {print "<property><name>" $1 "</name><value>" $2 "</value></property>"}' >> $2
      echo "</configuration>" >> $2
}

function configure-from-defaults() {
   echo "Configuring file $1 with type $2"
   env-to-conf $1
   merge $1 $2
   if [ ! -f $CONF_DIR/$1.$2 ]; then
      eval env-to-$2 $CONF_DIR/$1.conf $CONF_DIR/$1.$2
   fi
}
DEFAULTS_DIR=${DEFAULTS_DIR:-defaults}
for conf in `ls -1 $DEFAULTS_DIR`; do
   configure-from-defaults ${conf%.*} ${conf##*.}
done


