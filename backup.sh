#!/bin/bash

WORLD="world"
DATE=`date +%Y-%m-%d`
ARCHIVE="$WORLD-$DATE.tar.gz"
BUCKET="minecraft-worlds"

systemctl stop minecraft
tar -czf $ARCHIVE $WORLD ${WORLD}_nether ${WORLD}_the_end
systemctl start minecraft

aws s3 cp $ARCHIVE s3://$BUCKET/

rm $ARCHIVE