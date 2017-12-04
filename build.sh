#/bin/bash

docker build -t spigot .

CONTAINER=`docker create spigot`

docker cp $CONTAINER:/root/spigot.jar spigot.jar

docker rm $CONTAINER