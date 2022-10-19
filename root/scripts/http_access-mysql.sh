#!/bin/bash

SQLFILE=/dev/shm/.http_access.sql
echo -n > $SQLFILE

grep -v -e ^127.0.0.1 -e ^::1 $1 | while read L ; do
  #echo $L
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
done

mysql -u root django < $SQLFILE 2>/dev/shm/.http_access.err
