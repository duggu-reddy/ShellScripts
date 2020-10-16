#!/bin/bash

for line in $(cat Root_SnapshotID.txt)
    do
    snapdate=$(aws ec2 describe-snapshots --snapshot-ids $line --query Snapshots[*].StartTime --region us-east-1 --output text)
    combine=$(echo "$line| \t$snapdate")
    sed -i "s/${line}/${combine}/g" temp_InsVolSnapDetails.tsv >> Final_InsVolSnapDetails.tsv
    done

