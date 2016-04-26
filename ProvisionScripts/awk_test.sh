#!/bin/bash

SLEEP=5
declare -i VM_ID=170
MEMU=100
MEMT=0
ULIMIT=0.7
LLIMIT=0.3


declare -i LIMIT_TIME=15
declare -i DURATION=0

declare -i PROVISION=0
declare -i i=1;

PREV_STATE=" "
STATE=" "

while [ 1 == 1 ]
do
#INFO=$(sudo docker -H tcp://0.0.0.0:5001 info) 

#if [ $PROVISION -gt 0 ]; then
PREV_STATE=$STATE
STATE=$(sudo docker -H tcp://0.0.0.0:5001 info| awk -v limit="$ULIMIT" -v llimit="$LLIMIT" '
{ if(match($3,"Memory")) 
	{memu=memu+$4; memt=memt+$7; 
	if((memu/memt)>limit) 
		{status="EXCEEDED"}  
	else{if((memu/memt)<llimit) 
		{status="LOW"} 
	else
		{status="INLIMIT"}}}} 
 END{print status}')
#fi

echo 'state::'$STATE
#declare -i i=0
if [ $PREV_STATE != $STATE ]; then
if [ $STATE == "LOW" ]; then
	if [ $PROVISION -gt 0 ]; then
		if [ $LIMIT_TIME -lt $DURATION ]; then
			echo "deprovision"
			VM_NAME=$(sudo docker -H tcp://0.0.0.0:5001 info | awk '
			{if(match($1,"child-vm")) 
				{split($1,a,":");
				CONT_ID=a[1]}; 
			if(match($2,"Containers")) 
				{if($3<2) 
					{CONTS=CONT_ID}};}
			END{print CONTS}')
			if [ $VM_NAME != "" ]; then
				nova delete $VM_NAME
				DURATION=0
				PROVISION=$PROVISION-1
			fi
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
fi
echo "cycle::"$i	
sleep $SLEEP
i=$i+1
done
