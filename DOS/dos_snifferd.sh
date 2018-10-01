#!/bin/bash -e

#import functions and definitions
source functions.sh
dos_detetction_runtime=40




while :; do
	# listen to packets and collect data
	sudo timeout $dos_detetction_runtime tcpdump -nnq -i ens33  "tcp[tcpflags] & (tcp-syn) != 0" > $syn_file & # count SYN packets
	sudo timeout $dos_detetction_runtime tcpdump -nnq -i ens33  "tcp[tcpflags] & (tcp-fin) != 0" > $fin_file & # count FIN packets
	sleep $dos_detetction_runtime

	#count lines for producing ratio of SYN/FIN packets
	syns=$(cat $syn_file | wc -l)
	fins=$(cat $fin_file | wc -l)
	echo "SYNS $syns, FINS $fins"
    if [ $syns -eq "0" ]; then 
        syns=1 
    fi;
    if [ $fins -eq "0" ]; then 
        fins=1 
    fi;



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
		# no DOS attack detected, add current ratio to DB
		echo "intruder"
        convert_ip_lists $syn_file $fin_file
        detect_intruder_ip
        block_ip $last_intruder_ip
        echo "intruder blocked!"
        else
                    echo "OK"
	fi;

done;
