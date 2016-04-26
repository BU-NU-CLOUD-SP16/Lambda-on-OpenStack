#!/bin/bash
#this script is run at the start of cluster setup. It performs:
# 1. Sets up a manager container instance on the server instance on which it is executed.
# 2. sets up a consul discovery  container instance on the server instance on which it is executed.
# 3. Federates(joins) the Child node provided in parameters to the cluster via the discovery.
date
CHILD_VM_IP=$1        #192.168.1.106
MASTER_SERVER_IP=$2   #192.168.1.3
declare -i EXEC=1
declare -i LOOP=0

echo "child::"$CHILD_VM_IP"::"

KEY=$(cat setup.config | awk '{split($0,a,"="); if(a[1]=="KEY") print a[2]}')
#consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul -node=agent-one -bind=192.168.1.94 -client=0.0.0.0 -config-dir /etc/consul.d


#Create consul on the server.
echo "Creating consul"
sudo docker -H tcp://0.0.0.0:2375 run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap

sleep 15

#create swarm manager.
echo "Creating master"
sudo docker -H tcp://$MASTER_SERVER_IP:2375 run -d -p 5001:2375 swarm manage --strategy=binpack --advertise=$MASTER_SERVER_IP:2375 consul://$MASTER_SERVER_IP:8500


#join the newly created vm to the cluster
#sudo docker -H tcp://$CHILD_VM_IP:2375 run -d swarm join --advertise=$FLOATING_IP:2375 --heartbeat=15s --ttl=20s consul://$MASTER_SERVER_IP:8500
#scp -o StrictHostKeyChecking=no -i /home/ubuntu/my-key.pem ./join_node.sh ubuntu@$CHILD

echo "Starting child docker daemon"
while [ $EXEC -gt 0 ] && [ $LOOP -lt 5 ]
do
echo "******docker dameon*********"
ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$CHILD_VM_IP sudo docker -H tcp://0.0.0.0:2375 -d &
EXEC=$(echo $?)
LOOP=$LOOP+1
sleep 3
done

LOOP=0
EXEC=1
sleep 5
echo "Creating child"
while [ $EXEC -gt 0 ] && [ $LOOP -lt 5 ]
do
sleep 5
echo "running federation *********"
ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$CHILD_VM_IP sudo docker -H tcp://$CHILD_VM_IP:2375 run -d swarm join --advertise=$CHILD_VM_IP:2375 --heartbeat=15s --ttl=20s consul://$MASTER_SERVER_IP:8500
EXEC=$(echo $?)
LOOP=$LOOP+1
done

#date

#while [ true ]
#do
#sudo docker -H tcp://0.0.0.0:5001 info
#sleep 2
#done

date 
#join the newly created vm to the cluster
#sudo docker -H tcp://$CHILD_VM_IP:2375 run -d swarm join --advertise=$CHILD_NODE:2375 --heartbeat=15s --ttl=20s consul://$MASTER_SERVER_IP:8500
#chmod 770 join_node.sh
#./join_node.sh $CHILD_VM_IP $MASTER_SERVER_IP
#>>>>>>> Setup files for initial cluster configuration and federation <Rohit>
