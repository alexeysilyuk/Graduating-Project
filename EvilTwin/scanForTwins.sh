#!/bin/bash

source $CONF_WD/eviltwin.conf
function sendEmail(){
	python2.7 $WD/emailer.py  -t EvilTwin -d "intruder mac is: $1"
}

# detection loop
while :; do

  #get amount of networks with name $SSID, that declares WIFI SSID
  num_of_nets=$(sudo iwlist wlan0 scan | grep "SID" | awk -F ':' '{print $2}' | grep $SSID | wc -l)
  if [ "$num_of_nets" != "$max_networks" ] ; then
    $wd/eviltwin_prober.sh > $probes_files
    results=$(cat $probes_files | grep $SSID | awk '{ print $1 }' )
  
   for mac in $results; do
        if [ $mac != $my_mac ]; then
          is_exists=$(cat $log_file 2> /dev/null | awk  '{print $3}' | grep $mac | wc -l)
          if [ $is_exists = "0" ];then 
            echo $(date +%s"|"%d.%m.%y"|"%H:%M:%S)"|"$mac >> $log_file
		#sendEmail $mac
            fi
          fi
      done
  fi
  
  
  sleep 60
done;
