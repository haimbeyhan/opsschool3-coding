#!/bin/bash

node=$1
nodeip=$(vagrant ssh "$node" -c "hostname -I | cut -d' ' -f2" | tr -d '\r')
#echo "$nodeip"
#echo "$node"
hostsline="$nodeip $node"
#echo "$hostsline"

grep -w "$node" /etc/hosts 1>/dev/null
if [ $? == 0 ]; then
	echo "found, replacing node in /etc/hosts"
 	sudo sed -i "/$node/c$hostsline" /etc/hosts
else
 	echo "adding node to /etc/hosts"
 	echo  "$hostsline" | sudo tee -a /etc/hosts
fi
