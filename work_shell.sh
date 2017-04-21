#!/bin/sh
username="houchen"
password="asdfghjkl;'"
port="8022"
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}
host=$1
if valid_ip $host; then 
    echo "connecting to $host";
else "invalid host"; 
fi
scp -P $port $username@$host:/Users/houchen/workspace/sso-web-mobile/sso_mobile.tar.gz ./download/
sudo tar xf ./download/sso_mobile.tar.gz -C /data1/docker_user_file_houchen/www/htdocs/passport.sina.cn/
