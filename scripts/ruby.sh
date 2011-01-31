#!/bin/bash
cat <<EOF > /etc/yum.repo.d/ruby.repo
[ruby]
name=ruby
enabled=1
baseurl=http://centos.karan.org/el$releasever/ruby187/$basearch/
gpgcheck=1
gpgkey=http://centos.karan.org/RPM-GPG-KEY-karan.org.txt
EOF

yum install --enablerepo=ruby -y ruby-devel ruby ruby-irb ruby-libs ruby-rdoc
rpm -i http://centos.karan.org/el5/extras/testing/x86_64/RPMS/rubygems-1.3.1-2.el5.kb.noarch.rpm
sudo gem update --system

