#!/bin/bash
#iptables -I INPUT -p tcp -s ip.address --dport 22 -j DROP
LL="0.0.0.0"
CNT=1
MM="0"
TAG=`basename $0 .sh`

function filter_ip () {
  P=$1
  cat /var/log/auth.log.1 /var/log/auth.log | grep "$P" | while read L ; do
    #echo $L
    #echo $L | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
    echo $L | grep -oP '^.*?\K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
  done
}
MF=/dev/shm/SSH_Malicious_IP.txt
rm -f $MF
filter_ip 'refused connect' >> $MF
filter_ip 'Failed password for' >> $MF

#cat /var/log/auth.log.1 /var/log/auth.log | grep 'refused connect' | cut -d ' ' -f 11 | sort > /dev/shm/refused_connect.txt
cat $MF | sort > /dev/shm/refused_connect.txt
echo $LL >> /dev/shm/refused_connect.txt

#iptables -L -n | grep DROP > /dev/shm/iptables_drop.txt

ipset list sshblacklist > /dev/shm/ipset_sshblacklist.txt || ipset create sshblacklist hash:ip hashsize 4096
iptables -C INPUT -p tcp --dport 22 -m set --match-set sshblacklist src -j DROP || iptables -I INPUT 1 -p tcp --dport 22 -m set --match-set sshblacklist src -j DROP

while read L ; do
  if [ "$L" = "" ] ; then
    continue
  fi
  if [ "$LL" != "$L" ] ; then
    if (( $CNT > 10 )) ; then
      #echo "$LL => $CNT"
      IP=`echo $LL | sed 's/(//g;s/)//g'`
      #echo $IP
#      if [ ! "`grep $IP /dev/shm/iptables_drop.txt`" ] ; then
#        iptables -I INPUT -p tcp -s $IP --dport 22 -j DROP
#        MM="1"
#      fi
      if [ ! "`grep $IP /dev/shm/ipset_sshblacklist.txt`" ] ; then
        logger -t $TAG "ipset add sshblacklist $IP"
        ipset add sshblacklist $IP
        MM="1"
      fi
    fi
    CNT=1
  fi
  LL=$L
  CNT=$(( CNT + 1 ))
done < /dev/shm/refused_connect.txt

#if [ "$MM" = "1" ] ; then
#  iptables -L -n | mail -s 'iptables drop changes' jeremy.kao@gmail.com
#fi

