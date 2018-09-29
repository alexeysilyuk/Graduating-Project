#!/bin/bash

db="tcpdump"
max_records=20
oldestID_rowID=9999
interface=ens33


add_record () {
	ids=$(sqlite3 statistics.db "select count(id) from tcpdump")
	if [ $ids -ge $max_records ] ; then
		add_index=$(sqlite3 statistics.db "select ratio from tcpdump where id=$oldestID_rowID")

		if [ ${add_index%.*} -gt $max_records ]; then
			add_index=1
		fi;


		echo "update value $1 to db with id ${add_index%.*}"
		sqlite3 statistics.db "update tcpdump set ratio = $1 where id=${add_index%.*}"
		sqlite3 statistics.db "update tcpdump set ratio = $((${add_index%.*}+1)) where id=$oldestID_rowID"
	else
		max_record=$(sqlite3 statistics.db "select max(id) from tcpdump where id!= $oldestID_rowID")
		sqlite3 statistics.db "insert into tcpdump values ($(($max_record+1)),$1)"
	fi; 
}

${add_index%.*}

timeout 90 tcpdump -i ens33 "tcp[tcpflags] & (tcp-syn) != 0" > syn.txt &
timeout 90 tcpdump -i ens33 "tcp[tcpflags] & (tcp-fin) != 0" > fin.txt &
sleep 91

syns=$(cat syn.txt | wc -l)
fins=$(cat fin.txt | wc -l)
ratio=$(awk "BEGIN {print $syns/$fins; exit}")

echo "$syns syns"
echo "$fins fins"
echo "raion is $ratio"

add_record $ratio



#while :; do







#done
