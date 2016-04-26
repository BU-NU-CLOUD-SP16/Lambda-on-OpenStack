#!/bin/bash

LOOP=1
VM_NAME='child-vm-0'

KEY=$(cat setup.config | awk '{split($0,a,"="); if(a[1]=="KEY") print a[2]}')
FLAVOR=$(cat setup.config | awk '{split($0,a,"="); if(a[1]=="FLAVOR") print a[2]}')
IMAGE=$(cat setup.config | awk '{split($0,a,"="); if(a[1]=="IMAGE") print a[2]}')
KEY_NAME=$(cat setup.config | awk '{split($0,a,"="); if(a[1]=="KEY_NAME") print a[2]}')
SEC_GROUPS=$(cat setup.config | awk '{split($0,a,"="); if(a[1]=="SEC_GROUPS") print a[2]}')
NETWORK=$(cat setup.config | awk '{split($0,a,"="); if(a[1]=="NETWORK") print a[2]}')

nova boot --flavor $FLAVOR --image $IMAGE --key-name $KEY_NAME --security-groups $SEC_GROUPS --nic net-name=$NETWORK $VM_NAME

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

scp -o StrictHostKeyChecking=no -i $KEY ./Dockerfile ./init_config_child.sh ./configVM.sh ubuntu@$VM_IP:.

EXEC=$(echo $?)
echo $EXEC
while [ $EXEC -gt 0 ]
do
scp -o StrictHostKeyChecking=no -i $KEY ./Dockerfile ./init_config_child.sh ./configVM.sh ubuntu@$VM_IP:.
EXEC=$(echo $?)
echo "copy to vm:"$EXEC
sleep 1
done

echo "scp done"

ssh -o StrictHostKeyChecking=no -i $KEY ubuntu@$VM_IP ./init_config_child.sh $CLUSTER_ID

echo "ssh done"

nova image-create $VM_NAME ub-doc

IMAGE_ID=$(nova image-list | awk '{if (match($4,"ub-doc")) {id=$2}} END{print id}')

echo "VM_IP="$VM_IP
echo "IMAGE_ID="$IMAGE_ID
