#!/bin/sh

cd /home/ubuntu/Lambda-on-OpenStack/ProvisionScripts
./awk_test.sh &

nohup ./start-service.sh &
