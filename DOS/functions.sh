#!/bin/bash -e

# definitions
# global
interface="ens33"
runtime=60

#dos statistics
database_name="$database_name"
tablename="tcpdump"
max_records=50      # maximum of values to save
oldestID_rowID=9999 # holds index of oldest test cell to be replaced if no more place
allowed_margin=10

# output files

synfile="syn.txt"
finfile="fin.txt"
syn_ips="syn_ips.txt"
fin_ips="fin_ips.txt"


# convert tcpump log to 2 lists of ip's, ip's of SYN senders and ip's of FIN receiver
convert_ip_lists(){
	rm $syn_ips 2> /dev/null
	rm $fin_ips 2> /dev/null
	cat $synfile | awk '{print $3}' | awk -F '.' '{print  $1"."$2"."$3"."$4 }' > $syn_ips
	cat $finfile | awk '{print $5}' | awk -F '.' '{print  $1"."$2"."$3"."$4 }' > $fin_ips
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
