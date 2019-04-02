#!/usr/bin/env sh

CONFIG_FILE='.npmwdrc'

if [ -f $CONFIG_FILE ]; then
    NODE_VERSION=`cat $CONFIG_FILE`
fi

if [ -z $NODE_VERSION ]; then
    echo "Node version not specfied. Exiting."
    exit 1
fi

VERSION_1=`echo $NODE_VERSION | cut -d: -f1 -`
VERSION_2=`echo $NODE_VERSION | cut -d: -f2 -s -`
if [ -z $VERSION_2 ]; then
    IMAGE_VERSION=node:$VERSION_1
else
    IMAGE_VERSION=$VERSION_1:$VERSION_2
fi

CURRENT_USER_ID=`id -u`
CURRENT_GROUP_ID=`id -g`

docker run -v "$PWD":/usr/src/app -w /usr/src/app --user $CURRENT_USER_ID:$CURRENT_GROUP_ID $IMAGE_VERSION npm "$@"