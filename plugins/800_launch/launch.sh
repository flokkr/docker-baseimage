#/usr/bin/env bash
set -e
echo "======================================"
if [ -n "$RUNTIME_ARGUMENTS" ]; then
   echo "*** Launching \"$RUNTIME_ARGUMENTS\""
   eval $RUNTIME_ARGUMENTS
   EXIT_CODE=$?
else
   echo "No arguments to launch"
fi
