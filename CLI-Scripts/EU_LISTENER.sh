#!/bin/sh
for line in $(cat /home/duggun/EU_elbList.txt)
	do
	echo "$line : $(aws elb describe-load-balancers --load-balancer-name $line --region eu-west-1 --query 'LoadBalancerDescriptions[*].[ListenerDescriptions,DNSName]' --output text | grep LISTENER | awk -F' ' '{print $2}' | tail -1)" >> EU_Listerns.txt
#	aws elb describe-load-balancers --load-balancer-name $line --region us-east-1 --query LoadBalancerDescriptions[*].[ListenerDescriptions,DNSName] --output text | grep LISTENER >> US_Listerns.txt
#	echo " ------------------------" >> US_Listerns.txt
	done

	
