#!/bin/bash
outFile="out.txt"
NETMASK="192.168.4.0/24"
timeoutTime=60
packetsAmount=50

while : 
do
	sudo timeout $timeoutTime tcpdump -nnq -i wlan0 -c $packetsAmount dst net $NETMASK and 'tcp[tcpflags] == tcp-syn or tcp[tcpflags] == tcp-ack' 2>> /dev/null  > $outFile
	lines=$(wc -l $outFile | awk '{print $1}')
	if [ "$lines" != "1" ] 
	then
		cat $outFile | awk '{print $3}' | awk -F '.' '{print  $1"."$2"."$3"."$4 " make Dos attack"}' | sort -u
	fi;
	
done;
