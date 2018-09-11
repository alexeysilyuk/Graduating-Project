#!/bin/bash
logFile="log.txt"
if [ -f $logFile ]; then
	sudo rm $logFile
fi;

nohup ./dosSniffer.sh > detected_intruders.txt &





