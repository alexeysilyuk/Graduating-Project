#!/bin/bash

pid=$(pgrep -f dos_snifferd.sh)
sudo kill $pid 2> /dev/null
pid=$(pgrep -f  dos_analystd.sh)
sudo kill $pid 2> /dev/null
pid=$(pgrep -f  unblockIPs.sh)
sudo kill $pid 2> /dev/null

