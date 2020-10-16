#!/bin/bash

### Script to get IAM Roles attached policies - list-attached-role-policies
## List AWS Managed , Custom and in-line policies by passing Role Name.

#List IAM Roles with required fields in JSON format.
#aws iam list-roles --query 'Roles[*].[RoleName]' --output text > /home/duggun/inputfiles/14082020-list-roles.txt

for line in $(cat /home/duggun/inputfiles/14082020-list-roles.txt)
do
  ## List AWS, Custom Managed and in-line Policies of IAM Role.
  unset attrolepolicy
  AWSCustmPolicies=$(aws iam list-attached-role-policies --role-name $line --query 'AttachedPolicies[*].PolicyName'  --output text)
  attrolepolicy=$(echo -e $AWSCustmPolicies | tr "\t" ",")

  rolepolicy=$(aws iam list-role-policies --role-name $line --query 'PolicyNames[*]' --output text)
  echo -e $rolepolicy > a.txt
  inlinepolicy=$(cat a.txt | tr "\t" ",")
  echo -e "$line|$attrolepolicy|$inlinepolicy" >> /home/duggun/outputfiles/14082020-list-attached-role-policies.txt
  Cinlinepolicy=$(echo -e $inlinepolicy | awk 'NF' | wc -l)

  ## Get Statements if IAM Role has any in-line policies
  if [ $Cinlinepolicy != 0 ]; then
    export IFS=','
      for inlineP in ${inlinepolicy[@]}
          do
            aws iam get-role-policy --role-name $line --policy-name $inlineP --query 'PolicyDocument.Statement[*].{EFF:Effect,RES:Resource,ACT:Action}' > inlinePolicyfile.json
            Scount=$(grep "ACT" inlinePolicyfile.json | wc -l)

            count=0
            while [ $count -lt $Scount ]
            do
              Effect=$(cat inlinePolicyfile.json | jq -c --argjson index $count '.[$index].EFF')
              Resource=$(cat inlinePolicyfile.json | jq -c --argjson index $count '.[$index].RES')
              Action=$(cat inlinePolicyfile.json | jq -c --argjson index $count '.[$index].ACT')
              echo -e "$line|$inlineP|$Effect|$Resource|$Action" >> inline-output.txt
              count=`expr $count + 1`
            done
          done
  fi
done

