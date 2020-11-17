# Bash Script to fetch the weather forecast for the next 3 days (starting tomorrow) for a given IP address.
Script is to get a stock price for a given commodity is measured at hourly intervels during the day, from 9AM until 6PM (Can ber modified for a day too)

## Pre-requesits
* Make sure you have internet connection where the script is going to run
* jq cmdlet available

## Inputs
Input IP Address to check weather forecast.
If we don't enter any IP, it takes as default value 

## Usage
Assign required permission 
`chmod +x weather-forecast.sh`

Run the script
`sh weather-forecast.sh`

If required, in Debug Mode
`sh -xv StockProfits.sh`


## Sample Output
`root@test-instance:~# sh ip_forcast.sh 202.79.128.151
IP Address to get weather forecast is 202.79.128.151
2020-11-18: Possible light rain overnight.
2020-11-19: Rain in the morning and afternoon.
2020-11-20: Clear throughout the day.`


`root@test-instance:~# sh ip_forcast.sh
IP Address to get weather forecast is Default
2020-11-18: Humid and mostly cloudy throughout the day.
2020-11-19: Humid and partly cloudy throughout the day.
2020-11-20: Humid and mostly cloudy throughout the day.`




