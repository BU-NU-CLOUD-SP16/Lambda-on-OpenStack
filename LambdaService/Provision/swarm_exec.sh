#!/bin/bash

#swarm master
MASTER="tcp://<master ip:port>"

#create container
CONT_ID=$(sudo docker -H $MASTER create -t -v /home/ubuntu:/home/code -c 2 -m 1024m ubuntu 2>&1)
 #|| echo "Exception occured")

OUT=$(echo $CONT_ID | awk '{print $2}')

if [ "$OUT" == "" ]; then
#find container node
CONT_NODE=$(sudo docker -H $MASTER inspect --format='{{json .Node.IP}}' $CONT_ID | awk '{print substr($0,2,(length($0)-2))}')

#copy function
scp -i my-key.pem /home/ubuntu/code/hello.py ubuntu@$CONT_NODE:/home/ubuntu

#start the container
sudo docker -H $MASTER start $CONT_ID

#execute function
sudo docker -H $MASTER exec $CONT_ID apt-get install -y python
sudo docker -H $MASTER exec $CONT_ID python /home/code/hello.py

#stop container
#sudo docker -H $MASTER stop $CONT_ID

#remove container
#sudo docker -H $MASTER rm -f $CONT_ID

else
echo "ERROR:::"$CONT_ID;
fi
