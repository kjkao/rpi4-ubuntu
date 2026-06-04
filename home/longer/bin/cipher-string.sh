#!/bin/bash

function usage() {
  echo
  echo "Usage: command [ciphername]"
  echo
  echo "    command:"
  echo "        list    list ciphername"
  echo "        enc     encrypt string"
  echo "        dec     decrypt"
  echo "        decq    decrypt quiet"
  echo
  echo
  exit
}

if [ ! "$1" ] ; then
  usage
fi
CMD=$1
CN=$2

if [ "$CN" ] ; then
  ENCFILE=$HOME/.ssh/`basename -s .enc $CN`.enc
fi
if [ "$CMD" = "list" ] ; then

  cd $HOME/.ssh/
  echo "ciphername:"
  for F in `ls *.enc 2>/dev/null` ; do
    echo "  " `basename -s .enc $F`
  done

elif [ "$CMD" = "dec" ] ; then

  if [ "$CN" = "" ] ; then
    usage
  fi

  echo "Decrypt File store in $ENCFILE"
  echo "  CMD: " openssl rsautl -inkey $HOME/.ssh/id_rsa -decrypt -in $ENCFILE
  echo
  openssl rsautl -inkey $HOME/.ssh/id_rsa -decrypt -in $ENCFILE
  echo

elif [ "$CMD" = "decq" ] ; then

  if [ "$CN" = "" ] ; then
    usage
  fi

  openssl rsautl -inkey $HOME/.ssh/id_rsa -decrypt -in $ENCFILE

elif [ "$CMD" = "enc" ] ; then

  if [ "$CN" = "" ] ; then
    usage
  fi

  echo "Encrypt File store in $ENCFILE"
  read -p "  Enter Plain String: " S
  echo "  CMD: echo PLAINTEXT | openssl rsautl -inkey $HOME/.ssh/id_rsa -encrypt -out $ENCFILE"
  echo $S | openssl rsautl -inkey $HOME/.ssh/id_rsa -encrypt -out $ENCFILE

fi

exit

