#!/bin/bash

for line in $(cat /home/duggun/EU_IELB.txt)
	{
	echo -e "\n $(aws elb describe-load-balancers --load-balancer-name $line --region eu-west-1 --output text --query 'LoadBalancerDescriptions[*].[LoadBalancerName,Instances]' | tr '\n' ',')"
	}
