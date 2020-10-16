#!/bin/bash

## Get S3 Bucket LifeCycle details of Listed S3 buckets


for line in $(cat /home/duggun/inputfiles/S3bucketsList.txt)
        {
        echo -e "$line : $(aws s3 ls $line |wc -l)" >> /home/duggun/outputfiles/S3NoOfObjects.txt
        }

