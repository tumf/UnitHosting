#!/bin/bash
if [ -z $script_url ];then
    export script_url="http://github.com/tumf/UnitHosting/raw/master"
fi
curl $script_url/symfony-base.sh|bash

# yum install git
yum -y install git

# OpnePNEだと対話型インストールなんで
# 勝手にforkしたバージョン使います。ごめんなさい><
cd /var/www/sites
git clone git://github.com/tumf/OpenPNE3.git
cd OpenPNE3
git checkout OpenPNE-3.4.2
git pull origin provision

cp config/ProjectConfiguration.class.php.sample config/ProjectConfiguration.class.php
cp config/OpenPNE.yml.sample config/OpenPNE.yml
sed -i.orig -e "s/example\.com/$HOSTNAME/g" config/OpenPNE.yml
./symfony openpne:install --dsn=mysql://root@localhost/openpne

# cronの設定
cat <<EOF | crontab
00 6 * * * root sh /var/www/sites/OpenPNE3/bin/send_daily_news.cron /var/www/sites/OpenPNE3 /usr/bin/php
00 6 * * * root sh /var/www/sites/OpenPNE3/bin/birthday_mail.cron /var/www/sites/OpenPNE3 /usr/bin/php
EOF

cat <<EOF > /etc/httpd/site.d/openpne.conf
<VirtualHost *:80>
    ServerName $HOSTNAME
    ServerAdmin root@$HOSTNAME
    DirectoryIndex index.php
    DocumentRoot /var/www/sites/OpenPNE3/web

    ErrorLog /var/log/httpd/$HOSTNAME-error.log
    CustomLog /var/log/httpd/$HOSTNAME-access.log combined
    Alias /sf/ "/usr/share/pear/data/symfony/web/sf/"

</VirtualHost>
<Directory "/var/www/sites/OpenPNE3/web">
    AllowOverride All
    Options +FollowSymLinks
    
    AuthUserFile /var/www/etc/htpasswd
    AuthGroupFile /dev/null
    AuthType Basic
    AuthName "Please Enter Your Password"
    Require valid-user
</Directory>
EOF

# global ipの取得
export GLOBAL_IP=`curl http://www.unit-hosting.com/ip.php`
# uhuserのホームにパスワードファイルを置く
password=`cat /dev/urandom |head|md5sum|head -c 8`
mkdir -p /var/www/etc
htpasswd -s -b -c /var/www/etc/htpasswd uhuser $password
echo $password > /home/uhuser/openpne-password.txt

# メールを送る
/etc/init.d/sendmail start
cat <<EOF | mail $OP_MAIL -s "Welcome to OpenPNE on UnitHosting"
Hi, $OP_USER. I'm $HOSTNAME.

OpenPNE is now available.

--------------------
user: uhuser
password: $password

IE:
http://uhuser@$GLOBAL_IP/
others:
http://uhuser:$password@$GLOBAL_IP/
 
--------------------

I placed the password at /home/uhuser/openpne-password.txt,too.
EOF

/etc/init.d/httpd reload



