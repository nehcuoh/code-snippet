#!/bin/bash
modifies=`git diff --name-only`

modified_cnt=0
for f in $modifies
do
    if [ -s $f ];then
        modified_cnt=$(($modified_cnt+1))
    else
        echo "errors: $f";
        exit;
    fi
done

echo "$modified_cnt files modified";


if [ -e sso_security.tar.gz  ];then
    rm -fr sso_security.tar.gz
fi
test -e sso_security.tar.gz && rm -fr sso_security.tar.gz
tar czf sso_security.tar.gz $modifies
echo "done"
