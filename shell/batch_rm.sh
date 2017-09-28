#!/bin/bash

if [ "$1"x != "eachx" ]; then

    if  [ "$1"x == "x" ] || [ $1 -le 10 ]; then
        echo "err: file count < 10"
        exit;
    fi

fi

if [ "$1"x == "eachx" ]; then
    for filename in /tmp/pantao/*.log; do
        #for(( i=0; i<$2; i++ )) do 
        ./ptrm.sh $filename; 
        #done
    done
    exit;
fi 

for(( i=0; i<$1; i++ )) do 
    ./ptrm.sh /tmp/pantao/a$i.log;
done

