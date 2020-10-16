#!/bin/bash
### Script to get custom iam policy summary in Kantar AWS Account.

# To get the list of IAM Custom policies with Arn
aws iam list-policies --query 'Policies[*].Arn' | awk -F"\"" '{print $2}' | grep 837010418979 > /home/duggun/inputfiles/AccountTotalCustomIAMPolicies.txt

for pArn in $(cat /home/duggun/inputfiles/AccountTotalCustomIAMPolicies.txt)
      do
          #To get the Default version of Policy (which is in use).
          PDversion=$(aws iam list-policy-versions --policy-arn $pArn --query 'Versions[?IsDefaultVersion==`true`].{Vid:VersionId}' --output text)

          #To get permission of Policy
          aws iam get-policy-version --policy-arn $pArn --version-id $PDversion --query 'PolicyVersion.Document.Statement[*].{EFF:Effect,RES:Resource,ACT:Action}' > Policyfile.json

          #Get Policy Name
          pName=$(echo $pArn | awk -F"/" '{print $2}')
          Scount=$(grep "ACT" Policyfile.json | wc -l)

          count=0
          while [ $count -lt $Scount ]
          do
            Effect=$(cat Policyfile.json | jq -c --argjson index $count '.[$index].EFF')
            Resource=$(cat Policyfile.json | jq -c --argjson index $count '.[$index].RES')
            Action=$(cat Policyfile.json | jq -c --argjson index $count '.[$index].ACT')
            echo -e "$pName|$Effect|$Resource|$Action" >> output.txt
	    count=`expr $count + 1`
          done
      done
