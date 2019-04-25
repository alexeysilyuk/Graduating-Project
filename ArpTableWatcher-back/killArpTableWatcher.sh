#!/bin/bash

pid=$(pgrep -f Watcher.py)

for i in $pid; do
  sudo kill $i
  done