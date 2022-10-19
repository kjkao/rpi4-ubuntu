#!/bin/bash

grep -e ': DHCPOFFER' /var/log/syslog.1 | cut -d ' ' -f 6,8,10,1-3 | while read L ; do
  IP=`echo $L | cut -d ' ' -f 5`
  MC=`echo $L | cut -d ' ' -f 6`
  HN=`grep -e $IP /etc/hosts`
  TS=`echo $L | cut -d ' ' -f 1-3`
  [ ! "$HN" ] && HN=$IP
  echo $TS $MC $HN
done

grep -e ': DHCPOFFER' /var/log/syslog | cut -d ' ' -f 6,8,10,1-3 | while read L ; do
  IP=`echo $L | cut -d ' ' -f 5`
  MC=`echo $L | cut -d ' ' -f 6`
  HN=`grep -e $IP /etc/hosts`
  TS=`echo $L | cut -d ' ' -f 1-3`
  [ ! "$HN" ] && HN=$IP
  echo $TS $MC $HN
done

