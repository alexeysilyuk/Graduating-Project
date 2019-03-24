#!/bin/bash

#import functions and definitions
source $CONF_WD/dos.conf
source $wd/functions.sh

# test network traffic each 5 minutes
sleep_time=300

while :; do
	# listen to packets and collect data
	sudo timeout $statistic_analyzer_runtime tcpdump -nnq -i $interface  "tcp[tcpflags] & (tcp-syn) != 0" > $wd/$synfile & # count SYN packets
	sudo timeout $statistic_analyzer_runtime tcpdump -nnq -i $interface  "tcp[tcpflags] & (tcp-fin) != 0" > $wd/$finfile & # count FIN packets
	sleep $statistic_analyzer_runtime

	#count lines for producing ratio of SYN/FIN packets
	syns=$(cat $synfile | wc -l)
	fins=$(cat $finfile | wc -l)

	if [ $syns -eq "0" ]; then
		syns=1
		fi;
	if [ $fins -eq "0" ]; then
		fins=1
		fi;


	#calculate ratio
	ratio=$(awk "BEGIN {print $syns/$fins; exit}")

	#get current ratio from database
	avg_ratio=$(sqlite3 $database_name "select avg(ratio) from $tablename where id!=$oldestID_rowID")

	#calculate current average from db * dos_attack_margin to get maximal offset from real average
	#all values over thos 
	max_allowed_ratio=$(awk "BEGIN {print $avg_ratio * $allowed_margin; exit}")

	#compare real ratio with maximal allowed
	if (( $(echo "$ratio < $max_allowed_ratio" |bc -l) )) ;then
		# no DOS attack detected, add current ratio to DB
		echo "add ratio $ratio"
		add_record $ratio
	fi;

# sleep 
sleep $sleep_time
done;

