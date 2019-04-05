#!/bin/bash

tempfile="adminemail.txt"
source $CONF_WD/"tools.conf"
source $CONF_WD/"system_vars.sh"

echo $ADMIN_EMAIL  >  $wd/$tempfile
cat $wd/$tempfile
rm $wd/$tempfile
