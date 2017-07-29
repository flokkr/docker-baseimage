#/usr/bin/env bash
set -e
if [ -n "$RUNTIME_ARGUMENTS" ]; then
   echo "*** Launching \"$RUNTIME_ARGUMENTS\""
   eval $RUNTIME_ARGUMENTS
else
   echo "No arguments to launch"
fi
