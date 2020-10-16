#!/bin/bash
for line in $(cat /home/duggun/inputfiles/snapshotID.txt)
	do
	echo -e "Snapshot ID : $line"
	aws ec2 delete-snapshot --snapshot-id $line --region eu-west-1
	done
