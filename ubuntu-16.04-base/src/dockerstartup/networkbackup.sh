#!/bin/bash

## backup /etc/{hosts,hostname,resolv.conf}
rm -rf /root/dockerstartup/networkbackup/
mkdir /root/dockerstartup/networkbackup
cp /etc/hosts /root/dockerstartup/networkbackup/
cp /etc/hostname /root/dockerstartup/networkbackup/
cp /etc/resolv.conf /root/dockerstartup/networkbackup/
