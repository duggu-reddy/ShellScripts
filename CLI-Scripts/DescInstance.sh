#!/bin/bash
for line in $(cat /home/duggun/InstanceList.txt)
	do
	aws ec2 describe-instances --instance-ids $line --output text --region eu-west-1 --query 'Reservations[*].Instances[*].[InstanceId, InstanceType, State.Name, Placement.AvailabilityZone, PrivateIpAddress, Platform, [Tags[?Key==`Product`].Value] [0][0], [Tags[?Key==`Service`].Value] [0][0], [Tags[?Key==`Environment`].Value] [0][0], [Tags[?Key==`Name`].Value] [0][0], [Tags[?Key==`Role`].Value] [0][0], [Tags[?Key==`Opco`].Value] [0][0]]' >> DescInstancc_OUTPUT.txt
	done
	
