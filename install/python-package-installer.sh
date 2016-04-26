#!/bin/sh
sudo apt-get update -y
sudo apt-get install -y python-dev python-pip
pip install python-openstackclient

pip install ndg-httpsclient
pip install pyasn1
sudo apt-get install libffi-dev
sudo apt-get update -y
sudo apt-get install -y rabbitmq-server
pip install pika
pip install pymongo
sudo apt-get install -y git
