#!/bin/bash
### Script to grep for 'ec2:CreateTags\|ec2:DeleteTags\|ec2:*' actions in AWS Account Custom policies.

##Create or Nullify Output file.
> /home/duggun/outputfiles/EC2full-TagsAccess.txt

# To get the list of IAM policies with Arn
aws iam list-policies --query 'Policies[*].Arn' | awk -F"\"" '{print $2}' > /home/duggun/inputfiles/AccountTotalIAMPolicies.txt

for line in $(cat /home/duggun/inputfiles/AccountTotalIAMPolicies.txt)
      do
        # Check policy is Custom Managed or AWS mnaged
        cManaged=$(echo $line | grep "837010418979" | wc -l)
        if [ "$cManaged" -eq 1 ]; then
          echo "$line is a Custome Policy"
          #To get the Default version of Policy (which is in use).
          pDversion=$(aws iam list-policy-versions --policy-arn $line --query 'Versions[?IsDefaultVersion==`true`].{Vid:VersionId}' --output text)
          #To get permission of Policy and filter for 'ec2:CreateTags\|ec2:DeleteTags\|ec2:*'
          pEC2Entries=$(aws iam get-policy-version --policy-arn $line --version-id $pDversion | grep 'ec2\:CreateTags\|ec2\:DeleteTags\|ec2\:\*' | wc -l)
	  if [ "$pEC2Entries" -ge 1 ]; then
            echo -e "$line,$pDversion,$pEC2Entries" >> /home/duggun/outputfiles/EC2full-TagsAccess.txt
	  fi
        fi
      done
