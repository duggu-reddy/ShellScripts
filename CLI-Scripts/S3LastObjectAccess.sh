#!/bin/bash

## Get S3 Bucket LifeCycle details of Listed S3 buckets


for line in $(cat /home/duggun/inputfiles/S3bucketsList.txt)
        {
        echo -e "$line : $(aws s3 ls $line --recursive | sort | tail -n 1)" >> /home/duggun/outputfiles/S3LastAccessed.txt
        }

