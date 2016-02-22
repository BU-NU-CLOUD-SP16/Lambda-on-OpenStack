#!/bin/bash

IMAGE=$1
LOC_HOST=$2
LOC_CONT=$3
FILE=$4

echo 'vals::'$IMAGE'::'$LOC_HOST'::'$LOC_CONT'::'$FILE

echo 'creating log file.....'
#sudo docker exec $CID touch $LOC_CONT'/'$FILE'.out'
#sudo docker exec $CID chmod 777 $LOC_CONT'/'$FILE'.out'
sudo touch $LOC_HOST'/'$FILE'.out'
sudo chmod 777 $LOC_HOST'/'$FILE'.out'

echo 'sudo docker create -t -v '$LOC_HOST:$LOC_CONT' '$IMAGE

CID=`sudo docker create -t -v $LOC_HOST:$LOC_CONT $IMAGE`

echo $CID
sudo docker start $CID
echo 'container started....'

sudo docker exec $CID apt-get install -y python


echo 'executing code...'
sudo docker exec $CID python $LOC_CONT'/'$FILE >>$LOC_HOST'/'$FILE'.out'

echo 'exectuion done...'

sudo docker stop $CID
echo 'container stopped...'
