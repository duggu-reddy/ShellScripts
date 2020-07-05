#!/bin/bash

#ar=(10 30 44 44 69 12 11 20 38 41)
ar=(30 31 32 34 35 46 1 4 5 7)
maxInxVal=$(
{
for ((i = 0; i < ${#ar[@]}; i++)); do
    printf "%d %d\n" "$i" "${ar[i]}"
done
} | sort -rn -k2 | head -n 1)
#echo -e "Max Value : $maxInxVal"

MaxInd=$(echo $maxInxVal | awk -F" " '{print $1}')
MaxVal=$(echo $maxInxVal | awk -F" " '{print $2}')
#echo -e "Max Index Value: $MaxInd, Max Stock Value: $MaxVal"

minInxVal=$(
{
for ((i = 0; i < ${#ar[@]}; i++)); do
    printf "%d %d\n" "$i" "${ar[i]}"
done
} | sort -rn -k2 | tail -n 1)
#echo -e "Min Value : $minInxVal"

MinInd=`echo $minInxVal | awk -F" " '{print $1}'`
MinVal=`echo $minInxVal | awk -F" " '{print $2}'`
 
#echo -e "Min Index Value: $MinInd, Min Stock Value: $MinVal"

time_function()
{
case $1 in
	0)
		time=$(echo "9");;
	1)
		time=$(echo "10");;
        2)
                time=$(echo "11");;
	3)
		time=$(echo "12");;
        4)
                time=$(echo "13");;
	5)
		time=$(echo "14");;
        6)
                time=$(echo "15");;
	7)
		time=$(echo "16");;
        8)
                time=$(echo "17");;
	9)
		time=$(echo "18");;
esac
}

time_function $MaxInd
MaxTime=$time
#echo "Max Time: $MaxTime"
echo -e "Selling Value at $time:00 and Value is $MaxVal"

time_function $MinInd
MinTime=$time
#echo "Min Time: $MinTime"
echo -e "Buying Value at $time:00 and Value is $MinVal"

if [[ $MinTime -le $MaxTime ]]; then 
	Profit=`echo $MaxVal - $MinVal | bc`
	if ((Profit < 0)); then let Profit*=-1; fi
	echo "Maximum Possible Profit, Selling at $MaxTime:00 and Buying at $MinTime:00 :$"$Profit""
else
	echo -e "Selling at $MaxTime:00, Buying at $MinTime:00"
	echo -e "There are no best selling rate on same day after you Buy"
fi
