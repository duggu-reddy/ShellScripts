#!/bin/sh
for line in $(cat /home/duggun/GetVolID-SnapID.txt)
	do
	aws ec2 describe-snapshots --snapshot-id  $line --query 'Snapshots[*].[SnapshotId,VolumeId]' --output text
	done
