
yum install -y pcre pcre-devel openssl openssl-devel gcc
cd /usr/src
wget http://nginx.org/download/nginx-0.9.4.tar.gz
tar xvzf nginx-0.9.4.tar.gz
cd  nginx-0.9.4
./configure \
    --prefix=/var/lib/nginx \
    --pid-path=/var/lib/nginx/run \
    --lock-path=/var/lib/nginx/run \
    --with-http_ssl_module
make install
    
