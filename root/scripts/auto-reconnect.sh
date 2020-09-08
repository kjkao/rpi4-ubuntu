#!/bin/bash

TAG=`basename $0 .sh`
PPP_GW=`ip addr show ppp0 | awk '/inet/{print $4}' | cut -d '/' -f1`

for (( I=0 ; I <= 5 ; I=$(( I + 1 )) )) ; do
  ping -c 1 -W 1 $PPP_GW > /dev/null 2>&1

  if [ $? = 0 ] ; then
#    logger -t $TAG network connected.
    exit;
  fi
done

logger -t $TAG service networking restart
#echo `date`: service networking restart >> /var/log/myLog.txt
service networking restart
sleep 5

for (( I=0 ; I <= 10 ; I=$(( I + 1 )) )) ; do
  if [ ! "$PPP_GW" ] ; then
    PPP_GW=`ip addr show ppp0 | awk '/inet/{print $4}' | cut -d '/' -f1`
    sleep 1
  fi
  ping -c 1 -W 1 $PPP_GW > /dev/null 2>&1

  if [ $? = 0 ] ; then
    logger -t $TAG network re-connected.
    exit;
  fi
done

logger -t $TAG "shutdown -r now"
#echo `date`: shutdown -r now >> /var/log/myLog.txt
shutdown -r now

