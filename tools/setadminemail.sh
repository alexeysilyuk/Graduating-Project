#!/bin/bash

wd=$CONF_WD
if [ -z $1 ];then
	echo "must provide new email"
fi;

sed -i  "s/\(ADMIN_EMAIL=\)\(.*\)/\1$1/" $wd/"system_vars.sh"

source ~/.bashrc
