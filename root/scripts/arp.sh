#!/bin/bash
arp -n | grep -v -e ^Address -e 192.168.12.9 -e 192.168.12.6 | sort > /dev/shm/arp.curr ; 
if [ "`diff /dev/shm/arp.curr /dev/shm/arp.last`" ] ; then
  date -Iseconds >> /root/arp.lst ; 
  arp -n >> /root/arp.lst ; 
  echo >> /root/arp.lst; 
fi ; 
mv /dev/shm/arp.curr /dev/shm/arp.last
