#!/bin/sh
#rname="i-08d066axxcb9e2,i-0158edxx5df57,i-064a6xx74e0,i-09b1cf20xxa9,i-0a6e38cxxb00,i-0c8dfdxx0f7,i-0edd7xxa55"

#export IFS=','
#       for line in ${rname[@]}
for line in $(cat /home/duggun/scripts/allwindowseu.txt)
                do
                aws ec2 create-tags --region eu-west-1 --resources $line --tags Key="AWS-SSM",Value="SSM-Managed-Windows"
                done

