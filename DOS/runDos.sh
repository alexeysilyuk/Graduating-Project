#!/bin/bash

source $CONF_WD/dos.conf

sudo ipset create blacklist hash:ip hashsize 4096 2> /dev/null > /dev/null

nohup $wd/dos_snifferd.sh  > /dev/null 2> /dev/null &
nohup $wd/unblockIPs.sh > /dev/null 2> /dev/null &
nohup $wd/dos_analystd.sh >  /dev/null 2> /dev/null &
