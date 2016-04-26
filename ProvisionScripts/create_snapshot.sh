#!/bin/bash

LOOP=1
VM_NAME='child-vm-0'
nova boot --flavor m1.medium --image ubuntu-14.04 --key-name my-key --security-groups SSH,default --nic net-name=net-work $VM_NAME

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
        sleep 2
done

scp -o StrictHostKeyChecking=no -i /home/ubuntu/my-key.pem ./Dockerfile ./init_config_child.sh ./configVM.sh ubuntu@$VM_IP:.

EXEC=$(echo $?)
echo $EXEC
while [ $EXEC -gt 0 ]
do
scp -o StrictHostKeyChecking=no -i /home/ubuntu/my-key.pem ./Dockerfile ./init_config_child.sh ./configVM.sh ubuntu@$VM_IP:.
EXEC=$(echo $?)
echo "copy to vm:"$EXEC
sleep 1
done

echo "scp done"

ssh -o StrictHostKeyChecking=no -i /home/ubuntu/my-key.pem ubuntu@$VM_IP ./init_config_child.sh $CLUSTER_ID

echo "ssh done"

nova image-create $VM_NAME test-snap

IMAGE_ID=nova image-list | awk '{if (match($4,"test-snap")) {id=$2}} END{print id}'

echo "VM_IP="$VM_IP
echo "IMAGE_ID="$IMAGE_ID
