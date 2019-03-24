#!/bin/bash

pid=$(pgrep -f Sniffer_analyzer.py)

for i in $pid; do
  sudo kill $i
  done