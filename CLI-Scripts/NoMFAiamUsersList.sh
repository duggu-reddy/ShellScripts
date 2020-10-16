#!/bin/bash

MS_SBJT="KANTART AWS PROD - IAM Users WIHTOUT MFA "
MS_LIST="narduggu@in.ibm.com"

## Run below command to list all IAM users in AWS account
aws iam list-users --query 'Users[*].UserName' --output table | awk -F' ' '{print $2}' | tail -n +4 > /home/duggun/ListIAMusers.txt


### Get IAMusers list having console password enabled
>/home/duggun/IAMConsolePWDenabled.txt

for line in $(cat /home/duggun/ListIAMusers.txt)
        do
    	aws iam get-login-profile --user-name $line --query 'LoginProfile.UserName' --output text >> /home/duggun/IAMConsolePWDenabled.txt
    	done

sleep 5

grep -e "Hi Team \n\n Below listed users have Kantar AWS Console login WITHOUT MFA enabled, Please take an action immediatly\n" > /home/duggun/tempNoMFAUsers.txt

### Get No MFA IAM Users to send email 
for value in $(cat /home/duggun/IAMConsolePWDenabled.txt)
		do
		count=$(aws iam list-mfa-devices --user-name $value --query 'MFADevices[*].UserName' --output text | wc -l)
			if [ "$count" -eq "1" ];
                	then
                        	echo -e " $value " >> /home/duggun/tempNoMFAUsers.txt
                	fi
		done
echo -e "\n\nThank you \nGlobal Cloud Team" >> /home/duggun/tempNoMFAUsers.txt

#### Mail Section
cat /home/duggun/tempNoMFAUsers.txt | /bin/mail -s "$MS_SBJT" "$MS_LIST"

