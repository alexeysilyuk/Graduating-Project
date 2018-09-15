#!/bin/bash

#get amount of networks with name $SSID, that declares WIFI SSID
num_of_nets=$(sudo iwlist wlan0 scan | grep "SID" | awk -F ':' '{print $2}' | grep $SSID | wc -l)
if [ "$num_of_nets" != "1" ] ; then
         echo "$num_of_nets networks with name \"$SSID\" were found near to you, maybe it's  Evil Twin?"
else
        echo "OK"       

fi;
