#!/bin/sh

### Script to check HTTPD, JAVA and APACHE2 process on the Linux servers
### and display process output for validation
### narduggu@in.ibm.com

fqsname=`hostname`
ipsvr=`ifconfig | grep "inet addr"`

## Check for any httpd process is running on server
httpd_proc=`ps -aef | grep httpd| grep -v grep`
chttpd_proc=`ps -aef | grep httpd| grep -v grep | wc -l`
echo "======================" > "$fqsname"_Scriptout
echo $ipsvr >> "$fqsname"_Scriptout
echo $httpd_proc >> "$fqsname"_Scriptout
echo $fqsname >> "$fqsname"_Scriptout
if [ $chttpd_proc -ge 1 ]
then
        echo "HTTPD Process is running" >> "$fqsname"_Scriptout
else
        echo "No HTTPD Process" >> "$fqsname"_Scriptout
fi

## Check for any Java process is running on server
java_proc=`ps -aef | grep java | grep -v grep`
cjava_proc=`ps -aef | grep java | grep -v grep | wc -l`
echo $java_proc >> "$fqsname"_Scriptout
if [ $cjava_proc -ge 1 ]
then
        echo "Java Process is running" >> "$fqsname"_Scriptout
else
        echo "No JAVA Process running" >> "$fqsname"_Scriptout
fi

## Check for any apache2 process is running on server
java_proc=`ps -aef | grep apache2 | grep -v grep`
cjava_proc=`ps -aef | grep apache2 | grep -v grep | wc -l`
echo $java_proc >> "$fqsname"_Scriptout
if [ $cjava_proc -ge 1 ]
then
        echo "Apache2 Process is running" >> "$fqsname"_Scriptout
else
        echo "No Apache2 Process running" >> "$fqsname"_Scriptout
fi

echo "\n\nContent in file for verification \n `cat "$fqsname"_Scriptout`"
