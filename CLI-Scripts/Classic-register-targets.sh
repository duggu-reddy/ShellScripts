#!/bin/bash
for line in $(cat Classic-us-elb.txt)
do
	### TO register instance with load balancer eu-west-1
	#aws elb register-instances-with-load-balancer --load-balancer-name $line --instances i-035e3bfcf2d4e6339 --region eu-west-1
	### To deregister from load balancer eu-west-1
	aws elb deregister-instances-from-load-balancer --load-balancer-name $line --instances i-860740ed --region $1
done
