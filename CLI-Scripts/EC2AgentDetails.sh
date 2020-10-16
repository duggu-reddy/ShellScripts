#!/bin/bash

for line in $(cat /home/duggun/inputfiles/instanceID.txt)
	do
	echo -e "$line : `aws ec2 get-console-output --instance-id $line --output text | grep "EC2 Agent" | tail -1`"
#	aws ec2 get-console-output --instance-id $line --output text | grep "EC2 Agent" | tail -1
	done
