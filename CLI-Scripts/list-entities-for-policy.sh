#!/bin/bash
#### Script to get list-entities-for-policy 
#### narduggu@in.ibm.com
#### 24-June-2020

#!/bin/bash
#### Script to get list-entities-for-policy
#### narduggu@in.ibm.com
#### 24-June-2020
for line in $(cat /home/duggun/inputfiles/AccountTotalCustomIAMPolicies.txt)
  do
    #Get Policy Name
    pName=$(echo $line | awk -F"/" '{print $2,$3}')

    #Get Policy attached to any Group, Role or/and User
#    Entries=$(aws iam list-entities-for-policy --policy-arn $line --output text)
#    Value=$(echo $Entries | awk -F" " '{print $1,$3}')
     Value=$(aws iam list-entities-for-policy --policy-arn $line --output text | awk -F" " '{print $1,$3}')
    echo -e "$pName|$Value" >> /home/duggun/outputfiles/120820-list-entities-for-policy.txt
  done
