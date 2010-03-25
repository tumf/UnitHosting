#!/bin/bash

if [ -z $script_url ];then
    export script_url="http://github.com/tumf/UnitHosting/raw/master"
fi
curl $script_url/symfony-base.sh|bash

mysqladmin -uroot create eccube_db

cat <<EOF > /etc/httpd/site.d/eccube.conf
<VirtualHost *:80>
ServerName $HOSTNAME
ServerAdmin root@$HOSTNAME
DocumentRoot /var/www/sites/eccube-2.4.3
DirectoryIndex index.html index.php
</VirtualHost>
EOF

cd /var/www/sites/
wget http://downloads.ec-cube.net/src/eccube-2.4.3.tar.gz
tar xvzf eccube-2.4.3.tar.gz 
chmod 777 eccube-2.4.3/html/install/temp

# uhuserのホームにパスワードファイルを置く
password=`cat /dev/urandom |head|md5sum|cut -d ' ' -f 1`
mkdir -p /var/www/etc
htpasswd -s -b -c /var/www/etc/htpasswd uhuser $password
echo $password > /home/uhuser/eccube-password.txt

# メールを送る
/etc/init.d/sendmail start
cat <<EOF | mail $OP_MAIL -s "Welcome to EC-CUBE on UnitHosting"
Hi, $OP_USER. I'm $HOSTNAME.

Your EC-CUBE is now available.

--------------------
user: uhuser
password: $password

database: eccube_db
dbuser: root
dbpass: (none)
dbhost: localhost
--------------------

I placed the password at /home/uhuser/eccube-password.txt,too.
EOF

/etc/init.d/httpd reload
