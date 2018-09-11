#!/bin/bash
outFile="out.txt"
NETMASK="192.168.4.0/24"
detected_ips="detected_intruders.txt"
blocked_ips="blocked.txt"
timeoutTime=60
packetsAmount=50

while : ;
do
	if [ -f $detected_ips ]; then
		sudo rm $detected_ips
	fi;

	sudo timeout $timeoutTime tcpdump -nnq -i wlan0 -c $packetsAmount dst net $NETMASK and 'tcp[tcpflags] == tcp-syn or tcp[tcpflags] == tcp-ack' 2>> /dev/null  > $outFile
	lines=$(wc -l $outFile | awk '{print $1}')
	if [ "$lines" != "1" ] ;then
		attacker_ip=$(cat $outFile | awk '{print $3}' | awk -F '.' '{print  $1"."$2"."$3"."$4 }' | sort -u)
		sudo iptables -C INPUT -s $attacker_ip -j DROP 2>> /dev/null
		ip_already_blocked=$?

		if [ $ip_already_blocked -eq 1 ];then
			sudo iptables -A INPUT -s $attacker_ip -j DROP
			echo "New attack from [ $attacker_ip ], create new DROP rule in iptables" >> log.txt
			echo $attacker_ip >> $blocked_ips
		else
			echo "Dos attack from [ $attacker_ip ] " >> log.txt
		fi;
		
	fi;
	
done;
