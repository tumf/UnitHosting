#!/bin/bash
#symfony base

# dino yum repository
rpm -ivh http://nog.dino.co.jp/dist/centos/5/dino/noarch/dino-release-1.0-1.noarch.rpm

# DAG yum repository
rpm --import http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
rpm -ivh http://apt.sw.be/redhat/el5/en/i386/RPMS.dag/rpmforge-release-0.5.1-1.el5.rf.i386.rpm

# yum install httpd & php
yum -y install httpd httpd-devel php php-pear php-devel php-dom
# yum install git
yum -y git
# yum install mysql
yum -y install mysql mysql-server php-mysql
sed -i.orig -e "s/\[mysqld\]/\[mysqld\]\ndefault-character-set = utf8/" /etc/my.cnf
cat >> /etc/my.cnf <<EOF
[client]
default-character-set = utf8

[mysqldump]
default-character-set = utf8
EOF

# pear/pecl command patch
sed -e 's/16M/640M/' < /usr/bin/pear  > /usr/bin/pear-extend_memory_limit
chmod +x /usr/bin/pear-extend_memory_limit
sed -e 's/16M/640M/' < /usr/bin/pecl  > /usr/bin/pecl-extend_memory_limit
chmod +x /usr/bin/pecl-extend_memory_limit

# install symfony
pear-extend_memory_limit channel-discover pear.symfony-project.com
pear-extend_memory_limit install symfony/symfony

# install APC
# "extension=apc.so"
# pecl-extend_memory_limit install apc
# 上記のコマンドでは対話的にyesを求められるので止まってしまう yum の -y みたいなオプションが欲しい。
# expectで書くか...
# yum -y install expect

# deploy先のディレクトリを作成
sudo -u uhuser mkdir -p /var/www/symfony/projects
# sudo -u uhuser mkdir /home/uhuser/projects

# virtual host の設定
cat > /etc/httpd/conf.d/virtualhosts.conf <<EOF
NameVirtualHost *:80
Include site.d/*.conf
EOF



