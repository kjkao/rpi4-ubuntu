#!/bin/bash

tail -n20 /etc/hosts.deny | while read L ; do
  if [ "`echo $L | grep -e '^# @'`" ] ; then
    read LL
    if [ "`echo $LL | grep -e '^sshd:'`" ] ; then
      #echo $L $LL
      TKN=(`echo $L $LL | sed 's/@//g;s/invalid user//g'`)
      #echo ${TKN[*]}
      #TS=`date +%s --date="${TKN[1]} ${TKN[2]}"`
      TS=`date -u +'%F %T' --date="${TKN[1]} ${TKN[2]} +0800"`
      U=${TKN[3]}
      IP=${TKN[5]}
      SQL="SELECT COUNT(id) FROM hosts_deny WHERE ip = '$IP'"
      CC=`mysql -s -u root django -e "$SQL"`
      if [ "$CC" = "0" ] ; then
        SQL="INSERT INTO hosts_deny (time, user, ip) VALUES('$TS', '$U', '$IP')"
        #echo mysql -s -u root django -e \"$SQL\"
        mysql -u root django -e "$SQL" 2>/dev/null
      fi
      #echo $SQL
    fi
  fi
done
