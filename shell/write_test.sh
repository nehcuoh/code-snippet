if [ "$1"x == "eachx" ]; then
    for filename in /tmp/pantao/*.log; do
        for(( i=0; i< $2; i++  )) do echo "test | member$i | xxx" >> $filename; done
    done
    exit;
fi 
for(( i=0; i< $2; i++  )) do echo "test | member$i | xxx" >> $1; done
