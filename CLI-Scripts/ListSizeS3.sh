#!/bin/bash

for line in $(cat /home/duggun/s3.txt)
	{
	echo -e "$line : $(aws s3 ls s3://$line --recursive --human-readable --summarize | grep "Total Size")" >> /home/duggun/ListSizeS3.txt
	}
