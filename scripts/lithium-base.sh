# php5.3
wget http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
rpm -Uvh remi-release-5.rpm epel-release-5-4.noarch.rpm
yum -y --enablerepo=remi install php
pecl install mongo
/etc/init.d/httpd start

# mongo db
cd /usr/local/src
wget http://downloads.mongodb.org/linux/mongodb-linux-i686-1.2.2.tgz
tar zxfv mongodb-linux-i686-1.2.2.tgz

# start up mongo
mkdir /data
mkdir /data/db
# /usr/local/src/mongodb-linux-i686-1.2.2/bin/mongod
