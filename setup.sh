#!/bin/bash

set -e

BUILD_DIR="/home/ubuntu/build"
MINECRAFT_HOME="/opt/minecraft"
BUILD_SYSTEMD="$BUILD_DIR/systemd"
ETC_SYSTEMD="/etc/systemd/system"

sudo mkdir $MINECRAFT_HOME

sudo cp $BUILD_DIR/spigot.jar $MINECRAFT_HOME/spigot.jar
sudo cp $BUILD_DIR/server.properties $MINECRAFT_HOME/server.properties
# sudo cp $BUILD_DIR/backup.sh $MINECRAFT_HOME/backup.sh
sudo sh -c 'echo "eula=true" > $MINECRAFT_HOME/eula.txt'

sudo cp $BUILD_SYSTEMD/minecraft.service $ETC_SYSTEMD/minecraft.service
# sudo cp $BUILD_SYSTEMD/minecraft-backup.service $ETC_SYSTEMD/minecraft-backup.service
# sudo cp $BUILD_SYSTEMD/minecraft-backup.timer $ETC_SYSTEMD/minecraft-backup.timer

sudo rm -rf $BUILD_DIR

sudo apt-get update
sudo apt-get install -y default-jdk awscli

sudo useradd --system -d "/opt/minecraft" minecraft
sudo chown -R minecraft:minecraft $MINECRAFT_HOME

sudo systemctl enable minecraft
sudo systemctl start minecraft
# sudo systemctl enable minecraft-backup
# sudo systemctl start minecraft-backup

sudo ufw allow ssh/tcp
sudo ufw allow 25565/tcp
sudo ufw --force enable