#!/bin/bash

### Script to get IAM Role details 
## CreateDate, RoleName, Role Arn, Principal Details (to identify Instance-profile)

#List IAM Roles with required fields in JSON format.
#aws iam list-roles --query 'Roles[*].{Rolename:RoleName,Arn:Arn,Principal:AssumeRolePolicyDocument.Statement[*].Principal.Service,CreatedDate:CreateDate}' > /home/duggun/inputfiles/13082020-list-roles.json

Scount=$(grep "Rolename" /home/duggun/inputfiles/13082020-list-roles.json | wc -l)
count=0
while [ $count -lt $Scount ]
do
  echo -e "\n" >> /home/duggun/outputfiles/13082020-list-roles-out.txt
  cat /home/duggun/inputfiles/13082020-list-roles.json | jq -c --argjson index $count '.[$index].Rolename,.[$index].CreatedDate,.[$index].Arn,.[$index].Principal[]' | tr "\n" "|" >> /home/duggun/outputfiles/13082020-list-roles-out.txt
  count=`expr $count + 1`
done
