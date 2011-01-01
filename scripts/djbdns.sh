#!/bin/sh
yum -y install gcc

mkdir -p /package
chmod 1755 /package
cd /package
wget http://cr.yp.to/djbdns/djbdns-1.05.tar.gz
tar xvzf djbdns-1.05.tar.gz
cd djbdns-1.05

patch <<EOF
diff -ur error.h error.h.orig 
--- error.h.orig 2011-01-01 10:54:33.000000000 +0900
+++ error.h 2011-01-01 10:54:12.000000000 +0900
@@ -1,7 +1,7 @@
 #ifndef ERROR_H
 #define ERROR_H
 
-extern int errno;
+#include <errno.h>
 
 extern int error_intr;
 extern int error_nomem;
EOF
make
make setup check

