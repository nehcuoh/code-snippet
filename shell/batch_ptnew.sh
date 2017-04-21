#!/bin/bash
if  [ "$1"x == "x" ] || [ $1 -le 10 ]; then
    echo "err: file count < 10"
    exit;
fi
for(( i=10; i<$1; i++)) do
    touch /tmp/pantao/a"$i".log
    ./pttouch.sh a$i /tmp/pantao/a"$i".log
done
