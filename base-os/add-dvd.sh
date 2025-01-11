#!/bin/bash

for i in {1..6}; do
	echo $i
 	_dev=blkid | sed -n "/amd64 $i/p" | grep -oP '^/dev/sr[0-9]+' 
	mkdir -p /mnt/DVD$i || true 
	mount -t iso9660 -o loop $_dev /mnt/DVD$i
done
