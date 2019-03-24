#!/bin/bash

pid=$(pgrep -f eviltwinAutoRemover.sh)
sudo kill $pid 2> /dev/null
pid=$(pgrep -f  scanForTwins.sh)
sudo kill $pid 2> /dev/null




