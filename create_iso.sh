#!/bin/bash

if [ -f nxos_config.txt ]
then
 rm nxos_config.txt
fi

for device in vtepa vtepb spine
do
  if [ -f $device\_config.txt ]
  then
    cp $device\_config.txt nxos_config.txt
    mkisofs -o $device\_config.iso -l --iso-level 2 nxos_config.txt 
  fi
done
