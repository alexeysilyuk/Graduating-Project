#!/bin/bash

source $CONF_WD/"arpsniffer.conf"
sudo python2 $wd/Sniffer_analyzer.py > logs.log &

