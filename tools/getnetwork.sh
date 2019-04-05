#!/bin/bash

source $CONF_WD/"tools.conf"
tempfile="subnet.txt"

ip=$(ifconfig wlan1 | grep inet | head -n 1 | awk '{ print $2 }')

echo $ip > $wd/$tempfile
cat $wd/$tempfile
rm $tempfile

