#!/bin/bash

echo "begin config"
#sudo apt-get update

#sudo apt-get install -y docker.io

sudo stop docker

sudo rm -f /etc/docker/key.json

(sudo docker -H tcp://0.0.0.0:2375 -d </dev/null >/dev/null 2>/dev/null &)&

sleep 2

#sudo docker -H tcp://0.0.0.0:2375 load -i /home/ubuntu/ub-py.tar

echo "config ends"
