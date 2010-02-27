#!/bin/bash
#symfony base
rpm --import http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
rpm -ivh http://apt.sw.be/redhat/el5/en/i386/RPMS.dag/rpmforge-release-0.5.1-1.el5.rf.i386.rpm

yum -y install httpd httpd-devel php php-pear php-devel git

pear channel-discover pear.symfony-project.com
pear install symfony/symfony-1.4.3

mkdir -p /var/symfony-projects


