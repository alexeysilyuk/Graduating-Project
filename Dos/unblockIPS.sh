#!/bin/bash
blocked_list="blocked.txt"
updated_list="updated_blocks.txt"
logFile="autoremove_log.txt"

while : ; do

 if [ -f $updated_list ]; then
     rm $updated_list
     fi;

touch $updated_list
 if [ ! -f $blocked_list ]   ;then
     echo "There are no blocked ip's list" >> $logFile
     exit 1
     fi;
for i in $(cat $blocked_list); do
	ip="${i#*:}"
	time_stamp="${i%:*}"
	new_timestamp=$(($time_stamp + 600))
	current_timestamp=$(date  +%s)

	if [ $current_timestamp -gt $new_timestamp ]; then
		echo "Remove $ip from iptables block" >> $logFile
		sudo iptables -D INPUT -s $ip -j DROP 2>> /dev/null
	else
		echo "$ip block will expire in $((600- $(($current_timestamp-$time_stamp)))) seconds" >> $logFile
		echo $i >> $updated_list
	fi;
done

if [ -f $updated_list ]; then
	mv $updated_list $blocked_list
fi;

sleep 90
done;
