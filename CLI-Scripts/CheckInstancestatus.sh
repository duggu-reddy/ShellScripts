#!/bin/sh
######## Script to check Instance status is running or not, if any of instance listed
######## in "instances" variable is stopped then process (IF condition) will exit/terminate and informs you that instance is stopped state.

### Global Variables
filedate=$(date "+%d%m%Y_%H%M%S")
filename=InstanceStatusDetails_"$filedate"
MS_MAIL="Status of EC2 Instances "
MAILTO=ch.kishorreddy@gmail.com
regionDetails="eu-west-1"
VPCID="vpc-029ea864"

#### Filter instance using VPC details and get Instance-id details.
instances=`aws ec2 describe-instances --filters "Name=network-interface.vpc-id,Values=$VPCID"  --region eu-west-1 --query 'Reservations[*].Instances[*].[InstanceId]' --output text | awk '{print}' ORS=',' | sed 's/.\w*$//'`
#### Instance Details with comma (,) separated to check the status
#instances="i-e2e789ftfd3af,i-7890538c0411b,i-e987fd3af"


export IFS=','
    for line in ${instances[@]}
        do
            echo $line > /tmp/"$filename"
            status=`aws ec2 describe-instances --instance-ids $line --region $regionDetails --query 'Reservations[*].Instances[*].[State.Name]' --output text`
            if [ $status == running ]; then
                  echo "$line is running" >> /tmp/"$filename"
            else
                  echo "$line is not running, so terminating the process" >> /tmp/"$filename"
                  exit
            fi
        done
mail -s "$MS_MAIL" "$MAILTO" < /tmp/"$filename"
