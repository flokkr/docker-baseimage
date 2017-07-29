#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
wget https://github.com/btraceio/btrace/releases/download/v1.3.9/btrace-bin-1.3.9.tgz -O /tmp/btrace.tgz
mkdir -p $DIR/btrace
cd $DIR/btrace
export PATH=$PATH:/DIR/btrace/bin
export RUNTIME_ARGUMENTS="$RUNTIME_ARGUMENTS > /opt/output.log"
tar zxf /tmp/btrace.tgz
$DIR/btrace/bin/btracec $DIR/btrace/samples/Timers.java
