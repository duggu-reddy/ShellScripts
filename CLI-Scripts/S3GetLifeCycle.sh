#!/bin/bash

## Get S3 Bucket LifeCycle details of Listed S3 buckets


for line in $(cat /home/duggun/inputfiles/S3bucketsList.txt)
        {
        echo -e "\n==========================\nLifeCycle Policy for S3Bucket : $line  \n\n $(aws s3api get-bucket-lifecycle --bucket $line --query 'Rules[*].[ID,Prefix,Status,Transition.Days,Transition.StorageClass,Expiration.Days]' --output text) \n===============================\n" >> /home/duggun/outputfiles/S3GetLifeCycleDetails.txt
        }

