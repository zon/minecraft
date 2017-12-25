#/bin/bash

set -e

rm -rf build
mkdir -p build/systemd

docker build -t spigot .

CONTAINER=`docker create spigot`

docker cp $CONTAINER:/root/spigot.jar build/spigot.jar

docker rm $CONTAINER

cp server.properties build/server.properties
cp backup.sh build/backup.sh

cp -r systemd build/