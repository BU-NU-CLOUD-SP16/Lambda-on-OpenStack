#!/bin/bash

MASTER_IP=$1

echo "Starting to create VM  snapshot"
./create_snapshot.sh > snapshot.log
#OUT=$(cat snapshot.log)
echo "Finished creating snapshot"

VM_IP=$(cat snapshot.log | awk '{split($0,a,"=");if (match(a[1],"VM_IP")) {vm_ip=a[2]}} END{print vm_ip}')
IMAGE_ID=$(cat snaphot.log | awk '{split($0,a,"=");if (match(a[1],"IMAGE_ID")) {img_id=a[2]}} END{print img_id}')

echo "on master script::"$VM_IP
echo "on master script::"$IMAGE_ID
chmod 770 cluster_setup.sh
echo "executing cluster_setup"
./cluster_setup.sh $VM_IP $MASTER_IP

