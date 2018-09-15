#!/bin/bash
#file for exporting major variables to environment, add if you need something
export NETWORK_SUBNET="192.168.4.1/24"
export MACHINE_ID="0X123456789"
export SSID="SafeWiFi"
export WIFI_PASSPHRASE="wifipassword"
export CONFIG_PATH="/home/pi/conf/"
export DOS_PATH="/home/pi/DOS/"
exec $SHELL -i
