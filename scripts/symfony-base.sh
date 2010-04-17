#!/bin/bash
if [ -z $script_url ];then
    export script_url="http://github.com/tumf/UnitHosting/raw/master/scripts"
fi

#symfony base
curl $script_url/common.sh|bash
curl $script_url/mysql.sh|bash
curl $script_url/apache-php.sh|bash


# install symfony
pear channel-discover pear.symfony-project.com
pear install symfony/symfony

