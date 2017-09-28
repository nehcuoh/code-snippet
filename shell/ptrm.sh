#!/bin/bash
# $1 is filename will be removed.
echo -n $1" : "
curl -s "http://127.0.0.1:5020/action?name=shutdown_service&param=file,$1" 
echo ""
