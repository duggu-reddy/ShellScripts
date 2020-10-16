#!/bin/bash

## Get Public Subnet Details
aws ec2 describe-route-tables --query 'RouteTables[*].RouteTableId' --region us-east-1 --output table | grep "rtb-" | awk -F" " '{print $2}' > /home/duggun/inputfiles/tmp-us-east-1-routeTablesDetails

for line in $(cat /home/duggun/inputfiles/tmp-us-east-1-routeTablesDetails)
do
  igwCount=$(aws ec2 describe-route-tables --route-table-ids $line --query 'RouteTables[*].[Associations[*].SubnetId, RouteTableId, Routes[*].GatewayId]'  --output text | grep "igw-" | wc -l)
  if [ "$igwCount" -ge 1 ]; then
        PubSubnet=$(aws ec2 describe-route-tables --route-table-ids $line --query 'RouteTables[*].[Associations[*].SubnetId, RouteTableId, Routes[*].GatewayId]'  --output text | grep "subnet-" )
        echo -e "$PubSubnet" >> PublicSubnets.output
  else
        echo -e "$line doesn't have any Public Subnets"
  fi
done
