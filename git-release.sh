#!/usr/bin/env bash

git diff-index --quiet HEAD
if [ $? -eq 1 ]; then
    echo "You has uncommitted changes"
    exit
fi

echo "<?php" > src/Classes.php
echo "/* Automatic generate. Don't edit manually */" >> src/Classes.php
find src -iname *.php -type f | sed 's#src\/##g'\
| while read php; do
    echo "require_once '$php';" >> src/Classes.php
done;

version=`git rev-parse HEAD`
sed  -i '' "/VERSION/ s/\"\([^\"]*\)\"/\"${version:1:8}\"/" src/Config.php
git commit -a -m "RELEASE ${version:1:8}"

