#!/usr/bin/env bash

CONTAINER_NAME=$1
MAX_RETRY=$2
RETRY_INTERVAL=$3
MIN_SUCCESS_COUNT=$4
if [ -z "$MAX_RETRY" ]; then
    export MAX_RETRY=50;
fi
if [ -z "$RETRY_INTERVAL" ]; then
    export RETRY_INTERVAL=1;
fi
if [ -z "$MIN_SUCCESS_COUNT" ]; then
    export MIN_SUCCESS_COUNT=1;
fi

echo "MAX_RETRY = $MAX_RETRY"
echo "RETRY_INTERVAL = $RETRY_INTERVAL"

function getContainerHealth {
  docker inspect --format "{{json .State.Health.Status }}" $1
}

function waitContainer {
  let "var=1"
  let "successCount=1"
  while STATUS=$(getContainerHealth $1); [ $STATUS != "\"healthy\"" ]; do
    if [ $STATUS != "\"healthy\"" ]; then
        echo "$var STATUS=$STATUS" $1
#        printf .
#        lf=$'\n'
        sleep $RETRY_INTERVAL
#        docker ps -a
        let "var=var+1"
#        printf $var
        if [ "$var" -ge $MAX_RETRY ]; then
            docker logs $1
            exit 0
        fi
    fi
  done
  while STATUS=$(getContainerHealth $1); [ $STATUS = "\"healthy\"" ]; do

   echo "$var STATUS=$STATUS" $1 $successCount $MIN_SUCCESS_COUNT
   if [ "$successCount" -ge $MIN_SUCCESS_COUNT ]; then
         break;
   fi
   let "successCount=successCount+1"
   sleep $RETRY_INTERVAL

  done
  echo "$var STATUS=$STATUS" $1
  docker ps -a

  printf "$lf"
}
waitContainer $CONTAINER_NAME
