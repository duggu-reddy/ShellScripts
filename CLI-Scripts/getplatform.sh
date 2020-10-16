#!/bin/bash
for line in $(cat /home/duggun/scripts/test.txt)
        do
        aws ec2 describe-instances --instance-ids $line --output text --region us-east-1 --query 'Reservations[*].Instances[*].[InstanceId,Platform]' >> getplatform.txt
        done
