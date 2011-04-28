#!/bin/bash
if [ -z $script_url ];then
    export script_url="https://github.com/tumf/UnitHosting/raw/master/scripts"
fi

#symfony base
curl -L $script_url/common.sh|bash
curl -L $script_url/mysql.sh|bash
curl -L $script_url/apache-php.sh|bash

#zabbix install
rpm -ivh http://www.zabbix.jp/binaries/relatedpkgs/rhel5/i386/zabbix-jp-release-5-3.noarch.rpm
alternatives --set zabbix-jp-release /usr/share/zabbix-jp-release/zabbix-jp-1.8.repo
yum clean all
yum -y install zabbix.x86_64 zabbix-agent.x86_64 zabbix-jp-release.noarch zabbix-server.x86_64 zabbix-server-mysql.x86_64 zabbix-web.x86_64 zabbix-web-mysql.x86_64
chmod o+w /etc/zabbix/zabbix.conf.php

#mysql zabbix
zabbix_version=`/usr/sbin/zabbix_server -V | cut -d" " -f3 | sed -n '1p' | sed -e "s/^v\(.*\)/\1/"`
zabbix_path="/usr/share/doc/zabbix-server-$zabbix_version"
mysqladmin -uroot create zabbix --default-character-set=utf8
cat $zabbix_path/schema/mysql.sql | mysql -uroot zabbix
cat $zabbix_path/data/data.sql | mysql -uroot zabbix
cat $zabbix_path/data/images_mysql.sql | mysql -uroot zabbix

#iptables
mv /etc/sysconfig/iptables /etc/sysconfig/iptables.orig
cat <<EOF > /etc/sysconfig/iptables
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:RH-Firewall-1-INPUT - [0:0]
-A INPUT -j RH-Firewall-1-INPUT
-A FORWARD -j RH-Firewall-1-INPUT
-A RH-Firewall-1-INPUT -i lo -j ACCEPT
-A RH-Firewall-1-INPUT -p icmp --icmp-type any -j ACCEPT
-A RH-Firewall-1-INPUT -p 50 -j ACCEPT
-A RH-Firewall-1-INPUT -p 51 -j ACCEPT
-A RH-Firewall-1-INPUT -p udp --dport 5353 -d 224.0.0.251 -j ACCEPT
-A RH-Firewall-1-INPUT -p udp -m udp --dport 631 -j ACCEPT
-A RH-Firewall-1-INPUT -p tcp -m tcp --dport 631 -j ACCEPT
-A RH-Firewall-1-INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
#-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A RH-Firewall-1-INPUT -m tcp -p tcp --dport 80 -j ACCEPT
-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
-A RH-Firewall-1-INPUT -j REJECT --reject-with icmp-host-prohibited
# zabbix
-A RH-Firewall-1-INPUT -p tcp -m tcp --dport 10050 -j ACCEPT
-A RH-Firewall-1-INPUT -p tcp -m tcp --dport 10051 -j ACCEPT
# syslog
-A RH-Firewall-1-INPUT -s 10.10.1.0/26 -i eth1 -p udp -m udp --dport 162 -j ACCEPT
-A RH-Firewall-1-INPUT -s 10.10.1.0/26 -i eth1 -p udp -m udp --dport 514 -j ACCEPT
COMMIT
EOF
/etc/init.d/iptables restart

#httpd
mv /etc/httpd/conf.d/zabbix.conf /etc/httpd/conf.d/zabbix.conf.orig
cat <<EOF > /etc/httpd/conf.d/zabbix.conf
Alias /zabbix /usr/share/zabbix

<Directory "/usr/share/zabbix">
Options FollowSymLinks
AllowOverride None
Order allow,deny
Allow from all

php_value max_execution_time 300
php_value date.timezone Asia/Tokyo
php_value post_max_size 32M
php_value max_input_time 600
</Directory>

<Directory "/usr/share/zabbix/include">
Order deny,allow
Deny from all
<files *.php>
Order deny,allow
Deny from all
</files>
</Directory>

<Directory "/usr/share/zabbix/include/classes">
Order deny,allow
Deny from all
<files *.php>
Order deny,allow
Deny from all
</files>
</Directory>
EOF
/etc/init.d/httpd restart

#zabbix start
/sbin/chkconfig zabbix-server on
/etc/init.d/zabbix-server start


#send mail
export GLOBAL_IP=`curl -L http://www.unit-hosting.com/ip.php`
zabbix_server_status=`/etc/init.d/zabbix-server status`
httpd_server_status=`/etc/init.d/httpd status`

/etc/init.d/sendmail start
cat <<EOF | mail -s "Welcome to Zabbix on UnitHosting" $OP_MAIL
Hi, $OP_USER. I'm $HOSTNAME.

Zabbix is now available.

httpd_status:  $httpd_server_status
zabbix_status: $zabbix_server_status

-------------------------
ID:   admin
Pass: zabbix

http://$GLOBAL_IP/zabbix/
-------------------------
EOF

