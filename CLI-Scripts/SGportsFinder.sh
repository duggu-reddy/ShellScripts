#!/bin/bash


#aws ec2 describe-security-groups --query 'SecurityGroups[*].GroupId' --region eu-west-1 | grep sg | awk -F'"' '{print $2}' > /home/duggun/inputfiles/US-SGList.txt
for line in $(cat /home/duggun/inputfiles/US-SGList.txt)
      do
	      echo $line
              echo -e "$line: $(aws ec2 describe-security-groups --group-ids $line --query 'SecurityGroups[*].IpPermissions[?FromPort==`445`].IpRanges' --region us-east-1 --output text| tr '\n' '  ') : 445" >> 445_US_SGList_IP.txt
      done
