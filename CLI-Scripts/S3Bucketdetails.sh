#!/bin/bash
echo -e "Bucket Name    Owner   Region  " > /home/duggun/outputfiles/S3BucketDetails.txt
for line in $(cat /home/duggun/inputfiles/S3BucketsList.txt)
	do
#	echo -e "Bucket Name	Owner	Region	" > /home/duggun/outputfiles/S3BucketDetails.txt
	echo -e "$line	: $(aws s3api get-bucket-tagging --bucket $line --query '[TagSet[?Key==`Requester`].Value]' --output text) : $(aws s3api get-bucket-location --bucket $line --query 'LocationConstraint' --output text)" >>/home/duggun/outputfiles/S3BucketDetails.txt
	done
