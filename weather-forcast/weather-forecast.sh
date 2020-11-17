#!/bin/bash
## Input the IP Address to get weather forecast for the next 3 days
if [ -z "$1" ]
then
        echo "IP Address to get weather forecast is Default"
        location=$(curl --silent http://ipinfo.io/ | grep loc | awk -F" " '{print $2}' | tr -d '"' |sed 's/.\{1\}$//')
else
        echo "IP Address to get weather forecast is $1"
        location=$(curl --silent http://ipinfo.io/$1 | grep loc | awk -F" " '{print $2}' | tr -d '"' |sed 's/.\{1\}$//')
fi

## To get weather forecast
curl --silent https://api.darksky.net/forecast/6ce2cb95ebf7afee7f2d76afcc037fb3/$location > file.json
cat file.json | jq -c '.daily.data[] | "\(.time) \(.summary)"'| tr -d '"' > daysData.txt
while read -r line
do
#               echo "$line"
        xDate=$(echo "$line" | awk -F" " '{print $1}')
        rDate=$(date -d @"$xDate" "+%Y-%m-%d")
        sed -i "s/$xDate/$rDate:/g" daysData.txt
done < daysData.txt

## To Display next 3 days forecast
echo "`cat daysData.txt | head -5 | tail -3`"
