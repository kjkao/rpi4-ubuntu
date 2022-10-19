#!/bin/bash

PID=/dev/shm/.`basename $0`.pid
if [ -e $PID ] ; then
  exit
fi
echo $$ > $PID

F=$1
FN=`basename $F`
TF=/dev/shm/.$FN.nol.txt
CNOL=`wc -l < $F`
LNOL=`if [ -e $TF ] ; then cat $TF ; else echo 0 ; fi`
if (( $CNOL < $LNOL )) ; then
  F=$F.1
  CNOL=`wc -l < $F`
fi
NOL=$(( $CNOL - $LNOL ))

if (( $NOL == 0 )) ; then
  exit
fi

SQLFILE=/dev/shm/.http_access.sql
echo -n > $SQLFILE

LC=0
#grep -v -e ^127.0.0.1 -e ^::1 $1 | while read L ; do
#tail -n$NOL $1 | while read L ; do
while read L ; do
  LC=$(( LC + 1 ))
  if [ "`echo $L | grep -e ^127.0.0.1 -e ^::1`" ] ; then
    continue
  fi
  #echo $L
  EVAL=`echo $L | sed 's/^\(.*\) \(.*\) \(.*\) \[\(.*\)\] \"\(.*\)\" \([0-9]*\) \([0-9]*\) \"\(.*\)\" \"\(.*\)\"$/IP=\"\1\";TS=\"\4\";REQ=\"\5\";RC=\6;AG=\"\9\";/g'`
  #echo $EVAL
  eval ${EVAL//\$/\\$}
  TKN=($REQ)
  TS=`date -u +'%F %T' --date="$TS"`
  echo "INSERT INTO http_access (ip, time, method, request, code, agent) VALUES (\"$IP\", \"$TS\", \"${TKN[0]}\", \"$REQ\", $RC, \"$AG\");" >> $SQLFILE
  if [ "$1" = "$F" ] && (( $LC >= 1000 )) ; then
    break
  fi
done <<< $(tail -n$NOL $F)

if [ "$1" = "$F" ] ; then
  echo $(( $LNOL + $LC )) > $TF
else
  rm $TF
fi

mysql -u root django < $SQLFILE 2>/dev/shm/.http_access.err

rm -f $PID
