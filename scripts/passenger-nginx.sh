yum install -y pcre pcre-devel openssl openssl-devel gcc
yum install -y gcc-c++ curl-devel zlib-devel

gem install passenger

cd /usr/src
wget http://nginx.org/download/nginx-0.9.4.tar.gz
tar xvzf nginx-0.9.4.tar.gz
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
    --http-scgi-temp-path=/var/lib/nginx/tmp/scgi_temp \
    --add-module='/usr/lib/ruby/gems/1.8/gems/passenger-3.0.2/ext/nginx'

make && make install
mkdir -p /var/lib/nginx/tmp
chown nginx.nginx /var/lib/nginx/tmp

cat > /var/lib/nginx/run <<EOF
#!/bin/sh
PATH=/command:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
exec /var/lib/nginx/sbin/nginx -g 'daemon off;' 2>&1
EOF

chmod +x /var/lib/nginx/run


  

