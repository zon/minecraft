#!/bin/bash

ufw allow ssh/tcp
ufw allow 25565/tcp
ufw --force enable

apt-get update
apt-get install -y default-jdk awscli

echo "eula=true" > /opt/minecraft/eula.txt

useradd --system -d "/opt/minecraft" minecraft
chown -R minecraft:minecraft /opt/minecraft

systemctl enable minecraft
systemctl start minecraft
systemctl enable minecraft-backup
systemctl start minecraft-backup