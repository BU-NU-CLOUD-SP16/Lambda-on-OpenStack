#!/bin/bash

echo "updating child"

sudo apt-get update

sudo apt-get install -y docker.io

echo "installed docker"

sudo docker build -t ub-python .

sudo stop docker

sudo rm -f /etc/docker/key.json
