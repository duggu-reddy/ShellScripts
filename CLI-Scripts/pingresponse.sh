#!/bin/bash
for line in $(cat /home/duggun/inputfiles/urlsList.txt)
        do
	echo -e "$line :"
	timeout 2s ping -c 1 $line
	echo -e "------------------------\n"
        done

