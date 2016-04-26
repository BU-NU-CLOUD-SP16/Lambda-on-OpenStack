#!/bin/bash

MASTER_IP=$1

OUT=./create_snapshot.sh

VM_IP=$(echo $OUT | awk '{split($0,a,"=");if (match(a[1],"VM_IP")) {vm_ip=a[2]}} END{print vm_ip}')
IMAGE_ID=$(echo $OUT | awk '{split($0,a,"=");if (match(a[1],"IMAGE_ID")) {img_id=a[2]}} END{print img_id}')

echo "on master script::"$VM_IP
echo "on master script::"$IMAGE_ID

./cluster_setup.sh $VM_IP $MASTER_IP

