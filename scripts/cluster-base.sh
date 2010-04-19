#!/bin/bash

if [ -z $script_url ];then
    export script_url="http://github.com/tumf/UnitHosting/raw/master/scripts"
fi

# デフォルトゲートウェイの変更
/sbin/route del default gw
/sbin/route add -net default gw $LB_IP

sed -i.orig -e 's/GATEWAY=/#GATEWAY=/' /etc/sysconfig/network
echo 'GATEWAY=$LB_IP' >> /etc/sysconfig/network

#
yum upgrade -y
yum install -y git

curl $script_url/symfony-base.sh|bash








