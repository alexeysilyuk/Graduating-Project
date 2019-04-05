#!/bin/bash

source $CONF_WD/"tools.conf"
tempfile="ssid.txt"

ssid=$(cat /etc/hostapd/hostapd.conf | grep "ssid=" | head -n 1 | awk -F '=' '{ print $2 }')
echo $ssid > $wd/$tempfile
cat $wd/$tempfile
rm $tempfile

