#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

HS=(nswitch-oled Nest-Hub mod-wifi ChromeTV)
HC=${#HS[@]}
EC=0
for H in ${HS[@]} ; do
  #echo $H
  ping -W 1 -c 1 $H > /dev/null 2>&1
  if [ "$?" != "0" ] ; then
    echo ping -W 1 -c 1 $H failed
    EC=$(( EC + 1 ))
  fi
done
#echo $EC
if [ "$EC" == "$HC" ] ; then
  $DIR/smail.sh "ping local devices: all failed."
fi
