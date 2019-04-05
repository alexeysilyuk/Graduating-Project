#!/bin/bash

source $CONF_WD/"system_vars.sh"
wd="/home/pi/safewifi"
attack_type=$1
message=$2
echo  "sudo python2.7 $wd/emailer.py -t $attack_type -d $message -e $ADMIN_EMAIL"

sudo python2.7 $wd/emailer.py -t $attack_type -d $message -e $ADMIN_EMAIL
