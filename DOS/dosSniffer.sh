#!/bin/bash
outFile="out.txt"			#temp output file
NETMASK="192.168.4.0/24"		#subnet mask
blocked_ips="blocked.txt"		#file with blocked ip's and blocking timestamp
timeoutTime=60				#run check if 60 seconds to detect DOS attack
packetsAmount=50			#amount of packet to be sure in DOS attack
logFile="log.txt"

if [ -f $logFile ]; then
	rm $logFile
fi;

touch $blocked_ips
#run forever loop
while : ;
do
	
	#run tcpdump with timer and determine syn and ack packets, catch 50 packets ( it's not ok to send 50 syn packets in 1 minute )
	sudo timeout $timeoutTime tcpdump -nnq -i wlan0 -c $packetsAmount dst net $NETMASK and 'tcp[tcpflags] == tcp-syn or tcp[tcpflags] == tcp-ack' 2>> /dev/null  > $outFile
	lines=$(wc -l $outFile | awk '{print $1}')
	
	#summarize lines in file, empty file should exist 1 line if DOS not detected, otherwise detected DOS attack
	if [ "$lines" != "1" ] ;then
		#determine attacking machine's ip 
		attacker_ip=$(cat $outFile | awk '{print $3}' | awk -F '.' '{print  $1"."$2"."$3"."$4 }' | sort -u)
		
		#check if this ip already in block list
		sudo iptables -C INPUT -s $attacker_ip -j DROP 2>> /dev/null
		ip_already_blocked=$?

		host_name=$(host $attacker_ip | awk '{print $5}' | awk -F '.' '{print $1}')

		#if not in iptables rules to be DROPen, add rule nd write log
		if [ $ip_already_blocked -eq 1 ];then
			sudo iptables -A INPUT -s $attacker_ip -j DROP

			echo "$(date +%D" "%H:%M:%S) : New attack from [ $host_name, $attacker_ip ], create new DROP rule in iptables" >> $logFile
			
			#add ip to files with blocked ip's for futer unblocking
			echo "$(date +%s):$attacker_ip " >> $blocked_ips
		else
			#if ip already blocked, just write to log
			echo "$(date +%D" "%H:%M:%S) : Dos attack from [ $host_name, $attacker_ip ] " >> $logFile
		fi;
		
	fi;
	
done;