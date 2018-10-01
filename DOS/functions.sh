#!/bin/bash -e

source defs.conf

# convert tcpump log to 2 lists of ip's, ip's of SYN senders and ip's of FIN receiver
convert_ip_lists(){
	cat $syn_file | awk '{print $3}' | awk -F '.' '{print  $1"."$2"."$3"."$4 }' > $syn_ips
	cat $fin_file | awk '{print $5}' | awk -F '.' '{print  $1"."$2"."$3"."$4 }' > $fin_ips
}

# adding new ratio record to DB
add_record () {
	ids=$(sqlite3 $database_name "select count(id) from $tablename")
	if [ $ids -ge $max_records ] ; then
		add_index=$(sqlite3 $database_name "select ratio from $tablename where id=$oldestID_rowID")

		if [ ${add_index%.*} -gt $max_records ]; then
			add_index=1
		fi;

		sqlite3 $database_name "update $tablename set ratio = $1 where id=${add_index%.*}"
		sqlite3 $database_name "update $tablename set ratio = $((${add_index%.*}+1)) where id=$oldestID_rowID"
	else
		max_record=$(sqlite3 $database_name "select max(id) from $tablename where id!= $oldestID_rowID")
		sqlite3 $database_name "insert into $tablename values ($(($max_record+1)),$1)"
	fi; 
}


detect_intruder_ip(){

echo "detected intruder ip:"

intruder_ip=$(cat $syn_ips | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2 }')
echo $intruder_ip
last_intruder_ip=$intruder_ip

}



block_ip(){
    echo "trying to block $1"
    #check if this ip already in block list
    sudo iptables -C INPUT -s $1 -j DROP #2>> /dev/null
    ip_already_blocked=$?
    echo " ip already blocked : $ip_already_blocked"

    host_name=$(host $1 | awk '{print $5}' | awk -F '.' '{print $1}')
    echo "hostname : $host_name"

    #if not in iptables rules to be DROPen, add rule nd write log
    if [ $ip_already_blocked -eq 1 ];then
        echo "inside if"
        sudo iptables -A INPUT -s $1 -j DROP

        echo "$(date +%D" "%H:%M:%S) : New attack from [ $host_name, $1 ], create new DROP rule in iptables" >> $logFile
        
        #add ip to files with blocked ip's for futer unblocking
        echo "$(date +%s):$1 " >> $blocked_ips
    else
        echo "inside else"
        #if ip already blocked, just write to log
        echo "$(date +%D" "%H:%M:%S) : Dos attack from [ $host_name, $1 ] " >> $logFile
    fi;
}