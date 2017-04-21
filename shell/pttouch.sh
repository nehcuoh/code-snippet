#!/bin/bash

#参数顺序
# 0path, 1interface_name, 2interface_delimiter, 3interface_field,
# 4interface_trim_chars, 5status_delimiter, 6status_field, 7status_trim_chars,
# 8invert_match[, patterns...]
#curl -s 'http://127.0.0.1:5020/action?name=add_log_conf&param=/tmp/pantao/a5.log,a5,,,,%7c,2,,0,'

added=`curl -s "http://127.0.0.1:5020/action?name=add_log_conf&param=$2,$1,,,,%7c,2,,0"` 
if [[ $added == *"ERROR"* ]]; then
  echo "err: $added"
  exit
fi
#添加一个新的log文件给pantao（需要完成上一步后进行）
curl -s "http://127.0.0.1:5020/action?name=create_service&param=file,$2,name"
echo "  $1 $2 added!\r\n"
