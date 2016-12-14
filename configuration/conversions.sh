#!/bin/bash








function env-to-properties(){
   cat $1 | awk -F= '{ st = index($0,"=");print $1 ": " substr($0,st+1)}' > $2
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


