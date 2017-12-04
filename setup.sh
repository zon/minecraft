#!/bin/bash

apt-get update
apt-get install -y default-jdk

echo "eula=true" > /opt/minecraft/eula.txt

useradd --system -d "/opt/minecraft" minecraft
chown -R minecraft:minecraft /opt/minecraft

systemctl enable minecraft
systemctl start minecraft