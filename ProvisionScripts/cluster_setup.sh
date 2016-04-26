#!/bin/bash
#this script is run at the start of cluster setup. It performs:
# 1. Sets up a manager container instance on the server instance on which it is executed.
# 2. sets up a consul discovery  container instance on the server instance on which it is executed.
# 3. Federates(joins) the Child node provided in parameters to the cluster via the discovery.
 
CHILD_VM_IP=$1        #192.168.1.106
MASTER_SERVER_IP=$2   #192.168.1.3
FLOATING_IP=$3        #192.168.1.192



#consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul -node=agent-one -bind=192.168.1.94 -client=0.0.0.0 -config-dir /etc/consul.d


#Create consul on the server.
sudo docker -H tcp://0.0.0.0:2375 run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap

#create swarm manager.
sudo docker -H tcp://$MASTER_SERVER_IP:2375 run -d -p 5001:2375 swarm manage --strategy=binpack --advertise=$MASTER_SERVER_IP:2375 consul://$MASTER_SERVER_IP:8500


ssh -o StrictHostKeyChecking=no -i /home/ubuntu/my-key.pem -q ubuntu@CHILD_VM_IP

#join the newly created vm to the cluster
#sudo docker -H tcp://$CHILD_VM_IP:2375 run -d swarm join --advertise=$FLOATING_IP:2375 --heartbeat=15s --ttl=20s consul://$MASTER_SERVER_IP:8500
chmod +x consul_create.sh
./join_node.sh $CHILD_VM_IP $MASTER_SERVER_IP $FLOATING_IP