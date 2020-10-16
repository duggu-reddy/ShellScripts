#!/bin/sh
for line in $(cat /home/duggun/EU_SGInstance.txt)
        do
        echo "$line : $(aws ec2 describe-instances --instance-ids $line --region us-east-1 --output text --query 'Reservations[*].Instances[*].[PrivateIpAddress]') : $(aws ec2 describe-instances --region us-east-1 --instance-ids $line --output text | grep SECURITYGROUPS | awk -F' ' '{print $2}' | tr '\n' ',' | awk -F'[' '{print $1}')" >> SGOutout.txt
	done
	
	
