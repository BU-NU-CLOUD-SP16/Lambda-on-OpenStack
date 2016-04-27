#!/bin/bash

echo "updating child"

sudo apt-get update

sudo apt-get install -y docker.io

echo "installed docker"

sudo docker build -t ub-python .

sudo docker pull swarm

sudo stop docker

sudo rm -f /etc/docker/key.json

sudo docker -H tcp://0.0.0.0:2375 -d &
