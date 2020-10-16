#!/bin/bash

for i in $( cat /home/duggun/inputfiles/DC_KantarIP.txt )
do
ping -q -c2 $i > /dev/null

if [ $? -eq 0 ]
then
echo $i "Pingable" >> /home/duggun/outputfiles/DC-KantarIP-PingResponse.txt
else
echo $i "NotPingable" >> /home/duggun/outputfiles/DC-KantarIP-PingResponse.txt
fi
done
