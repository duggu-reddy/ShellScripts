#!/bin/bash

/opt/sophos-av/bin/savdstatus --version | grep "Sophos Anti-Virus\|Last update" > /home/duggun/temp.txt


InstanceID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
Hostname=$(curl http://169.254.169.254/latest/meta-data/hostname)
OperatingSystem=$(cat /etc/*-release* | grep Linux | tail -1)
ServicePack=NA ; echo $ServicePack
Version=NA ; echo $Version

SophosVersion=$(cat /home/duggun/temp.txt | grep "Sophos Anti-Virus"  | awk -F" " '{print $4}')
day=$(cat /home/duggun/temp.txt | grep "Last update"  | awk -F"= " '{print $2}' | awk -F" " '{print $2}')
month=$(cat /home/duggun/temp.txt | grep "Last update"  | awk -F"= " '{print $2}' | awk -F" " '{print $3}')
case $month in
	Jan)
		nmonth=$(echo "01")
		;;
	Feb)
		nmonth=$(echo "02")
		;;
	Mar)
		nmonth=$(echo "03")
		;;
	Apr)
		nmonth=$(echo "04")
		;;
	May)
		nmonth=$(echo "05")
		;;
	Jun)
		nmonth=$(echo "06")
		;;
	Jul)
		nmonth=$(echo "07")
		;;
	Aug)
		nmonth=$(echo "08")
		;;
	Sept)
		nmonth=$(echo "09")
		;;
	Oct)
		nmonth=$(echo "10")
		;;
	Nov)
		nmonth=$(echo "11")
		;;
	Dec)
		nmonth=$(echo "12")
		;;
esac
year=$(cat /home/duggun/temp.txt | grep "Last update"  | awk -F"= " '{print $2}' | awk -F" " '{print $4}')
hours=$(cat /home/duggun/temp.txt | grep "Last update"  | awk -F"= " '{print $2}' | awk -F" " '{print $5}' | awk -F":" '{print $1}')
minutes=$(cat /home/duggun/temp.txt | grep "Last update"  | awk -F"= " '{print $2}' | awk -F" " '{print $5}' | awk -F":" '{print $2}')
LastUpdated=$(echo -E "$day-$nmonth-$year $hours:$minutes")
#LastUpdated=$(cat /home/duggun/temp.txt | grep "Last update"  | awk -F"= " '{print $2}')

IpAddress=$(ifconfig | grep "inet addr" | awk -F":" '{print $2}' | head -1 | awk -F" " '{print $1}')
SophosParentAddress=$(grep "BAD-PRIMARY-URL" /opt/sophos-av/log/savupdate-debug.log | head -1| awk -F" " '{print $6}')
SophosPrimaryUpdate=$(grep "SUCCESSFULLY_UPDATED_FROM" /opt/sophos-av/log/savupdate-debug.log | head -1| awk -F" " '{print $6}')

day1=$(cat /home/duggun/temp.txt | grep "Last update"  | awk -F" " '{print $5}')
day2=$(date +%d)
month1=$(cat /home/duggun/temp.txt | grep "Last update"  | awk -F" " '{print $6}')
month2=$(date | awk -F" " '{print $2}')

if [ $month1 == $month2 ];
	then
	if [ $day1 == $day2 ];
		then
		SophosUpToDate=$(echo "1")
	else
		SophosUpToDate=$(echo "0")
	fi
else
	SophosUpToDate=$(echo "0")
fi

LastPatchInstalledOn=NA
ReportRunDate=$(date +%d-%m-%Y)
echo -E "InstanceID, Hostname, IpAddress,OperatingSystem, ServicePack, Version, SophosVersion, LastUpdated,SophosUpToDate,SophosParentAddress, SophosPrimaryUpdate,LastPatchInstalledOn,ReportRunDate" > "$InstanceID".csv
echo -E "$InstanceID, $Hostname,$IpAddress, $OperatingSystem, $ServicePack, $Version, $SophosVersion, $LastUpdated,$SophosUpToDate,$SophosParentAddress, $SophosPrimaryUpdate,$LastPatchInstalledOn,$ReportRunDate" >> "$InstanceID".csv
