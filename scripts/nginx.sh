yum install -y pcre pcre-devel openssl openssl-devel gcc
cd /usr/src
wget http://nginx.org/download/nginx-0.9.4.tar.gz
tar xvzf nginx-0.9.4.tar.gz
cd  nginx-0.9.4
sudo /usr/sbin/adduser nginx -d /var/lib/nginx -s /sbin/nologin 

./configure \
    --user=nginx \
    --group=nginx \
    --prefix=/var/lib/nginx \
    --with-http_ssl_module \
    --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi_temp \
    --http-proxy-temp-path=/var/lib/nginx/tmp/proxy_temp \
    --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi_temp \
    --http-client-body-temp-path=/var/lib/nginx/tmp/client_body_temp \
    --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi_temp \
    --http-scgi-temp-path=/var/lib/nginx/tmp/scgi_temp 
make
make install
    
