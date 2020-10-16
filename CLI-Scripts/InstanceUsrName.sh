#!/bin/bash
for line in $(cat /home/duggun/EU_InstanceListUsrName.txt)
        do
        aws ec2 describe-instances --instance-ids $line --output text --region eu-west-1 --query 'Reservations[*].Instances[*].[InstanceId, [Tags[?Key==`Username`].Value] [0][0]]' >> EU_DescInstancUsrName.txt
        done
