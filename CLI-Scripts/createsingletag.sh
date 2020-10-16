#!/bin/sh
#rname="i-08d066aca894cb9e2,i-0158ed579e0e5df57,i-064a69f82a95174e0,i-09b1cf20273d524a9,i-0a6e38c3ed3234b00,i-0c8dfdc5046ce40f7,i-0edd7623fc9836a55"

#export IFS=','
#       for line in ${rname[@]}
for line in $(cat /home/duggun/scripts/allwindowseu.txt)
                do
                aws ec2 create-tags --region eu-west-1 --resources $line --tags Key="AWS-SSM",Value="SSM-Managed-Windows"
                done

