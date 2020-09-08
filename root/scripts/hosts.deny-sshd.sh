#!/bin/bash
#DS=`date "+%b %d %H:"`
DS=`date "+%b %e %H:"`
#echo "'$DS'"

AUTHLOG="/var/log/auth.log"
HOSTSDENY=`grep -e "$DS" $AUTHLOG | grep -e 'Failed password for' | sed 's/^.*from //g' | sed 's/ port.*$//g' | sort -u`

for addr in $HOSTSDENY;
do
  if [ "`grep -e $addr /etc/hosts.deny`" ] ; then
    continue;
  else
    L0=`grep -e "$DS" $AUTHLOG | grep -e 'Failed password for' | grep -m1 -e "$addr"`
    L=`echo $L0 | cut -d ' ' -f1,2,3,9- | sed 's/ from .* ssh2//g'`
    echo \# @$L >> /etc/hosts.deny
    if [ "`echo $addr | egrep '([0-9]{1,3}\.){3}[0-9]{1,3}'`" ] ; then
      echo sshd: $addr >> /etc/hosts.deny
    else
      echo \# sshd: $addr >> /etc/hosts.deny
    fi
  fi
done
