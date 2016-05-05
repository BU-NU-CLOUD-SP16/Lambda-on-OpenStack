#!/bin/bash

#VAL=$(nova image-list | awk '{if (match($4,"test-snap")) {id=$2}} END{print id}')
declare -i i=1
while [ 1==1 ]
do
echo $i
i=$1+1
sleep 3
done
