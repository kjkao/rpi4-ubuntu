#!/bin/bash
#iptables -I INPUT -p tcp -s ip.address --dport 22 -j DROP
LL="0.0.0.0"
CNT=1
MM="0"
cat /var/log/auth.log.1 /var/log/auth.log | grep 'refused connect' | cut -d ' ' -f 11 | sort > /dev/shm/refused_connect.txt
echo "0.0.0.0" >> /dev/shm/refused_connect.txt
iptables -L -n | grep DROP > /dev/shm/iptables_drop.txt
while read L ; do
  if [ "$L" = "" ] ; then
    continue
  fi
  if [ "$LL" != "$L" ] ; then
    if (( $CNT > 10 )) ; then
      #echo "$LL => $CNT"
      IP=`echo $LL | sed 's/(//g;s/)//g'`
      #echo $IP
      if [ ! "`grep $IP /dev/shm/iptables_drop.txt`" ] ; then
	iptables -I INPUT -p tcp -s $IP --dport 22 -j DROP
	MM="1"
      fi
    fi
    CNT=1
  fi
  LL=$L
  CNT=$(( CNT + 1 ))
done < /dev/shm/refused_connect.txt

if [ "$MM" = "1" ] ; then
  iptables -L -n | mail -s 'iptables drop changes' jeremy.kao@gmail.com
fi
