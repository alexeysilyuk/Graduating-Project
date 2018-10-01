#!/bin/bash
blocked_list="blocked.txt"
updated_list="updated_blocks.txt"
logFile="log.txt"
unblockIPs_sleep_time=90

if [ -f $logFile ]; then
	rm $logFile
fi;

while : ; do

 if [ -f $updated_list ]; then
     rm $updated_list
     fi;

touch $updated_list
 while [ ! -f $blocked_list ]   ;do
     echo "UnblockIP.sh: There are no blocked ip's list" >> $logFile
     sleep $unblockIPs_sleep_time
     done;
for i in $(cat $blocked_list); do
	ip="${i#*:}"
	time_stamp="${i%:*}"
	new_timestamp=$(($time_stamp + 600))
	current_timestamp=$(date  +%s)

	if [ $current_timestamp -gt $new_timestamp ]; then
		echo "(date +%D" "%H:%M:%S): UnblockIP.sh: Remove $ip from iptables block" >> $logFile
		sudo ipset del blacklist $ip
	else
		echo "(date +%D" "%H:%M:%S): UnblockIP.sh: $ip block will expire in $((600- $(($current_timestamp-$time_stamp)))) seconds" >> $logFile
		echo $i >> $updated_list
	fi;
done

if [ -f $updated_list ]; then
	mv $updated_list $blocked_list
fi;

sleep $unblockIPs_sleep_time
done;
