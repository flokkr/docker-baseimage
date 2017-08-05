#/usr/bin/env bash
echo "======================================"
if [ -n "$RUNTIME_ARGUMENTS" ]; then
   echo "*** Launching \"$RUNTIME_ARGUMENTS\""
   eval $RUNTIME_ARGUMENTS
   EXIT_CODE=$?
   echo "Process exited with exit code $EXIT_CODE"
else
   echo "No arguments to launch"
fi
