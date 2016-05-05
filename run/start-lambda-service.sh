#!/bin/sh

cd /home/ubuntu/Lambda-on-OpenStack/ProvisionScripts
./awk_test.sh &

nohup ./start-service.sh &
nohup mongod &
cd /home/ubuntu/Lambda-on-OpenStack/UserInterface
nohup ruby wrapper.rb &
