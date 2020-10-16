#!/bin/bash

rm -rf /home/duggun/temp/*.temp
for line in $(cat /home/duggun/dir_size.csv)
	do
	InstanceID=`echo $line | awk -F"," '{print $1}'` 
	hName=`echo $line | awk -F"," '{print $2}'`
	hDir=`echo $line | awk -F"," '{print $3}'` 
	Size=`echo $line | awk -F"," '{print $4}'` 
	echo "$hDir - $Size" >> /home/duggun/temp/"$InstanceID".temp
	done

ls -ltr  /home/duggun/temp/ | awk -F" " '{print $9}'| tail -n +2 > InstanceID_file.txt
for file in $(cat /home/duggun/InstanceID_file.txt)
	do
	InID=`echo $file | awk -F"." '{print $1}'`
	iDetail=$(aws ec2 describe-instances --instance-ids $InID --query 'Reservations[*].Instances[*].[PrivateIpAddress,[Tags[?Key==`Name`].Value] [0][0], [Tags[?Key==`Requester`].Value] [0][0]]' --output text)
	IPDetail=`echo $iDetail | awk -F" " '{print $1}'`
	hName=`echo $iDetail | awk -F" " '{print $2}'`
	Requester=`echo $iDetail | awk -F" " '{print $3}'`
	echo -e "********************* TESTING - Please Ignore ***********************\n\nHello, \n\nPlease cleanup some space from the below directories on host $hName - $IPDetail \n\n`cat /home/duggun/temp/$file` \n\nThank you\nGlobal Cloud Team" | mail -s "Home Directory cleanup $hName - $IPDetail" narduggu@in.ibm.com
	done 
