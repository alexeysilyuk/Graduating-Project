#!/bin/bash
blocked_list="blocked.txt"
updated_list="updated_blocks.txt"
 if [ -f $updated_list ]; then
     rm $updated_list
     fi;

touch $updated_list
 if [ ! -f $blocked_list ]   ;then
     echo "There are no blocked ip's list"
     exit 1
     fi;
for i in $(cat $blocked_list); do
        ip="${i#*:}"
        echo $ip
        time_stamp="${i%:*}"
        echo $time_stamp
        new_timestamp=$(($time_stamp + 600))
        current_timestamp=$(date  +%s)

        if [ $current_timestamp -gt $new_timestamp ]; then
                echo "remove $ip from iptables block"
                sudo iptables -D INPUT -s $ip -j DROP 2>> /dev/null
        else
                echo "will expire in $((600- $(($current_timestamp-$time_stamp)))) seconds"
                echo $i >> $updated_list
        fi;
done

echo "rewriting blocked.txt"
if [ -f $updated_list ]; then
        mv $updated_list $blocked_list
fi;

