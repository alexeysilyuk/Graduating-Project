#!/bin/bash
blocked_list="blocked.txt"
updated_list="updated_blocks.txt"
logFile="autoremove_log.txt"

#repeat forever loop
while : ; do

#clear old updated_list
 if [ -f $updated_list ]; then
     rm $updated_list
     fi;
#create empty one
touch $updated_list

#if blocked.txt file not exists, exit
 if [ ! -f $blocked_list ]   ;then
     echo "There are no blocked ip's list" >> $logFile
     exit 1
     fi;
 
#run over list with blocked ip's    
for i in $(cat $blocked_list); do
	ip="${i#*:}"
	time_stamp="${i%:*}"
	new_timestamp=$(($time_stamp + 600))
	current_timestamp=$(date  +%s)
	
	#check if pass 10 minutes after ip been blocked
	if [ $current_timestamp -gt $new_timestamp ]; then
		#remove it from iptables
		echo "Remove $ip from iptables block" >> $logFile
		sudo iptables -D INPUT -s $ip -j DROP 2>> /dev/null
	else
		#if not, write this entry to updated_list, that been checked in next iteration
		echo "$ip block will expire in $((600- $(($current_timestamp-$time_stamp)))) seconds" >> $logFile
		echo $i >> $updated_list
	fi;
done

#rewrite blocked.txt file with new created one with updated_list
if [ -f $updated_list ]; then
	mv $updated_list $blocked_list
fi;

sleep 300 #sleep 5 minutes between each try
done;
