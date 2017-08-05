#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RETRY_NUMBER=${RETRY_NUMBER:-10}
SLEEP=10
COUNTER=$RETRY_NUMBER
RETRY_NORMAL_RUN_DURATION=${RETRY_NORMAL_RUN_DURATION:-60}
export EXIT_CODE=0
while [ $COUNTER -gt 0 ]; do
   SECONDS=0
   let COUNTER=COUNTER-1
   call-next-plugin "$@"
   if [ $SECONDS -gt $RETRY_NORMAL_RUN_DURATION ]; then
     SLEEP=10
     COUNTER=$RETRY_NUMBER
   fi
   if [ $EXIT_CODE -eq 0 ]; then
      let COUNTER=0
   else
     echo "Process has been failed (exit code: $EXIT_CODE), restarting after $SLEEP seconds... ($COUNTER/$RETRY_NUMBER)"
     sleep $SLEEP
     let SLEEP=SLEEP+10
   fi
done
