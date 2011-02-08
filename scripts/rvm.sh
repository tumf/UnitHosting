#!/bin/bash
if [ -z $script_url ];then
    export script_url="http://github.com/tumf/UnitHosting/raw/master/scripts"
fi
curl -L $script_url/common.sh|bash

yum install -y git-core
yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel bison shadow-utils

bash < <( curl -L http://bit.ly/rvm-install-system-wide )
source /usr/local/lib/rvm
# echo "source /usr/local/lib/rvm" >> /root/.bash_profile

rvmsudo rvm install 1.8.7-p330
rvmsudo rvm use 1.8.7-p330

