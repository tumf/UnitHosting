#!/bin/bash
# dino yum repository
rpm -ivh http://nog.dino.co.jp/dist/centos/5/dino/noarch/dino-release-1.0-1.noarch.rpm

# DAG yum repository
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt

wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.1-1.el5.rf.x86_64.rpm
rpm -ivh rpmforge-release-0.5.1-1.el5.rf.x86_64.rpm

# yum install postfix
# yum install -y postfix

rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

