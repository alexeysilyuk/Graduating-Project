#!/bin/bash

#import functions and definitions

source $CONF_WD/dos.conf
source $wd/"functions.sh"
mkdir  $wd/"sniffer_files" 2> /dev/null


while :; do
	# listen to packets and collect data
	sudo timeout $dos_detetction_runtime tcpdump -nnq -i $interface -e "tcp[tcpflags] & (tcp-syn) != 0" > $syn_file & # count SYN packets
	sudo timeout $dos_detetction_runtime tcpdump -nnq -i $interface -e "tcp[tcpflags] & (tcp-fin) != 0" > $fin_file & # count FIN packets
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
    
	#get current ratio from database
	avg_ratio=$(sqlite3 $database_name "select avg(ratio) from $tablename where id!=$oldestID_rowID")
   echo WHAT_DA $oldestID_rowID

	#calculate current average from db * dos_attack_margin to get maximal offset from real average
	#all values over thos 
	max_allowed_ratio=$(awk "BEGIN {print $avg_ratio * $allowed_margin; exit}")

	#compare real ratio with maximal allowed
	if (( $(echo "$ratio > $max_allowed_ratio" |bc -l) )) ;then
		# no DOS attack detected, add current ratio to DB
        convert_ip_lists $syn_file $fin_file
        detect_intruder_ip
        block_ip $last_intruder_ip
        attacker_hostname=$(host $last_intruder_ip | awk '{ print $5 }')
        if [ $attacker_hostname == "3(NXDOMAIN)" ]; then 
          attacker_hostname="Fake Hostname" 
        fi
        attacked_hostname=$(host $attacked_ip | awk '{ print $5 }')
        msg=$(date +%s"|"%d.%m.%y"|"%H:%M:%S)"|"$attacker_hostname"|"$last_intruder_ip"|"$intruder_mac"|"$attacked_hostname"|"$attacked_ip"|"$attacked_mac
        echo  $msg >> $historyFile
	fi;

done;
