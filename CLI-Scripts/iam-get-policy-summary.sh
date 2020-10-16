#!/bin/bash
### Script to get custom iam policy summary in Kantar AWS Account.

# To get the list of IAM Custom policies with Arn
#aws iam list-policies --query 'Policies[*].Arn' | awk -F"\"" '{print $2}' | grep 837010418979 > /home/duggun/inputfiles/AccountTotalCustomIAMPolicies.txt

for pArn in $(cat /home/duggun/inputfiles/AccountTotalCustomIAMPolicies.txt)
      do
          #To get the Default version of Policy (which is in use).
          PDversion=$(aws iam list-policy-versions --policy-arn $pArn --query 'Versions[?IsDefaultVersion==`true`].{Vid:VersionId}' --output text)

          #To get permission of Policy
          aws iam get-policy-version --policy-arn $pArn --version-id $PDversion --output text > tempfile.txt

          #Get Policy Name
          pName=$(echo $pArn | awk -F"/" '{print $2}')

          while read -r line
                  do
                          echo -e "$line"
                          type=$(echo -e $line | awk -F" " '{print $1}')
                          echo $type
                          if [ $type == STATEMENT ]; then
                                  echo -e "$pName|$Effect|$Resources|$actions" >> output
                          fi
                          case $type in
                                  STATEMENT)
                                          echo -e "\n"
                                          Effect=$(echo -e "$line" | awk -F" " '{print $2}')
                                          Resources=$(echo -e "$line" | awk -F" " '{print $3}')
                                          unset actions
                                          ;;
                                  ACTION)
                                          action=$(echo -e "$line" | awk -F" " '{print $2}')
                                          actions=${actions},${action}
                                          ;;
                          esac
                  done <tempfile.txt
          echo -e "$pName|$Effect|$Resources|$actions" >> output
	 # unset Effect Resources actions
      done 
