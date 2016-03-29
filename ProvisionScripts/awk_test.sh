#!/bin/bash

SLEEP=2
declare -i VM_ID=60
MEMU=100
MEMT=0
ULIMIT=0.7
LLIMIT=0.3

declare -i LIMIT_TIME=15
declare -i DURATION=0

declare -i PROVISION=1
declare -i i=1;


while [ 1 == 1 ]
do
STATE=$(sudo docker -H tcp://0.0.0.0:5001 info | awk -v limit="$ULIMIT" -v llimit="$LLIMIT" '
{ if(match($3,"Memory")) 
	{memu=memu+$4; memt=memt+$7; 
	if((memu/memt)>limit) 
		{status="EXCEEDED"}  
	else{if((memu/memt)<llimit) 
		{status="LOW"} 
	else
		{status="INLIMIT"}}}} 
 END{print status}')

echo 'state::'$STATE
#declare -i i=0

if [ $STATE == "LOW" ]; then
	if [ $PROVISION -gt 0 ]; then
		if [ $LIMIT_TIME -lt $DURATION ]; then
			echo "deprovision"
			DURATION=0
			PROVISION=$PROVISION-1
		else
			DURATION=$DURATION+5
			echo "watch"
		fi
		echo $DURATION
	
	fi
else  
	if [ $STATE == "EXCEEDED" ]; then
        	echo "provision"
		./provisionVM.sh $VM_ID
		PROVISION=$PROVISION+1
		echo "VM_ID::"$VM_ID
		VM_ID=$VM_ID+1
	fi 
fi
echo "cycle::"$i	
sleep $SLEEP
i=$i+1
done
