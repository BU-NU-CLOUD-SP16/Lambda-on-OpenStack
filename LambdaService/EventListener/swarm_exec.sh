#!/bin/bash

#swarm master

# CPU = $1
# MEMORY = $2+"m"
FUNCTION_NAME=$1
UUID=$2
#echo $FUNCTION_NAME
MASTER="tcp://192.168.1.3:5001"

echo "Exceuting docker swarm"
#create container
CONT_ID=$(sudo docker -H $MASTER create -t -v /home/ubuntu:/home/code -c 1 -m 1024m ub-python 2>&1)
 #|| echo "Exception occured")

OUT=$(echo $CONT_ID | awk '{print $2}')

if [ "$OUT" == "" ]; then
#find container node
CONT_NODE=$(sudo docker -H $MASTER inspect --format='{{json .Node.IP}}' $CONT_ID | awk '{print substr($0,2,(length($0)-2))}')

#copy function
#codePath="/home/ubuntu/"+$FUNCTION_NAME 

scp -i /home/ubuntu/my-key.pem /home/ubuntu/$FUNCTION_NAME ubuntu@$CONT_NODE:/home/ubuntu

#start the container
sudo docker -H $MASTER start $CONT_ID

#execute function
sudo docker -H $MASTER exec $CONT_ID apt-get install -y python
echo "::::::Begining Code Execution:::::::"
OUT=sudo docker -H $MASTER exec $CONT_ID python /home/code/$FUNCTION_NAME > $FUNCTION_NAME"_"$UUID".log"
echo $OUT
echo "::::::Log file copying to Master::::::"
scp -i /home/ubuntu/my-key.pem ubuntu@$CONT_NODE:/home/ubuntu/Lambda-on-OpenStack/LambdaService/EventListener/$FUNCTION_NAME"_"$UUID".log" /home/ubuntu/
echo "::::::Execution ends::::::"

#stop container
sudo docker -H $MASTER stop $CONT_ID

#remove container
sudo docker -H $MASTER rm -f $CONT_ID

else
echo "ERROR:::"$CONT_ID;
fi
