#!/bin/bash
export script_url="http://github.com/tumf/UnitHosting/raw/divtest"
curl $script_url/openpne.sh|bash 2>&1 >> /root/post-install.log
