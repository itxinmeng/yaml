#!/bin/bash

[ $# -ne 2 ] && echo "$0 port passwd" && exit 2
port=$1
container_name=$1
passwd=$2

ip=$(curl -s cip.cc |head -1|awk '{print $3}')

passwd_base64=$( echo -n $passwd | base64 |sed 's/=//g')

docker stop $(echo $1 -5 | bc)   &>/dev/null

docker rm $(echo $1 -5 | bc)   &>/dev/null

docker run -td --restart=always -p $port:$port -e PORT=$port -e PASSWORD=$passwd --name $container_name itxinmeng/ssr-server &>/dev/null

if [ $? -eq 0 ];then
    ssr="$ip:$port:auth_aes128_sha1:aes-256-cfb:plain:$passwd_base64/?obfsparam=&remarks=eGlubWVuZw&group=eGlubWVuZy1zc3I"
    base64_ssr=$(echo -n $ssr|base64)
    link=$(echo -n $base64_ssr| sed s/[[:space:]]//g|sed s#/#_#g|sed s/+/-/g|sed 's/=//g')
    echo "ssr://$link"
else
    echo "ssr启动失败"
fi



