yum -y install ipvsadm
sed -i.orig -e "s/net.ipv4.ip_forward = 1/net.ipv4.ip_forward = 0/g" /etc/sysctl.conf


chkconfig --add ipvsadm
chkconfig ipvsadm on
