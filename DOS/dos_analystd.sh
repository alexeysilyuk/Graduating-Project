#!/bin/bash -e

#import functions and definitions
source functions.sh

# test network traffic each 5 minutes
sleep_time=300

while :; do
	# listen to packets and collect data
	timeout $statistic_analyzer_runtime tcpdump -nnq -i ens33  "tcp[tcpflags] & (tcp-syn) != 0" > $synfile & # count SYN packets
	timeout $statistic_analyzer_runtime tcpdump -nnq -i ens33  "tcp[tcpflags] & (tcp-fin) != 0" > $finfile & # count FIN packets
	sleep $statistic_analyzer_runtime

	#count lines for producing ratio of SYN/FIN packets
	syns=$(cat $synfile | wc -l)
	fins=$(cat $finfile | wc -l)
	echo "SYNS $syns, FINS $fins"

	#calculate ratio
	ratio=$(awk "BEGIN {print $syns/$fins; exit}")
	echo "RATIO: $ratio"

	#get current ratio from database
	avg_ratio=$(sqlite3 $database_name "select avg(ratio) from $tablename where id!=$oldestID_rowID")

	#calculate current average from db * dos_attack_margin to get maximal offset from real average
	#all values over thos 
	max_allowed_ratio=$(awk "BEGIN {print $avg_ratio * $allowed_margin; exit}")
	echo "Maximal available ratio: $max_allowed_ratio"


	#compare real ratio with maximal allowed
	if (( $(echo "$ratio < $max_allowed_ratio" |bc -l) )) ;then
		# no DOS attack detected, add current ratio to DB
		add_record $ratio
	fi;

# sleep 
sleep $sleep_time
done;

