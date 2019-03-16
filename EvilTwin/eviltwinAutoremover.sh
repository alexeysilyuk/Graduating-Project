#!/bin/bash
source ./config.conf


while :; do


for line in `cat $log_file`; do 

	# parse line
	timestamp=$(echo $line | awk -F '|' '{ print $1 }')
	date=$(echo $line | awk -F '|' '{ print $2 }')
	time=$(echo $line | awk -F '|' '{ print $3 }')
	mac=$(echo $line | awk -F '|' '{ print $4 }')

	# create variables with for comparison timestamps
	current_timestamp=$(date +%s)
	new_timestamp=$(($timestamp + $delete_intruder_timeout_seconds))

	# in case of time over, remove old detected intruder from file
	if [ $current_timestamp -gt $new_timestamp ]; then
		sed -i '/'"$line"'/d'  $log_file
	fi
 done

sleep 60
done
