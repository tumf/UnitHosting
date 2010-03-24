#!/bin/bash
#symfony base
curl http://github.com/tumf/UnitHosting/raw/master/symfony-base.sh|bash

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

# uhuserのホームにパスワードファイルを置く
password=`cat /dev/urandom |head|md5sum|cut -d ' ' -f 1`
mkdir -p /var/www/etc
htpasswd -s -b -c /var/www/etc/htpasswd uhuser $password
echo $password > /home/uhuser/openpne-password.txt

# メールを送る
cat | mail $OP_MAIL -s "Welcome to OpenPNE on UnitHosting" <<EOF
Hi, $OP_USER. I'm $HOSTNAME.

OpenPNE is now available.

--------------------
user: uhuser
password: $password
--------------------

I placed the password at /home/uhuser/openpne-password.txt,too.
EOF




cat > /etc/httpd/site.d/openpne.conf <<EOF
<VirtualHost *:80>
    ServerName $HOSTNAME
    ServerAdmin info@$HOSTNAME
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

/etc/init.d/httpd reload

# cronの設定
cat | crontab <<EOF
00 6 * * * root sh /var/www/sites/OpenPNE3/bin/send_daily_news.cron /var/www/sites/OpenPNE3 /usr/bin/php
00 6 * * * root sh /var/www/sites/OpenPNE3/bin/birthday_mail.cron /var/www/sites/OpenPNE3 /usr/bin/php
EOF


