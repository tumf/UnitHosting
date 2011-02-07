#!/bin/bash
cat <<EOF > /etc/yum.repos.d/kbs.repo
[kbs-CentOS-Extras]
name=kbs-CentOS-Extras
gpgcheck=0
gpgkey=http://centos.karan.org/RPM-GPG-KEY-karan.org.txt
enabled=0
baseurl=http://centos.karan.org/el\$releasever/extras/testing/\$basearch/RPMS/

[kbs-CentOS-Testing]
name=kbs-CentOS-Testing
gpgcheck=0
gpgkey=http://centos.karan.org/RPM-GPG-KEY-karan.org.txt
enabled=0
baseurl=http://centos.karan.org/el\$releasever/misc/testing/\$basearch/RPMS/
EOF

yum install --enablerepo=kbs-CentOS-Testing -y ruby ruby-irb ruby-libs ruby-rdoc ruby-devel
yum install --enablerepo=kbs-CentOS-Extras -y rubygems
# sudo gem update --system

