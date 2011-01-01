#!/bin/bash

if [ -z $script_url ];then
    export script_url="http://github.com/tumf/UnitHosting/raw/master/scripts"
fi


/sbin/route del default
/sbin/route add -net default gw 10.10.11.78
sed -i.orig -e 's/GATEWAY=/#GATEWAY=/' /etc/sysconfig/network
echo 'GATEWAY=10.10.11.78' >> /etc/sysconfig/network


# デフォルトゲートウェイの変更
/sbin/route del default
/sbin/route add -net default gw $LB_IP

sed -i.orig -e 's/GATEWAY=/#GATEWAY=/' /etc/sysconfig/network
echo 'GATEWAY=$LB_IP' >> /etc/sysconfig/network

/sbin/chkconfig --list|perl -anle '`/sbin/chkconfig --del $F[0]` unless $F[0]=~m/^(atd|crond|iptables|network|postfix|snmpd|snmptrapd|sshd|syslog|sysstat|xe-linux-distribution|kudzu)$/;'


#
yum upgrade -y
yum install -y git

curl $script_url/symfony-base.sh|bash








