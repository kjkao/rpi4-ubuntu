#!/bin/bash

if [ "$1" = "all" ] ; then
  iw dev wlan0 station dump
else
  iw dev wlan0 station dump | grep -e Station -e bitrate -e time -e signal | while read L ; do
    if [[ "$L" =~ "Station"* ]] ; then
      MACADDR=`echo $L | cut -d ' ' -f 2`
      WLHOST=`grep $MACADDR /etc/hosts | sed s/$MACADDR//g`
      echo "$L" $WLHOST
    else
      echo "    "$L
    fi
  done
fi
