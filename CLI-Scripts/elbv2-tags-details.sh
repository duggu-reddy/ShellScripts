#!/bin/bash

if [ "$1" == "us-east-1" ]
then
        export REGION="US-EAST"
        export region="us-east-1"
elif [ "$1" == "eu-west-1" ]
then
        export REGION="EU"
        export region="eu-west-1"
else
        echo "Region is not valid exiting now.."
        exit 0
fi

## Get all ALB and NLB Details.
aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerArn,Scheme,Type]' --region $region --output text > "$region"-elbv2-arn.txt
cat "$region"-elbv2-arn.txt | awk -F" " '{print $1}' > arnValues.txt

## Get Tag details
for line in $(cat arnValues.txt)
do
  lbarn=$(echo -e "$line")
  lbTags=$(aws elbv2 describe-tags --resource-arns $lbarn --region $region --query 'TagDescriptions[*].[[Tags[?Key==`Environment`].Value] [0][0],[Tags[?Key==`Product`].Value] [0][0],[Tags[?Key==`Role`].Value] [0][0],[Tags[?Key==`Service`].Value] [0][0],[Tags[?Key==`Requester`].Value] [0][0],[Tags[?Key==`Opco`].Value] [0][0]]' --output text)
  echo -e "$lbarn $lbTags" >> $region-elbv2-details.txt
done
