#!/bin/bash

pid=$(pgrep -f safesurf.py)

for i in $pid; do
  sudo kill $i
  done