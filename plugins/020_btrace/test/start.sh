#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

env BTRACE_SCRIPT=com/sun/btrace/samples/Timers.class $DIR/../../../launcher.sh $DIR/runner.sh
