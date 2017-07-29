#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
java $JAVA_OPTS -cp $DIR Start
