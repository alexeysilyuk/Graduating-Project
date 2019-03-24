#/bin/bash
for i in $(cat blocked.txt); do
	ip="${i##*|}"
  	echo $ip
	time_stamp="${i%%|*}"
	echo $time_stamp
 done
