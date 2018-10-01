#!/bin/bash
nohup ./unblockIPs.sh > /dev/null &
nohup ./dos_analystd.sh > /dev/null &
nohup ./dos_snifferd.sh > /dev/null &
