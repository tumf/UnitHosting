#!/bin/bash

if [ -z $script_url ];then
    export script_url="http://github.com/tumf/UnitHosting/raw/master"
fi
curl $script_url/symfony-base.sh|bash

mysqladmin -uroot create eccube_db
mysql -uroot eccube_db <<EOF
GRANT ALL PRIVILEGES ON eccube_db.* TO eccube_db_user@localhost IDENTIFIED BY 'eccube';
FLUSH PRIVILEGES;
EOF

cat <<EOF > /etc/httpd/site.d/eccube.conf
<VirtualHost *:80>
ServerName $HOSTNAME
ServerAdmin root@$HOSTNAME
DocumentRoot /var/www/sites/eccube-2.4.3/html
DirectoryIndex index.html index.php
</VirtualHost>
<Directory "/var/www/sites/eccube-2.4.3/html">
    AllowOverride All
    Options +FollowSymLinks
    
    AuthUserFile /var/www/etc/htpasswd
    AuthGroupFile /dev/null
    AuthType Basic
    AuthName "Please Enter Your Password"
    Require valid-user
</Directory>

EOF

cd /var/www/sites/
wget http://downloads.ec-cube.net/src/eccube-2.4.3.tar.gz
tar xvzf eccube-2.4.3.tar.gz 
chmod 777 eccube-2.4.3/html/install/temp

# uhuserのホームにパスワードファイルを置く
password=`cat /dev/urandom |head|md5sum|head -c 8`
mkdir -p /var/www/etc
htpasswd -s -b -c /var/www/etc/htpasswd uhuser $password
echo $password > /home/uhuser/eccube-password.txt

# メールを送る
/etc/init.d/sendmail start
cat <<EOF | mail $OP_MAIL -s "Welcome to EC-CUBE on UnitHosting"
Hi, $OP_USER. I'm $HOSTNAME.

Your EC-CUBE is now available.

--------------------
IE
http://uhuser@$GLOBAL_IP/install/
Others
http://uhuser:$password@$GLOBAL_IP/install/

user: uhuser
password: $password

database: eccube_db
dbuser: eccube_db_user
dbpass: eccube
dbhost: localhost
--------------------

I placed the password at /home/uhuser/eccube-password.txt,too.
EOF


