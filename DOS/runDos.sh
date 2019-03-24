#!/bin/bash

source $CONF_WD/dos.conf

nohup $wd/dos_snifferd.sh  > /dev/null 2> /dev/null &
nohup $wd/unblockIPs.sh > /dev/null 2> /dev/null &
nohup $wd/dos_analystd.sh >  /dev/null 2> /dev/null &
