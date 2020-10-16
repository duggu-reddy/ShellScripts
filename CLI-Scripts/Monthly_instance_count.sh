#!/bin/bash
(date "+%Y-%m-%d" ; aws ec2 describe-instances --output table --region us-east-1 --query 'Reservations[*].Instances[*].[State.Name]' | grep running | wc -l ; aws ec2 describe-instances --output table --region eu-west-1 --query 'Reservations[*].Instances[*].[State.Name]' | grep running | wc -l ) | tr '\n' ',' > fileforcount.txt
