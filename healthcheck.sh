CONTAINER_NAME=$1
MAX_RETRY=$2
RETRY_INTERVAL=$3
if [ -z "$MAX_RETRY" ]; then
    export MAX_RETRY=50;
fi
if [ -z "$RETRY_INTERVAL" ]; then
    export RETRY_INTERVAL=1;
fi

echo "MAX_RETRY = $MAX_RETRY"
echo "RETRY_INTERVAL = $RETRY_INTERVAL"

function getContainerHealth {
  docker inspect --format "{{json .State.Health.Status }}" $1
}

function waitContainer {
  let "var=1"
  while STATUS=$(getContainerHealth $1); [ $STATUS != "\"healthy\"" ]; do 
    if [ $STATUS == "\"unhealthy\"" ]; then
        echo "STATUS=$STATUS"
        printf .
        lf=$'\n'
        sleep $RETRY_INTERVAL
        docker ps -a
        let "var=var+1"
        printf $var
        if [ "$var" -ge $MAX_RETRY ]; then
            docker logs $1
            exit 0
        fi
    fi
  done
  printf "$lf"
}
waitContainer $CONTAINER_NAME

