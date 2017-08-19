#!/bin/bash
#batch_mv <end_file_name>
if  [ "$1"x == "x" ] || [ $1 -le 10 ]; then
    echo "err: file count < 10"
    exit;
fi
#向前移动还是向后移动文件名
op=$2
if [ "$op"x == "+"x ]; then
    # $1 表示最大文件是几
    for(( i=$1; i>=10; i--)) do
        k=$(( $i+1 ))
        mv /tmp/pantao/a$i.log /tmp/pantao/a$k.log
    done
else
    for(( i=10; i<=$1; i++)) do
        k=$(( $i-1 ))
        mv /tmp/pantao/a$i.log /tmp/pantao/a$k.log
    done
fi
