#!/bin/bash
TAG=`basename $0 .sh`

function pppoe_disconnect() {
  poff dsl-dip-provider
  ip rule del table 22
  sleep 1

  for (( I=0 ; I < 15 ; I=$(( $I + 1 )) )) ;
  do
    if [ "`ifconfig ppp1 2>/dev/null | grep inet`" = "" ] ; then
      break;
    fi
    sleep 1
  done
}

function pppoe_connect() {
  logger -t $TAG "pon dsl-dip-provider"
  pon dsl-dip-provider
  for (( I=0 ; I < 15 ; I=$(( $I + 1 )) )) ;
  do
    if [ "`ifconfig ppp1 2>/dev/null | grep inet`" ] ; then
      break;
    fi
    sleep 1
  done
  PPP1_IP=`ip addr show ppp1 | awk '/inet /{print $2}'`
  ip rule add from $PPP1_IP table 22
  ip route replace default via $PPP1_IP table 22
  ip route flush cache
}

case ${1,,} in
  start )
    pppoe_connect
    ;;
  stop )
    pppoe_disconnect
    ;;
  * )
    pppoe_disconnect
    pppoe_connect
    ;;
esac

