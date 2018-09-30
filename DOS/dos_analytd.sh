#!/bin/bash -e

#import functions and definitions
source functions.sh

#while :; do


# listen to packets and collect data
timeout $runtime tcpdump -nnq -i ens33  "tcp[tcpflags] & (tcp-syn) != 0" > $synfile & # count SYN packets
timeout $runtime tcpdump -nnq -i ens33  "tcp[tcpflags] & (tcp-fin) != 0" > $finfile & # count FIN packets
sleep $runtime

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
if (( $(echo "$ratio > $max_allowed_ratio" |bc -l) )) ;then
	# potential DOS attack detected
	echo "$ratio greter than $max_allowed_ratio"
	echo "potential intruder!"
	#create list of ip's for future detecting intruders
	convert_ip_lists

else	
	# no DOS attack detected, add current ratio to DB
	echo "adding $ratio to DB"
	add_record $ratio
fi;

#done;

