#!/bin/bash

if [ "$1" = "noauth" ] ; then
  NOAUTH_ONLY="Y"
fi

#grep -a -e ': DHCPACK' /var/log/syslog.1 | while read L ; do
#  LA=($L)
#  IP=${LA[7]}
#  MC=${LA[9]}
#  TS="${LA[0]} ${LA[1]} ${LA[2]}"
#  echo $IP $MC $TS
#done
#exit 
#Feb 5 15:30:30 kjkao dhcpd[1052]: DHCPACK on 192.168.12.97 to 1c:45:86:ca:d3:93 via br0
##grep -e ': DHCPOFFER' /var/log/syslog.1 | cut -d ' ' -f 6,8,10,1-3 | while read L ; do
#grep -a -e ': DHCPACK' /var/log/syslog.1 | cut -d ' ' -f 6,8,10,1-3 | while read L ; do
#  IP=`echo $L | cut -d ' ' -f 5`
#  MC=`echo $L | cut -d ' ' -f 6`
#  TS=`echo $L | cut -d ' ' -f 1-3`
grep -a -e ': DHCPACK' /var/log/syslog.1 | while read L ; do
  LA=($L)
  IP=${LA[7]}
  MC=${LA[9]}
  TS="${LA[0]} ${LA[1]} ${LA[2]}"
  HN=`grep -e $IP /etc/hosts`
  if [ ! "$HN" ] ; then
    echo $TS $MC $IP
  elif [ "$NOAUTH_ONLY" != "Y" ] ; then
    echo $TS $MC $HN
  fi
done

##grep -e ': DHCPOFFER' /var/log/syslog | cut -d ' ' -f 6,8,10,1-3 | while read L ; do
#grep -a -e ': DHCPACK' /var/log/syslog | cut -d ' ' -f 6,8,10,1-3 | while read L ; do
#  IP=`echo $L | cut -d ' ' -f 5`
#  MC=`echo $L | cut -d ' ' -f 6`
#  TS=`echo $L | cut -d ' ' -f 1-3`
grep -a -e ': DHCPACK' /var/log/syslog | while read L ; do
  LA=($L)
  IP=${LA[7]}
  MC=${LA[9]}
  TS="${LA[0]} ${LA[1]} ${LA[2]}"
  HN=`grep -e $IP /etc/hosts`
  if [ ! "$HN" ] ; then
    echo $TS $MC $IP
  elif [ "$NOAUTH_ONLY" != "Y" ] ; then
    echo $TS $MC $HN
  fi
done

