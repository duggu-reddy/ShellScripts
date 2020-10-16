#!/bin/bash

if [ "$1" == "us-east-1" ]
then
        export REGION="US-EAST"
        export region="us-east-1"
elif [ "$1" == "eu-west-1" ]
then
        export REGION="EU-WEST"
        export region="eu-west-1"
else
        echo "Region is not valid exiting now.."
        exit 0
fi


#List Classic Load Balance Details
aws elb describe-load-balancers --region $1 --query 'LoadBalancerDescriptions[*].[LoadBalancerName]' --output text > /home/duggun/inputfiles/"$1"-clb-LoadBalancerName


for line in $(cat /home/duggun/inputfiles/"$1"-clb-LoadBalancerName)
do
  clbarn=$(aws elb describe-load-balancers --load-balancer-name $line --region $1 --query 'LoadBalancerDescriptions[*].ListenerDescriptions[*].[Listener.LoadBalancerPort, Listener.SSLCertificateId]' --output text | grep 443 | awk -F' ' '{print $2}')
  echo "CLB ARN: $clbarn"
  acmid=$(echo $clbarn | awk -F'/' '{print $2}')
  echo "ACM ID: $acmid"
  SubjectAlternativeNames=$(aws acm describe-certificate --certificate-arn $clbarn --region $1 --query '[Certificate.SubjectAlternativeNames[*]]' --output text)
  echo $SubjectAlternativeNames
  CertDate=$(aws acm describe-certificate --certificate-arn $clbarn --region $1 --query '{NotBefore:Certificate.NotBefore,NotAfter:Certificate.NotAfter}')
  echo $CertDate
  start=$(date -d "@$(echo $CertDate | sed "s/,/\n/" | grep NotBefore | awk -F' ' '{print $2}')")
  expire=$(date -d "@$(echo $CertDate | sed "s/,/\n/" | grep NotAfter | awk -F' ' '{print $3}')")
  echo -e "$line,$SubjectAlternativeNames,$start,$expire" >> acm-loadbalance-"$1".csv
done
