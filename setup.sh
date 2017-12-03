#!/bin/bash

apt-get update
apt-get install -y default-jdk

mkdir /opt/minecraft

cd /opt/minecraft

wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
git config --global --unset core.autocrlf
java -jar BuildTools.jar

groupadd --system minecraft
useradd --system -g minecraft -d "/opt/minecraft" minecraft

chown -R minecraft:minecraft /opt/minecraft

systemctl enable minecraft