#!/bin/bash

date

#VM_NAME=child-vm-7
VM_NAME=child-vm-$1
CLUSTER_ID=3627ac6ad042110a08e877c0c82732e4
LOOP=1

#crete VM instance 
nova boot --flavor m1-4cpu --image ubuntu-14.04 --key-name my-key --security-groups SSH,default --nic net-name=net-work $VM_NAME

#sleep 10

while [ $LOOP -gt 0 ]
do
#ip address of instance with inst name
#VM_IP=$(nova show $VM_NAME | awk '{ if(match((if(match($2,"net-work")) print $5 }')
VM_IP=$(nova show $VM_NAME 2>&1| awk '
{split($2,a,":");
if(match(a[2],"vm_state"))
        {state=$4;}
else
        {state=state;};
if(match(state,"active") && match($2,"net-work"))
        {val=$5;}}
END { print val }')

echo $VM_IP

OUT=$(echo $VM_IP | awk '{print $2}')

if [ "$VM_IP" == "" ]; then
	GOAHEAD=0
	
else
	GOAHEAD=1
	LOOP=-1
fi
	echo $LOOP
	echo $GOAHEAD
	echo $OUT
	echo $VM_IP
	sleep 5
done

sleep 10
if [ $GOAHEAD==1 ]; then
#send image to vm

scp -o StrictHostKeyChecking=no -i /home/ubuntu/my-key.pem /home/ubuntu/docker-image/ub-py.tar /home/ubuntu/docker-image/configVM.sh ubuntu@$VM_IP:.
EXEC=$(echo $?)
echo $EXEC
while [ $EXEC -gt 0 ] 
do
scp -o StrictHostKeyChecking=no -i /home/ubuntu/my-key.pem /home/ubuntu/docker-image/ub-py.tar /home/ubuntu/docker-image/configVM.sh ubuntu@$VM_IP:.
EXEC=$(echo $?)
echo "copy to vm:"$EXEC
sleep 10
done

#avoid strict host key check
#ssh -o StrictHostKeyChecking=no -i /home/ubuntu/my-key.pem ubuntu@$VM_IP "sudo apt-get update"
ssh -o StrictHostKeyChecking=no -i /home/ubuntu/my-key.pem -q ubuntu@$VM_IP ./configVM.sh >/dev/null 2>/dev/null
echo "vm config done"

sleep 10

#federate node to swarm
sudo docker -H tcp://$VM_IP:2375 run -d swarm join --addr=$VM_IP:2375 token://$CLUSTER_ID

echo "node added to swarm"

fi
date
