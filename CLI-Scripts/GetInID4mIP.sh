#1/bin/bash

for line in $(cat /home/duggun/GetInID4mIP.txt)
        do
	aws ec2 describe-instances --output table --region eu-west-1 --query 'Reservations[*].Instances[*].[InstanceId, State.Name, PrivateIpAddress,Platform]' | grep $line >> /home/duggun/GetInIDDetails4mIP.txt
	done
