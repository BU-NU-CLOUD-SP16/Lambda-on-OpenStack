#!bin/bash

#creates a discovery service sing consul container.
#The same script is used 

CHILD_VM_IP=$1        #192.168.1.106
MASTER_SERVER_IP=$2   #192.168.1.3
FLOATING_IP=$3        #192.168.1.192


sudo docker -H tcp://$CHILD_VM_IP:2375 run -d swarm join --advertise=$FLOATING_IP:2375 --heartbeat=15s --ttl=20s consul://$MASTER_SERVER_IP:8500