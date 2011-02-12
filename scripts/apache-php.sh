#!/bin/bash
# yum install httpd & php
yum -y install httpd httpd-devel php php-pear php-devel php-dom php-mbstring php-mysql php-gd pcre pcre-devel
# install APC
yes no|pecl install apc
echo "extension=apc.so" > /etc/php.d/apc.ini

# pear/pecl command patch
sed -i.orig -e 's/16M/640M/' /usr/bin/pear
#chmod +x /usr/bin/pear-extend_memory_limit
sed -i.orig -e 's/16M/640M/' /usr/bin/pecl
# chmod +x /usr/bin/pecl-extend_memory_limit

# /etc/php.d/my.ini にオレオレ設定を書く
cat <<EOF > /etc/php.d/my.ini
memory_limit = 640M
short_open_tag = Off

[mbstring]
mbstring.language = Japanese
mbstring.internal_encoding = utf-8
EOF

/sbin/chkconfig httpd on

# deploy先のディレクトリを作成
mkdir -p /var/www/sites
chown uhuser /var/www/sites

# virtual host の設定
cat <<EOF  > /etc/httpd/conf.d/virtualhosts.conf
NameVirtualHost *:80
Include site.d/*.conf
EOF
mkdir -p /etc/httpd/site.d
