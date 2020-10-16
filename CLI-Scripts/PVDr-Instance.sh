#!/bin/bash
for line in $(cat /home/duggun/inputfiles/EU_PVDr_instance.txt)
        do
        echo "$line : $(aws ec2 get-console-output --instance-id $line --output text --region eu-west-1 | grep -m1 OsProductName | awk -F":" '{print $5}') : $(aws ec2 get-console-output --instance-id $line --region eu-west-1 --output text | grep -i "Driver: AWS PV" | grep -i 'Network\|Driver' | tail -n2 | tail -1 | awk -F" " '{print $8,$9}' | rev | awk -F"v" '{print $1}' | rev)" >> /home/duggun/outputfiles/EU_PVDr_Instance.txt
        done
