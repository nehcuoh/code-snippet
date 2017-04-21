#!/bin/bash
container="houchen"

if [ "x" != "$1"x ]; then
    container="$1"
fi

sudo docker exec -ti $container /bin/sh -c "source /etc/profile && bash"
