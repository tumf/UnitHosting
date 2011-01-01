yum -y install ipvsadm
sed -i.orig -e "s/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g" /etc/sysctl.conf
/sbin/sysctl -p

chkconfig --add ipvsadm
chkconfig ipvsadm on
